---
Title: Yugrow Engineering Rules
Version: 1.0
Status: Approved
Owner: Engineering
Last Updated: 2026-07-28
Dependencies: CONSTITUTION.md, DECISIONS.md
---

# Yugrow Engineering Rules

> The operating system for how Yugrow evolves as a platform.
> Not a coding standard — a governance system for engineering decisions.

---

## 1. Architecture Is Frozen Unless Unfrozen

| Rule | Detail |
|------|--------|
| **R1** | Never modify frozen architecture. Frozen means "no changes without an RFC and explicit approval." |
| **R2** | Frozen components are listed in `YUGROW-INDEX.md`. If it's not listed as frozen, confirm before assuming it's unfrozen. |
| **R3** | When in doubt, ask. Silence is not permission. |

---

## 2. Never Duplicate an Engine

| Rule | Detail |
|------|--------|
| **R4** | Every feature must map to exactly one engine. If it doesn't fit an existing engine, it may be a new engine — but that requires review. |
| **R5** | Before adding code, search the entire codebase for existing implementations. Reuse before extend. Extend before create. |
| **R6** | Shared packages (`@ui`, `@core`, `@shared`) exist to prevent duplication. If you're writing the same pattern twice, it belongs in a shared package. |

---

## 3. Every UI Change Follows the Design Language

| Rule | Detail |
|------|--------|
| **R7** | All UI must conform to `docs/YUGROW-DESIGN-LANGUAGE.md`. No invented colours, typography, spacing, or components. |
| **R8** | All copy must conform to `docs/YUGROW-BRAND-LANGUAGE.md`. No "users" — only "professionals." No corporate speak. |
| **R9** | All animations must conform to `docs/YUGROW-MOTION-LANGUAGE.md`. Only 4 allowed animations. Nothing exceeds 250ms. |
| **R10** | All empty states, success screens, and error states must conform to `docs/YUGROW-ILLUSTRATION-LANGUAGE.md`. |

---

## 4. Every New Domain Concept Requires Evaluation

| Rule | Detail |
|------|--------|
| **R11** | Before introducing a new domain concept, evaluate it against the Constitution (`CONSTITUTION.md`). |
| **R12** | Does the concept strengthen an existing concept before introducing a new one? (FD-024) |
| **R13** | Does it violate the Domain Language (`YUGROW-DOMAIN-LANGUAGE.md`)? |
| **R14** | Does it belong to a dormant bounded context (`FUTURE-BOUNDED-CONTEXTS.md`)? If yes, activate it — don't create a new one. |

---

## 5. Documentation Is the Source of Truth

| Rule | Detail |
|------|--------|
| **R15** | If documentation and implementation disagree, report the discrepancy — do not silently fix it. |
| **R16** | Every significant decision becomes a Founder Decision (`DECISIONS.md`) or Architecture Decision Record (`adr/`). |
| **R17** | Session output is captured in `CURRENT-CONTEXT.md`. The repository remembers. The chat does not. |

---

## 6. Every Bug Is Tracked

| Rule | Detail |
|------|--------|
| **R18** | Every confirmed bug becomes a tracked work item. No silent fixes. |
| **R19** | Bug classification: P0 (blocks testing), P1 (significant impairment), P2 (cosmetic / edge case). |
| **R20** | Fix the root cause, not the symptom. If a workaround is necessary, document it in `CURRENT-CONTEXT.md`. |

---

## 7. Every Session Ends With a Review

| Rule | Detail |
|------|--------|
| **R21** | Run `END-SESSION.md` before every commit. |
| **R22** | Update `CURRENT-CONTEXT.md` if the project state changed. |
| **R23** | Update `YUGROW-INDEX.md` if frozen components or milestones changed. |
| **R24** | Do not modify historical Founder Decisions. Add new ones with the next FD number. |

---

## 8. Every Sprint Ends With a Freeze Review

| Rule | Detail |
|------|--------|
| **R25** | At the end of each sprint, evaluate what can be frozen. |
| **R26** | A component qualifies for freeze when: (a) it's stable, (b) it's tested, (c) no further changes are expected, (d) the team agrees. |
| **R27** | Frozen components are moved from "Active" to "Frozen" in `YUGROW-INDEX.md`. |

---

## 9. Keep the MVP Lean

| Rule | Detail |
|------|--------|
| **R28** | Every feature must answer: "Does this help the First Independent Success milestone?" |
| **R29** | If a feature can wait, it waits. Capture it as a dormant context or backlog item. |
| **R30** | Prefer deleting code over adding code. The best feature is the one you don't build. |

---

## 10. Alpha Hardening

| Rule | Detail |
|------|--------|
| **R31** | During Alpha Hardening, no new feature may be implemented unless it directly improves the First Independent Success journey. Every implementation must improve at least one of: completion rate, clarity, reliability, performance, trust, accessibility, visual consistency, error recovery, or user confidence. If it does not improve one of these, it must be deferred until after First Meetup validation. |
| **R32** | **Nothing Embarrassing.** Before any build is shown to another human, there must be: no dead buttons, no placeholder text, no lorem ipsum, no unhandled errors, no inconsistent spacing, no inconsistent colours, no "Coming Soon" unless absolutely necessary, no console errors during normal usage, and no screen that leaves the user wondering what to do next. The goal is not perfection — the goal is that nothing breaks trust. A stranger should think: "This feels like a real product." |

### Journey-based bug classification

During Alpha Hardening, bugs and improvements are classified by the journey step they affect:

```
Signup
Onboarding
Profile
Event Creation
Venue
Check-In
Discovery
Connection
Conversation
Feedback
Founder Console
```

This ensures the team knows exactly where users fail — not just *that* they fail.

---

## Enforcement

These rules are enforced through code review:

1. Violation of a frozen architecture rule → Blocking
2. Violation of the Design Language → Blocking
3. Unnecessary duplication → Blocking
4. Unresolved doc/code discrepancy → Blocking
5. Missing session review → Warning

Every PR should be reviewed against these rules before merging.
