# QA Rules — Yugrow Engineering Governance

> **Status:** Active
> **Enforced by:** AI QA Pipeline
> **Last Updated:** 2026-07-30

---

## Purpose

These rules govern the Quality Assurance pipeline for the Yugrow platform.
They ensure that every change is validated by real user journeys, not by assumptions.

---

## QR-001 — Every Feature Must Have a Playwright Journey

Every new feature or UI component added to the Yugrow platform **must** have a corresponding Playwright test journey before it is considered complete.

- **Web app:** Add journey to `qa/journeys/`
- **Admin app:** Add journey to `qa/journeys/`
- **Exception:** Hotfixes for production outages (documented with `QA-EXEMPT` in the PR)

---

## QR-002 — No PR Without PASS

No pull request shall be merged unless the full Playwright suite passes.

```
Before merge:
  ❌ "Looks good to me"
  ✅ "All journeys PASS"
```

The QA report (`qa/reports/QA-LATEST.md`) must be included or linked in every PR.

---

## QR-003 — Screenshots Are Mandatory

Every failed journey must produce a screenshot.
Every PR should include screenshots of the key journeys that were affected.

---

## QR-004 — Videos Retained for Failures

Video recordings are retained for **failed** journeys only.
Passing journey videos are automatically cleaned up.

---

## QR-005 — AI Fixes Only Evidence-Backed Failures

Copilot must not fix a failure unless there is supporting evidence in the QA report.

**Acceptable evidence:**
- Screenshot showing the broken UI
- Console error with stack trace
- Network response with error payload
- Trace showing the failed interaction

**Unacceptable:**
- "I think it's this"
- "This might be the issue"
- Guessing without evidence

---

## QR-006 — No Manual "Looks Good"

Manual visual approval is not sufficient for UI changes.
Every UI change must pass:
1. The Playwright journey for that feature
2. The full Founder Walkthrough suite

---

## QR-007 — QA Reports Are Structured Evidence

Every Playwright run produces a structured QA report at:
```
qa/reports/QA-<YYYY-MM-DD>-<HH-MM-SS>.md
qa/reports/QA-LATEST.md          ← Always points to the latest run
```

The report contains:
- Pass/fail summary
- Per-journey status and duration
- Error messages and stack traces
- Links to screenshots, traces, and videos
- Console logs (for failed journeys)

---

## QR-008 — One Failure, One Fix, One Verify

The QA loop follows strict ordering:

```
1. Run full suite
2. Identify first failure
3. Collect ALL evidence
4. Apply minimal fix
5. Re-run the failed journey only
6. If pass → run full suite
7. If still fail → repeat from step 3
8. If all pass → done
```

Never fix multiple failures in one iteration.

---

## QR-009 — Founder Walkthrough Is the Master Regression

The `founder-walkthrough.spec.ts` journey is the **master regression test**.
It must be run and pass before every release.

The Founder Walkthrough covers:
1. Landing Page
2. Sign Up / Sign In
3. Dashboard
4. Event Discovery
5. Platform Health

Any code change that causes the Founder Walkthrough to fail blocks the release.

---

## QR-010 — Core Journeys Are Permanent Regression Tests

The following journeys are permanent and must never be removed:

| Journey | File | Purpose |
|---------|------|---------|
| Authentication | `qa/journeys/authentication.spec.ts` | Login, signup, error handling |
| Landing Page | `qa/journeys/landing.spec.ts` | Hero, features, navigation |
| Event Discovery | `qa/journeys/event-discovery.spec.ts` | Event detail, interested, error states |
| Dashboard | `qa/journeys/dashboard.spec.ts` | Widgets, stats, journeys |
| Founder Walkthrough | `qa/journeys/founder-walkthrough.spec.ts` | Complete end-to-end regression |

New journeys may be added. Existing journeys may be extended. No journey may be removed without a governance review.

---

## QR-011 — QA Pipeline Runs Before Every Commit

Before committing code changes, run:

```bash
make qa
```

This will:
1. Build the project
2. Run all Playwright journeys
3. Generate the QA report
4. Exit with 0 only if all journeys pass

---

## QR-012 — CI Must Enforce QA

The CI pipeline must:
1. Install dependencies
2. Build the project
3. Start the dev server
4. Run `pnpm qa:run`
5. Fail the build if any journey fails
6. Archive the QA report as a build artifact

---

## QR-013 — Severity Classification

Every journey is classified by severity. Severity determines pipeline behaviour:

| Severity | Definition | Pipeline Action |
|----------|------------|-----------------|
| **P0** | Journey completely broken. User cannot complete core flow. | **STOP PIPELINE.** Must fix before any other work. |
| **P1** | Journey completes but has visual/functional issues. | Fix after P0. Pipeline continues for other journeys. |
| **P2** | Minor issues. Console warnings, timing, non-critical. | Log only. Fix when time permits. |

### Current Journey Severity Map

| # | Journey | Severity | Can Deploy If Failed? |
|---|---------|----------|----------------------|
| 01 | Authentication | P0 | ❌ No |
| 02 | Onboarding | P0 | ❌ No |
| 03 | Profile | P1 | 🟡 Conditional |
| 04 | Event Discovery | P0 | ❌ No |
| 05 | Venue | P1 | 🟡 Conditional |
| 06 | Check-in | P0 | ❌ No |
| 07 | Discovery | P1 | 🟡 Conditional |
| 08 | Connection | P1 | 🟡 Conditional |
| 09 | Conversation | P1 | 🟡 Conditional |
| 10 | Founder Console | P1 | 🟡 Conditional |
| 11 | Yugrow System | P1 | 🟡 Conditional |
| 12 | Messages & Network | P1 | 🟡 Conditional |
| 13 | Landing & Navigation | P0 | ❌ No |
| 14 | Performance | P2 | ✅ Yes |
| 15 | Accessibility | P2 | ✅ Yes |

### Severity Changes

Severity can only be changed by:
1. A Founder Decision (FD)
2. A governance review with documented rationale

---

## QR-014 — Visual Regression Testing

Every full QA suite run includes a visual regression check.

### How It Works
1. Baseline screenshots are stored in `qa/screenshots/baseline/`
2. Current screenshots are stored in `qa/screenshots/current/`
3. The visual diff script compares them and generates a report

### Rules
- **QR-014a:** Baseline must be updated after intentional UI changes: `make qa-baseline`
- **QR-014b:** Unintentional visual changes are BLOCKING. Must be fixed before commit.
- **QR-014c:** Visual regression report is at `qa/reports/visual-diff/visual-regression-report.md`
- **QR-014d:** All PRs must include a visual diff summary

### Commands
```bash
make qa-visual       # Compare current against baseline
make qa-baseline     # Update baseline with current screenshots
```

---

## QR-015 — Accessibility Checks

Every full QA suite run includes accessibility checks.

### What Is Checked
- Keyboard navigation (tab order, focus indicators)
- ARIA labels and roles
- Form field labelling
- Image alt text
- Page title descriptiveness
- Heading hierarchy (h1 → h2 → h3)
- Landmark structure (nav, main, footer)
- Colour contrast (basic)

### Rules
- **QR-015a:** P0 journeys must pass all accessibility checks
- **QR-015b:** P2 accessibility violations are logged but non-blocking
- **QR-015c:** New components must maintain or improve accessibility

---

## QR-016 — Autonomous QA Loop

The autonomous QA fix loop (`node qa/auto-fix-loop.js`) implements the self-correcting pipeline:

```
QA Engineer runs tests
        │
        ▼
Evidence collected
        │
        ▼
Bug Fix Engineer reads evidence only
        │
        ▼
Applies minimal fix
        │
        ▼
Re-runs QA
        │
        ▼
PASS? ──NO──► Repeat (max 3 attempts)
        │
       YES
        │
        ▼
Reviewer approves
```

### Rules
- **QR-016a:** The fix loop runs a maximum of 3 retry attempts
- **QR-016b:** If P0 persists after 3 attempts, manual intervention is required
- **QR-016c:** The Bug Fix Engineer NEVER sees source code before the fix — only evidence
- **QR-016d:** The Reviewer NEVER approves if P0 failures exist

---

## QR-017 — AI Agent Roles

Three dedicated AI agents govern the QA pipeline:

| Agent | File | Responsibility |
|-------|------|----------------|
| QA Engineer | `.github/agents/qa-engineer.agent.md` | Run tests, collect evidence, generate reports |
| Bug Fix Engineer | `.github/agents/fix-engineer.agent.md` | Fix evidence-backed failures only |
| Reviewer | `.github/agents/reviewer.agent.md` | Verify quality, approve or block commits |

### Rules
- **QR-017a:** QA Engineer must never fix code
- **QR-017b:** Bug Fix Engineer must never build features
- **QR-017c:** Reviewer must never fix bugs or build features
- **QR-017d:** Roles are enforced by VS Code Custom Agent definitions

---

## QR-018 — QA Dashboard

The QA Dashboard at `qa/dashboard.html` provides a real-time quality overview.

### What It Shows
- Build status (PASS/FAIL)
- Confidence score (0–100%)
- Pass/fail counts
- P0/P1/P2 breakdown
- Per-journey status with severity
- Duration metrics
- Auto-refresh every 30 seconds

### Rules
- **QR-018a:** Dashboard must be opened before every demo: `make qa-dashboard`
- **QR-018b:** Confidence must be ≥ 90% before any demo
- **QR-018c:** Dashboard reads from `qa/reports/QA-LATEST.json` (generated automatically)

---

## Conventions

### Journey File Names
```
qa/journeys/<feature-name>.spec.ts
```

### Journey Numbering
```
01-authentication  02-onboarding  03-profile  ...
```

### Test Structure
```typescript
test.describe('<Feature Name> Journey', () => {
  test('Specific behavior or assertion', async ({ page }) => {
    // Arrange → Act → Assert
  });
});
```

### Test Data
- Use `page.route()` to mock API responses
- Never depend on external APIs being available
- Use descriptive mock data that reflects real Yugrow scenarios
- Annotate mobile-only tests with `test.info().annotations.push({ type: 'mobile', ... })`

### Mobile Test Stubs
Features that exist only in the Flutter mobile app should have stub tests:
```typescript
test('[MOBILE] Feature description — requires Flutter integration test', async () => {
  test.info().annotations.push({
    type: 'mobile',
    description: 'What this feature does',
  });
  test.skip(true, 'Flutter mobile test — run via flutter test');
});
```

---

## Enforcement

These rules are enforced by:
1. **Pre-commit:** The `make qa` command
2. **CI:** The build pipeline
3. **PR Review:** AI-assisted PR review checks for QA artifacts
4. **Governance:** Violations are tracked in `reviews/qa-violations/`
5. **Commit Blocking:** END-SESSION.md blocks commits if QA fails
6. **QA Dashboard:** Visual quality overview at `qa/dashboard.html`

---

_These rules extend the Yugrow Engineering Constitution. They are governed by the same amendment process as ENGINEERING-RULES.md._
