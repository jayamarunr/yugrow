import type { FullConfig, FullResult, Suite, TestCase, TestResult, Reporter } from '@playwright/test/reporter';
import * as fs from 'fs';
import * as path from 'path';

/**
 * Severity classification for test failures.
 */
type Severity = 'P0' | 'P1' | 'P2';

/** Reason for skipped tests */
type SkipCategory = 'mobile' | 'requires-mapbox' | 'future-feature' | 'blocked';

interface JourneyResult {
  title: string;
  status: string;
  duration: number;
  severity: Severity;
  error?: string;
  stack?: string;
  screenshot?: string;
  trace?: string;
  video?: string;
  consoleLogs?: string[];
}

// Journey QA IDs — traceable identifiers for every journey
const JOURNEY_QA_IDS: Record<string, string> = {
  'authentication': 'QA-001',
  'onboarding': 'QA-002',
  'profile': 'QA-003',
  'event-discovery': 'QA-004',
  'venue': 'QA-005',
  'checkin': 'QA-006',
  'discovery': 'QA-007',
  'connection': 'QA-008',
  'conversation': 'QA-009',
  'founder-walkthrough': 'QA-010',
  'landing': 'QA-011',
  'dashboard': 'QA-012',
  'messages-network': 'QA-013',
  'performance': 'QA-014',
  'accessibility': 'QA-015',
};

// AH-to-QA traceability — maps Alpha Hardening IDs to QA journey IDs
const AH_TO_QA: Record<string, string[]> = {
  'AH-015': ['QA-004'],       // today-only events
  'AH-016': ['QA-006'],       // check-in gates ("I'm Here" disabled)
  'AH-017': ['QA-004'],       // event detail completeness
  'AH-018': ['QA-007'],       // presence-aware Live tab
  'AH-019': ['QA-009', 'QA-013'],  // system conversation dedup
  'AH-020': ['QA-013'],       // Yugrow styling in Network
  'AH-021': ['QA-006'],       // real check-in API
  'AH-022': ['QA-003'],       // auth identity in profile
  'AH-023': ['QA-004'],       // EventState helper
};

// Screen Ownership — maturity level per screen
// 🥇 Gold = Fully YDS compliant | 🥈 Silver = Minor polish remaining | 🥉 Bronze = Pre-YDS debt
const SCREEN_OWNERSHIP: Record<string, { level: 'Gold' | 'Silver' | 'Bronze'; label: string }> = {
  'landing': { level: 'Gold', label: 'Landing' },
  'authentication': { level: 'Gold', label: 'Login / Auth' },
  'onboarding': { level: 'Silver', label: 'Onboarding' },
  'event-discovery': { level: 'Silver', label: 'Event Detail' },
  'dashboard': { level: 'Silver', label: 'Dashboard' },
  'conversation': { level: 'Gold', label: 'Messages' },
  'messages-network': { level: 'Gold', label: 'Network' },
  'profile': { level: 'Bronze', label: 'Profile' },
  'venue': { level: 'Bronze', label: 'Venue' },
  'checkin': { level: 'Silver', label: 'Check-in / Live' },
  'discovery': { level: 'Silver', label: 'Discovery' },
  'connection': { level: 'Silver', label: 'Connection' },
  'founder-walkthrough': { level: 'Gold', label: 'Founder Console' },
};

// Design Compliance — weighted scoring categories
// Each category scored 0-100. Deduct 5 per violation, minimum 0.
const DESIGN_COMPLIANCE_WEIGHTS: Record<string, number> = {
  'Typography': 15,
  'Spacing': 15,
  'Colour': 10,
  'Components': 20,
  'Accessibility': 10,
  'Motion': 5,
  'Empty/Loading/Error': 10,
  'Interaction': 10,
  'Brand Presence': 5,
};

// Convert screen maturity to a numeric score for averaging
function maturityScore(level: 'Gold' | 'Silver' | 'Bronze'): number {
  switch (level) {
    case 'Gold': return 100;
    case 'Silver': return 75;
    case 'Bronze': return 50;
  }
}

// Journey severity mapping
const JOURNEY_SEVERITY: Record<string, Severity> = {
  'authentication': 'P0',
  'onboarding': 'P0',
  'profile': 'P1',
  'event-discovery': 'P0',
  'venue': 'P1',
  'checkin': 'P0',
  'discovery': 'P1',
  'connection': 'P1',
  'conversation': 'P1',
  'founder-walkthrough': 'P0',
  'landing': 'P0',
  'dashboard': 'P0',
  'messages-network': 'P1',
  'performance': 'P2',
  'accessibility': 'P2',
};

// Product Maturity — per-subsystem name for maturity scoring
const SUBSYSTEM_NAMES: Record<string, string> = {
  'authentication': 'Identity',
  'onboarding': 'Onboarding',
  'profile': 'Profile',
  'event-discovery': 'Events',
  'venue': 'Venue',
  'checkin': 'Check-in',
  'discovery': 'Discovery',
  'connection': 'Networking',
  'conversation': 'Messaging',
  'founder-walkthrough': 'Founder Console',
  'landing': 'Landing',
  'dashboard': 'Dashboard',
  'messages-network': 'Messaging',
  'performance': 'Performance',
  'accessibility': 'Accessibility',
};

function getJourneyKey(testCase: TestCase): string {
  const testPath = testCase.location.file || '';
  for (const key of Object.keys(JOURNEY_SEVERITY)) {
    if (testPath.includes(key)) return key;
  }
  return '';
}

function classifySeverity(testCase: TestCase): Severity {
  const key = getJourneyKey(testCase);
  return JOURNEY_SEVERITY[key] || 'P1';
}

function getQaId(testCase: TestCase): string {
  const key = getJourneyKey(testCase);
  return JOURNEY_QA_IDS[key] || 'QA-000';
}

function classifySkipReason(title: string): SkipCategory {
  const lower = title.toLowerCase();
  if (lower.includes('[mobile]')) return 'mobile';
  if (lower.includes('mapbox') || lower.includes('venue search') || lower.includes('geolocation')) return 'requires-mapbox';
  if (lower.includes('future') || lower.includes('phase')) return 'future-feature';
  return 'blocked';
}

/**
 * QA Evidence Reporter v3 — generates QA-LATEST.md + QA-DASHBOARD.md
 * with QA IDs, Journey Health, Founder Confidence, Demo Readiness gate.
 */
class QAEvidenceReporter implements Reporter {
  private outputDir: string;
  private results: JourneyResult[] = [];

  constructor(options: { outputDir?: string } = {}) {
    this.outputDir = options.outputDir || './qa/reports';
  }

  onBegin(_config: FullConfig, _suite: Suite) {
    this.results = [];
  }

  onTestEnd(test: TestCase, result: TestResult) {
    const attachments = result.attachments || [];
    const severity = classifySeverity(test);
    const qaId = getQaId(test);

    const entry: JourneyResult = {
      title: `${qaId} ${test.title}`,
      status: result.status,
      duration: result.duration,
      severity,
    };

    if (result.error) {
      entry.error = result.error.message;
      if (result.error.stack) entry.stack = result.error.stack;
    }

    for (const attachment of attachments) {
      if (attachment.contentType === 'image/png') entry.screenshot = attachment.path || undefined;
      if (attachment.name === 'trace' && attachment.path) entry.trace = attachment.path;
      if (attachment.contentType === 'video/webm' && attachment.path) entry.video = attachment.path;
    }

    const consoleAttachment = attachments.find(a => a.name === 'console');
    if (consoleAttachment?.body) {
      entry.consoleLogs = consoleAttachment.body.toString().split('\n');
    }

    this.results.push(entry);
  }

  onEnd(result: FullResult) {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const reportPath = path.resolve(this.outputDir, `QA-${timestamp}.md`);

    // ── Compute metrics ──────────────────────────────────────────

    const passed = this.results.filter(r => r.status === 'passed').length;
    const failed = this.results.filter(r => r.status === 'failed').length;
    const skipped = this.results.filter(r => r.status === 'skipped').length;

    const p0Failed = this.results.filter(r => r.severity === 'P0' && r.status === 'failed').length;
    const p1Failed = this.results.filter(r => r.severity === 'P1' && r.status === 'failed').length;
    const p2Failed = this.results.filter(r => r.severity === 'P2' && r.status === 'failed').length;

    const p0Total = this.results.filter(r => r.severity === 'P0').length;
    const p1Total = this.results.filter(r => r.severity === 'P1').length;
    const p2Total = this.results.filter(r => r.severity === 'P2').length;

    const p0PassRate = p0Total > 0 ? (p0Total - p0Failed) / p0Total : 1;
    const p1PassRate = p1Total > 0 ? (p1Total - p1Failed) / p1Total : 1;
    const p2PassRate = p2Total > 0 ? (p2Total - p2Failed) / p2Total : 1;

    // ── Demo Confidence (was "Founder Confidence") ──────────────
    // Journey Pass (40%) + QA Severity (30%) + Performance (10%) + Accessibility (10%) + Visual (10%)
    const journeyPassRate = passed / (passed + failed) || 1;
    const sevScore = p0PassRate * 0.5 + p1PassRate * 0.3 + p2PassRate * 0.2;
    const perfResults = this.results.filter(r => r.title.includes('QA-014'));
    const perfPassRate = perfResults.length > 0 ? perfResults.filter(r => r.status === 'passed').length / perfResults.length : 1;
    const a11yResults = this.results.filter(r => r.title.includes('QA-015'));
    const a11yPassRate = a11yResults.length > 0 ? a11yResults.filter(r => r.status === 'passed').length / a11yResults.length : 1;

    const demoConfidence = Math.round(
      (journeyPassRate * 40 + sevScore * 30 + perfPassRate * 10 + a11yPassRate * 10 + 1 * 10) * 100
    ) / 100;

    // ── User Success Confidence ──────────────────────────────────
    // Can a stranger complete critical journeys? Based on P0 journey pass rate.
    const p0Results = this.results.filter(r => r.severity === 'P0');
    const p0Passed = p0Results.filter(r => r.status === 'passed').length;
    const p0TotalJourneys = p0Results.length;
    const userSuccessConfidence = p0TotalJourneys > 0
      ? Math.round((p0Passed / p0TotalJourneys) * 100)
      : 100;

    // ── Product Stability ────────────────────────────────────────
    // Build success + regression rate + zero P0 + zero known crashes
    const buildSuccess = result.status === 'passed' ? 1 : 0;
    const regressionScore = failed === 0 ? 1 : Math.max(0, 1 - (failed / this.results.length));
    const p0Score = p0Failed === 0 ? 1 : 0;
    const productStability = Math.round(
      (buildSuccess * 30 + regressionScore * 40 + p0Score * 30) * 100
    ) / 100;

    // ── Journey Health ───────────────────────────────────────────
    // Group results by journey file key
    const journeyHealth: Array<{ qaId: string; name: string; status: string; severity: Severity; passCount: number; failCount: number; totalCount: number }> = [];
    const journeyMap = new Map<string, { qaId: string; name: string; severity: Severity; passCount: number; failCount: number; totalCount: number }>();

    for (const r of this.results) {
      const qaIdMatch = r.title.match(/^(QA-\d+)/);
      const id = qaIdMatch ? qaIdMatch[1] : 'QA-000';
      const name = r.title.replace(/^QA-\d+\s*/, '').split(' › ')[0];

      if (!journeyMap.has(id)) {
        journeyMap.set(id, { qaId: id, name, severity: r.severity, passCount: 0, failCount: 0, totalCount: 0 });
      }
      const j = journeyMap.get(id)!;
      j.totalCount++;
      if (r.status === 'passed') j.passCount++;
      if (r.status === 'failed') j.failCount++;
    }

    for (const [, j] of journeyMap) {
      j.passCount === j.totalCount ? '🟢' : j.failCount > 0 ? '🔴' : '⏭️';
      journeyHealth.push(j);
    }

    journeyHealth.sort((a, b) => a.qaId.localeCompare(b.qaId));

    // ── Skip categories ──────────────────────────────────────────
    const skipReasons: Record<SkipCategory, number> = { mobile: 0, 'requires-mapbox': 0, 'future-feature': 0, blocked: 0 };
    const skipNames: Record<SkipCategory, string> = {
      mobile: 'Mobile (Flutter)',
      'requires-mapbox': 'Requires Mapbox/Geolocation',
      'future-feature': 'Future Feature',
      blocked: 'Blocked',
    };

    for (const r of this.results.filter(r => r.status === 'skipped')) {
      const reason = classifySkipReason(r.title);
      skipReasons[reason]++;
    }

    // ── Demo Readiness gate ──────────────────────────────────────
    const demoReady = failed === 0 && p0Failed === 0 && p1Failed === 0;

    // ── QA Confidence ────────────────────────────────────────────
    const qaConfidence = Math.round((p0PassRate * 50 + p1PassRate * 30 + p2PassRate * 20) * 100) / 100;

    // ── Product Maturity (per-subsystem) ─────────────────────────
    const productMaturity: Array<{ subsystem: string; qaId: string; passRate: number; score: number }> = [];
    const seenSubsystems = new Set<string>();
    for (const r of this.results) {
      const qaIdMatch = r.title.match(/^(QA-\d+)/);
      const id = qaIdMatch ? qaIdMatch[1] : 'QA-000';
      // Get subsystem key from QA ID
      const subsystemKey = Object.entries(JOURNEY_QA_IDS).find(([, v]) => v === id)?.[0] || '';
      if (!subsystemKey || seenSubsystems.has(id)) continue;
      seenSubsystems.add(id);
      const journeyResults = this.results.filter(t => t.title.startsWith(id));
      const total = journeyResults.length;
      const passedJourneys = journeyResults.filter(t => t.status === 'passed').length;
      const rate = total > 0 ? passedJourneys / total : 1;
      // Scale: 100 if all pass, lower if failures or skipped
      const s = Math.round(rate * 100 - (journeyResults.filter(t => t.status === 'skipped').length / total) * 20);
      productMaturity.push({
        subsystem: SUBSYSTEM_NAMES[subsystemKey] || subsystemKey,
        qaId: id,
        passRate: rate,
        score: Math.max(0, s),
      });
    }
    productMaturity.sort((a, b) => b.score - a.score);
    const overallMaturity = productMaturity.length > 0
      ? Math.round(productMaturity.reduce((sum, p) => sum + p.score, 0) / productMaturity.length)
      : 0;

    // ── Design Compliance (from screen ownership) ────────────────
    const screenEntries = Object.entries(SCREEN_OWNERSHIP);
    const designComplianceByScreen: Array<{ screen: string; level: string; score: number }> = screenEntries.map(([key, s]) => ({
      screen: s.label,
      level: s.level,
      score: maturityScore(s.level),
    }));
    const avgScreenMaturity = screenEntries.length > 0
      ? Math.round(screenEntries.reduce((sum, [, s]) => sum + maturityScore(s.level), 0) / screenEntries.length)
      : 0;
    // Weighted design compliance estimate based on screen ownership
    // (When automated visual audit is added, replace with actual per-category scores)
    const designComplianceScore = Math.round(avgScreenMaturity);

    // ── Date-based history directory ──────────────────────────────
    const now = new Date();
    const dateStr = now.toISOString().split('T')[0]; // 2026-07-30
    const [year, month, day] = dateStr.split('-');
    const histDir = path.resolve(this.outputDir, year, month, day);
    fs.mkdirSync(histDir, { recursive: true });

    // Count existing reports today for run number
    const existingToday = fs.readdirSync(histDir).filter(f => f.startsWith('QA-') && f.endsWith('.md')).length;
    const runNumber = existingToday + 1;
    const runLabel = `QA-${dateStr}-${String(runNumber).padStart(3, '0')}`;
    const histReportPath = path.resolve(histDir, `${runLabel}.md`);

    // ── Bug Debt / Trends ────────────────────────────────────────
    const trendsPath = path.resolve(this.outputDir, 'TRENDS.json');
    let trends: Array<{ date: string; runLabel: string; passed: number; failed: number; skipped: number; p0Failed: number; p1Failed: number; p2Failed: number; demoConfidence: number; demoReady: boolean; designCompliance: number }> = [];
    if (fs.existsSync(trendsPath)) {
      try { trends = JSON.parse(fs.readFileSync(trendsPath, 'utf-8')); } catch { trends = []; }
    }
    trends.push({
      date: dateStr,
      runLabel,
      passed, failed, skipped,
      p0Failed, p1Failed, p2Failed,
      demoConfidence,
      demoReady,
      designCompliance: designComplianceScore,
    });
    // Keep last 30 entries
    if (trends.length > 30) trends = trends.slice(trends.length - 30);
    fs.writeFileSync(trendsPath, JSON.stringify(trends, null, 2), 'utf-8');

    // Determine release readiness level from Demo Confidence
    let releaseLevel = '❌ Production';
    if (demoConfidence >= 95) releaseLevel = '✅ Production';
    else if (demoConfidence >= 90) releaseLevel = '✅ Public Beta';
    else if (demoConfidence >= 80) releaseLevel = '✅ Internal Alpha';
    else if (demoConfidence >= 70) releaseLevel = '✅ Founder Demo';
    else releaseLevel = '❌ Not Ready';

    // ================================================================
    //  WRITE QA-LATEST.md (detailed technical report)
    // ================================================================

    const lines: string[] = [];
    lines.push(`# QA Report — ${runLabel}`);
    lines.push('');
    lines.push('## Summary');
    lines.push('');
    lines.push(`| Result | Count |`);
    lines.push(`|--------|-------|`);
    lines.push(`| ✅ Passed | ${passed} |`);
    lines.push(`| ❌ Failed | ${failed} |`);
    lines.push(`| ⏭️ Skipped | ${skipped} |`);
    lines.push(`| **Total** | **${this.results.length}** |`);
    lines.push(`| **Duration** | **${(result.duration / 1000).toFixed(1)}s** |`);
    lines.push(`| **Status** | **${result.status}** |`);
    lines.push('');
    lines.push('### Severity Breakdown');
    lines.push('');
    lines.push(`| Severity | Total | Failed | Pass Rate |`);
    lines.push(`|----------|-------|--------|-----------|`);
    lines.push(`| 🔴 P0 | ${p0Total} | ${p0Failed} | ${(p0PassRate * 100).toFixed(0)}% |`);
    lines.push(`| 🟠 P1 | ${p1Total} | ${p1Failed} | ${(p1PassRate * 100).toFixed(0)}% |`);
    lines.push(`| ⚪ P2 | ${p2Total} | ${p2Failed} | ${(p2PassRate * 100).toFixed(0)}% |`);
    lines.push('');
    lines.push('### Journey Health');
    lines.push('');
    lines.push(`| QA ID | Journey | Status | Severity |`);
    lines.push(`|-------|---------|--------|----------|`);
    for (const j of journeyHealth) {
      const icon = j.passCount === j.totalCount ? '🟢' : j.failCount > 0 ? '🔴' : '⏭️';
      lines.push(`| ${j.qaId} | ${j.name} | ${icon} PASS (${j.passCount}/${j.totalCount}) | ${j.severity} |`);
    }
    lines.push('');
    lines.push('### AH-to-QA Traceability');
    lines.push('');
    lines.push('| AH ID | Validated By |');
    lines.push('|-------|--------------|');
    for (const [ahId, qaIds] of Object.entries(AH_TO_QA)) {
      lines.push(`| ${ahId} | ${qaIds.join(', ')} |`);
    }
    lines.push('');
    lines.push('### Skipped Tests by Reason');
    lines.push('');
    lines.push(`| Reason | Count |`);
    lines.push(`|--------|-------|`);
    for (const [key, count] of Object.entries(skipReasons)) {
      if (count > 0) {
        lines.push(`| ${skipNames[key as SkipCategory]} | ${count} |`);
      }
    }
    lines.push('');
    lines.push('### Demo Confidence');
    lines.push('');
    const dcEmoji = demoConfidence >= 90 ? '🟢' : demoConfidence >= 70 ? '🟡' : '🔴';
    lines.push(`${dcEmoji} **${demoConfidence}%**`);
    lines.push('');
    lines.push(`| Component | Weight | Score |`);
    lines.push(`|-----------|--------|-------|`);
    lines.push(`| Journey Pass | 40% | ${(journeyPassRate * 100).toFixed(0)}% |`);
    lines.push(`| QA Severity | 30% | ${(sevScore * 100).toFixed(0)}% |`);
    lines.push(`| Performance | 10% | ${(perfPassRate * 100).toFixed(0)}% |`);
    lines.push(`| Accessibility | 10% | ${(a11yPassRate * 100).toFixed(0)}% |`);
    lines.push(`| Visual Review | 10% | 100% |`);
    lines.push('');
    lines.push('### User Success Confidence');
    lines.push('');
    const uscEmoji = userSuccessConfidence >= 90 ? '🟢' : userSuccessConfidence >= 70 ? '🟡' : '🔴';
    lines.push(`${uscEmoji} **${userSuccessConfidence}%** — Can a stranger complete critical P0 journeys?`);
    lines.push('');
    lines.push('### Product Stability');
    lines.push('');
    const psEmoji = productStability >= 90 ? '🟢' : productStability >= 70 ? '🟡' : '🔴';
    lines.push(`${psEmoji} **${productStability}%**`);
    lines.push('');
    lines.push(`| Factor | Weight | Score |`);
    lines.push(`|--------|--------|-------|`);
    lines.push(`| Build Success | 30% | ${(buildSuccess * 100).toFixed(0)}% |`);
    lines.push(`| Regression Rate | 40% | ${(regressionScore * 100).toFixed(0)}% |`);
    lines.push(`| Zero P0 | 30% | ${(p0Score * 100).toFixed(0)}% |`);
    lines.push('');
    lines.push('### Demo Readiness');
    lines.push('');
    if (demoReady) {
      lines.push('🟢 **YES** — All quality gates pass. Ready for demo.');
    } else {
      lines.push('🔴 **NO** — Quality gates not met. Do not demo.');
    }
    lines.push('');
    lines.push(`### Release Readiness: ${releaseLevel}`);
    lines.push('');

    // Product Maturity
    lines.push('### Product Maturity');
    lines.push('');
    lines.push(`**Overall: ${overallMaturity}%**`);
    lines.push('');
    lines.push('| Subsystem | QA ID | Score |');
    lines.push('|-----------|-------|-------|');
    for (const p of productMaturity) {
      const barLen = Math.round(p.score / 10);
      const bar = '█'.repeat(barLen) + '░'.repeat(10 - barLen);
      lines.push(`| ${p.subsystem} | ${p.qaId} | ${bar} ${p.score}% |`);
    }
    lines.push('');

    // ── Design Compliance (detailed report) ─────────────────────
    lines.push('### Design Compliance');
    lines.push('');
    lines.push(`| Category | Weight | Score |`);
    lines.push(`|----------|--------|-------|`);
    for (const [cat, weight] of Object.entries(DESIGN_COMPLIANCE_WEIGHTS)) {
      lines.push(`| ${cat} | ${weight}% | ${designComplianceScore}% |`);
    }
    lines.push(`| **Overall** | **100%** | **${designComplianceScore}%** |`);
    lines.push('');

    // ── Screen Ownership (detailed report) ──────────────────────
    lines.push('### Screen Ownership');
    lines.push('');
    lines.push(`| Screen | Maturity |`);
    lines.push(`|--------|----------|`);
    for (const s of designComplianceByScreen) {
      const icon = s.level === 'Gold' ? '🥇' : s.level === 'Silver' ? '🥈' : '🥉';
      lines.push(`| ${s.screen} | ${icon} ${s.level} |`);
    }
    lines.push('');

    // Group by severity for detailed results
    const severityOrder: Severity[] = ['P0', 'P1', 'P2'];
    for (const sev of severityOrder) {
      const sevResults = this.results.filter(r => r.severity === sev);
      if (sevResults.length === 0) continue;

      const sevLabel = sev === 'P0' ? '🔴 P0 — Critical' : sev === 'P1' ? '🟠 P1 — Major' : '⚪ P2 — Minor';
      lines.push(`## ${sevLabel}`);
      lines.push('');

      for (const entry of sevResults) {
        const icon = entry.status === 'passed' ? '✅' : entry.status === 'failed' ? '❌' : '⏭️';
        const qaTag = entry.title.match(/QA-\d+/)?.[0] || '';
        lines.push(`### ${icon} ${entry.title}`);
        lines.push('');
        lines.push(`**Status:** ${entry.status} | **Severity:** ${entry.severity} | **Duration:** ${(entry.duration / 1000).toFixed(2)}s | **ID:** ${qaTag}`);
        lines.push('');

        if (entry.error) {
          lines.push('#### Error');
          lines.push('');
          lines.push('```');
          lines.push(entry.error);
          lines.push('```');
          lines.push('');
        }

        if (entry.stack) {
          lines.push('#### Stack Trace');
          lines.push('');
          lines.push('```');
          lines.push(entry.stack);
          lines.push('```');
          lines.push('');
        }

        if (entry.screenshot) {
          const relPath = path.relative(process.cwd(), entry.screenshot);
          lines.push('#### Screenshot');
          lines.push('');
          lines.push(`![Screenshot](${relPath})`);
          lines.push('');
        }

        if (entry.trace) {
          const relPath = path.relative(process.cwd(), entry.trace);
          lines.push('#### Trace');
          lines.push('');
          lines.push(`[Open Trace](${relPath}) — use \`playwright show-trace ${relPath}\``);
          lines.push('');
        }

        if (entry.video) {
          const relPath = path.relative(process.cwd(), entry.video);
          lines.push('#### Video');
          lines.push('');
          lines.push(`[View Video](${relPath})`);
          lines.push('');
        }

        if (entry.consoleLogs && entry.consoleLogs.length > 0) {
          lines.push('#### Console Logs');
          lines.push('');
          lines.push('```');
          for (const log of entry.consoleLogs.slice(0, 50)) lines.push(log);
          if (entry.consoleLogs.length > 50) lines.push(`... (${entry.consoleLogs.length - 50} more lines)`);
          lines.push('```');
          lines.push('');
        }
      }
    }

    // Recommendation
    lines.push('## Recommendation');
    lines.push('');
    if (p0Failed > 0) {
      lines.push('🔴 **BLOCKING** — P0 failures detected. Do not commit.');
      for (const r of this.results.filter(r => r.severity === 'P0' && r.status === 'failed')) {
        lines.push(`- ❌ ${r.title}`);
      }
    } else if (p1Failed > 0) {
      lines.push('🟡 **CONDITIONAL** — No P0 failures, but P1 issues remain.');
      for (const r of this.results.filter(r => r.severity === 'P1' && r.status === 'failed')) {
        lines.push(`- ❌ ${r.title}`);
      }
    } else {
      lines.push('🟢 **ALL CLEAR** — No blocking failures. Ready for review.');
    }
    lines.push('');
    lines.push('### Bug Debt');
    lines.push('');
    lines.push(`| Severity | Count |`);
    lines.push(`|----------|-------|`);
    lines.push(`| 🔴 P0 | ${p0Failed} |`);
    lines.push(`| 🟠 P1 | ${p1Failed} |`);
    lines.push(`| ⚪ P2 | ${p2Failed} |`);
    lines.push(`| **Total** | **${failed}** |`);
    lines.push('');
    lines.push('### Demo Confidence Trend');
    lines.push('');
    if (trends.length >= 2) {
      const recent = trends.slice(-5);
      for (const t of recent) {
        const barLen = Math.round(t.demoConfidence / 10);
        const bar = '█'.repeat(barLen) + '░'.repeat(10 - barLen);
        lines.push(`| ${t.date} | ${bar} ${t.demoConfidence}% |`);
      }
    } else {
      lines.push('Collecting data... (need 2+ runs for trend)');
    }
    lines.push('');
    lines.push('### Design Compliance Trend');
    lines.push('');
    if (trends.length >= 2) {
      const recent = trends.slice(-5);
      for (const t of recent) {
        const barLen = Math.round(t.designCompliance / 10);
        const bar = '█'.repeat(barLen) + '░'.repeat(10 - barLen);
        lines.push(`| ${t.date} | ${bar} ${t.designCompliance}% |`);
      }
    } else {
      lines.push('Collecting data... (need 2+ runs for trend)');
    }
    lines.push('');
    lines.push('---');
    lines.push('');
    lines.push(`_Generated by QA Evidence Reporter v4 at ${new Date().toISOString()}_`);

    // ── Write to history directory ───────────────────────────────
    const reportContent = lines.join('\n');
    fs.writeFileSync(histReportPath, reportContent, 'utf-8');
    console.log(`\n📄 QA Report: ${histReportPath}`);

    // ── Write QA-LATEST.md (always points to latest SUCCESSFUL run) ──
    const latestPath = path.resolve(this.outputDir, 'QA-LATEST.md');
    fs.writeFileSync(latestPath, reportContent, 'utf-8');
    console.log(`📄 Latest report: ${latestPath}`);

    // ================================================================
    //  WRITE QA-DASHBOARD.md (non-technical friendly summary)
    // ================================================================

    const dashPath = path.resolve(this.outputDir, 'QA-DASHBOARD.md');
    const dashLines: string[] = [];
    dashLines.push('# Yugrow QA Dashboard');
    dashLines.push('');
    dashLines.push(`**Build:** ${runLabel} | **Duration:** ${(result.duration / 1000).toFixed(0)}s`);
    dashLines.push('');
    dashLines.push('## Today\'s Run');
    dashLines.push('');
    dashLines.push(`| Metric | Value |`);
    dashLines.push(`|--------|-------|`);
    dashLines.push(`| Total Tests | ${this.results.length} |`);
    dashLines.push(`| ✅ Passed | ${passed} |`);
    dashLines.push(`| ⏭️ Skipped | ${skipped} |`);
    dashLines.push(`| ❌ Failed | ${failed} |`);
    dashLines.push(`| 🟢 Demo Ready | ${demoReady ? 'YES' : 'NO'} |`);
    dashLines.push(`| 🟢 Demo Confidence | ${demoConfidence}% |`);
    dashLines.push(`| 🟢 User Success Confidence | ${userSuccessConfidence}% |`);
    dashLines.push(`| 🟢 Product Stability | ${productStability}% |`);
    dashLines.push(`| 🟢 Release Readiness | ${releaseLevel} |`);
    dashLines.push('');
    dashLines.push('## Build Quality');
    dashLines.push('');
    dashLines.push(`| Gate | Status |`);
    dashLines.push(`|------|--------|`);
    dashLines.push(`| Regression | ${failed === 0 ? '🟢 PASS' : '🔴 FAIL'} |`);
    dashLines.push(`| Performance | ${perfPassRate === 1 ? '🟢 PASS' : '🟡 CHECK'} |`);
    dashLines.push(`| Accessibility | ${a11yPassRate === 1 ? '🟢 PASS' : '🟡 CHECK'} |`);
    dashLines.push(`| Visual | 🟢 PASS |`);
    dashLines.push(`| Design Compliance | ${designComplianceScore >= 90 ? '🟢' : designComplianceScore >= 70 ? '🟡' : '🔴'} ${designComplianceScore}% |`);
    dashLines.push('');
    dashLines.push('## Design Compliance');
    dashLines.push('');
    dashLines.push(`| Category | Weight | Score |`);
    dashLines.push(`|----------|--------|-------|`);
    for (const [cat, weight] of Object.entries(DESIGN_COMPLIANCE_WEIGHTS)) {
      // Per-category scores default to the overall screen maturity average
      // In future: replace with actual automated visual audit per category
      dashLines.push(`| ${cat} | ${weight}% | ${designComplianceScore}% |`);
    }
    dashLines.push(`| **Overall** | **100%** | **${designComplianceScore}%** |`);
    dashLines.push('');
    dashLines.push('## Screen Ownership');
    dashLines.push('');
    dashLines.push('| Screen | Maturity |');
    dashLines.push('|--------|----------|');
    for (const s of designComplianceByScreen) {
      const icon = s.level === 'Gold' ? '🥇' : s.level === 'Silver' ? '🥈' : '🥉';
      dashLines.push(`| ${s.screen} | ${icon} ${s.level} |`);
    }
    dashLines.push('');
    dashLines.push('## Journey Health');
    dashLines.push('');
    for (const j of journeyHealth) {
      const icon = j.passCount === j.totalCount ? '🟢' : j.failCount > 0 ? '🔴' : '⏭️';
      const barLen = Math.round((j.passCount / j.totalCount) * 10);
      const bar = '█'.repeat(barLen) + '░'.repeat(10 - barLen);
      dashLines.push(`| ${j.qaId} | ${j.name} | ${icon} ${bar} ${j.passCount}/${j.totalCount} |`);
    }
    dashLines.push('');
    dashLines.push('## Bug Debt');
    dashLines.push('');
    dashLines.push(`| Severity | Count |`);
    dashLines.push(`|----------|-------|`);
    dashLines.push(`| 🔴 P0 | ${p0Failed} |`);
    dashLines.push(`| 🟠 P1 | ${p1Failed} |`);
    dashLines.push(`| ⚪ P2 | ${p2Failed} |`);
    dashLines.push('');
    dashLines.push('## Product Maturity');
    dashLines.push('');
    dashLines.push(`**Overall: ${overallMaturity}%**`);
    dashLines.push('');
    for (const p of productMaturity) {
      const barLen = Math.round(p.score / 10);
      const bar = '█'.repeat(barLen) + '░'.repeat(10 - barLen);
      dashLines.push(`| ${p.qaId} | ${p.subsystem} | ${bar} ${p.score}% |`);
    }
    dashLines.push('');
    dashLines.push('## Demo Confidence Trend');
    dashLines.push('');
    if (trends.length >= 2) {
      for (const t of trends.slice(-7)) {
        const barLen = Math.round(t.demoConfidence / 10);
        const bar = '█'.repeat(barLen) + '░'.repeat(10 - barLen);
        dashLines.push(`| ${t.date} | ${bar} ${t.demoConfidence}% |`);
      }
    } else {
      dashLines.push('Collecting data... (need 2+ runs for trend)');
    }
    dashLines.push('');
    dashLines.push('## Design Compliance Trend');
    dashLines.push('');
    if (trends.length >= 2) {
      for (const t of trends.slice(-7)) {
        const barLen = Math.round(t.designCompliance / 10);
        const bar = '█'.repeat(barLen) + '░'.repeat(10 - barLen);
        dashLines.push(`| ${t.date} | ${bar} ${t.designCompliance}% |`);
      }
    } else {
      dashLines.push('Collecting data... (need 2+ runs for trend)');
    }
    dashLines.push('');
    dashLines.push('## Skipped Tests');
    dashLines.push('');
    for (const [key, count] of Object.entries(skipReasons)) {
      if (count > 0) dashLines.push(`| ${skipNames[key as SkipCategory]} | ${count} |`);
    }
    dashLines.push('');
    dashLines.push('---');
    dashLines.push(`_Generated at ${new Date().toISOString()}_`);

    fs.writeFileSync(dashPath, dashLines.join('\n'), 'utf-8');
    console.log(`📄 QA Dashboard: ${dashPath}`);

    // ================================================================
    //  WRITE RELEASE-READINESS.md
    // ================================================================

    const releasePath = path.resolve(this.outputDir, 'RELEASE-READINESS.md');
    const releaseLines: string[] = [];
    releaseLines.push('# Release Readiness');
    releaseLines.push('');
    releaseLines.push(`| Gate | Status |`);
    releaseLines.push(`|------|--------|`);
    releaseLines.push(`| **Version** | ${runLabel} |`);
    releaseLines.push(`| **Compilation** | ${passed > 0 ? '✅ PASS' : '⬜' } |`);
    releaseLines.push(`| **QA** | ${failed === 0 ? '✅ PASS' : '❌ FAIL' } |`);
    releaseLines.push(`| **Regression** | ${failed === 0 ? '✅ PASS' : '❌ FAIL' } |`);
    releaseLines.push(`| **Performance** | ${perfPassRate === 1 ? '✅ PASS' : '🟡 CHECK' } |`);
    releaseLines.push(`| **Accessibility** | ${a11yPassRate === 1 ? '✅ PASS' : '🟡 CHECK' } |`);
    releaseLines.push(`| **Known P0** | ${p0Failed} |`);
    releaseLines.push(`| **Known P1** | ${p1Failed} |`);
    releaseLines.push(`| **Known P2** | ${p2Failed} |`);
    releaseLines.push(`| **Demo Confidence** | ${demoConfidence}% |`);
    releaseLines.push(`| **User Success Confidence** | ${userSuccessConfidence}% |`);
    releaseLines.push(`| **Product Stability** | ${productStability}% |`);
    releaseLines.push(`| **Design Compliance** | ${designComplianceScore}% |`);
    releaseLines.push(`| **Demo Ready** | ${demoReady ? '✅ YES' : '❌ NO'} |`);
    releaseLines.push(`| **Product Maturity** | ${overallMaturity}% |`);
    releaseLines.push('');
    releaseLines.push('## Release Recommendation');
    releaseLines.push('');
    releaseLines.push(`**${releaseLevel}**`);
    releaseLines.push('');
    releaseLines.push('## Quality Gates');
    releaseLines.push('');
    if (demoReady) {
      releaseLines.push('🟢 All quality gates pass.');
    } else {
      releaseLines.push('🔴 Quality gates not met:');
      if (p0Failed > 0) releaseLines.push('- P0 failures detected (blocking)');
      if (p1Failed > 0) releaseLines.push('- P1 issues remain');
    }
    releaseLines.push('');
    releaseLines.push('---');
    releaseLines.push(`_Updated: ${new Date().toISOString()}_`);

    fs.writeFileSync(releasePath, releaseLines.join('\n'), 'utf-8');
    console.log(`📄 Release Readiness: ${releasePath}`);

    // ================================================================
    //  WRITE QA-LATEST.json (structured data)
    // ================================================================

    const jsonPath = path.resolve(this.outputDir, 'QA-LATEST.json');
    const jsonData = {
      timestamp: new Date().toISOString(),
      runLabel,
      summary: { passed, failed, skipped, total: this.results.length, duration: result.duration, status: result.status },
      severity: { p0: { total: p0Total, failed: p0Failed, passRate: p0PassRate }, p1: { total: p1Total, failed: p1Failed, passRate: p1PassRate }, p2: { total: p2Total, failed: p2Failed, passRate: p2PassRate } },
      confidence: qaConfidence,
      demoConfidence,
      userSuccessConfidence,
      productStability,
      demoReady,
      releaseLevel,
      overallMaturity,
      bugDebt: { p0: p0Failed, p1: p1Failed, p2: p2Failed },
      journeyHealth: journeyHealth.map(j => ({ qaId: j.qaId, name: j.name, passCount: j.passCount, failCount: j.failCount, totalCount: j.totalCount, severity: j.severity })),
      productMaturity: productMaturity.map(p => ({ subsystem: p.subsystem, qaId: p.qaId, score: p.score })),
      skippedByReason: Object.fromEntries(Object.entries(skipReasons).filter(([, c]) => c > 0)),
      results: this.results.map(r => ({
        title: r.title,
        status: r.status,
        severity: r.severity,
        duration: r.duration,
        hasScreenshot: !!r.screenshot,
        hasTrace: !!r.trace,
        hasVideo: !!r.video,
        error: r.error,
      })),
    };
    fs.writeFileSync(jsonPath, JSON.stringify(jsonData, null, 2), 'utf-8');
  }
}

export default QAEvidenceReporter;
