---
Title: Yugrow Presence Model
Version: 1.0
Status: Draft
Owner: Chief Architect
Last Updated: 2026-07-23
Dependencies:
  - PLATFORM-CONSTITUTION.md
  - DOMAIN-MODEL.md
  - ENGINE-SPECIFICATIONS.md
Related Documents:
  - SPRINT-7-OPPORTUNITY-ENGINE.md
  - BUSINESS-OBJECT-BIBLE.md
  - YUGROW-CONSTITUTION.md
---

# Yugrow Presence Model

> **Yugrow is a real-time presence graph for the business world.**

Everything grows from presence.

---

## What is Presence?

Presence is a person's **intentional declaration** that they are at a specific place, right now, available to be discovered and connected with.

**Presence is not:**
- A location ping (GPS is a trigger, not the signal)
- An attendance record (you were there ≠ you're available)
- A social media status
- A check-in gamification mechanic
- A background activity

**Presence is:**
- A voluntary signal
- Time-bound
- Purpose-bound (I'm here *for this event*)
- Identity-bound (I'm here *as this workspace*)
- Ephemeral by design

```typescript
Presence {
  personId: string;
  workspaceId: string;       // "as Company A" not "as myself"
  venueId: string;
  eventId: string;
  startedAt: timestamp;
  expiresAt: timestamp;       // 60 minutes from now, renewable
  status: 'active' | 'expiring' | 'expired';
}
```

A person can have **only one active presence at a time.** You cannot be at two events simultaneously.

---

## When Does Presence Begin?

Presence begins with a **conscious, intentional act.** The user taps "I'm Here."

**The trigger sequence:**

```
User opens Yugrow
  → Sees nearby event
  → Taps "Join"
  → Selects workspace (Personal / Company A / ...)
  → Taps "I'm Here"
  → Presence created
```

**Geofence is a trigger, not a gate.** If the user is near the venue, the "I'm Here" button is prominent. If they're far, they can still tap it — they're telling us they're *about* to arrive or *at* the venue. We trust the user's declaration over GPS accuracy.

**Presence is never automatic.** No background check-in. No "you were near this venue" detection. The act of declaring presence is itself a signal — it means the user is *ready to connect*.

---

## When Does Presence End?

Presence ends when one of three conditions is met:

| Condition | How | Why |
|-----------|-----|-----|
| **Explicit departure** | User taps "I'm Leaving" | User left the event |
| **Timer expiry** | 60 minutes since last renewal | Presence is a live signal, not a persistent state |
| **Event end** | Event.endTime reached | The event is over |

**Renewal:** The user receives a subtle notification at 50 minutes. One tap extends presence by another 60 minutes. No renewal = presence expires gracefully. No penalty. No badge of shame.

**What happens on expiry:**

```
Presence expires
  ↓
User disappears from Live view
  ↓
Their opportunities expire
  ↓
Their recommendations disappear from others' views
  ↓
Their relationships remain (permanent)
  ↓
Their event memory remains (for them)
```

**Presence expiry does not delete relationships.** Connections formed during presence persist forever. Only the *live signal* disappears.

---

## Who Owns Presence?

**The Person owns their presence.** Always.

| Aspect | Owner |
|--------|-------|
| Creation | Person (intentional tap) |
| Duration | Person (renew or let expire) |
| Deletion | Person (tap "I'm Leaving") |
| Visibility | Person (visible to others at same event only) |
| Data | Person (expired presence data belongs to the person) |

**The Presence Engine manages presence.** It is a platform engine, not a product. It does not decide who sees what — that is the Recommendation Engine's job. It does not decide who can connect — that is the Relationship Engine's job.

The Presence Engine's sole responsibility is:

> Know who is present, where, and for how long.

That's it.

---

## How Do Organizations Emerge?

Organizations emerge from **workspace-tagged presence.**

When a person checks in as "Company A" (their active workspace), their presence carries the organization's identity. Over time:

```
Person A checks in as Company A
Person B checks in as Company A
Person C checks in as Company A
  ↓
Company A has organizational presence at this event
  ↓
Other attendees see: "3 people from Manufakt Automation here"
```

**Organizations do not need profiles to exist.** An organization is an emergent property of workspace-tagged presence. Formal organization profiles (Sprint 8) are a *product* built on top of this pattern — they add detail, but the *signal* already exists.

**Key rule:** An organization's presence is the aggregate of its members' individual presences. There is no separate "org check-in." The org is present because its people are present.

---

## How Do Recommendations Emerge?

Recommendations emerge from **Presence + Signals + Ranking.**

```
Presence creates the pool
  ↓  (everyone checked in to this event)
Signals create the alignment
  ↓  (intent, industry, role, mutual connections)
Ranking creates the priority
  ↓  (Intent > Trust > Presence > Discovery)
Recommendations are delivered to the user
```

**The formula:**

```
Recommendation = Presence ∩ (Intent ∪ Industry ∪ Role ∪ Mutuals)
                × (Trust + Recency)
```

**Presence is the prerequisite.** If you are not present at this event, you cannot appear in recommendations. No exceptions. This is the moat.

**Every recommendation expires with presence.** When the person leaves, their recommendation disappears. This reinforces: *recommendations exist because presence exists — not because a database exists.*

---

## How Do Broadcasts Emerge?

Broadcast is a **presence-independent mode** of the Opportunity Engine.

```
Presence Mode (Sprint 7)          Broadcast Mode (Sprint 9)
─────────────────────────         ─────────────────────────
Trigger: "I'm Here"               Trigger: "I need something"
Scope: Same event + time          Scope: Network-wide + geo
Detection: Deterministic          Detection: AI matching
Output: "People to meet"          Output: "Opportunities for you"
```

**Broadcast does not require presence.** You can broadcast from anywhere. But presence makes broadcast *better*:

- "846 professionals are here right now" gives broadcast context
- Intent signals from presence feed broadcast targeting
- Trust accumulated through presence improves broadcast credibility

**Broadcast becomes valuable because presence tells you who's listening.**

---

## How Does Memory Emerge?

Memory is **what remains after presence expires.**

```
Presence expires
  ↓
Live signal disappears
  ↓
But these persist:
  ├── Relationships formed
  ├── Event attendance history
  ├── Organizations represented
  ├── Opportunities detected
  └── Connections made
```

**Memory has two forms:**

| Form | What it is | Visible to |
|------|-----------|------------|
| **Personal memory** | Events attended, people met, conversations had | The person only |
| **Relationship memory** | Origin context (Event + Venue + Date) | Both parties in a connection |

**Personal memory becomes Sprint 10 (Relationship Memory).** Until then, Yugrow remembers nothing beyond the current event — intentionally. This keeps the product focused on *what's happening now*, not *what happened before*.

**Relationship memory already exists in v1.** Every connection stores: Event, Venue, Date. This is the seed. Sprint 10 will expand it into a full history view.

---

## The Complete Model

```
                     ┌──────────────────┐
                     │                  │
                     │   PERSON TAPS    │
                     │   "I'M HERE"     │
                     │                  │
                     └────────┬─────────┘
                              │
                              ▼
                     ┌──────────────────┐
                     │                  │
                     │    PRESENCE      │
                     │                  │
                     │  ┌────────────┐  │
                     │  │ 60-minute  │  │
                     │  │  window    │  │
                     │  └────────────┘  │
                     └────────┬─────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
              ▼               ▼               ▼
     ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
     │              │ │              │ │              │
     │ DISCOVERY    │ │CONNECTIONS   │ │OPPORTUNITIES │
     │ (Live view)  │ │(Relationships│ │(Recommend-   │
     │              │ │ formed)      │ │ ations)      │
     └──────────────┘ └──────────────┘ └──────────────┘
              │               │               │
              │               │               │
              ▼               ▼               ▼
     ┌─────────────────────────────────────────────┐
     │                                             │
     │           PRESENCE EXPIRES                  │
     │                                             │
     │  ┌─────────────┐  ┌────────────────────┐   │
     │  │ Relationships│  │  Personal Memory   │   │
     │  │ persist      │  │  (Events attended, │   │
     │  │ with origin  │  │   people met,      │   │
     │  │ context      │  │   conversations)   │   │
     │  └─────────────┘  └────────────────────┘   │
     │                                             │
     └─────────────────────────────────────────────┘
                              │
                              │ (next event)
                              ▼
                     ┌──────────────────┐
                     │                  │
                     │   NEW PRESENCE   │
                     │                  │
                     │  Relationships   │
                     │  carry forward   │
                     │  as foundation   │
                     │                  │
                     └──────────────────┘
```

---

## What This Means for Every Sprint

| Sprint | How Presence enables it |
|--------|------------------------|
| **Sprint 1–6** ✅ | Presence IS the product. Discovery, Connect, Chat all depend on it. |
| **Sprint 7** 🔄 | Recommendations are Presence + Signals. Without presence, no recommendations. |
| **Sprint 8** ⏳ | Organizations emerge from workspace-tagged presence. |
| **Sprint 9** ⏳ | Broadcast is presence-independent, but presence makes it contextual. |
| **Sprint 10** ⏳ | Memory is what persists after presence expires. |
| **Sprint 11** ⏳ | Personalization needs presence data to learn from. |

---

## Core Principle

> **Everything begins and ends with presence.**

Discovery begins when presence begins.
Opportunities exist while presence exists.
Relationships persist after presence ends.
Memory is what remains when presence is gone.

Yugrow is not a relationship management platform.
It is not an event networking platform.
It is not an opportunity matching platform.

Yugrow is a **real-time presence graph for the business world.**
Everything else is an application that uses that graph.
