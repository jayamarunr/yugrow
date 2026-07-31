/**
 * Yugrow Platform Bootstrap v1.1 (JavaScript)
 * Single orchestrator for all platforms.
 * Invoked by: Makefile, bootstrap.ps1, or `node scripts/bootstrap/bootstrap.js`
 */
const{execSync,spawn}=require('child_process'),fs=require('fs'),path=require('path');
const ROOT=process.cwd(),PORTS={api:3001,web:3002,flutter:3003,qa:3004},LOG_DIR=path.join(ROOT,'logs','bootstrap'),STATUS_FILE=path.join(ROOT,'DEV-STATUS.md');
fs.mkdirSync(LOG_DIR,{recursive:true});
const ts=new Date().toISOString().replace(/[:.]/g,'-'),logFile=path.join(LOG_DIR,`bootstrap-${ts}.log`),logStream=fs.createWriteStream(logFile,{flags:'a'});
function log(m,l='INFO'){const line=`[${new Date().toISOString()}] [${l}] ${m}`;logStream.write(line+'\n');const p=l==='ERROR'?'❌':l==='WARN'?'⚠️':l==='DONE'?'✅':'  ';console.log(`  ${p} ${m}`)}
function run(c,o={}){try{const r=execSync(c,{cwd:o.cwd||ROOT,timeout:o.timeout||3e4,stdio:'pipe',windowsHide:true,shell:true});return{stdout:r.toString().trim(),exitCode:0}}catch(e){return{stdout:(e.stdout||'').toString().trim(),exitCode:e.status||1}}}
function sleep(ms){return new Promise(r=>setTimeout(r,ms))}
async function waitFor(fn,t,iv=2e3){const s=Date.now();while(Date.now()-s<t){if(fn())return true;await sleep(iv)}return false}
function getLanIp(){try{const r=run('powershell.exe -Command "(Get-NetIPConfiguration|Where-Object{$_.IPv4DefaultGateway-ne$null}).IPv4Address.IPAddress"',{timeout:5e3});if(r.stdout&&r.exitCode===0)return r.stdout.trim()}catch{}try{const r=run('ipconfig',{timeout:5e3}),m=r.stdout.match(/IPv4 Address[^:]*:\s*([0-9.]+)/);if(m)return m[1]}catch{}return'127.0.0.1'}
function isPortOpen(p){try{const r=run(`powershell.exe -Command "Get-NetTCPConnection -LocalPort ${p} -ErrorAction SilentlyContinue|Select-Object OwningProcess"`,{timeout:5e3});if(r.stdout.trim()){const pid=parseInt(r.stdout.trim().split('\n')[0]);if(pid)return{inUse:true,pid}}}catch{}return{inUse:false}}
function killProcess(pid){try{run(`taskkill /F /PID ${pid}`,{timeout:3e3})}catch{}}
const results={};
function setStatus(svc,status,detail){results[svc]={status,detail};log(`${svc}: ${status} — ${detail}`,status==='FAIL'?'ERROR':status==='WARN'?'WARN':status==='PASS'?'DONE':'INFO')}

async function step1(){
  log('─── Step 1: Dependencies ───');
  const checks=[{name:'Node.js',cmd:'node --version'},{name:'pnpm',cmd:'pnpm --version'},{name:'Flutter',cmd:'flutter --version'},{name:'Git',cmd:'git --version'}];
  try{execSync('docker --version',{stdio:'pipe',timeout:5e3});checks.push({name:'Docker',cmd:'docker --version'})}catch{}
  for(const d of checks){const r=run(d.cmd,{timeout:1e4});setStatus(d.name,r.exitCode===0?'PASS':'FAIL',r.exitCode===0?r.stdout.split('\n')[0].substring(0,60):'Not found')}
}

async function step2(){
  log('─── Step 2: Ports ───');
  for(const[n,p]of Object.entries(PORTS)){const c=isPortOpen(p);if(c.inUse){log(`Port ${p} in use — killing...`,'WARN');killProcess(c.pid);await sleep(1e3);const r=isPortOpen(p);setStatus(`Port ${p}`,r.inUse?'FAIL':'PASS',r.inUse?'Could not free':'Freed')}else setStatus(`Port ${p}`,'PASS','Available')}
}

async function step3(){
  log('─── Step 3: Docker ───');
  const r=run('docker info',{timeout:1e4});if(r.exitCode===0){setStatus('Docker','PASS','Running');return true}
  log('Starting Docker...','WARN');run('start "" "C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe"',{timeout:5e3});
  const ok=await waitFor(()=>run('docker info',{timeout:5e3}).exitCode===0,12e4);setStatus('Docker',ok?'PASS':'FAIL',ok?'Started':'Failed');return ok
}

async function step4(){
  log('─── Step 4: Docker Services ───');
  const f=path.join(ROOT,'infrastructure','docker','docker-compose.yml');if(!fs.existsSync(f)){setStatus('Docker Services','FAIL','File not found');return}
  run(`docker compose -f "${f}" up -d`,{timeout:6e4});const ok=await waitFor(()=>{const r=run(`docker compose -f "${f}" ps --format json`,{timeout:5e3});return r.stdout.includes('postgres')&&r.stdout.includes('running')},3e4);
  setStatus('Docker Services',ok?'PASS':'WARN',ok?'Running':'May not be ready')
}

async function step5(){
  log('─── Step 5: Database ───');
  const g=run('pnpm db:generate',{timeout:3e4});const p=g.exitCode===0?run('pnpm db:push',{timeout:3e4}):g;
  setStatus('Database',g.exitCode===0&&p.exitCode===0?'PASS':'FAIL','Schema setup')
}

async function step6(){
  log('─── Step 6: API ───');
  const d=path.join(ROOT,'apps','api');if(!fs.existsSync(d)){setStatus('API','FAIL','Not found');return}
  spawn('pnpm',['dev'],{cwd:d,stdio:'pipe',shell:true,windowsHide:true});
  const ok=await waitFor(()=>{try{return run('curl -s http://localhost:3001/api/health 2>nul',{timeout:3e3}).exitCode===0}catch{return false}},3e4);
  setStatus('API',ok?'PASS':'WARN',ok?'Running on :3001':'May need more time')
}

async function step7(){
  log('─── Step 7: Connectivity ───');
  const ip=getLanIp();const l=run('curl -s http://localhost:3001/api/health 2>nul',{timeout:5e3});
  setStatus('Health Endpoint',l.exitCode===0?'PASS':'FAIL',l.exitCode===0?'200 OK':'Not reachable');
  if(ip!=='127.0.0.1'){const a=run(`curl -s http://${ip}:3001/api/health 2>nul`,{timeout:5e3});setStatus('LAN Access',a.exitCode===0?'PASS':'WARN',a.exitCode===0?'Reachable':'Check firewall')}
  const c=run(`curl -s -H "Origin: http://localhost:3003" -I http://localhost:3001/api/health 2>nul`,{timeout:5e3});
  setStatus('CORS',c.stdout.includes('Access-Control')?'PASS':'WARN',c.stdout.includes('Access-Control')?'Headers present':'Not detected')
}

async function step8(){
  log('─── Step 8: Report ───');
  const ip=getLanIp(),order=['Node.js','pnpm','Flutter','Git','Docker','Port 3001','Port 3002','Port 3003','Port 3004','Docker Services','Database','API','Health Endpoint','LAN Access','CORS'];
  const lines=['# Dev Environment Status','',`> **Generated:** ${new Date().toISOString()}`,'> **Bootstrap:** v1.1',`> **LAN IP:** ${ip}`,`> **Log:** ${logFile}`,'','## Bootstrap Status','','| Service | Status | Detail |','|---------|--------|--------|'];
  for(const k of order){if(results[k]){const r=results[k],icon=r.status==='PASS'?'✅':r.status==='FAIL'?'❌':'⚠️';lines.push(`| ${k} | ${icon} ${r.status} | ${r.detail} |`)}}
  lines.push('','## Access URLs','','| Platform | URL |','|----------|-----|');
  for(const[n,p]of Object.entries(PORTS))lines.push(`| ${n} | http://localhost:${p} |`);
  lines.push(`| Mobile Flutter | http://${ip}:${PORTS.flutter} |`);
  const passed=Object.values(results).filter(r=>r.status==='PASS').length,total=Object.values(results).filter(r=>r.status!=='SKIP').length,dx=total>0?Math.round(passed/total*100):0;
  lines.push('','## DX Score','','| Metric | Score |','|--------|-------|',`| Environment | ${dx}% |`, `| ${passed}/${total} healthy | ${dx}% |`);
  fs.writeFileSync(STATUS_FILE,lines.join('\n'),'utf8');setStatus('DEV-STATUS.md','PASS',`DX Score: ${dx}%`);return{passed,failed:total-passed,lanIp:ip}
}

async function main(){
  const args=process.argv.slice(2),skipDocker=args.includes('--skip-docker'),verifyOnly=args.includes('--verify-only');
  console.log('\n╔══════════════════════════════════════════════════╗\n║     Yugrow Bootstrap v1.1                       ║\n╚══════════════════════════════════════════════════╝\n');log(`Log: ${logFile}`,'INFO');
  await step1();await step2();
  if(!verifyOnly){const ok=skipDocker||await step3();if(ok&&!skipDocker){await step4();await step5()}await step6()}
  await step7();const{passed,failed,lanIp}=await step8();
  console.log(`\n╔══════════════════════════════════════════════════╗\n║${failed>0?'  Bootstrap Complete — Issues Found               ':'  Bootstrap Complete — All Systems Go                 '}║\n╚══════════════════════════════════════════════════╝\n`);
  console.log(`  ✅ ${passed} passed  ❌ ${failed} failed\n  📋 ${STATUS_FILE}\n`);
  console.log('  Access URLs:');console.log(`  API             http://localhost:${PORTS.api}`);console.log(`  Web             http://localhost:${PORTS.web}`);console.log(`  Flutter         http://localhost:${PORTS.flutter}`);console.log(`  Flutter (Phone) http://${lanIp}:${PORTS.flutter}\n`);
  logStream.end();process.exit(failed>0?1:0)
}
main().catch(e=>{log(`Fatal: ${e.message}`,'ERROR');logStream.end();process.exit(1)});
