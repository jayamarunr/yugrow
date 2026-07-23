---
Title: Sprint 7 — Opportunity Engine (Presence Mode)
Version: 1.0
Status: Approved — Frozen
Next Action: Awaiting Presence Model completion before implementation
Owner: Chief Architect
Last Updated: 2026-07-23
Dependencies:
  - ENGINE-SPECIFICATIONS.md (Engine 5 — full lifecycle)
  - INTELLIGENCE-LAYER.md
  - PRESENCE-ENGINE.md
Related Documents:
  - SPRINT-6-ARRIVAL-EXPERIENCE.md
  - DOMAIN-MODEL.md
  - YUGROW-FLOW-EXPERIENCE-SYSTEM.md
---

# Sprint 7 — Opportunity Engine (Presence Mode)

> **This is not "you might also like."**
> This is "here's what's happening right now in this room that's relevant to you."

---

## Why This Sprint Exists

The Arrival Experience (Sprints 1–6) solved: *"How do I discover and connect with people at an event?"*

Sprint 7 solves: *"How do I know who I should spend my next 30 minutes with?"*

These are fundamentally different questions. The first is about discovery. The second is about **priority**.

---

## What This Is Not

This sprint does **not** build:

- ❌ AI-powered opportunity matching
- ❌ User intent forms ("What are you looking for?")
- ❌ Cross-event opportunities
- ❌ Organization profiles (Sprint 8)
- ❌ Broadcast integration (Sprint 9)
- ❌ Relationship history (Sprint 10)
- ❌ Deals, pipelines, or CRM

---

## Product Positioning

**Internal name:** Opportunity Engine (Engine 8)

**External name (never expose in UI):** Opportunity

**User-facing labels:**

| Context | Label |
|---------|-------|
| Section header | "People you should meet" |
| Tooltip | "Recommended based on who's here" |
| Filter toggle | "Worth meeting" / "Everyone" |
| Card badge | "Why this appeared" |

The word "Opportunity" never appears in the UI. The user sees **people**, not abstractions.

---

## Architecture Philosophy

```
Frameworks live at the application's edge.
Shared packages depend only on domain concepts and UI primitives,
never on framework APIs.
```

— FD-023

Applied to this engine:

```
Signals live at the engine's edge.
The engine depends only on domain concepts (Presence, Profile, Intent),
never on application-specific routing, frameworks, or AI providers.
```

---

## The Yugrow Difference

> Yugrow doesn't help you find people. It helps you notice the right people at exactly the right moment, while you're in the same room.

LinkedIn recommends people anywhere. Event apps show who's attending. Yugrow surfaces who you should meet **right now**, **20 metres away**, based on **what they've told us they're looking for**.

That is the moat.

---

## Layer Architecture

The engine is built in four layers. Each layer has one responsibility:

```
Signal                  Raw facts ("checked in", "same industry")
   │
   ▼
Opportunity             Meaningful alignment (internal engine object)
   │
   ▼
Recommendation          Ranked presentation to the user
   │
   ▼
Relationship            What happens after the user acts (connect, message)
```

### Layer 1 — Signal

A signal is a **single verifiable fact** about a person's current state at an event.

| Signal | Source | Deterministic |
|--------|--------|---------------|
| `presence.arrived` | Presence Engine | ✅ |
| `profile.industry` | Person profile | ✅ |
| `profile.role` | Person profile | ✅ |
| `workspace.active` | Workspace Engine | ✅ |
| `relationship.mutual` | Relationship Engine | ✅ |
| `intent.looking_for` | Person profile — "Looking for" field | ✅ |
| `trust.verified` | Trust Engine | ✅ |

All signals are **deterministic**. No AI inference. Every signal is auditable.

### Layer 2 — Opportunity

An opportunity is a **detected alignment** between two people currently present at the same event.

```typescript
interface Opportunity {
  id: string;
  type: OpportunityType;
  sourcePersonId: string;
  targetPersonId: string;
  eventId: string;
  signals: Signal[];            // evidence backing this opportunity
  explanation: string;          // "You're both in Manufacturing"
  status: 'active' | 'connected' | 'expired' | 'ignored';
  detectedAt: number;           // timestamp
  expiresAt: number;            // tied to presence or event end
}

type OpportunityType =
  | 'intent_match'           // strongest — "Looking for" aligns
  | 'same_industry'
  | 'complementary_role'     // e.g., founder meets investor
  | 'mutual_connection'
  | 'recent_arrival'
  | 'shared_workspace';
```

**Every opportunity must answer three questions:**

| Question | Answer |
|----------|--------|
| WHO | Person's name + role + company |
| WHY | Evidence signals + explanation |
| WHY NOW | Recency — "Arrived 4 mins ago" / "Here for 45 mins" |

### Layer 3 — Recommendation

Ranked, presented opportunities. Ranking is deterministic in v1.

```
Score = Intent + Trust + Presence + Discovery
```

| Factor | Weight | What it measures |
|--------|--------|------------------|
| **Intent** | Highest | Direct "Looking for" alignment between two people. This is Yugrow's strongest signal. |
| **Trust** | High | Verified profile, event history, relationship graph depth |
| **Presence** | Medium | Recently arrived people get a boost. People about to expire also get attention. |
| **Discovery** | Low-Medium | Less overlap = more discovery value. But never penalizes a strong intent match. |

**Intent is the heaviest factor** because it's the most specific signal the user has given us. "Looking for distributors" + "Looking for automation products" is a stronger signal than "same industry."

**Novelty is NOT a ranking factor.** Someone you've seen five times today might still be your best opportunity in the room.

### Layer 4 — Relationship

When the user acts on a recommendation (views profile, connects, messages), the opportunity becomes a relationship action. This layer is owned by the Relationship Engine. The Opportunity Engine's job ends when the user decides to act.

---

## Detection Pipeline

Runs on every presence heartbeat (arrival, departure, expiry):

```
Presence Change
     │
     ▼
┌─────────────────────┐
│  1. Signal Scanner   │  Scan all active presences at this event
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│  2. Alignment Check  │  Pair current user with each active presence
└─────────┬───────────┘   Compute opportunity score
          │
          ▼
┌─────────────────────┐
│  3. Deduplicator     │  Remove already-connected or previously-ignored
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│  4. Ranker           │  Sort by Intent + Trust + Presence + Discovery
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│  5. Distributor      │  Push to user's Live view
└─────────────────────┘
```

**Scoped to the current event.** Opportunities only surface for people currently present at the same event. No cross-event noise.

---

## Intent Signal (The Strongest Signal)

The "Looking for" field in a person's profile is the most valuable signal Yugrow owns. It is the user telling us, in their own words, why they are here.

**Detection logic:**

```
Person A: "Looking for distributors"
Person B: "Looking for automation products"

→ Intent match detected: A wants what B offers
→ Opportunity created with type: intent_match
→ Explanation: "She's looking for automation distributors"
```

**This is not AI matching.** It's direct field comparison with taxonomy mapping. The taxonomy is:

| Category | Matches With |
|----------|-------------|
| Looking for distributors | Looking for products to distribute |
| Looking for investors | Looking for startups to invest in |
| Looking for co-founders | Looking for co-founders |
| Looking for customers | Looking for solutions |
| Looking for suppliers | Looking for buyers |
| Looking for partners | Looking for partnerships |
| Hiring | Looking for jobs |

The taxonomy is **configuration, not code**. It can be extended without deployment.

---

## Data Collection Only (Learning Deferred)

> **Learning (personalization) is explicitly out of scope for Sprint 7.**
> Deferred to Sprint 11 — after enough data exists to make it meaningful.

In v1, the engine only records:

```typescript
{
  action: 'ignored' | 'viewed' | 'connected',
  opportunityId: string,
  timestamp: number
}
```

"Ignored" means no action was taken. Nothing happens as a result.

**Intent is deferred to Sprint 11.** Do not build personalization logic in Sprint 7. Collect data. Ship. Learn. Iterate.

---

## UX Impact

### Current Live screen:

```
Live
────────────────────
247 Professionals
┌──────────────────┐
│ Raj K. · Founder │
│ CRM Automation   │
└──────────────────┘
┌──────────────────┐
│ Priya S. · COO   │
│ Manufakt Auto.   │
└──────────────────┘
...
```

### With Opportunity Engine:

```
Live              [Filter: Worth meeting ▾]
═══════════════════════════════════════════

People you should meet    (4)
──────────────────────────

🎯 Looking for distributors
   Priya S. · COO · Manufakt Automation
   Why? She's looking for automation distributors
   Why now? Arrived 4 mins ago
   [View] [Connect]

🔗 Mutual connection
   Raj K. · Founder · CRM Labs
   Why? Connected through Arun K.
   Why now? Here for 45 mins
   [View] [Connect]

🏢 Same organization
   Ananya S. · Sales Director · Manufakt
   Why? Also representing Manufakt today
   Why now? Arrived 15 mins ago
   [View] [Connect]

──────────────────────────
Everyone Here    (243)
──────────────────────────
[scrollable list continues]
```

**Key UX decisions:**
- Opportunities are a **lens on top of Live**, not a separate screen
- User toggles between "Worth meeting" and "Everyone"
- Every card answers WHO, WHY, WHY NOW
- No "confidence score" — evidence replaces confidence
- The "Opportunity" word never appears

---

## API Contract

```typescript
// Engine 8 — Opportunity Engine (Presence Mode)

GET  /api/v1/events/:eventId/opportunities
     → List ranked opportunities for current user at this event
     Query: ?filter=intent|industry|mutual|all

GET  /api/v1/opportunities/:id/signals
     → Get evidence signals backing this opportunity

POST /api/v1/opportunities/:id/ignore
     → Mark as "no action taken" (teaches the engine)

POST /api/v1/opportunities/:id/connect
     → Convert opportunity to connection request
     (delegates to Relationship Engine)
```

---

## Events

**Emits:**
- `Opportunity.Detected` — New opportunity created
- `Opportunity.Expired` — Presence ended or event over
- `Opportunity.Ignored` — User took no action (learning signal)

**Consumes:**
- `Presence.Arrived` — Trigger signal scan
- `Presence.Departed` — Expire related opportunities
- `Profile.Intent.Updated` — Re-evaluate "Looking for" matches
- `Relationship.Connected` — Remove connected pairs from opportunities

---

## Relationship to Broadcast-Mode (Future)

The ENGINE-SPECIFICATIONS.md describes a **separate mode** of the same engine:

| Dimension | Presence Mode (Sprint 7) | Broadcast Mode (Sprint 9) |
|-----------|-------------------------|--------------------------|
| Trigger | Physical presence | Created opportunity post |
| Scope | Same event + same time | Network-wide + geo-radius |
| Detection | Deterministic signals | AI matching + semantic |
| Ranking | Intent + Trust + Presence + Discovery | AI scoring + deal probability |
| Output | "People you should meet" | "Opportunities for you" |
| AI | None | Semantic matching, categorization |
| When | Sprint 7 | Sprint 9+ |

Both modes share the same `Opportunity` data model but use different detection pipelines. The Broadcast mode is explicitly out of scope for Sprint 7.

---

## Acceptance Criteria

```
Given I am checked into an event
When I open the Live screen
Then I see a "Worth meeting" section at the top
And each card answers: WHO, WHY, WHY NOW

Given a person with "Looking for distributors" on their profile
And another person with "Looking for automation products"
When both are present at the same event
Then an intent_match opportunity is created
And the explanation says why they align

Given I connect with someone from an opportunity
Then that person no longer appears in my opportunities
And the relationship origin records the event context

Given I ignore an opportunity
Then the engine learns but does not penalize me
And the opportunity is hidden for this session only
```

---

## What Success Looks Like

At a real event:

> "I opened Yugrow and it showed me four people I should meet. I connected with two of them. One was a distributor I'd been looking for. The whole thing took 30 seconds."

Not "analytics." Not "dashboards." Just: **one fewer missed connection.**
