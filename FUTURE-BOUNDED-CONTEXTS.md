# Future Bounded Contexts

> **A registry of acknowledged future capabilities that are intentionally not built yet.**

Not every future capability deserves an engine, a document, a folder, or code. Some deserve only three things: a name, a purpose, and an activation condition.

This file is that registry. It is not a roadmap, not a backlog, not a spec. It is a **placeholder** — enough information that when the activation condition is met, nobody has to rediscover *why* the context exists.

**Dormant contexts are not promises — they are hypotheses.** A context may activate as expected, activate very differently, or never activate. All three outcomes are acceptable. The document does not say "we will build this." It says "if reality demands this bounded context, this is where it belongs."

**Admission criteria:** An idea belongs in this file only if it satisfies all four conditions:

1. **It represents a true domain**, not just a feature or UI pattern.
2. **It has a clear purpose** independent of its eventual implementation.
3. **It has a testable activation condition** that determines when it ceases to be dormant.
4. **It cannot naturally belong inside an existing engine** — if it fits an existing bounded context, reference that context instead.

If an idea does not meet these criteria, it belongs in product planning, not here. Admission into this file is intentionally difficult — it keeps the document special and ensures each entry represents a genuine piece of future architecture rather than an accumulation of ideas.

**How to use this file:** When a new capability is proposed, evaluate it through this deterministic order:

```
New idea
    │
    ▼
Does it violate the Constitution?
    │
 ├── Yes → Reject
 │
 └── No
      │
      ▼
Does it require a philosophical commitment?
      │
 ├── Yes → Founder Decision (DECISIONS.md)
 │
 └── No
      │
      ▼
Is the bounded context already active?
      │
 ├── No → Add to this file (if it meets admission criteria)
 │
 └── Yes
      │
      ▼
Does validation justify building it now?
      │
 ├── No → Validation backlog
 │
 └── Yes
      │
      ▼
Sprint (sprint-plan document)
```

---

## Dormant Contexts

### Contribution Engine

| Field | Value |
|-------|-------|
| **Purpose** | Reward verified professional contributions to the ecosystem. Owns referral attribution, credit earning, host reputation, venue stewardship, topic stewardship. |
| **Activation** | Relationship Economy and Intelligence Economy validated (Phase 1 + Phase 2 complete). |
| **Status** | Dormant. |
| **Principle** | *Yugrow rewards verified professional contributions, not platform activity.* |

---

### Topic Engine

| Field | Value |
|-------|-------|
| **Purpose** | Govern evolving professional taxonomy. Owns topic normalization, merging, deprecation, aliasing, and semantic search across events. |
| **Activation** | Thousands of community-created topics exist and manual management is no longer feasible. |
| **Status** | Dormant. |
| **Note** | The topic lifecycle (pending → verified → popular → deprecated/merged) is defined in CONSTITUTION.md §0.4. The Topic Engine would implement it at scale. |

---

### Commerce Engine

| Field | Value |
|-------|-------|
| **Purpose** | Payments, subscriptions, billing, usage metering, invoicing, tax handling, payment provider abstraction. |
| **Activation** | Paid products exist and need transaction processing. |
| **Status** | Dormant. |
| **Note** | Pricing philosophy exists in workflow memory: *Monetize capability, not existence.* The engine is implementation. |

---

### Broadcast Engine

> **Note:** The Opportunity Engine (Engine 5) is specified in ENGINE-SPECIFICATIONS.md with full Broadcast lifecycle. This entry acknowledges Broadcast as a standalone product experience, not a new engine.

| Field | Value |
|-------|-------|
| **Purpose** | One-to-many professional announcements distributed through multi-level geographic broadcast (connections → venue → city → state → country → global). |
| **Activation** | Users need to distribute opportunities beyond event attendees (Sprint 9). |
| **Status** | Dormant. Engine spec exists; product experience not built. |

---

### Ambient Presence

| Field | Value |
|-------|-------|
| **Purpose** | Check in to real-world places (coworking spaces, campuses, airports, offices) without requiring an organized event. |
| **Activation** | Events validated as a trusted presence source. Horizon 1 complete. |
| **Status** | Dormant. |
| **Note** | Architecture already supports it (Venue → Presence without Event). The product sequence determines when to unlock it. See CONSTITUTION.md §1.4 (The Two Horizons). |

---

### Knowledge Model (Full)

| Field | Value |
|-------|-------|
| **Purpose** | Formalize Yugrow's epistemology — what the platform is allowed to know, remember, infer, and forget. |
| **Activation** | AI features reach a scale where knowledge boundaries need explicit definition beyond the Design Axiom and Three-Layer Model. |
| **Status** | Dormant. |
| **Note** | The Constitution §0 already defines the core: Reality → Interpretation → Experience. A full Knowledge Model document would extend this with specific policies for data retention, inference rules, and forgetting. |

---

### Feedback Intelligence Engine

| Field | Value |
|-------|-------|
| **Purpose** | Transform customer feedback into verified product decisions. Owns the pipeline: capture → evidence → validation → user story → sprint → implementation → verification → notify reporter. Ingests feedback from any channel (in-app shake, WhatsApp, Telegram, email, Play Store, GitHub) and unifies into a single feedback record. |
| **Activation** | When multiple Yugrow products generate enough external feedback that manual triage no longer scales. |
| **Status** | Dormant. |
| **Note** | Every message in a System Conversation (see below) is an input to this engine. The engine is not a support ticketing system — it is an evidence-driven product decision pipeline. Closely related to the System Conversations concept. |

### System Conversations *(Design Note — not a bounded context)*

| Field | Value |
|-------|-------|
| **Purpose** | Platform-owned conversations that exist by default for every person or workspace. Examples: **Yugrow** (product updates, support, feedback, AI assistance), **Workspace Assistant** (announcements, onboarding), **Event Host** (event updates), **Billing** (future — invoices, payments). Built on the existing Conversation Engine — no new infrastructure required. |
| **Activation** | When the Feedback Intelligence Engine activates, or when user research shows professionals expect a direct communication channel with the platform. |
| **Status** | Design note. Conversation Engine supports this today. |
| **Principle** | *Every relationship matters — including the relationship between the professional and Yugrow itself.* |
| **Note** | This is not a separate engine. It's a product pattern on top of the existing Conversation Engine. The first implementation is a default "Yugrow" chat created at onboarding completion, with a welcome message explaining it's their direct line to the team. Supports rich cards (bug status, feature request status, release notes), AI-assisted answers, and human escalation. See `docs/PRODUCT-STORY-LANGUAGE.md` for narrative framing.

---

## How to Add a Dormant Context

A new entry must include:

1. **Name** — A noun phrase that names the bounded context
2. **Purpose** — One or two sentences describing what it owns
3. **Activation** — The specific condition that must be met before building
4. **Status** — Always `Dormant` at creation time

Optional:
- **Principle** — A governing constraint (one sentence)
- **Note** — Cross-references to existing documents or relevant context

Entries without an activation condition will be rejected. Every dormant context must have a clear, testable trigger for when it ceases to be dormant.
