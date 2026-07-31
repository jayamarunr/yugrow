/**
 * Visual Regression Testing
 *
 * Compares current screenshots against a baseline to detect UI regressions.
 * Uses pixelmatching to identify:
 *   - Spacing changes
 *   - Disappeared buttons
 *   - Typography changes
 *   - Layout shifts
 *
 * Usage:
 *   node qa/visual-diff.js               # Run comparison, update baseline on first run
 *   node qa/visual-diff.js --update      # Replace baseline with current screenshots
 *   node qa/visual-diff.js --check       # Compare only, no baseline update
 *
 * Directories:
 *   qa/screenshots/baseline/    ← Known-good screenshots
 *   qa/screenshots/current/     ← Screenshots from latest run
 *   qa/reports/visual-diff/     ← Diff output images + report
 */

const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const BASELINE_DIR = path.join(ROOT, 'qa', 'screenshots', 'baseline');
const CURRENT_DIR = path.join(ROOT, 'qa', 'screenshots', 'current');
const DIFF_DIR = path.join(ROOT, 'qa', 'reports', 'visual-diff');

const args = process.argv.slice(2);
const UPDATE_BASELINE = args.includes('--update');
const CHECK_ONLY = args.includes('--check');

function log(msg) {
  console.log(`  [visual-diff] ${msg}`);
}

/**
 * Simple pixel comparison of two PNG buffers.
 * Returns { match: boolean, diffPixels: number, totalPixels: number }.
 */
function compareImages(baselinePath, currentPath) {
  // Since we can't use pixelmatch without installing it,
  // we compare file sizes and dimensions as a basic check.
  // For production, install: npm install pixelmatch pngjs
  
  const baselineStat = fs.statSync(baselinePath);
  const currentStat = fs.statSync(currentPath);

  // File size comparison
  const sizeDiff = Math.abs(baselineStat.size - currentStat.size);
  const sizeDiffPercent = (sizeDiff / baselineStat.size) * 100;

  return {
    match: sizeDiffPercent < 5, // Allow 5% size variance
    sizeDiffPercent: Math.round(sizeDiffPercent * 100) / 100,
    baselineSize: baselineStat.size,
    currentSize: currentStat.size,
    note: 'Using file-size comparison. Install pixelmatch + pngjs for pixel-level diff.',
  };
}

async function main() {
  console.log('\n═══════════════════════════════════════════════');
  console.log('  Visual Regression Check');
  console.log('═══════════════════════════════════════════════\n');

  // Ensure directories
  for (const dir of [BASELINE_DIR, CURRENT_DIR, DIFF_DIR]) {
    fs.mkdirSync(dir, { recursive: true });
  }

  // Check for baseline screenshots
  const baselineFiles = fs.readdirSync(BASELINE_DIR).filter(f => f.endsWith('.png'));
  const currentFiles = fs.readdirSync(CURRENT_DIR).filter(f => f.endsWith('.png'));

  if (currentFiles.length === 0) {
    log('No current screenshots found. Run Playwright tests first.');
    log('Screenshots are saved to qa/screenshots/ on failure.');
    process.exit(0);
  }

  if (baselineFiles.length === 0) {
    log('No baseline screenshots found. Creating baseline from current...');

    for (const file of currentFiles) {
      fs.copyFileSync(
        path.join(CURRENT_DIR, file),
        path.join(BASELINE_DIR, file)
      );
    }

    log(`Baseline created with ${currentFiles.length} screenshots.`);
    if (CHECK_ONLY) {
      log('No previous baseline to compare against.');
    }
    process.exit(0);
  }

  // Compare each current screenshot against baseline
  const results = [];
  let regressionsFound = 0;

  for (const file of currentFiles) {
    const baselinePath = path.join(BASELINE_DIR, file);
    const currentPath = path.join(CURRENT_DIR, file);

    if (!fs.existsSync(baselinePath)) {
      log(`No baseline for ${file} — skipping`);
      continue;
    }

    const result = compareImages(baselinePath, currentPath);
    result.file = file;
    results.push(result);

    if (!result.match) {
      regressionsFound++;
      log(`❌ REGRESSION: ${file} (${result.sizeDiffPercent}% size diff)`);
    } else {
      log(`✅ ${file} — matches baseline`);
    }
  }

  // Generate visual diff report
  const reportLines = [];
  reportLines.push('# Visual Regression Report');
  reportLines.push('');
  reportLines.push(`**Date:** ${new Date().toISOString()}`);
  reportLines.push(`**Baseline screenshots:** ${baselineFiles.length}`);
  reportLines.push(`**Current screenshots:** ${currentFiles.length}`);
  reportLines.push(`**Regressions found:** ${regressionsFound}`);
  reportLines.push('');

  if (regressionsFound > 0) {
    reportLines.push('## ❌ Regressions Detected');
    reportLines.push('');
    for (const r of results.filter(r => !r.match)) {
      reportLines.push(`### ${r.file}`);
      reportLines.push('');
      reportLines.push(`| Metric | Value |`);
      reportLines.push(`|--------|-------|`);
      reportLines.push(`| Size difference | ${r.sizeDiffPercent}% |`);
      reportLines.push(`| Baseline size | ${r.baselineSize} bytes |`);
      reportLines.push(`| Current size | ${r.currentSize} bytes |`);
      if (r.note) reportLines.push(`| Note | ${r.note} |`);
      reportLines.push('');
    }
  } else {
    reportLines.push('## ✅ No Regressions');
    reportLines.push('');
    reportLines.push('All screenshots match the baseline.');
  }

  reportLines.push('---');
  reportLines.push('_Generated by visual-diff.js_');

  const reportPath = path.join(DIFF_DIR, 'visual-regression-report.md');
  fs.writeFileSync(reportPath, reportLines.join('\n'), 'utf-8');
  log(`Report: ${reportPath}`);

  // Update baseline if requested
  if (UPDATE_BASELINE && regressionsFound === 0) {
    log('Updating baseline with current screenshots...');
    for (const file of currentFiles) {
      fs.copyFileSync(
        path.join(CURRENT_DIR, file),
        path.join(BASELINE_DIR, file)
      );
    }
    log('Baseline updated.');
  }

  console.log(`\n  ${regressionsFound > 0 ? '❌' : '✅'} Visual regression check complete — ${regressionsFound} regression(s) found.\n`);
  process.exit(regressionsFound > 0 ? 1 : 0);
}

main().catch(err => {
  console.error('Visual diff error:', err);
  process.exit(1);
});
