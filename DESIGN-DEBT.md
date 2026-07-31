# Design Debt Register

> **Status:** Active
> **Purpose:** Track intentionally accepted design debt — screens, components, or patterns that don't yet comply with YDS.
> **Rule:** Every sprint should reduce design debt. No new feature sprint opens while design debt exists unless explicitly approved.

---

## DD-001 — Conversation Spacing

| Field | Value |
|-------|-------|
| **Issue** | Spacing inconsistent between message bubbles; doesn't follow 8pt grid. |
| **Reason** | Built pre-YDS, never audited. |
| **Priority** | P2 |
| **Target Sprint** | DS-005 |
| **Status** | Open |

---

## DD-002 — Profile Screen Radius

| Field | Value |
|-------|-------|
| **Issue** | Cards use 12px radius instead of YDS 16px (`--radius-xl`). |
| **Reason** | Pre-YDS implementation. |
| **Priority** | P2 |
| **Target Sprint** | DS-004 |
| **Status** | Open |

---

## DD-003 — Home Screen Typography

| Field | Value |
|-------|-------|
| **Issue** | Card titles use 18px/600 instead of YDS 20px/600 (`--type-h3`). Secondary text uses 13px instead of 14px (`--type-body-small`). |
| **Reason** | Built pre-YDS, never audited. |
| **Priority** | P2 |
| **Target Sprint** | DS-004 |
| **Status** | Open |

---

## DD-004 — Event Detail Hero Spacing

| Field | Value |
|-------|-------|
| **Issue** | Hero section padding uses 20px gap instead of 24px (`--space-5`). |
| **Reason** | Pre-YDS implementation. |
| **Priority** | P3 |
| **Target Sprint** | DS-004 |
| **Status** | Open |

---

## DD-005 — Button Height Mismatch

| Field | Value |
|-------|-------|
| **Issue** | Secondary buttons use 52px height instead of YDS 48px (`--size-button`). |
| **Reason** | Flutter default override not applied. |
| **Priority** | P2 |
| **Target Sprint** | DS-004 |
| **Status** | Open |

---

## DD-006 — Missing Empty States

| Field | Value |
|-------|-------|
| **Issue** | Network, Dashboard, and Profile screens have no YDS-compliant empty state (missing icon + message + action). |
| **Reason** | Never implemented. |
| **Priority** | P1 |
| **Target Sprint** | DS-004 |
| **Status** | Open |

---

## DD-007 — Missing Loading States

| Field | Value |
|-------|-------|
| **Issue** | Several screens show no skeleton/shimmer during data load — blank screen or flash of nothing. |
| **Reason** | Never implemented. |
| **Priority** | P1 |
| **Target Sprint** | DS-004 |
| **Status** | Open |

---

## DD-008 — Flutter Primary Colour Drift

| Field | Value |
|-------|-------|
| **Issue** | Flutter app uses `#115E59` as primary colour instead of YDS `#0F8B6D`. |
| **Reason** | Flutter was built before YDS was formalized. |
| **Priority** | P0 |
| **Target Sprint** | DS-004 |
| **Status** | Open |

---

## DD-009 — Flutter Radius Drift

| Field | Value |
|-------|-------|
| **Issue** | Flutter uses sm=6/md=10/lg=12/xxl=24 instead of YDS sm=8/md=12/lg=14/xxl=20. |
| **Reason** | Pre-YDS values. |
| **Priority** | P1 |
| **Target Sprint** | DS-004 |
| **Status** | Open |

---

## DD-010 — Flutter Background Colour Drift

| Field | Value |
|-------|-------|
| **Issue** | Flutter uses `#F8F9FB` for background instead of YDS `#FAFAFA`. Border uses `#E5E7EB` instead of `#E2E8F0`. |
| **Reason** | Pre-YDS values. |
| **Priority** | P2 |
| **Target Sprint** | DS-004 |
| **Status** | **Closed** ✅ *(Resolved in DS-004A — AppColors updated to YDS)* |

---

## DD-011 — Colors.white/Black References

| Field | Value |
|-------|-------|
| **Issue** | ~55 `Colors.white`/`Colors.black` references remain across 18 files. Most are context-dependent (button text vs card background). |
| **Reason** | Context-dependent — cannot mechanically replace. Needs manual review per use case. |
| **Priority** | P1 |
| **Target Sprint** | DS-004B |
| **Status** | Open |

---

## DD-012 — Semantic Background Tints

| Field | Value |
|-------|-------|
| **Issue** | ~46 hardcoded semantic background tints remain (success green bg, error red bg, warning amber bg, info blue bg). Need migration to YDS soft colours (`successSoft`, `warningSoft`, `errorSoft`, etc.) or custom tokens. |
| **Reason** | No direct AppColors equivalent. Requires design conformance decision. |
| **Priority** | P1 |
| **Target Sprint** | DS-004B |
| **Status** | Open |

---

## DD-013 — Dark Mode Colour Variants

| Field | Value |
|-------|-------|
| **Issue** | Debug screens use custom dark mode colours (`#1A1A2E`, `#16213E`) instead of YDS dark tokens (`surfaceDark`, `backgroundDark`). |
| **Reason** | Pre-YDS implementation with different dark colour values. |
| **Priority** | P2 |
| **Target Sprint** | DS-004B |
| **Status** | Open |

---

## DD-014 — Flutter Hardcoded Font Sizes in Theme

| Field | Value |
|-------|-------|
| **Issue** | `app_theme.dart` uses hardcoded font sizes (32, 24, 18, 16, 14, 12) instead of `YTypography.*` tokens. |
| **Reason** | `YTypography` presets available but theme not yet migrated. |
| **Priority** | P2 |
| **Target Sprint** | DS-004B |
| **Status** | Open |

| Rule | Description |
|------|-------------|
| DD-001 | Every debt entry has a clear issue, reason, priority, and target sprint. |
| DD-002 | P0 = Blocks release. Must fix before any code ships. |
| DD-003 | P1 = Significant quality gap. Should fix within current sprint. |
| DD-004 | P2 = Minor inconsistency. Fix when screen is touched for other reasons. |
| DD-005 | P3 = Cosmetic. Tracked but not scheduled. |
| DD-006 | Closing a debt entry requires the fix to pass the Design Compliance gate. |
| DD-007 | Design debt is reviewed every sprint planning session. No sprint closes with more debt than it opened. |
