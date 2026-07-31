/**
 * Autonomous QA Fix Loop
 *
 * This script implements the self-correcting development loop:
 *
 *   ┌─────────────────────────────────────────┐
 *   │  Run Playwright                         │
 *   │         │                               │
 *   │         ▼                               │
 *   │  Collect Evidence                       │
 *   │         │                               │
 *   │         ▼                               │
 *   │  Analyze Failures                       │
 *   │         │                               │
 *   │    ┌────┴────┐                          │
 *   │    │ P0?     │                          │
 *   │    └────┬────┘                          │
 *   │         │                               │
 *   │    YES  │          NO                   │
 *   │    ┌────┴────┐    ┌────┴────┐           │
 *   │    │ STOP   │    │ Report  │           │
 *   │    │ FIX    │    │ PASS    │           │
 *   │    └────┬────┘    └─────────┘           │
 *   │         │                               │
 *   │         ▼                               │
 *   │  Re-run QA                              │
 *   │         │                               │
 *   │         ▼                               │
 *   │  PASS? ──NO──► Repeat (max 3x)          │
 *   │         │                               │
 *   │        YES                              │
 *   │         │                               │
 *   │         ▼                               │
 *   │  Session Complete                       │
 *   └─────────────────────────────────────────┘
 *
 * Usage:
 *   node qa/auto-fix-loop.js              # Full autonomous loop
 *   node qa/auto-fix-loop.js --max-retry 5 # Allow up to 5 fix attempts
 *   node qa/auto-fix-loop.js --dry-run    # Run QA without fixing
 *
 * Environment:
 *   CI=true  — CI mode (strict, no retries)
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');

const args = process.argv.slice(2);
const MAX_RETRIES = parseInt(args.find(a => a.startsWith('--max-retry'))?.split('=')[1] || process.env.MAX_RETRIES || '3', 10);
const DRY_RUN = args.includes('--dry-run');
const isCI = process.env.CI === 'true';

function log(step, message) {
  const ts = new Date().toISOString().split('T')[1].split('.')[0];
  console.log(`\n  [${ts}] [${step}] ${message}`);
}

function runCommand(cmd) {
  try {
    execSync(cmd, { cwd: ROOT, stdio: 'inherit', shell: true });
    return true;
  } catch {
    return false;
  }
}

function getQAResults() {
  const jsonPath = path.join(ROOT, 'qa', 'reports', 'QA-LATEST.json');
  if (!fs.existsSync(jsonPath)) return null;
  try {
    return JSON.parse(fs.readFileSync(jsonPath, 'utf-8'));
  } catch {
    return null;
  }
}

function getFailedJourneys(results) {
  if (!results?.results) return [];
  return results.results
    .filter(r => r.status === 'failed')
    .map(r => ({
      title: r.title,
      severity: r.severity,
      hasScreenshot: r.hasScreenshot,
      hasTrace: r.hasTrace,
      error: r.error,
    }));
}

function buildEvidenceBundle(results) {
  // Package the latest QA report, traces, screenshots for AI analysis
  const bundle = {
    report: path.join(ROOT, 'qa', 'reports', 'QA-LATEST.md'),
    summary: results?.summary || {},
    severity: results?.severity || {},
    confidence: results?.confidence || 0,
    failures: getFailedJourneys(results),
  };
  return bundle;
}

async function main() {
  console.log('\n═══════════════════════════════════════════════');
  console.log('  Autonomous QA Fix Loop');
  console.log('═══════════════════════════════════════════════\n');

  console.log(`  Max retry attempts: ${MAX_RETRIES}`);
  console.log(`  Dry run: ${DRY_RUN ? 'YES (no fixes applied)' : 'NO'}`);
  console.log(`  CI mode: ${isCI ? 'YES' : 'NO'}`);
  console.log('');

  let attempt = 0;
  let allPassed = false;
  let failedBefore = false;

  while (attempt <= MAX_RETRIES) {
    attempt++;
    console.log(`\n  ── Attempt ${attempt}/${MAX_RETRIES} ──\n`);

    // Step 1: Run QA
    log('QA', 'Running Playwright journeys...');
    const qaPassed = runCommand('node qa/pipeline.js');

    // Step 2: Collect results
    const results = getQAResults();

    if (!results) {
      log('ERROR', 'Could not read QA results. Pipeline may have failed.');
      break;
    }

    const failures = getFailedJourneys(results);
    const p0Failures = failures.filter(f => f.severity === 'P0');
    const p1Failures = failures.filter(f => f.severity === 'P1');

    console.log('');
    log('RESULTS', `Passed: ${results.summary?.passed || 0}, Failed: ${results.summary?.failed || 0}`);
    log('RESULTS', `P0 failures: ${p0Failures.length}, P1 failures: ${p1Failures.length}`);
    log('RESULTS', `Confidence: ${results.confidence}%`);

    if (qaPassed && p0Failures.length === 0) {
      allPassed = true;
      console.log('\n  ✅ All QA gates passed!\n');
      break;
    }

    if (failedBefore && p0Failures.length > 0) {
      log('STUCK', 'P0 failures persist after fix attempt. Manual intervention needed.');
      break;
    }

    if (attempt > MAX_RETRIES) {
      log('LIMIT', `Max retries (${MAX_RETRIES}) reached. Manual intervention needed.`);
      break;
    }

    // Step 3: Build evidence bundle
    const evidence = buildEvidenceBundle(results);
    console.log('');
    log('EVIDENCE', `Bundle created at ${evidence.report}`);
    log('EVIDENCE', `Failures to fix: ${evidence.failures.length}`);
    for (const f of evidence.failures) {
      console.log(`    ${f.severity === 'P0' ? '🔴' : '🟠'} [${f.severity}] ${f.title}`);
    }

    // Step 4: If CI mode or dry run, stop here — no auto-fix
    if (isCI) {
      log('CI', 'CI mode — stopping. Manual fix required.');
      break;
    }

    if (DRY_RUN) {
      log('DRY RUN', 'Dry run mode — stopping without fixing.');
      break;
    }

    failedBefore = true;

    // Step 5: Apply fixes (prompt the Bug Fix Engineer)
    console.log('');
    log('FIX', 'Evidence bundle ready at: qa/reports/QA-LATEST.md');
    log('FIX', '');
    log('FIX', 'To continue the autonomous loop:');
    log('FIX', '1. Read qa/reports/QA-LATEST.md');
    log('FIX', '2. Apply minimal fix based on evidence');
    log('FIX', '3. Re-run this script: node qa/auto-fix-loop.js');
    log('FIX', '');

    if (p0Failures.length > 0) {
      log('ACTION', '🔴 Fix P0 failures FIRST:');
      for (const f of p0Failures) {
        console.log(`       - ${f.title}`);
        if (f.hasTrace) console.log(`         Trace: qa/traces/`);
        if (f.hasScreenshot) console.log(`         Screenshot: qa/screenshots/`);
      }
    }

    if (p1Failures.length > 0) {
      log('ACTION', '🟠 Then fix P1 failures:');
      for (const f of p1Failures) {
        console.log(`       - ${f.title}`);
      }
    }

    console.log('');
    log('NEXT', `Re-run: node qa/auto-fix-loop.js`);
    break; // Break after first iteration — AI will re-run
  }

  // Final summary
  console.log('\n═══════════════════════════════════════════════');
  if (allPassed) {
    console.log('  ✅ QA Fix Loop Complete — All journeys PASS');
    console.log('  📄 Report: qa/reports/QA-LATEST.md');
    console.log('  🟢 Ready for commit.');
  } else if (isCI) {
    console.log('  ❌ CI: QA pipeline failed. Check qa/reports/QA-LATEST.md');
    process.exit(1);
  } else {
    console.log('  📋 QA evidence collected. Feed to Bug Fix Engineer.');
    console.log('  📄 Report: qa/reports/QA-LATEST.md');
    console.log('  🔄 Re-run: node qa/auto-fix-loop.js');
  }
  console.log('═══════════════════════════════════════════════\n');
}

main().catch(err => {
  console.error('Auto-fix loop error:', err);
  process.exit(1);
});
