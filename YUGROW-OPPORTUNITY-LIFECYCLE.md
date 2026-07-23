---
Title: Yugrow Opportunity Lifecycle
Version: 1.0
Status: Draft
Owner: Chief Architect
Last Updated: 2026-07-23
Dependencies:
  - PLATFORM-CONSTITUTION.md
  - YUGROW-PRESENCE-MODEL.md
  - ENGINE-SPECIFICATIONS.md (Engine 5 — Opportunity Engine, Engine 6 — Relationship Engine)
  - INTELLIGENCE-LAYER.md
Related Documents:
  - SPRINT-7-OPPORTUNITY-ENGINE.md
  - BUSINESS-OBJECT-BIBLE.md
  - DOMAIN-MODEL.md
  - DECISIONS.md
---

# Yugrow Opportunity Lifecycle

> **How a temporary presence becomes a permanent professional relationship.**

Presence tells Yugrow who is available right now. The Opportunity Lifecycle defines how those temporary moments become lasting professional relationships — while preserving urgency, trust, and contextual relevance.

**Governing document:** This document operates under the constitutional principles defined in `PLATFORM-CONSTITUTION.md` Part 0 (Knowledge Model). The Design Axiom, Three-Layer Model, and Domain Invariants established there govern everything described here. This document does not restate them — it applies them to the specific context of opportunity timing and expiry.

---

## Core Principle

```
Presence
    ↓
Opportunity
    ↓
Relationship
    ↓
Memory
```

Four concepts. One direction. No cycles.

### Presence

**Ephemeral.** Answers: *Who is available now?*

Owned by the Presence Engine. A voluntary, time-bound signal. It begins with a conscious tap of "I'm Here" and ends when the user leaves, the timer expires, or the event concludes. Presence has no memory — it never looks backward.

### Opportunity

**Time-bound.** Answers: *Who should I meet?*

Owned by the Opportunity Engine. A detected alignment between two people based on presence, signals, and timing. Opportunities are always scoped to a context (event, venue, time window) and always expire. An opportunity is not a relationship — it is a **possibility** that either converts or vanishes.

### Relationship

**Permanent.** Answers: *Who do I know?*

Owned by the Relationship Engine. A confirmed, mutual connection between two people. Relationships persist across events, presence, and time. They are the compounding asset of the platform.

### Memory

**Historical.** Answers: *Where did we meet?*

Owned by the Event Engine (attendance history) and Relationship Engine (origin context). Every relationship remembers how it started — the event, the venue, the date. This is immutable. It never changes after creation.

---

## The Four Types of Opportunity

The Opportunity Engine recognizes two modes, each producing two types of opportunity:

```
Opportunity Engine
    │
    ├── Presence Mode (Sprint 7)
    │       │
    │       ├── Live Opportunity
    │       └── Missed Opportunity
    │
    └── Broadcast Mode (Sprint 9)
            │
            ├── Distributed Opportunity
            └── Inbound Interest
```

This document governs the **Presence Mode** — opportunities that emerge from physical presence. Broadcast Mode is defined in the Opportunity Engine specification.

---

## The Two-Clock Model

This is the core architectural insight of the Opportunity Lifecycle.

There are two independent clocks. Each governs a different type of opportunity. They do not overlap. They do not conflict.

```
Clock A
─────────────────────────────────────────
Live Opportunity

Starts:   Check-in ("I'm Here")
Ends:     Check-out ("I'm Leaving") or presence expiry
Scope:    People currently present at the same event
Purpose:  "Who can I meet right now?"


Clock B
─────────────────────────────────────────
Missed Opportunity

Starts:   Check-out
Ends:     24 hours after the event ends
Scope:    People who attended the same event but did not overlap
Purpose:  "Who did I miss?"
```

### Why Clock B ends at event end + 24 hours, not check-out + 24 hours

Consider this scenario:

```
AI Expo (9 AM – 6 PM)

Jay:     9:00–11:15 (leaves early)
Priya:   2:30–5:40  (arrives later)
```

If Missed Opportunity expired 24 hours after Jay's check-out, Priya would never discover Jay even though they both attended. By tying Clock B to the **event end**, everyone who attended — regardless of when they arrived or left — gets the full networking window.

The 24-hour post-event window exists because:
- Networking energy is highest immediately after an event
- Everyone is still thinking about who they met (and who they missed)
- It creates a natural deadline that drives action
- After 24 hours, the moment fades and the window closes gracefully

---

## Missed Networking

### Definition

Missed Networking is a feature of the Opportunity Engine that connects two people who:

1. Both attended the same event
2. Both had verified physical presence (checked in)
3. Had **no temporal overlap** in their presence
4. Are within the 24-hour post-event networking window

### Result

A **Missed Opportunity** — not a Relationship. The system surfaces:

```
You both attended AI Expo.

You missed each other.

Would you like to connect?
```

### What Missed Networking is not

- Not a relationship (connection has not happened yet)
- Not a recommendation (no ranking; everyone who qualifies appears)
- Not live presence (both have checked out)
- Not a broadcast (no AI matching — pure deterministic query)

### Trust Property

Yugrow can prove both people were physically there. This is the moat. Unlike "I clicked Interested" or "I watched online," Yugrow has a verified check-in event for each attendee. The Missed Opportunity carries this trust signal implicitly.

### Query (Logical)

```
SELECT
  PresenceSession A,
  PresenceSession B
WHERE
  A.eventId = B.eventId
  AND A.personId ≠ B.personId
  AND NOT (A.timeRange OVERLAPS B.timeRange)
  AND now() ≤ Event.endTime + 24 hours
```

No AI. No inference. A deterministic query against immutable presence sessions.

---

## Connection Lifecycle

The connection lifecycle governs how an opportunity becomes a relationship — and how it expires if it doesn't.

```
Live Opportunity
    │
    ├── Connect Request Sent
    │       │
    │       ├── Accepted ──► Relationship Created
    │       │
    │       └── Expired (24h) ──► Networking Window Closed
    │
    └── Ignored ──► Removed from Live view

Missed Opportunity
    │
    ├── Connect Request Sent
    │       │
    │       ├── Accepted ──► Relationship Created (with origin: "Missed Connection")
    │       │
    │       └── Expired (24h) ──► Networking Window Closed
    │
    └── Ignored ──► Opportunity expires when window closes
```

### Connection Request States

| State | Meaning | Timer |
|-------|---------|-------|
| `pending` | Sent, awaiting response | 24 hours from send |
| `accepted` | Recipient accepted → Relationship created | Permanent |
| `expired` | 24 hours elapsed with no response | — |

### Why 24 hours?

Networking is contextual. If someone sends a connection request at an event and the recipient ignores it for two weeks, the moment is gone. A 24-hour window:

- Creates **urgency** — people open Yugrow after the event
- Preserves **context** — the event is still fresh in both minds
- Eliminates **limbo** — no requests sit forever
- Drives **retention** — users check Yugrow within the window

### Important Distinction

`Expired` is not `Rejected`. Rejection is an active decision. Expiry is a natural passage of time. The UI should communicate this clearly:

```
Networking Window Closed
```

Not:

```
Request Expired
```

One implies opportunity lost to time. The other implies failure. They are different messages.

### What happens after expiry

Both users revert to **Past Attendees** of that event. There is no penalty, no badge, no negative signal. If they genuinely want to connect later, they can search and send a new request outside the event context — but it will not carry the Missed Opportunity framing.

---

## User Experience Flow

### During presence (Clock A)

```
[I'm Here] → Live view → See people → Connect → Accepted → Relationship
```

The user sees only people currently present. Opportunities are ranked by relevance (see Sprint 7 — Opportunity Engine).

### On check-out

```
[I'm Leaving]

↓

"Thanks for attending AI Summit Chennai.

Networking continues for the next 24 hours.
People who attended after you may still discover you.

You have 3 pending requests.
"
```

The user transitions from Live Discovery to Missed Networking. They are no longer visible to others in Live view, but their presence session is recorded and available for Missed Opportunity queries.

### After 24 hours

```
AI Summit Chennai

Networking Closed

7 connections created
2 conversations started

See you at the next event.
```

The window closes. All pending connection requests expire. The event transitions from active networking to professional history.

---

## Engine Ownership

Every state in the lifecycle is owned by exactly one engine. No engine owns states that belong to another lifecycle phase.

| Concept | Engine | Responsibility |
|---------|--------|----------------|
| **Presence** (live signal) | Presence Engine | Is the person here now? |
| **Attendance** (historical) | Event Engine | Who attended? When? Where? |
| **Live Opportunity** | Opportunity Engine | Who can I meet right now? |
| **Missed Opportunity** | Opportunity Engine | Who did I miss? |
| **Connection Request** | Relationship Engine | Was a request sent? Is it pending? |
| **Relationship** | Relationship Engine | Did they connect? Is it permanent? |
| **Conversation** | Communication Engine | Are they talking? |
| **Memory** | Relationship Engine | Where did they meet? |

### What the Presence Engine does NOT own

- Presence sessions (history)
- Attendance records
- Opportunities (live or missed)
- Connection requests
- Relationships
- Post-event networking windows

The Presence Engine owns exactly one question: **"Is this person here now?"** When the answer becomes no, the Presence Engine's job is done.

---

## Presence Session (Historical Record)

A Presence Session is an **immutable historical record** of a completed presence. It is not a Presence state — it is a history entry owned by the Event Engine for attendance queries.

```typescript
interface PresenceSession {
  id: string;
  personId: string;
  workspaceId: string;
  venueId: string;
  eventId: string;
  startedAt: timestamp;    // first "I'm Here"
  endedAt: timestamp;      // check-out or expiry
  duration: number;        // computed: endedAt - startedAt
  source: 'checkin' | 'auto_expiry' | 'event_end';
}
```

### Key Rules

- **Immutable.** Once created, a Presence Session is never modified.
- **Not a Presence state.** The Presence Engine does not manage sessions. It emits events; the Event Engine records them.
- **Used for Missed Opportunity queries.** The Opportunity Engine reads Presence Sessions to determine non-overlapping attendance.
- **Not exposed in Live view.** Sessions are history, not presence.

### How a Presence Session is created

```
User taps "I'm Here"
    ↓
Presence Engine creates active presence
    ↓
Presence Engine emits event: Presence.Active
    ↓
Event Engine records: PresenceSession.startedAt = now
    │
    ...time passes...
    │
User taps "I'm Leaving" (or presence expires)
    ↓
Presence Engine ends presence
    ↓
Presence Engine emits event: Presence.Ended
    ↓
Event Engine records: PresenceSession.endedAt = now
```

---

## Relationship to Existing Documents

| Document | What it covers | What this document adds |
|----------|---------------|------------------------|
| `PLATFORM-CONSTITUTION.md` | Supreme governing document — Part 0 defines Knowledge Model, Design Axiom, Three-Layer Model, Domain Invariants | This document **applies** those constitutional principles to the specific context of opportunity timing and expiry |
| `YUGROW-PRESENCE-MODEL.md` | What presence is, when it starts/ends, who owns it | What happens **after** presence — opportunity, expiry, closure |
| `SPRINT-7-OPPORTUNITY-ENGINE.md` | How opportunities are detected, ranked, and presented | The **lifecycle** — how opportunities evolve (or expire) over time |
| `ENGINE-SPECIFICATIONS.md` | Engine APIs, data models, events, capabilities | **Engine boundaries** — what each engine owns and does not own in the lifecycle |
| `BUSINESS-OBJECT-BIBLE.md` | Definitions of every business object | **Presence Session** as a historical record, **Missed Opportunity** as a concept |
| `DECISIONS.md` | Foundational decisions (FD-001 through FD-029) | This document does not introduce new FDs. It formalizes patterns already implied by existing decisions. |

---

## What This Document Does Not Cover

- ❌ Recommendation ranking (see Sprint 7)
- ❌ AI-powered matching (see Intelligence Layer)
- ❌ Broadcast opportunities (see Sprint 9)
- ❌ Organization profiles (see Sprint 8)
- ❌ Relationship management (see Relationship Engine)

---

## Validation Questions

This document formalizes a model that has not been tested with real users. The following questions should be answered during the first real-world experiment.

```
□ Do users understand Missed Networking without explanation?

□ Is 24 hours the right window for post-event networking?
   Or should it be 12 hours? 48 hours?

□ Is 24 hours the right expiry for connection requests?
   Or should it be 12 hours? 48 hours?

□ Should multi-day expos behave differently
   (24h per day vs 24h after last day)?

□ Do users perceive Missed Networking as valuable
   or as a gimmick?

□ Does the 24-hour expiry on connection requests
   increase acceptance rate?

□ Do users reopen Yugrow after leaving an event
   because of the 24-hour window?

□ Is the distinction between "expired" and "rejected"
   meaningful to users?
```

These are not rhetorical questions. The answers will determine whether the model survives contact with reality.

---

## Architectural Constraint

```
Presence is ephemeral.
History is immutable.
Opportunities are time-bound.
Relationships are permanent.
```

These four sentences define the entire lifecycle. Every implementation decision must be consistent with all four.

These constraints derive from the Domain Invariants in `PLATFORM-CONSTITUTION.md` §0.3 and Laws 51–55. They are not new rules — they are the Opportunity Lifecycle's expression of constitutional principles.
