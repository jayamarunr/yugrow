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
| **Activation** | When multiple Yugrow products generate enough external feedback that manual triage no longer scales. (1) Feedback volume exceeds manual triage capacity. (2) Multiple Yugrow products begin receiving user feedback. (3) Closing the feedback loop becomes a competitive advantage for retention. |
| **Status** | Dormant. |
| **Note** | Every message in a System Conversation (see below) is an input to this engine. The engine is not a support ticketing system — it is an evidence-driven product decision pipeline. Closely related to the System Conversations concept. See also: Product Memory (design note below). |

### System Conversations *(Design Note — not a bounded context)*

| Field | Value |
|-------|-------|
| **Purpose** | Platform-owned conversations that exist by default for every person or workspace. Examples: **Yugrow** (product updates, support, feedback, AI assistance, release notes, beta access, surveys, security notifications, billing alerts, workspace health, productivity tips), **Workspace Assistant** (announcements, onboarding), **Event Host** (event updates), **Billing** (future — invoices, payments). Built on the existing Conversation Engine — no new infrastructure required. |
| **Activation** | When the Feedback Intelligence Engine activates, or when user research shows professionals expect a direct communication channel with the platform. |
| **Status** | Design note. Conversation Engine supports this today. |
| **Principle** | *Every relationship matters — including the relationship between the professional and Yugrow itself. The relationship with the product should not end when a ticket closes.* |
| **Note** | This is not a separate engine. It's a product pattern on top of the existing Conversation Engine. The first implementation is a default "Yugrow" chat created at onboarding completion, with a welcome message explaining it's their direct line to the team. Supports rich cards (bug status, feature request status, release notes), AI-assisted answers, and human escalation. See `docs/PRODUCT-STORY-LANGUAGE.md` for narrative framing.

### Product Memory *(Design Note — not a bounded context)*

| Field | Value |
|-------|-------|
| **Purpose** | The Yugrow conversation remembers its journey with each professional. Past feedback, feature requests, bug reports, milestones — all accessible within the conversation context. "You reported Venue Search in April. Fixed in v1.2." "You were one of the first 100 founders to host an event." |
| **Activation** | When the System Conversation pattern is active and the Feedback Intelligence Engine has accumulated enough historical feedback data per professional to make recall meaningful. |
| **Status** | Design note. Not an engine — a capability of the System Conversation + Feedback Engine combination. |
| **Principle** | *The product should remember the relationship. Not just the last message — the entire journey.* |

---

### Event Identity Layer *(Design Note — post-Alpha capability)*

| Field | Value |
|-------|-------|
| **Purpose** | Solve the trust problem in event discovery. The problem isn't duplicate events — it's not knowing which one is real. Introduce an **Identity Layer** where every event answers "Who is behind this?" rather than "What is this called?" **Host identity becomes primary. Event title becomes secondary.** Four tiers: **Official Events** (paid organiser, OFFICIAL badge, branding, analytics, featured placement), **Community Meetups** (👥, hosted by a professional), **Networking Spots** (📍, hosted by an attendee), **Private Events** (🔒, invite-only). The word "Official" is psychologically stronger than "Verified." |
| **Activation** | After the First Meetup, when evidence shows that (a) duplicate or misleading events cause real user confusion, (b) an organiser explicitly asks how attendees will know their event is the real one, or (c) an organiser is ready to pay for an Official Event package. |
| **Status** | Design note. Not a new engine — the existing Event Engine gains an identity attribute. Part of a broader **Identity hierarchy**: Professional → Company → Venue → Event → Workspace → Organisation. |
| **Principle** | *Trust comes from identity, not moderation. The market self-corrects when identity is visible.* |
| **Note** | **Design rule:** Never use colour alone. Always combine badge + icon + host identity for accessibility and clarity. Example: `✓ OFFICIAL` badge + 🏢 + "Hosted by XYZ Exhibitions". **Model change:** `Event` gains `type: official \| community \| networking \| private`. `hostId` already present — UI needs to display it prominently. **Monetisation:** Organisers buy an **Official Event Package** — not a blue tick. Package includes OFFICIAL badge, brand logo, featured placement, analytics dashboard, networking enabled, QR check-in, post-event retargeting, lead export, sponsor dashboard. This is selling an **Official Digital Event Presence**, not verification. **Free tiers** (Community, Networking, Private) remain free. **Not Alpha:** Violates R31 — introduces a new capability and touches the Event model. The flow: Idea → Architecture → Documentation → Dormant → Customer Evidence → Activation → Implementation. **Pre-Alpha mitigation (no-code):** Display host name prominently on every event card. Reserve space for an OFFICIAL badge but don't activate it. Collect evidence in CUSTOMER-EVIDENCE.md: "Did users struggle to identify the real event?" "Did organisers ask how to distinguish their event?" Full traceability chain: `FD-0XX → Post-Meetup Sprint → Event Identity Layer → Event.type`. |

---

A new entry must include:

1. **Name** — A noun phrase that names the bounded context
2. **Purpose** — One or two sentences describing what it owns
3. **Activation** — The specific condition that must be met before building
4. **Status** — Always `Dormant` at creation time

Optional:
- **Principle** — A governing constraint (one sentence)
- **Note** — Cross-references to existing documents or relevant context

Entries without an activation condition will be rejected. Every dormant context must have a clear, testable trigger for when it ceases to be dormant.

---

### Feedback Stream *(Design Note — precursor to Feedback Intelligence Engine)*

| Field | Value |
|-------|-------|
| **Purpose** | The public memory of Yugrow's product improvement journey. A single shared conversation where every bug, idea, and improvement exists exactly once — not scattered across WhatsApp, email, Discord, or DMs. Every user-visible product improvement must be traceable to evidence (professional feedback, founder observation, analytics, interview, crash report, or operational necessity). |
| **Activation** | After the First Meetup, when the founder needs to consolidate feedback from multiple testers into a single visible stream — specifically when duplicate reports become frequent enough that a shared view reduces friction. |
| **Status** | Design note. Not a separate engine — a `feedback` conversation type on the existing Conversation Engine. |
| **Principle** | *Feedback should be visible, not siloed. Every tester should see what others have reported before reporting it themselves. Every feature should be traceable to the evidence that justified it.* |
| **Note** | This is the **human-powered precursor** to the dormant Feedback Intelligence Engine. In Alpha, all triage is manual (founder reads, classifies, updates status). The Feedback Intelligence Engine later automates this pipeline. **Constraints:** exactly one shared feedback conversation, no direct messaging between users, no community features (roles, channels, reactions, mentions, threads), founder-controlled status updates. Each feedback item is a post with threaded replies (like GitHub Issues, not WhatsApp chat). Status lifecycle: New → Accepted → Planned → In Progress → Released → Closed. Status updates notify all affected professionals via their private Yugrow conversation. Feedback items render as structured cards, not chat bubbles — showing title, reporter, status, affected count, and replies. **Future vision:** AI groups duplicates, suggests priority, drafts user story. Same workflow, only faster. **Not a feature — a product learning system.** The user-facing name should be collaborative, not transactional: "Build Yugrow Together" or "Help Improve Yugrow" rather than "Feedback Stream." The internal conversation type remains `feedback`. **Three relationship model:** (1) Person ↔ Person (events → private conversations), (2) Yugrow ↔ Person (system conversations), (3) Everyone ↔ Product (feedback stream). The third relationship is what most products miss. The conversation type is `feedback` — distinct from `private` (one-to-one) and `system` (Yugrow ↔ professional). **Implementation plan:** `docs/sprints/SPRINT-E-FEEDBACK-STREAM.md` — dormant until activation condition met. See also: Conversation Engine (existing), Feedback Intelligence Engine (dormant), FD-032 (System Conversations). |
