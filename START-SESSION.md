# Yugrow Engineering Session — Start

> **Read this file at the beginning of every VS Code development session.**
> Follow each step in order before writing any code.

---

## Step 1 — Read the project memory

Read these files completely before making any decision:

- `YUGROW-INDEX.md` — Project overview, frozen components, architecture map
- `CURRENT-CONTEXT.md` — Active sprint, priorities, risks, decisions

Then read, when relevant to today's work:

- `CONSTITUTION.md` — 58 non-negotiable platform laws
- `DECISIONS.md` — Founder Decisions (FD-001 through FD-031+)
- `docs/YUGROW-DESIGN-LANGUAGE.md` — Colours, typography, components, spacing
- `docs/YUGROW-BRAND-LANGUAGE.md` — Brand identity, tone, vocabulary
- `docs/YUGROW-MOTION-LANGUAGE.md` — Allowed animations, timing, haptics
- `docs/YUGROW-ILLUSTRATION-LANGUAGE.md` — Empty states, photography, assets
- `docs/PRODUCT-STORY-LANGUAGE.md` — Narrative arc for every screen
- `FUTURE-BOUNDED-CONTEXTS.md` — Registry of dormant capabilities

---

## Step 2 — Understand the current sprint

Determine:

- **Current Sprint** — What is the active sprint name/number?
- **Current Goal** — What is the single goal of this sprint?
- **Frozen subsystems** — What must NOT be modified?
- **Active subsystem** — What is being worked on?
- **Known bugs** — What bugs are currently open?
- **Open technical debt** — What workarounds exist that need permanent fixes?
- **Next milestone** — What is the next validation milestone?

**Do NOT modify frozen architecture unless explicitly instructed.**

---

## Step 3 — Understand before implementing

Before changing code:

- Search for existing implementation first — never duplicate
- Reuse existing components from `packages/`, `lib/shared/`, or `@ui`
- Respect Engine Architecture boundaries (19 engines in ENGINE-SPECIFICATIONS.md)
- Respect Provider Abstractions and dependency injection patterns
- Respect all Founder Decisions (especially FD-024 Conceptual Integrity)
- Respect FD-031 (Venue Search provider chain) and FD-032 (Tailwind workaround)

---

## Step 4 — Produce a Project Status Summary

Before implementing anything, output the following block. Wait for approval before coding.

```
────────────────────────────────────────────────────

CURRENT SPRINT: [Sprint Name]

Current Goal: [What we're trying to achieve]

Frozen Components:
- [Component 1]
- [Component 2]
- ...

Current Tasks:
- [Task 1]
- [Task 2]
- ...

Known Risks:
- [Risk 1]
- [Risk 2]
- ...

Suggested Development Plan:
1. [Step 1]
2. [Step 2]
3. [Step 3]

────────────────────────────────────────────────────
```

---

## Pre-Implementation Checklist

Before writing code, ask yourself:

- [ ] Does this already exist somewhere in the codebase?
- [ ] Does this violate the Constitution?
- [ ] Does this violate a Founder Decision?
- [ ] Can this reuse an existing Engine?
- [ ] Can this reuse an existing Component?
- [ ] Will this make the MVP simpler?
- [ ] Will this help the First Independent Success milestone?

**If documentation and implementation disagree, stop and report the discrepancy instead of guessing.**

If the answer to any of these is uncertain, stop and explain before coding.
