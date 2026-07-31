# AI QA Prompt — Evidence-Driven Failure Resolution

## Purpose

When Playwright detects a test failure, this prompt guides Copilot to analyze the available evidence and fix the root cause — without guessing, redesigning, or adding features.

## Workflow

```
QA Report Generated
        │
        ▼
Read QA Report (qa/reports/QA-LATEST.md)
        │
        ▼
For each FAILED journey:
        │
        ├── Read error message
        ├── View screenshot (if available)
        ├── Open trace (playwright show-trace)
        ├── Review console logs
        └── Review network logs
        │
        ▼
Identify root cause
        │
        ▼
Apply minimal fix
        │
        ▼
Re-run Playwright
        │
        ▼
Repeat until ALL PASS
```

## AI Agent Roles

This prompt is used by three distinct AI agents:

| Agent | File | Role |
|-------|------|------|
| **QA Engineer** | `.github/agents/qa-engineer.agent.md` | Runs tests, collects evidence, generates report. Never fixes code. |
| **Bug Fix Engineer** | `.github/agents/fix-engineer.agent.md` | Reads QA report evidence only. Applies minimal fix. Never builds features. |
| **Reviewer** | `.github/agents/reviewer.agent.md` | Verifies quality, approves or blocks commits. Never builds or fixes. |

### Autonomous Loop

```
QA Engineer → Run QA → Evidence → Bug Fix Engineer → Fix → Re-run → Reviewer → Approve
```

The autonomous loop is executed via:
```bash
node qa/auto-fix-loop.js
```

Max retries: 3. If P0 persists after 3 attempts, manual intervention required.

---

## Severity Classification

Failures are classified by severity. Fix order is ALWAYS P0 → P1 → P2.

| Severity | Meaning | Action |
|----------|---------|--------|
| **🔴 P0** | Journey completely broken. User cannot complete core flow. | **STOP.** Fix immediately. Blocking. |
| **🟠 P1** | Journey completes but has visual/functional issues. | Fix after all P0 pass. |
| **⚪ P2** | Minor issues. Console warnings, timing. | Log only. |

### P0 Examples
- Login fails for valid credentials
- Page shows white screen / 500 error
- Navigation is broken
- Critical button is missing

### P1 Examples
- Missing loading skeleton
- Console errors (non-breaking)
- Slow response but works

### P2 Examples
- Console warnings (not errors)
- Minor colour or spacing issues
- Timing issues in tests

---

## Rules

### QR-001 — Evidence Only
Do NOT fix any failure that lacks supporting evidence in the QA report.
If the report says "Element not found" but there is no screenshot, inspect the trace first.

### QR-002 — One Fix at a Time
Fix exactly ONE failing journey per iteration.
Re-run Playwright after each fix.
Do not batch fixes.

### QR-003 — No Redesign
Fix the failure. Do not redesign the component.
Do not add features.
Do not refactor.
Do not rename things.

### QR-004 — Minimal Diff
Change the minimum code required to make the test pass.
If a selector is wrong, fix only the selector.
If a component is missing, add only the missing piece.

### QR-005 — Verify Before Moving On
After applying a fix:
1. Re-run the specific failed journey: `pnpm qa:run -- --grep "Journey Name"`
2. If it passes, run the full suite: `pnpm qa:run`
3. Only move to the next task when ALL journeys pass

### QR-006 — No Silent Fixes
Every fix must be documented in the QA report's recommendation section.
Do not apply fixes that are not traceable to a specific failure.

### QR-007 — Escalate on Ambiguity
If the evidence is insufficient to determine the root cause:
1. Check the Playwright trace file
2. Check the video recording
3. Check the console logs
4. If still ambiguous, flag as "NEED_MORE_INFO" — do not guess

## Evidence Sources

| Source | Location | How to Use |
|--------|----------|------------|
| QA Report | `qa/reports/QA-LATEST.md` | Read first — contains all failure context |
| Screenshots | `qa/screenshots/` | View to see the UI state at time of failure |
| Traces | `qa/traces/` | Run `npx playwright show-trace <trace.zip>` |
| Videos | `qa/videos/` | View to see the full user interaction flow |
| Console Logs | Embedded in QA report | Check for JS errors, API failures |
| Test Results | `qa/reports/test-results.json` | Machine-readable failure data |

## Common Failure Patterns

### Pattern 1: Element Not Found
```
Error: locator.click: Target closed
Error: locator.click: Timeout 30000ms exceeded
```
**Action:** Check screenshot → does the element exist on the page?
- If no: The component may not be rendered. Check conditions.
- If yes: The selector may be wrong. Inspect the DOM in the trace.

### Pattern 2: API Failure
```
Error: expect.toBeVisible: Timeout
Combined with: API returned 500/401/404
```
**Action:** Check network logs in trace → was the API called correctly?
- If API returns error: Check if the mock or endpoint needs fixing.
- If API not called: Check if the component makes the request.

### Pattern 3: Console Error
```
console.error: Something went wrong
```
**Action:** Check the error stack in console logs.
- Fix the JS error before the test assertion.

### Pattern 4: Navigation Failure
```
Error: page.goto: Timeout
```
**Action:** Check if the dev server is running.
- Run `pnpm dev` in a separate terminal.

## Report Structure

Each QA report contains:
```
Summary       → Pass/fail counts, duration
Per Journey   → Status, error message, evidence links
Screenshots   → UI state at failure
Traces        → Full interaction timeline
Console Logs  → JavaScript errors and warnings
```

## Termination Condition

Stop the QA loop when:
```
ALL JOURNEYS: PASS
Duration: < 5 min per full suite
Screenshots: Present for all journeys
Console Errors: 0
```
