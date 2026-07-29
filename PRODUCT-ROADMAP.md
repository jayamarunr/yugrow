---
Title: Yugrow Capability Roadmap
Version: 1.0
Status: Living (update after every milestone review)
Owner: Founder
Last Updated: 2026-07-28
---

# Yugrow Capability Roadmap

> **Executive view of every capability — live, dormant, and future.**
>
> This is not a marketing roadmap. It is a strategic product governance document.
> Every dormant capability has a testable activation condition and will not be
> built until evidence justifies it.

---

## Legend

| Icon | Status | Meaning |
|------|--------|---------|
| ✅ | **Live** | Built, tested, and in active use |
| 🔒 | **Frozen** | Stable — do not modify without RFC |
| 💤 | **Dormant** | Designed but intentionally not built yet |
| ⏳ | **Pending** | Activation condition partially met, partial implementation exists |
| ❌ | **Rejected** | Evaluated and explicitly not building |
| 📋 | **Planned** | Sprint plan written, awaiting activation |

---

## Capability Map

### Core Platform

| Capability | Status | Activation | Notes |
|-----------|--------|------------|-------|
| Platform Constitution | ✅ Frozen | — | 58 non-negotiable laws |
| Founder Decisions | ✅ Frozen | — | FD-001 through FD-032 |
| Engine Architecture | ✅ Frozen | — | 19 engines, v2.0 |
| Engineering Governance | ✅ Frozen | — | 32 rules (R1–R32) |
| Design Language | ✅ Frozen | — | Colours, typography, spacing |
| Brand Language | ✅ Frozen | — | Tone, vocabulary, writing |
| Motion Language | ✅ Frozen | — | 4 animations, 250ms max |
| Illustration Language | ✅ Frozen | — | Empty states, photography |
| Product Story Language | ✅ Frozen | — | Narrative arc per screen |

### Authentication & Identity

| Capability | Status | Activation | Notes |
|-----------|--------|------------|-------|
| Person Identity | ✅ Frozen | — | One identity per person (FD-001) |
| Authentication (JWT) | ✅ Frozen | — | Email/password, session persistence |
| Professional Identity | ✅ Frozen | — | Profile, title, company, skills |
| Workspace | ✅ Frozen | — | Multi-workspace, active context (FD-002) |

### Venue & Events

| Capability | Status | Activation | Notes |
|-----------|--------|------------|-------|
| Venue Engine | ✅ Frozen | — | Search, create, geofence, trust |
| Event Creation | ✅ Frozen | — | Name, venue, time, visibility |
| Check-In | ✅ Frozen | — | Presence recording, frictionless (FD-004) |

### Relationships & Communication

| Capability | Status | Activation | Notes |
|-----------|--------|------------|-------|
| Relationship Engine | ✅ Frozen | — | Entity relationships, business cards |
| Conversation Engine | ✅ Frozen | — | Private one-to-one messaging |
| System Conversations (FD-032) | ✅ Frozen | — | Yugrow ↔ Professional, pinned, permanent |

### Founder Tools

| Capability | Status | Activation | Notes |
|-----------|--------|------------|-------|
| Founder Mode v2 | ✅ Live | — | Status dashboard, geofence toggle, force check-in |
| Feedback Inbox | ✅ Live | — | Read/reply to system conversation messages |
| Send Messages | ✅ Live | — | Release notes, announcements, feedback status cards |

### Experiences

| Capability | Status | Activation | Notes |
|-----------|--------|------------|-------|
| Events Timeline | ✅ Live | — | "Where should I go today?" |
| Live Discovery | ✅ Live | — | "Who is here now?" |
| Network | ✅ Live | — | "What relationships have I built?" |
| Profile | ✅ Live | — | "Who am I professionally?" |
| Message Screen | ✅ Live | — | Text, system, release note, announcement, feedback status cards |

### Message Types

| Capability | Status | Activation | Notes |
|-----------|--------|------------|-------|
| Text messages | ✅ Live | — | Default message type |
| System messages | ✅ Live | — | Welcome, Yugrow persona |
| Release Note cards | ✅ Live | — | Version, changes, action button |
| Announcement cards | ✅ Live | — | Gradient header, date, location, action |
| Feedback Status cards | ✅ Live | — | Title, status badge, sprint, note |

---

## Dormant Capabilities

| Capability | Status | Activation Condition | Sprint Doc |
|-----------|--------|---------------------|------------|
| Feedback Stream | 📋 Planned | First Meetup completed + duplicate reports become measurable friction | `docs/sprints/SPRINT-E-FEEDBACK-STREAM.md` |
| Feedback Intelligence Engine | 💤 Dormant | Feedback volume exceeds manual triage capacity | `FUTURE-BOUNDED-CONTEXTS.md` |
| Product Memory | 💤 Dormant | After Feedback Intelligence activates | `FUTURE-BOUNDED-CONTEXTS.md` |
| Contribution Engine | 💤 Dormant | Relationship Economy validated | `FUTURE-BOUNDED-CONTEXTS.md` |
| Topic Engine | 💤 Dormant | Thousands of community-created topics | `FUTURE-BOUNDED-CONTEXTS.md` |
| Commerce Engine | 💤 Dormant | Paid products exist | `FUTURE-BOUNDED-CONTEXTS.md` |
| Broadcast Engine | 💤 Dormant | Users need to distribute opportunities beyond events | `FUTURE-BOUNDED-CONTEXTS.md` |
| Ambient Presence | 💤 Dormant | Events validated as trusted presence source | `FUTURE-BOUNDED-CONTEXTS.md` |
| Knowledge Model (Full) | 💤 Dormant | AI features reach scale needing knowledge boundaries | `FUTURE-BOUNDED-CONTEXTS.md` |

## Rejected Capabilities

| Capability | Reason |
|-----------|--------|
| Community Engine (multi-group) | Would require new engine. Feedback Stream covers the actual need without it. Groups/channels/roles are not validated as valuable. |

---

## Current Sprint

| Field | Value |
|-------|-------|
| **Sprint** | Alpha Hardening |
| **Phase** | First Independent Success |
| **North Star** | Can 10 professionals use Yugrow for 2 hours without founder explanation? |
| **Restriction** | Zero new features (R31). Nothing embarrassing (R32). |

---

## Post-Alpha Sequence

```
Alpha Hardening
        ↓
  First Meetup (validation)
        ↓
  Evidence Review
        ↓
  Sprint E — Feedback Stream Activation (if evidence supports it)
        ↓
  Second Meetup
        ↓
  Play Store Closed Testing
        ↓
  Feedback Intelligence Engine (if >100 feedback items/month)
        ↓
  Open Beta
        ↓
  Public Launch
```

---

## Principles

1. **Evidence over intuition** — No dormant capability activates without meeting its activation condition.
2. **Architecture over features** — Every capability must fit the existing engine model. New engines are a last resort.
3. **Freeze over refactor** — Once frozen, capabilities are not modified without RFC and explicit approval.
4. **Momentum over scope** — The First Independent Success milestone gates everything else.
