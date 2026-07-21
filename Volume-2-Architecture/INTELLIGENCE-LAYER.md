---
Title: Intelligence Layer
Version: 1.0
Status: Approved
Owner: Chief Architect / CPO
Last Updated: 2026-07-22
Dependencies:
  - Volume-2-Architecture/BUSINESS-OBJECT-BIBLE.md
  - PLATFORM-CONSTITUTION.md
Related Documents:
  - Volume-2-Architecture/AI-ARCHITECTURE.md
  - Volume-2-Architecture/ENGINE-SPECIFICATIONS.md
---

# Intelligence Layer

> **AI generates. Intelligence decides.**
>
> This document defines the **decision-making layer** of Yugrow — the rules, signals, and pipelines that determine who sees what, why they see it, and what action they should take next.
>
> AI features (content generation, image creation, chatbots) are documented in the AI Architecture. This layer is separate by design.

---

## Core Principle

> **Every recommendation must be explainable.**

A user should always be able to ask "why am I seeing this?" and receive a clear, specific answer:

- *"You're seeing this because you listed CRM Automation as a skill and you're currently in Dubai."*
- *"This person is recommended because you both attended Fintech Summit and have 3 mutual connections."*
- *"This opportunity was matched to you because your company is in Logistics and the broadcaster selected 'Venue' radius at Chennai Trade Centre."*

---

## Where Intelligence Operates

| Product | Intelligence Function | AI Function (Separate) |
|---------|----------------------|------------------------|
| **CheckIN / Presence** | Who to show in Live tab; ordering; filtering | Generating message suggestions |
| **Broadcast** | Who should receive this opportunity; ranking | Writing opportunity descriptions |
| **Discovery** | What to recommend; personalization | Summarizing why |
| **Relationship** | Whom to suggest as connection; strength scoring | Drafting connection messages |
| **Content** | What content to surface; SEO optimization | Generating content |
| **Trust** | Which evidence to surface; which signals matter | Summarizing reputation |
| **Journey Engine** | Which journey step is next; contextual coaching | Answering user questions |

---

## The Intelligence Pipeline

Every intelligence decision follows the same pipeline:

```
1. Candidate Selection     ← Who could this apply to?
2. Context Filter          ← Does their current context match?
3. Relationship Filter     ← Are they connected / how closely?
4. Skill Match             ← Do their declared skills align?
5. Intent Match            ← Does their current intent align?
6. Presence Match          ← Are they in the right place right now?
7. Trust Signals           ← What does their trust evidence say?
8. Personal Ranking        ← How relevant is this to them personally?
9. Explainability          ← Why are they seeing this?
10. Delivery               ← Show it to them
```

### Stage 1 — Candidate Selection

Eliminate everyone who clearly shouldn't receive this.

| Rule | Example |
|------|---------|
| Geographic scope | Only users currently in or historically in the target city |
| Minimum trust | Users with no trust evidence or negative signals excluded |
| Self-exclusion | User has opted out of this category |
| Rate limit | User has received maximum daily recommendations |

### Stage 2 — Context Filter

Match against the user's current context.

| Signal | Weight | Source |
|--------|--------|--------|
| Current presence (ACTIVE) | High | Presence object |
| Recent presence (RECENT) | Medium | Presence object |
| Business intent (lookingFor) | High | Presence.lookingFor |
| Available today | High | Presence.availableToday |
| Past event attendance | Low | Event history (used for networking, NOT for expertise) |

**Platform Law reminder:** Past event attendance is a weak signal used only for networking context. It must never be used for skill inference or opportunity matching.

### Stage 3 — Relationship Filter

| Signal | Weight | Source |
|--------|--------|--------|
| Direct connection | Highest | Relationship (Active) |
| Connection of connection | High | Relationship graph |
| Same workspace | Medium | Membership |
| Past event co-attendance | Low | Presence history |
| No relationship | Baseline | — |

### Stage 4 — Skill Match

| Match Type | Weight | Description |
|------------|--------|-------------|
| Exact skill match | Highest | Skill listed = skill required |
| Category match | High | Same category (e.g., "Export" and "Logistics") |
| Industry match | Medium | Same industry |
| Adjacent industry | Low | Related industry |
| No match | Zero | Excluded from this opportunity |

### Stage 5 — Intent Match

| Match | Weight | Description |
|-------|--------|-------------|
| Intent aligns with opportunity purpose | High | "Looking for Customers" matches "Seeking Vendors" |
| Intent partially aligns | Medium | "Networking" matches most opportunities |
| Intent conflicts | Zero | "Hiring" does not match "Looking for Job" |
| No intent declared | Low | Fallback to skill and context |

### Stage 6 — Presence Match

| Match | Weight | Description |
|-------|--------|-------------|
| Currently at same venue | Highest | Same venue right now |
| Currently in same city | High | Same geographic area |
| Recently present at venue | Medium | Was there in last 24h |
| Not present | Baseline | Location-independent opportunities |

### Stage 7 — Trust Signals

| Signal | Effect | Source |
|--------|--------|--------|
| High trust evidence | Boost ranking | TrustEvidence |
| Mutual trust connections | Moderate boost | TrustEvidence + Relationship |
| Low or no evidence | No penalty | — |
| Negative evidence | Exclusion | TrustEvidence (revoked/flagged) |

### Stage 8 — Personal Ranking

Combine all signals into a personalized score:

```
score = (skillMatch * 0.30) +
        (intentMatch * 0.20) +
        (relationshipWeight * 0.20) +
        (presenceMatch * 0.15) +
        (trustSignals * 0.10) +
        (contextBonus * 0.05)
```

Weights are illustrative. Actual weights are determined by experimentation and may vary by product.

### Stage 9 — Explainability

Before delivery, generate the "why" statement:

```
Rule-based: Assemble from matched signals
  "You're seeing this because:
   - You listed CRM Automation (skill match)
   - You're currently in Dubai (presence match)
   - The broadcaster is a connection of your connection (relationship)"
```

### Stage 10 — Delivery

Present to the user with the explainability statement attached.

---

## Intelligence Signals Reference

### Person Signals

| Signal | Type | Freshness | Source |
|--------|------|-----------|--------|
| Skills | Declared | Months | Profile |
| Industries | Declared | Months | Profile |
| Current intent | Declared | Hours | Presence |
| Availability | Declared | Hours | Presence |
| Presence status | Derived | Minutes | Presence |
| Relationship graph | Derived | Real-time | Relationship Engine |
| Trust evidence | Derived | Permanent | Trust Engine |
| Past events | Historical | Days to years | Presence history |
| Response time | Derived | Per-event | Presence/ConnectionRequest |
| Networking activity | Derived | Per-event | Presence/ConnectionRequest |

### Opportunity Signals

| Signal | Type | Source |
|--------|------|--------|
| Skills required | Declared | Opportunity |
| Industries | Declared | Opportunity |
| Geographic scope | Declared | Opportunity |
| Distribution radius | Declared | Opportunity |
| Expiry | Declared | Opportunity |
| Business intent | Declared | Opportunity |
| Creator trust score | Derived | Trust Engine |
| Creator relationship graph | Derived | Relationship Engine |

---

## Intelligence vs AI — Clear Boundary

| | Intelligence Layer | AI Layer |
|---|---|---|
| **Purpose** | Decide who sees what and why | Generate content, summarize, chat |
| **Output** | Rankings, filters, explainability statements | Text, images, code, answers |
| **Latency** | < 200ms (computed, not generated) | 1-10s (generated) |
| **Deterministic?** | Yes (same inputs = same output) | No (generative) |
| **Auditable?** | Fully (every decision logged) | Partially (prompt + output) |
| **Fallback** | Fixed rules if signals are missing | Graceful degradation |
| **Platform Law** | Must comply with all Platform Laws | Must comply with all Platform Laws |
| **Example** | "Send this opportunity to 247 people because..." | "Write a blog post about AI in logistics" |

### Integration Points

Intelligence Layer feeds data TO the AI Layer:
- Ranked lists → AI summarizes them
- User context → AI personalizes tone
- Explainability data → AI generates natural language explanations

AI Layer never overrides Intelligence Layer decisions.
Intelligence Layer never generates content.

---

## Guardrails

| Rule | Enforcement |
|------|-------------|
| Never infer expertise from event attendance | Intelligence pipeline excludes attendance from skill/opportunity matching |
| Never expose Presence Score publicly | Internal signal only |
| Never override user visibility settings | HIDDEN means excluded from all lists |
| Always provide explainability | Every recommendation includes "why" |
| Rate limit all deliveries | Per-user daily cap |
| Log every decision for audit | Full decision trace stored |

---

> **The Intelligence Layer is what makes Yugrow intelligent, not the AI.**
>
> AI generates. Intelligence decides. Build the Intelligence Layer to be deterministic, auditable, and explainable from day one. AI features can be added on top later without changing how decisions are made.
>