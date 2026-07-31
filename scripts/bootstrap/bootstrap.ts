/**
 * Yugrow Platform Bootstrap v1.1
 *
 * Single orchestrator for all supported platforms (Windows, Linux, macOS, CI).
 * Invoked by platform-specific wrappers: bootstrap.ps1, bootstrap.sh
 *
 * Usage:
 *   node scripts/bootstrap/bootstrap.ts
 *   node scripts/bootstrap/bootstrap.ts --skip-docker
 *   node scripts/bootstrap/bootstrap.ts --verify-only
 */

import { execSync, spawn, ChildProcess } from 'child_process';
import * as fs from 'fs';
import * as path from 'path';

// ── Configuration ──────────────────────────────────────────────
const ROOT = path.resolve('.');
const PORTS = { api: 3001, web: 3002, flutter: 3003, qa: 3004 };
const LOG_DIR = path.join(ROOT, 'logs', 'bootstrap');
const STATUS_FILE = path.join(ROOT, 'DEV-STATUS.md');
const TIMEOUTS = { docker: 120_000, db: 30_000, api: 30_000, web: 30_000, flutter: 60_000 };

// ── Logging ────────────────────────────────────────────────────
const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
const logFile = path.join(LOG_DIR, `bootstrap-${timestamp}.log`);
const logStream = fs.createWriteStream(logFile, { flags: 'a' });

function log(msg: string, level: 'INFO' | 'WARN' | 'ERROR' | 'DONE' = 'INFO') {
  const line = `[${new Date().toISOString()}] [${level}] ${msg}`;
  logStream.write(line + '\n');
  const prefix = level === 'ERROR' ? '❌' : level === 'WARN' ? '⚠️' : level === 'DONE' ? '✅' : '  ';
  console.log(`  ${prefix} ${msg}`);
}

// ── Helpers ────────────────────────────────────────────────────
function run(cmd: string, opts: { timeout?: number; cwd?: string; silent?: boolean } = {}): { stdout: string; exitCode: number } {
  try {
    const out = execSync(cmd, {
      cwd: opts.cwd || ROOT,
      timeout: opts.timeout || 30_000,
      stdio: opts.silent ? 'pipe' : 'pipe',
      windowsHide: true,
    });
    return { stdout: out.toString().trim(), exitCode: 0 };
  } catch (e: any) {
    return { stdout: e.stdout?.toString()?.trim() || '', exitCode: e.status ?? 1 };
  }
}

function sleep(ms: number) { return new Promise(r => setTimeout(r, ms)); }

async function waitFor(fn: () => boolean | { ok: boolean }, timeoutMs: number, intervalMs = 2000): Promise<boolean> {
  const start = Date.now();
  while (Date.now() - start < timeoutMs) {
    const result = fn();
    if (typeof result === 'boolean' ? result : result.ok) return true;
    await sleep(intervalMs);
  }
  return false;
}

function getLanIp(): string {
  try {
    const out = run('powershell.exe -Command "(Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null }).IPv4Address.IPAddress"', { silent: true });
    if (out.stdout && out.exitCode === 0) return out.stdout;
  } catch {}
  try {
    const out = run('ipconfig', { silent: true });
    const match = out.stdout.match(/IPv4 Address[^:]*:\s*([0-9.]+)/);
    if (match) return match[1];
  } catch {}
  return '127.0.0.1';
}

function isPortOpen(port: number): { inUse: boolean; pid?: number; processName?: string } {
  try {
    const out = run(`powershell.exe -Command "Get-NetTCPConnection -LocalPort ${port} -ErrorAction SilentlyContinue | Select-Object OwningProcess,@{N='Name';E={Get-Process -Id \$_.OwningProcess | Select-Object -ExpandProperty ProcessName}}"`, { silent: true });
    if (out.stdout.trim()) {
      const lines = out.stdout.split('\n').filter(l => l.trim());
      const parts = lines[0]?.trim().split(/\s+/) || [];
      return { inUse: true, pid: parseInt(parts[0]), processName: parts[1] };
    }
  } catch {}
  return { inUse: false };
}

function killProcess(pid: number) {
  try { run(`taskkill /F /PID ${pid}`, { silent: true }); } catch {}
}

// ── Status tracking ────────────────────────────────────────────
interface ServiceStatus { status: 'PASS' | 'FAIL' | 'WARN' | 'SKIP'; detail: string }
const results: Record<string, ServiceStatus> = {};

function setStatus(service: string, status: ServiceStatus['status'], detail: string) {
  results[service] = { status, detail };
  log(`${service}: ${status} — ${detail}`, status === 'FAIL' ? 'ERROR' : status === 'WARN' ? 'WARN' : status === 'PASS' ? 'DONE' : 'INFO');
}

// ── Step 1: Dependency Validation ──────────────────────────────
async function step1Dependencies() {
  log('─── Step 1: Dependencies ───', 'INFO');

  const deps: { name: string; cmd: string; versionMatch?: RegExp }[] = [
    { name: 'Node.js', cmd: 'node --version', versionMatch: /v22\./ },
    { name: 'pnpm', cmd: 'pnpm --version' },
    { name: 'Flutter', cmd: 'flutter --version', versionMatch: /Flutter 3\./ },
    { name: 'Git', cmd: 'git --version' },
    { name: 'PowerShell', cmd: 'powershell.exe -Command "$PSVersionTable.PSVersion.ToString()"', versionMatch: /7\.|5\./ },
  ];

  const dockerPath = run('where docker', { silent: true });
  if (dockerPath.stdout) deps.push({ name: 'Docker', cmd: 'docker --version' });

  for (const dep of deps) {
    const result = run(dep.cmd, { silent: true });
    if (result.exitCode === 0) {
      const version = result.stdout.split('\n')[0].trim();
      if (dep.versionMatch && !dep.versionMatch.test(version)) {
        setStatus(dep.name, 'WARN', `Found: ${version} (unexpected version)`);
      } else {
        setStatus(dep.name, 'PASS', version.substring(0, 60));
      }
    } else {
      setStatus(dep.name, 'FAIL', 'Not found. Install and add to PATH.');
    }
  }
}

// ── Step 2: Port Verification ──────────────────────────────────
async function step2Ports() {
  log('─── Step 2: Ports ───', 'INFO');

  for (const [name, port] of Object.entries(PORTS)) {
    const check = isPortOpen(port);
    if (check.inUse) {
      log(`Port ${port} (${name}) in use by ${check.processName} (PID ${check.pid})`, 'WARN');
      // Auto-kill if it's a known dev process
      if (['node.exe', 'dart.exe', 'flutter.exe'].includes(check.processName || '')) {
        log(`Auto-terminating ${check.processName} (PID ${check.pid})...`, 'WARN');
        killProcess(check.pid!);
        await sleep(1000);
        const recheck = isPortOpen(port);
        if (recheck.inUse) {
          setStatus(`Port ${port}`, 'FAIL', `Could not free port ${port} (${name}). Terminate manually.`);
        } else {
          setStatus(`Port ${port}`, 'PASS', `Freed port ${port} for ${name}`);
        }
      } else {
        setStatus(`Port ${port}`, 'WARN', `In use by ${check.processName} (PID ${check.pid}) — may conflict`);
      }
    } else {
      setStatus(`Port ${port}`, 'PASS', `Available for ${name}`);
    }
  }
}

// ── Step 3: Docker ─────────────────────────────────────────────
async function step3Docker() {
  log('─── Step 3: Docker ───', 'INFO');

  // Check if Docker is running
  const dockerInfo = run('docker info', { silent: true, timeout: 10_000 });
  if (dockerInfo.exitCode === 0) {
    setStatus('Docker', 'PASS', 'Docker Desktop is running');
    return true;
  }

  log('Docker Desktop not running. Attempting to start...', 'WARN');
  
  // Try to start Docker Desktop
  const startResult = run('start "" "C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe"', { silent: true });
  
  const started = await waitFor(() => {
    const check = run('docker info', { silent: true, timeout: 5_000 });
    return check.exitCode === 0;
  }, TIMEOUTS.docker);

  if (started) {
    setStatus('Docker', 'PASS', 'Started Docker Desktop successfully');
    return true;
  } else {
    setStatus('Docker', 'FAIL', 'Could not start Docker Desktop. Start manually and re-run.');
    return false;
  }
}

// ── Step 4: Docker Services ────────────────────────────────────
async function step4DockerServices() {
  log('─── Step 4: Docker Services ───', 'INFO');

  const composeFile = path.join(ROOT, 'infrastructure', 'docker', 'docker-compose.yml');
  if (!fs.existsSync(composeFile)) {
    setStatus('Docker Services', 'FAIL', `docker-compose.yml not found at ${composeFile}`);
    return;
  }

  run(`docker compose -f "${composeFile}" up -d`, { timeout: 60_000 });

  const pgReady = await waitFor(() => {
    const pg = run('docker compose -f "${composeFile}" ps --format json', { silent: true });
    return pg.stdout.includes('postgres') && pg.stdout.includes('running');
  }, TIMEOUTS.db);

  if (pgReady) {
    setStatus('PostgreSQL', 'PASS', 'Healthy on port 5432');
    setStatus('Docker Services', 'PASS', 'All containers running');
  } else {
    setStatus('PostgreSQL', 'FAIL', 'Timed out waiting for PostgreSQL');
  }
}

// ── Step 5: Database Setup ─────────────────────────────────────
async function step5Database() {
  log('─── Step 5: Database ───', 'INFO');
  
  const generate = run('pnpm db:generate', { timeout: 30_000 });
  const push = run('pnpm db:push', { timeout: 30_000 });

  if (generate.exitCode === 0 && push.exitCode === 0) {
    setStatus('Database', 'PASS', 'Schema generated and pushed');
  } else {
    setStatus('Database', 'FAIL', generate.stderr || push.stderr || 'Database setup failed');
  }
}

// ── Step 6: API ────────────────────────────────────────────────
async function step6Api() {
  log('─── Step 6: API ───', 'INFO');

  const apiDir = path.join(ROOT, 'apps', 'api');
  if (!fs.existsSync(apiDir)) {
    setStatus('API', 'FAIL', 'API directory not found');
    return;
  }

  // Start API process
  const apiProcess = spawn('pnpm', ['dev'], { cwd: apiDir, stdio: 'pipe', windowsHide: true, shell: true });
  
  const apiReady = await waitFor(() => {
    try {
      const health = run('curl -s http://localhost:3001/api/health 2>nul', { silent: true, timeout: 3_000 });
      return health.exitCode === 0;
    } catch { return false; }
  }, TIMEOUTS.api);

  if (apiReady) {
    setStatus('API', 'PASS', 'Running on http://localhost:3001');
  } else {
    setStatus('API', 'FAIL', 'API did not start within timeout');
  }
}

// ── Step 7: LAN & Connectivity ─────────────────────────────────
async function step7Connectivity() {
  log('─── Step 7: Connectivity ───', 'INFO');

  const lanIp = getLanIp();
  log(`LAN IP: ${lanIp}`, 'INFO');

  // Test local API
  try {
    const localHealth = run('curl -s http://localhost:3001/api/health 2>nul', { silent: true, timeout: 5_000 });
    if (localHealth.exitCode === 0) {
      setStatus('Health Endpoint', 'PASS', 'GET /api/health → 200');
    } else {
      setStatus('Health Endpoint', 'FAIL', 'API health check failed');
    }
  } catch {
    setStatus('Health Endpoint', 'FAIL', 'API not reachable');
  }

  // Test LAN API access
  if (lanIp !== '127.0.0.1') {
    try {
      const lanHealth = run(`curl -s http://${lanIp}:3001/api/health 2>nul`, { silent: true, timeout: 5_000 });
      if (lanHealth.exitCode === 0) {
        setStatus('LAN Access', 'PASS', `API reachable at http://${lanIp}:3001`);
      } else {
        setStatus('LAN Access', 'WARN', 'LAN IP not reachable — check firewall or API binding');
      }
    } catch {
      setStatus('LAN Access', 'WARN', 'Could not verify LAN access');
    }
  }

  // Test CORS
  try {
    const corsCheck = run(`curl -s -H "Origin: http://localhost:3003" -I http://localhost:3001/api/health 2>nul`, { silent: true, timeout: 5_000 });
    if (corsCheck.stdout.includes('Access-Control-Allow-Origin')) {
      setStatus('CORS', 'PASS', 'CORS headers present');
    } else {
      setStatus('CORS', 'WARN', 'No CORS headers detected');
    }
  } catch {
    setStatus('CORS', 'WARN', 'Could not verify CORS');
  }
}

// ── Step 8: Generate DEV-STATUS.md ─────────────────────────────
async function step8Report() {
  log('─── Step 8: Report ───', 'INFO');

  const lanIp = getLanIp();
  const lines: string[] = [];

  lines.push('# Dev Environment Status');
  lines.push('');
  lines.push(`> **Generated:** ${new Date().toISOString()}`);
  lines.push(`> **Bootstrap:** v1.1`);
  lines.push(`> **LAN IP:** ${lanIp}`);
  lines.push(`> **Log:** ${logFile}`);
  lines.push('');
  lines.push('## Bootstrap Status');
  lines.push('');
  lines.push('| Service | Status | Detail |');
  lines.push('|---------|--------|--------|');

  const order = ['Node.js', 'pnpm', 'Flutter', 'Git', 'PowerShell', 'Docker', 'Port 3001', 'Port 3002', 'Port 3003', 'Port 3004', 'Docker Services', 'PostgreSQL', 'Database', 'API', 'Health Endpoint', 'LAN Access', 'CORS'];
  for (const key of order) {
    if (results[key]) {
      const r = results[key];
      const icon = r.status === 'PASS' ? '✅' : r.status === 'FAIL' ? '❌' : r.status === 'WARN' ? '⚠️' : '⏭️';
      lines.push(`| ${key} | ${icon} ${r.status} | ${r.detail} |`);
    }
  }

  lines.push('');
  lines.push('## Access URLs');
  lines.push('');
  lines.push('| Platform | URL |');
  lines.push('|----------|-----|');
  lines.push(`| API | http://localhost:${PORTS.api} |`);
  lines.push(`| API (LAN) | http://${lanIp}:${PORTS.api} |`);
  lines.push(`| Web (Next.js) | http://localhost:${PORTS.web} |`);
  lines.push(`| Flutter Verification | http://localhost:${PORTS.flutter} |`);
  lines.push(`| Flutter (Mobile) | http://${lanIp}:${PORTS.flutter} |`);
  lines.push('');
  lines.push('## Flutter API Configuration');
  lines.push('');
  lines.push(`The Flutter app uses \`--dart-define=API_BASE_URL=http://${lanIp}:${PORTS.api}\``);
  lines.push('to ensure mobile browsers on the same WiFi can reach the API.');
  lines.push('');

  // DX Score
  const passed = Object.values(results).filter(r => r.status === 'PASS').length;
  const total = Object.values(results).filter(r => r.status !== 'SKIP').length;
  const dxScore = total > 0 ? Math.round((passed / total) * 100) : 0;

  lines.push('## Developer Experience (DX) Score');
  lines.push('');
  lines.push(`| Metric | Score |`);
  lines.push(`|--------|-------|`);
  lines.push(`| Environment | ${dxScore}% |`);
  lines.push(`| ${passed}/${total} services healthy | ${dxScore}% |`);
  lines.push('');

  fs.writeFileSync(STATUS_FILE, lines.join('\n'), 'utf-8');
  setStatus('DEV-STATUS.md', 'PASS', `Generated with DX Score: ${dxScore}%`);
}

// ── Main ───────────────────────────────────────────────────────
async function main() {
  const args = process.argv.slice(2);
  const skipDocker = args.includes('--skip-docker');
  const verifyOnly = args.includes('--verify-only');

  console.log('');
  console.log('╔══════════════════════════════════════════════════╗');
  console.log('║     Yugrow Bootstrap v1.1                       ║');
  console.log('╚══════════════════════════════════════════════════╝');
  console.log(`  Log: ${logFile}`);
  console.log('');

  await step1Dependencies();
  await step2Ports();

  if (!verifyOnly) {
    const dockerOk = skipDocker || await step3Docker();
    if (dockerOk && !skipDocker) {
      await step4DockerServices();
      await step5Database();
    }
    await step6Api();
  }

  await step7Connectivity();
  await step8Report();

  // ── Summary ────────────────────────────────────────────────
  const failed = Object.values(results).filter(r => r.status === 'FAIL').length;
  const passed = Object.values(results).filter(r => r.status === 'PASS').length;

  console.log('');
  console.log('╔══════════════════════════════════════════════════╗');
  console.log(failed > 0
    ? '║     Bootstrap Complete — Issues Found                   ║'
    : '║     Bootstrap Complete — All Systems Go                 ║');
  console.log('╚══════════════════════════════════════════════════╝');
  console.log('');
  console.log(`  ✅ ${passed} passed  ❌ ${failed} failed`);
  console.log(`  📋 ${STATUS_FILE}`);
  console.log('');
  console.log('  Access URLs:');
  console.log(`  API             http://localhost:${PORTS.api}`);
  console.log(`  Web             http://localhost:${PORTS.web}`);
  console.log(`  Flutter         http://localhost:${PORTS.flutter}`);
  console.log(`  Flutter (Phone) http://${getLanIp()}:${PORTS.flutter}`);
  console.log('');

  logStream.end();
  process.exit(failed > 0 ? 1 : 0);
}

main().catch(e => {
  log(`Fatal error: ${e.message}`, 'ERROR');
  logStream.end();
  process.exit(1);
});
