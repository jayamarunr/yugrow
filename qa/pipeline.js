/**
 * QA Pipeline Orchestrator
 *
 * Runs Playwright journeys, collects evidence, generates QA report.
 * Designed for the AI feedback loop: test → collect → analyze → fix → retest.
 *
 * Usage:
 *   node qa/pipeline.js                  # Full QA run
 *   node qa/pipeline.js --grep "Auth"    # Run specific journeys
 *   node qa/pipeline.js --headed         # Run with browser visible
 *   node qa/pipeline.js --trace          # Force trace on all tests
 *
 * Environment:
 *   BASE_URL   — App URL (default: http://localhost:3000)
 *   API_URL    — API URL (default: http://localhost:4000)
 *   CI         — Set to "true" for CI mode (strict, no retries)
 */

const { execSync, spawn } = require('child_process');
const path = require('path');
const fs = require('fs');

const ROOT = path.resolve(__dirname, '..');
const REPORT_DIR = path.join(ROOT, 'qa', 'reports');

// Parse args
const args = process.argv.slice(2);
const grepIndex = args.indexOf('--grep');
const grep = grepIndex >= 0 ? args[grepIndex + 1] : null;
const headed = args.includes('--headed');
const forceTrace = args.includes('--trace');
const isCI = process.env.CI === 'true';

function log(step, message) {
  const ts = new Date().toISOString().split('T')[1].split('.')[0];
  console.log(`\n  [${ts}] [${step}] ${message}`);
}

function runCommand(cmd, opts = {}) {
  const defaults = { cwd: ROOT, stdio: 'inherit', shell: true };
  const merged = { ...defaults, ...opts };
  try {
    execSync(cmd, merged);
    return true;
  } catch (e) {
    return false;
  }
}

async function main() {
  console.log('\n═══════════════════════════════════════════════');
  console.log('  Yugrow QA Pipeline');
  console.log('═══════════════════════════════════════════════\n');

  // Step 1: Ensure QA directories exist
  log('SETUP', 'Ensuring QA directories...');
  for (const dir of ['reports', 'screenshots', 'videos', 'traces', 'failures']) {
    fs.mkdirSync(path.join(ROOT, 'qa', dir), { recursive: true });
  }

  // Step 2: Check if Playwright browsers are installed
  log('SETUP', 'Checking Playwright browsers...');
  const browsersInstalled = fs.existsSync(
    path.join(ROOT, 'node_modules', 'playwright', '.local-browsers')
  ) || fs.existsSync(
    path.join(process.env.USERPROFILE || '', 'AppData', 'Local', 'ms-playwright')
  );

  if (!browsersInstalled && !isCI) {
    log('SETUP', 'Installing Playwright browsers (chromium only)...');
    runCommand('npx playwright install chromium', { cwd: ROOT });
  }

  // Step 3: Check if dev server is running
  log('CHECK', 'Checking if dev server is running...');
  const serverRunning = runCommand(
    `powershell -Command "try { $r = Invoke-WebRequest -Uri '${process.env.BASE_URL || 'http://localhost:3000'}/health' -TimeoutSec 5 -UseBasicParsing; exit 0 } catch { exit 1 }"`,
    { stdio: 'pipe', cwd: ROOT }
  );

  if (!serverRunning) {
    console.log('\n  ⚠️  Dev server does not appear to be running.');
    console.log('     Start it with: make dev  OR  pnpm dev');
    console.log('     Or set BASE_URL to a running instance.\n');

    if (!isCI) {
      console.log('  Attempting to start dev server...');
      // Start dev server in background
      const devServer = spawn('pnpm', ['dev'], {
        cwd: ROOT,
        shell: true,
        stdio: 'pipe',
        detached: true,
      });

      // Wait for server to be ready
      let attempts = 0;
      const maxAttempts = 30;
      let serverReady = false;

      while (attempts < maxAttempts) {
        await new Promise(r => setTimeout(r, 2000));
        try {
          execSync(
            `powershell -Command "try { $r = Invoke-WebRequest -Uri '${process.env.BASE_URL || 'http://localhost:3000'}/health' -TimeoutSec 5 -UseBasicParsing; exit 0 } catch { exit 1 }"`,
            { stdio: 'pipe', cwd: ROOT }
          );
          serverReady = true;
          break;
        } catch {
          attempts++;
        }
      }

      if (!serverReady) {
        console.log('\n  ❌ Dev server failed to start within 60s.');
        console.log('     Start manually: pnpm dev');
        process.exit(1);
      }

      log('CHECK', 'Dev server is now running.');
    } else {
      console.log('\n  ❌ Dev server is not running. CI requires a running server.');
      process.exit(1);
    }
  } else {
    log('CHECK', 'Dev server is running.');
  }

  // Step 4: Build Playwright command
  log('TEST', 'Running Playwright journeys...');
  const playwrightArgs = ['playwright', 'test', '--config', 'playwright.config.ts'];

  if (grep) {
    playwrightArgs.push('--grep', grep);
    console.log(`     Filter: "${grep}"`);
  }

  if (headed) {
    playwrightArgs.push('--headed');
    console.log('     Mode: headed (visible browser)');
  }

  if (forceTrace) {
    // Trace is already configured in playwright.config.ts
    console.log('     Trace: enabled');
  }

  if (isCI) {
    playwrightArgs.push('--reporter', 'json');
    console.log('     Mode: CI');
  }

  // Step 5: Run Playwright
  console.log('\n  ── Running: npx ' + playwrightArgs.join(' ') + ' ──\n');
  const testPassed = runCommand('npx ' + playwrightArgs.join(' '), { cwd: ROOT });

  // Step 6: Check if QA report was generated
  const latestJson = path.join(REPORT_DIR, 'QA-LATEST.json');
  let passed = 0, failed = 0, total = 0, confidence = 0;
  let p0Failed = 0, p1Failed = 0;

  if (fs.existsSync(latestJson)) {
    try {
      const jsonData = JSON.parse(fs.readFileSync(latestJson, 'utf-8'));
      passed = jsonData.summary?.passed || 0;
      failed = jsonData.summary?.failed || 0;
      total = jsonData.summary?.total || 0;
      confidence = jsonData.confidence || 0;
      p0Failed = jsonData.severity?.p0?.failed || 0;
      p1Failed = jsonData.severity?.p1?.failed || 0;
    } catch {
      // Fallback to markdown parsing
      const latestReport = path.join(REPORT_DIR, 'QA-LATEST.md');
      if (fs.existsSync(latestReport)) {
        const content = fs.readFileSync(latestReport, 'utf-8');
        const passMatch = content.match(/\| ✅ Passed \| (\d+) \|/);
        const failMatch = content.match(/\| ❌ Failed \| (\d+) \|/);
        passed = passMatch ? parseInt(passMatch[1]) : 0;
        failed = failMatch ? parseInt(failMatch[1]) : 0;
      }
    }
  }

  const confidenceIcon = confidence >= 90 ? '🟢' : confidence >= 70 ? '🟡' : '🔴';

  console.log('\n  ── Results ──');
  console.log(`     ✅ Passed: ${passed}`);
  console.log(`     ❌ Failed: ${failed}`);
  console.log(`     ${confidenceIcon} Confidence: ${confidence}%`);
  console.log(`     🔴 P0 failures: ${p0Failed}`);
  console.log(`     🟠 P1 failures: ${p1Failed}`);
  console.log(`     📄 Report: qa/reports/QA-LATEST.md\n`);

  // Step 7: Visual regression check (only if full suite ran)
  if (!grep) {
    log('VISUAL', 'Running visual regression check...');
    runCommand('node qa/visual-diff.js --check', { stdio: 'pipe', cwd: ROOT });
  }

  // Step 8: Summary
  console.log('═══════════════════════════════════════════════');
  if (failed > 0) {
    console.log(`  ❌ QA Pipeline FAILED — ${failed} journey(s) did not pass.\n`);

    if (p0Failed > 0) {
      console.log('  🔴 P0 failures detected. STOP. Fix before continuing.');
    } else if (p1Failed > 0) {
      console.log('  🟠 P1 failures detected. Fix before committing.');
    }

    console.log('\n  📄 Report: qa/reports/QA-LATEST.md');
    console.log('  🔄 Autonomous fix: node qa/auto-fix-loop.js\n');
    process.exit(1);
  }

  console.log('  ✅ QA Pipeline PASSED — all journeys successful!');
  console.log(`  ${confidenceIcon} Confidence: ${confidence}%\n`);
  console.log('═══════════════════════════════════════════════\n');
}

main().catch(err => {
  console.error('Pipeline error:', err);
  process.exit(1);
});
