# Yugrow Engineering Session — End

> **Run this at the end of every VS Code development session.**
> Perform each step in order before closing.

---

## Step 1 — Verify the build

Verify there are:

- [ ] No compilation errors (check all apps: API, Mobile, Web, Admin)
- [ ] No missing imports
- [ ] No broken references
- [ ] No TODOs accidentally left in production code
- [ ] No dead code introduced today
- [ ] No debug logs or console.log statements left in production code

---

## Step 1b — Run the QA pipeline

Before reviewing, verify quality with automated journeys:

- [ ] Run `make qa` or `pnpm qa:run` — all Playwright journeys execute
- [ ] Check the QA report at `qa/reports/QA-LATEST.md`
- [ ] **0 P0 failures** — critical journeys must all PASS
- [ ] **0 P1 failures recommended** — fix before committing if possible
- [ ] **Confidence score ≥ 90%** — otherwise do not ship
- [ ] All evidence collected: screenshots, traces, logs
- [ ] Visual regression check passed (no unexpected UI changes)

**If QA fails:** Do NOT proceed to review. Fix failures first, re-run QA, then continue.

**If QA passes:** Attach the report to the session summary.

```bash
# Quick check
node qa/pipeline.js

# Or for full autonomous loop
node qa/auto-fix-loop.js
```

---

## Step 2 — Review today's implementation

Produce a summary of:

| Category | Details |
|----------|---------|
| **Completed Features** | What was built |
| **Modified Files** | Files that were changed |
| **Created Files** | Files that were added |
| **Architecture Changes** | Any structural changes |
| **Bug Fixes** | Issues that were resolved |
| **Known Limitations** | What doesn't work yet |
| **Technical Debt** | Workarounds or shortcuts taken |

---

## Step 3 — Update project memory

If today's work changed the current project state, update:

- `CURRENT-CONTEXT.md` — Session log, current priorities, risks, decisions
- `YUGROW-INDEX.md` — If architecture, frozen components, or milestones changed

**Do NOT modify historical Founder Decisions** (`DECISIONS.md`).
**Do NOT modify frozen documents** unless explicitly instructed.

---

## Step 4 — Evaluate freeze candidates

If today's work resulted in a completed subsystem, mark it as:

```
Architecture Frozen
```
or
```
Implementation Frozen
```

Explain why it qualifies for freeze.

---

## Step 5 — Generate the Development Session Report

Output the following block:

```
────────────────────────────────────────────────────

SESSION COMPLETE

Session Summary:
[Brief summary of what was accomplished]

Files Changed:
- [File 1] — [Change description]
- [File 2] — [Change description]
- ...

Subsystem Status:
- [Subsystem 1]: [Stable / Changed / Frozen]
- [Subsystem 2]: [Stable / Changed / Frozen]
- ...

Current Sprint Status:
[Progress update — X% complete, what remains]

Remaining Tasks:
- [Task 1]
- [Task 2]
- ...

Next Sprint Recommendation:
[Brief recommendation for next steps]

Suggested Commit Message:
[Multi-line commit message following conventional format]

────────────────────────────────────────────────────
```

---

## Step 6 — Check for new artifacts

If today's work genuinely requires it, consider creating:

- **Founder Decision** — A new philosophical commitment (`DECISIONS.md`)
- **Architecture Decision** — A structural decision (`adr/ADR-XXXX.md`)
- **Dormant Context** — A future bounded context (`FUTURE-BOUNDED-CONTEXTS.md`)
- **Design Language update** — Only if the design system changed

---

## Final check

Answer with **"Session Complete"** only after all checks pass.
