---
Title: Yugrow Platform Constitution v1.1
Version: 1.1
Status: Ratified
Owner: Chief Architect
Last Updated: 2026-07-23
Classification: SUPREME — Overrides all other documents
Effective: Immediately
Amendments: Recorded as ADRs with label CONSTITUTION-AMENDMENT
---

# ⚖️ Yugrow Platform Constitution v1.0

> **The supreme governing document of the Yugrow Platform.**
>
> Every line of code, every API, every database migration, every AI agent output, every pull request — everything must conform to this constitution. If there is a conflict between this document and any other document, **this document prevails**.
>
> This constitution is implementation-independent and designed to govern a platform expected to evolve over the next 10 years.

---

## Preamble

Yugrow is an **AI-powered Business Operating System** built on reusable platform engines and modular products. It is not a CRM, not a website builder, not an HR platform — it is a platform upon which those products happen to exist.

The Yugrow Platform is being built to last decades, not months. Every architectural decision made today will either enable or constrain the platform's evolution for years to come. This constitution exists to ensure that short-term convenience never sacrifices long-term architectural integrity.

**Three flagship products define Yugrow's market identity:**
1. **Yugrow Content** — Create once, publish everywhere. A Content Operating System.
2. **Yugrow CRM** — Business management, pipeline, deals, forecast.
3. **Yugrow Broadcast** — Opportunity distribution through multi-level geographic broadcast.

---

# Part 0 — Knowledge Model

> **Yugrow records facts, not interpretations.**

This part defines the philosophical foundation of the platform — what Yugrow is allowed to know, what it is allowed to remember, and what boundaries no feature may cross. These principles predate and govern all other parts of this constitution.

---

## 0.1 Design Axiom

> **Yugrow never invents professional relationships. It only reveals opportunities and records what people choose.**

This single sentence constrains every present and future feature of the platform:

- AI recommendations may **suggest** connections but never **create** them
- Ranking algorithms may **surface** people but never **introduce** them
- The Opportunity Engine may **detect** alignment but never **fabricate** it
- The Broadcast Engine may **distribute** opportunities but never **presume** interest
- Future features (recruiter tools, CRM automation, AI introductions) must all pass the same test: *Does this invent a relationship or reveal one?*

**Violation:** Any feature that creates a connection, relationship, or introduction without an explicit human decision to connect. This is a constitutional defect and must be rejected before merge.

### Companion Principle — Evidence-Based Opportunity

> **Professional opportunity is always evidence-based and participation is always voluntary.**

This principle extends the Design Axiom from relationships to the entire opportunity layer. It governs how Yugrow decides who is eligible for discovery, regardless of the evidence source.

A professional opportunity exists when Yugrow has enough evidence that a person legitimately belongs in a professional context — and that person has voluntarily chosen to be discoverable within it.

| Evidence source | How it's gathered | How voluntary opt-in works |
|----------------|-------------------|---------------------------|
| Physical presence | Check-in at venue | "I'm Here" tap |
| Event attendance | Ticket purchase + session join | "Join Networking" tap |
| Workshop participation | Verified attendance | Host-issued networking session |
| Online session | Host-opened networking window | Explicit opt-in to network |
| Future sources | (TBD) | Always requires conscious action |

The specific evidence mechanism may change. The two constraints — **evidence** and **voluntary participation** — never do.

**Violation:** Any feature that makes a person discoverable without both sufficient evidence of their participation in a professional context *and* their explicit, conscious decision to be visible. This includes automatic visibility after joining a session, background presence detection, and any future mechanism that bypasses the voluntary opt-in.

---

## 0.2 The Three-Layer Model

Yugrow interprets reality through three distinct layers. Every object, every signal, every feature belongs to exactly one layer.

```
Reality
   ↓
Interpretation
   ↓
Experience
```

### Layer 1 — Reality

Things that exist without Yugrow. These are independent of the platform.

```
Person
Workspace
Venue
Event
Presence (physical attendance)
```

Yugrow does not create these. It observes and records them.

### Layer 2 — Interpretation

Things Yugrow derives from Reality. These are Yugrow's model of the world.

```
Presence Session    ← recorded from Presence
Opportunity         ← detected from alignment
Relationship        ← created by mutual consent
Conversation        ← enabled by Relationship
Trust Evidence      ← accumulated from interaction
```

Interpretation is always a **model**, never a fact. It is the platform's best understanding of what happened — grounded in Reality but distinct from it.

### Layer 3 — Experience

What users actually see and interact with. These are the products and interfaces that surface Interpretation to humans.

```
Events (tab)
Live (tab)
Network (tab)
Profile
Founder Console
```

Experience changes frequently. Interpretation changes rarely. Reality never changes.

**Design rule:** A UI redesign should never require changing the Interpretation layer. Adding a new product should never require changing the Reality model.

---

## 0.3 Domain Invariants

These are architectural laws that must **never** be violated. They are not implementation details — they are truths about the domain that the platform must preserve under all circumstances.

```
Invariant 1

Presence cannot exist without a Person.

Invariant 2

Presence Sessions are immutable.
Once recorded, they never change.

Invariant 3

Opportunities never create Relationships automatically.
A human decision is required for every connection.

Invariant 4

Relationships never disappear because an Event disappears.
Deleting an Event never cascades to Relationships.

Invariant 5

Trust Evidence can be added but never rewritten.
It is append-only by design.
```

**Why these matter:** Invariants protect the platform from well-intentioned optimizations that would silently corrupt domain integrity. A future engineer may propose "cleaning up" old Presence Sessions, "auto-connecting" high-match users, or "cascading" event deletes. The invariants stop them before code is written.

**Enforcement:** Automated tests should verify that no code path violates any invariant. Any PR that would violate an invariant must be rejected regardless of its other merits.

---

## 0.4 Professional Context

> **Yugrow is not a people discovery platform. It is a professional context discovery platform. People become visible only because they intentionally participate in a professional context.**

This principle is the platform's safeguard against misuse. It defines what Yugrow is — and what it will never become.

### Definition of a Professional Event

A Professional Event is a temporary gathering created with the explicit purpose of exchanging professional knowledge, opportunities, or business relationships.

**A Professional Event is:**
- A conference, expo, workshop, seminar, or meetup with a business purpose
- A company-hosted event (open house, product launch, office hours)
- A pitch night, demo day, or investor session
- A networking breakfast, lunch, or happy hour organized around an industry or profession
- A community meetup with a professional theme (technology, manufacturing, healthcare, design, etc.)

**A Professional Event is NOT:**
- A personal party, dinner, or hangout
- A dating mixer, singles event, or social meetup with no professional purpose
- A nightlife, entertainment, or recreational gathering
- A casual social gathering (friends, coffee, drinks) without a professional framing
- Any event whose primary purpose is personal, romantic, or social rather than professional

### Why this matters

Every social platform faces the same question: *What prevents misuse?* The common answer is moderation — detecting bad behavior after it happens. Yugrow's answer is **design constraints** — making the intended behavior overwhelmingly more rewarding than unintended behavior through the structure of the platform itself.

**Four constraints that protect professional context:**

**Constraint 1 — Event Types are platform-defined and immutable.** Event creation must require an Event Type selected from a platform-controlled vocabulary. Event Types answer: *"What kind of professional gathering is this?"*

| Type | Purpose |
|------|---------|
| 🤝 Networking Meetup | Open networking among professionals |
| 🎓 Workshop | Hands-on learning session |
| 🎤 Conference | Multi-session knowledge event |
| 🏢 Expo | Exhibition with multiple exhibitors |
| 🚀 Product Launch | New product or service announcement |
| 💼 Hiring Event | Recruitment and career fair |
| 🧠 Seminar | Educational presentation |
| 🎯 Pitch Night | Startup pitches to investors |
| 👥 Community Meetup | Community-driven gathering |
| 🏭 Company Event | Organization-hosted event |

**Properties of Event Types:**
- Controlled by Yugrow. Stored as enum. Never user-created.
- Used for analytics, search/filtering, and recommendations.
- Localizable into every language.
- Change rarely (months to years between additions).
- Social categories never added (Party, Dinner, Hangout, Singles, Coffee, Friends).

**Constraint 2 — Topics are community-defined and evolve continuously.** Events must be tagged with professional Topics. Topics answer: *"What is this event about?"*

Unlike Event Types, Topics are:
- Free-form text entered by the event creator
- Suggested by the platform based on usage frequency
- Created by the community when no existing Topic matches
- Normalized, merged, or deprecated over time by the platform

The platform may suggest, normalize, merge, or deprecate Topics over time, but must never alter the historical meaning of an Event. If someone hosted "AI Meetup" in 2026 and the platform later normalizes AI → Artificial Intelligence, the original event's historical record remains accurate.

**Topic lifecycle:**

```
User creates topic
    ↓
pending — first occurrence
    ↓
verified — used by multiple events
    ↓
deprecated — merged into a canonical topic
```

This is a taxonomy problem, not a moderation problem. Topics evolve with industries. The platform learns from usage without requiring product releases for new vocabulary. Social topics (Dating, Friendship, Nightlife, Fun, Drinks) are never suggested or promoted.

**Constitutional rule:** Event Types are defined by the platform and change rarely. Topics are defined by the community and evolve continuously.

### Ownership Model

| Property | Event Type | Topic |
|----------|------------|-------|
| **Owner** | Platform | Community |
| **Created by** | Platform | Users |
| **Vocabulary** | Controlled, immutable enum | Free-form, evolving |
| **Can rename** | Platform (rarely) | Platform (normalization only) |
| **Can delete** | Never | Never (soft deprecate only) |
| **Can merge** | Never | Yes |
| **Can deprecate** | Never | Yes |
| **Can alias** | Never | Yes |
| **Historical value** | Immutable | Immutable |
| **Analytics** | Primary dimension | Secondary dimension |
| **Lifecycle** | None (permanent) | pending → verified → popular → deprecated/merged |

**Constraint 3 — Professional profiles.** What a user exposes when they join an event: Role, Company, Looking For, Skills, Industry, Projects, Website, LinkedIn. Never: Age, Relationship status, Photo gallery, Hobbies unrelated to profession.

**Constraint 4 — Networking intent.** The primary signal on every profile is *"I'm looking for..."* (Investors, Clients, Partners, Mentors, Hiring, Job, Speaking, Vendors). The interaction is framed by business intent, not personal characteristics.

### Trust Evidence as natural moderation

When misuse does occur (spam events, misleading categories, unwanted connection requests), the existing Trust Evidence system handles it without dedicated moderation infrastructure. Repeated negative signals naturally reduce the user's visibility and credibility within the platform. No AI needed. No moderation team required at launch. Just evidence accumulated over time.

**Violation:** Any feature that would allow a user to create or participate in a non-professional context within Yugrow. This includes free-form Event Types (must be platform-controlled), social-only Event Types, profile fields that expose personal (non-professional) attributes as primary signals, or any design that frames discovery around people rather than professional contexts. Free-form Topics are permitted and encouraged — they are distinct from Event Types per the constitutional rule above.

---

# Part 1 — Vision

## 1.1 Platform Identity

Yugrow is an AI-powered Business Operating System designed to help businesses discover opportunities, build trusted professional relationships, automate business operations, and grow through an intelligent ecosystem of modular products.

## 1.2 Long-Term Principles

| # | Principle | Meaning |
|---|-----------|---------|
| 1 | AI-Native by Design | AI is the primary experience, not an add-on. Every engine has an AI integration point. |
| 2 | Platform Before Product | Reusable engines are built before any product that consumes them. |
| 3 | Business Objects First | The platform revolves around Business Objects, not products. Products are experiences over objects. |
| 4 | Cloud Agnostic | No dependency on a single cloud provider. Run on AWS, Azure, GCP, or on-prem. |
| 5 | Vendor Neutral | AI models, email, SMS, payments — all swappable without code changes. |
| 6 | API First | Every capability is an API before it is a UI. |
| 7 | Event Driven | Async communication for scalability and decoupling. |
| 8 | Human Control | AI outputs are reviewable, overridable, and auditable. Humans always decide. |
| 9 | Security by Design | Built in from the start, not bolted on. |
| 10 | Privacy by Design | Compliance is a product feature, not an afterthought. |
| 11 | Enterprise First | Design for multi-tenancy, auditability, and high availability from day one. |
| 12 | Documentation Before Development | No code until architecture, API contracts, and data models are documented and reviewed. |

## 1.3 The Platform Stack

```
Business Objects
        |
        v
  Business Engines (16 engines)
        |
        v
  Products (Content, Sites, CRM, CheckIN, Broadcast, Finance, HR, Marketing, Engage)
        |
        v
  AI Agents (autonomous assistants operating within permissions)
```

## 1.4 The Two Horizons

> **Yugrow is the professional presence layer for the real world. Events are our first validated source of presence — not our final destination.**

Yugrow has two horizons. Both are governed by the same architecture. The difference is scope.

### Horizon 1 — Verified Presence through Events (Today)

```
Place (Venue)
   │
Event (temporary context)
   │
Presence
   │
Opportunity
   │
Relationship
```

Everything is deterministic. Every connection has context (event + venue + date). This is the MVP being validated.

Events serve as **training wheels** for the presence platform. They solve five foundational problems that ambient presence cannot:

| Problem | How events solve it |
|---------|---------------------|
| **Trust** | People expect networking at events. Nobody wonders why strangers are nearby. |
| **Intent** | Everyone came for business. Not random people with unknown motives. |
| **Density** | 200 professionals inside one building, not spread across a city. Network effects appear immediately. |
| **Safety** | Users intentionally joined an event. No accidental exposure of location or availability. |
| **Validation** | Connections, conversations, follow-ups, and missed networking are measurable in a bounded context. |

### Horizon 2 — Ambient Professional Presence (Future)

```
Place
   │
Presence
   │
Opportunity
```

No event required. Walk into a coworking space, airport lounge, coffee shop, university campus, tech park, or office building — check in, see professionals nearby, discover opportunities.

This was Yugrow's original vision. It was never wrong. It was simply too broad for an MVP. The architecture has always supported it — a Place can host Presence directly, without requiring an Event as an intermediary.

### Relationship Between Horizons

Horizon 2 is a **superset** of Horizon 1. The same Presence Engine, the same Opportunity Lifecycle, the same Relationship Engine. Events become one specialization of Place Context — not the root of the model.

```
Place
 ├── Event (Horizon 1 — structured, scheduled, organized)
 ├── Expo Hall (Horizon 1 — multiple simultaneous gatherings)
 ├── Coworking Space (Horizon 2 — ambient)
 ├── Office Building (Horizon 2 — ambient)
 ├── University Campus (Horizon 2 — ambient)
 ├── Airport Lounge (Horizon 2 — ambient)
 └── Business District (Horizon 2 — future)
```

**Product sequence:** Do not implement Horizon 2 until Horizon 1 is validated. First answer: *Does verified presence at professional events create better professional relationships?* If yes, the architecture is ready to expand. If no, the model needs to evolve before scaling.

**Professional context applies to both horizons.** Whether through Events (Horizon 1) or ambient Places (Horizon 2), the definition of professional context from §0.4 governs every presence source. Expanding to new presence sources does not relax the constraints — it applies them more broadly.

---

# Part 2 — Core Business Objects

Every meaningful entity in Yugrow is a **Business Object**. These form the canonical language of the platform.

## 2.1 Person

| Attribute | Value |
|-----------|-------|
| Owner Engine | Identity Engine |
| Source of Truth | `Person` table |
| Lifecycle | Registered > Active > Suspended > Deactivated (soft delete) |
| Events | `Identity.Person.Registered`, `.LoggedIn`, `.Updated`, `.Deactivated` |

## 2.2 Workspace

| Attribute | Value |
|-----------|-------|
| Owner Engine | Workspace Engine |
| Types | PERSONAL, COMPANY, BRAND, NONPROFIT, COMMUNITY, EVENT, EDUCATIONAL, GOVERNMENT |
| Key Rule | Every action in Yugrow carries a Workspace Context. No action exists outside a workspace. |

## 2.3 Membership

| Attribute | Value |
|-----------|-------|
| Owner Engine | Workspace Engine |
| Types | OWNER, CO_FOUNDER, EMPLOYEE, CONTRACTOR, CONSULTANT, VENDOR, AUDITOR, PARTNER, CUSTOMER, INVESTOR |
| Key Rule | A Person can have multiple Memberships across multiple Workspaces. The active Membership determines context. |

## 2.4 Organization (Business Hierarchy)

| Attribute | Value |
|-----------|-------|
| Owner Engine | Organization Engine |
| Entities | BusinessGroup > LegalEntity > Brand > Branch > Department > Team |
| Key Rule | One Workspace can own multiple Legal Entities (holding company structure). |

## 2.5 Relationship

| Attribute | Value |
|-----------|-------|
| Owner Engine | Relationship Engine |
| Types | Business Partner, Customer, Supplier, Employee, Vendor, Friend, Mentor, Investor, Advisor, Community Member |
| Key Rule | Every connection has context — source, type, strength, tags, notes. |

## 2.6 Trust

| Attribute | Value |
|-----------|-------|
| Owner Engine | Trust Engine |
| Entities | ReferenceRequest, ReferenceResponse, Collaboration, Endorsement, TrustEvidence, TrustScore |
| Key Rule | Trust is built from evidence, not popularity. No public star ratings. |

## 2.7 Opportunity

| Attribute | Value |
|-----------|-------|
| Owner Engine | Opportunity Engine |
| Lifecycle | Draft > Published > Matching > Interest > Evaluation > Deal > Project > Closed |
| Key Rule | Everything is an Opportunity — jobs, suppliers, buyers, investors, distributors, customers, speakers, freelancers, mentors, franchises, manufacturers. One universal model. |

## 2.8 Broadcast

| Attribute | Value |
|-----------|-------|
| Owner Engine | Opportunity Engine (core) / Broadcast product (experience) |
| Key Rule | The Opportunity Engine owns the core model. The Broadcast product owns campaign UX. Other products create opportunities without depending on Broadcast. |

## 2.9 Content

| Attribute | Value |
|-----------|-------|
| Owner Engine | Content Engine (future) |
| Lifecycle | Draft > Review > Approved > Published > Archived |
| Key Rule | Content is created once and published everywhere. |

## 2.10 Website

| Attribute | Value |
|-----------|-------|
| Owner | Yugrow Sites product |
| Key Rule | A Website is a Composition. It renders widgets from other products: Blog Feed (Content), Events (CheckIN), Jobs (Broadcast). |

## 2.11 Conversation / Event / Contact / Deal / Invoice / Payment / Expense / Document / Workflow / AI Agent / Notification / Integration / Domain

Each of these is owned by its respective engine or product. No product owns a private version of a platform Business Object.

---

# Part 3 — Platform Laws (50 Laws)

> These 50 laws are non-negotiable. Every engineer, every AI agent, every pull request must conform.

### Architecture Laws (1-10)

**Law 1: Everything belongs to a Workspace.** No data exists outside a workspace context.

**Law 2: Every request carries Workspace Context.** The active workspace is extracted from the JWT and injected into every request.

**Law 3: Every object has exactly one owner engine.** No Business Object is owned by more than one engine.

**Law 4: Products never access another product's database.** All cross-engine access through APIs or events.

**Law 5: Engine boundaries follow business capability.** If two capabilities share data at the database level, they belong in the same engine.

**Law 6: Every engine exposes a Capability Registry.** Products consume capabilities, not internals.

**Law 7: Every engine has an API contract.** No capability exists without a documented API.

**Law 8: Every engine emits events.** Every state change produces a CloudEvents-compliant event.

**Law 9: Every engine has a health check.** Health endpoints return status, latency, and dependency health.

**Law 10: Engines are independently deployable.** Each engine can be extracted from the monolith without code changes.

### Data Laws (11-20)

**Law 11: Every entity has a UUID primary key.** No auto-increment IDs.

**Law 12: Every table has createdAt, updatedAt, deletedAt.** Soft deletes are universal.

**Law 13: Tenant isolation at every layer.** Gateway (JWT), application (filters), database (RLS).

**Law 14: Cross-tenant access prohibited by default.** Explicit authorization required.

**Law 15: Cached copies have bounded TTL.** Maximum 5 minutes unless approved.

**Law 16: Audit trails are immutable.** Append-only. No engine modifies audit records.

**Law 17: Soft deletes have configurable retention.** Default 90 days.

**Law 18: One source of truth per entity.** No duplication across engines.

**Law 19: Every mutation is audited.** Immutable records with personId, workspaceId, action.

**Law 20: Secrets never appear in code.** Vault-injected at runtime.

### API Laws (21-27)

**Law 21: Every API is versioned.** URL-based. Minimum 6-month deprecation window.

**Law 22: Backward compatible within a version.** Additive only. Breaking changes need new version.

**Law 23: Every API has rate limits.** Per-tenant, per-endpoint.

**Law 24: Every API has a defined error contract.** Consistent format.

**Law 25: REST conventions.** Plural nouns, standard methods, cursor pagination.

**Law 26: Every endpoint checks authorization.** Public endpoints explicitly declared.

**Law 27: APIs documented via OpenAPI.** Schemas, errors, examples.

### Event Laws (28-34)

**Law 28: All events follow CloudEvents 1.0.**

**Law 29: Events are idempotent.** Processing twice = same result.

**Law 30: At-least-once delivery.** Consumers handle duplicates.

**Law 31: Events carry workspaceId.**

**Law 32: Events are versioned.** Breaking changes create new event type.

**Law 33: Dead-letter queues capture failed events.** No silent drops.

**Law 34: Event log is Data Lake seed.** Minimum 7-day retention.

### Security Laws (35-41)

**Law 35: Zero Trust by default.**

**Law 36: Encryption everywhere.** AES-256 at rest, TLS 1.3 in transit.

**Law 37: Least privilege enforced.**

**Law 38: AI never bypasses permissions.**

**Law 39: Multi-tenant isolation verified in every PR.**

**Law 40: Secrets rotated automatically.**

**Law 41: Security reviews mandatory for every PR.**

### AI Laws (42-46)

**Law 42: All AI requests route through AI Gateway.** No direct provider calls.

**Law 43: Prompts are versioned.** A/B testing supported. Rollback enabled.

**Law 44: AI outputs are explainable.** No black boxes.

**Law 45: AI never trains on customer data.** Opt-in consent required.

**Law 46: AI failures never block core workflows.** Graceful degradation.

### Product Laws (47-50)

**Law 47: Every product registers itself.** Routes, menus, widgets, capabilities, feature flags.

**Law 48: Navigation is never hardcoded.** Shell assembles from registered products.

**Law 49: Dashboards are composed from widgets.** No product owns the dashboard.

**Law 50: Every feature has a feature flag.** Enabled per workspace, per plan tier.

### Domain Invariant Laws (51-55)

These laws are non-negotiable truths about the domain. They protect the integrity of the platform's knowledge model (see Part 0). Violations are architectural defects and must be corrected before merge.

**Law 51: Presence cannot exist without a Person.** Every presence record must be anchored to a verified person identity. Anonymous or system-generated presence is prohibited.

**Law 52: Presence Sessions are immutable.** Once a presence session is recorded (start + end), it may never be modified, overwritten, or deleted. Corrections to the underlying presence record do not retroactively change the session.

**Law 53: Opportunities never create Relationships automatically.** No code path may create a relationship (mutual connection) without an explicit human decision from both parties. AI may suggest, rank, and surface, but the act of connecting belongs to people.

**Law 54: Relationships survive Events.** Deleting an event, venue, or presence session must never cascade to delete relationships formed at that event. Relationships outlive the context that created them.

**Law 55: Trust Evidence is append-only.** Once created, trust evidence (endorsements, references, collaboration records) may never be altered or deleted. Additional evidence may be added; existing evidence is permanent.

---

# Part 4 — Product Rules

## 4.1 Product Registration Contract

Every product registers with the Platform Shell:

```typescript
registerProduct({
  id: 'crm',
  name: 'CRM',
  icon: PipelineIcon,
  href: '/crm',
  menuItems: [
    { label: 'Dashboard', href: '/crm', icon: DashboardIcon },
    { label: 'Contacts', href: '/crm/contacts', icon: ContactIcon },
  ],
  capabilities: ['crm.contacts.*', 'crm.pipeline.*', 'crm.deals.*'],
});
```

## 4.2 What Products Register

| Artifact | Required |
|----------|----------|
| Routes (URL paths) | Yes |
| Menu Items (sidebar navigation) | Yes |
| Widgets (dashboard components) | Recommended |
| Capabilities (atomic permissions) | Yes |
| Feature Flags (plan-based licensing) | Yes |
| Events (emit/consume) | Recommended |
| API Contracts (OpenAPI) | Yes |

## 4.3 Product Boundaries

- Products do not own Business Objects — they orchestrate them.
- Products do not own navigation — they register nav items.
- Products do not own dashboards — they register widgets.
- Products do not own permissions — they consume capabilities.
- Products do not own AI — they consume the AI Gateway.

---

# Part 5 — Permission Rules

## 5.1 The 5-Layer Authorization Model

```
Layer 1 - Identity:      Who are you?              (Person, authenticated)
Layer 2 - Workspace:     Where are you working?     (Active workspace)
Layer 3 - Membership:    What's your relationship?  (Owner, Employee, etc.)
Layer 4 - Role:          What's your function?      (CEO, Sales Manager)
Layer 5 - Capability:    What can you do?           (crm.contacts.create)
```

Access is granted only if all five layers pass.

## 5.2 Capability Naming

```
{product}.{resource}.{action}

Examples: crm.contacts.create, content.article.publish, broadcast.send.global
```

## 5.3 ABAC Scoping

Capabilities can be restricted by attributes: branch, brand, department, region, country.

## 5.4 Temporary Grants

Capabilities can be granted temporarily with automatic expiry.

## 5.5 UI Projection

Frontend queries capabilities and renders UI dynamically. No hardcoded role checks.

```
GET /api/v1/permissions/capabilities/{personId}/{workspaceId}
-> ["crm.contacts.create", "crm.pipeline.manage", ...]
```

---

# Part 6 — Event Rules

## 6.1 Naming Convention

`{Engine}.{Entity}.{Action}` (e.g., `Identity.Person.Registered`)

## 6.2 Format (CloudEvents 1.0)

```json
{
  "specversion": "1.0",
  "id": "uuid",
  "source": "/yugrow/engine/{engine-name}",
  "type": "Identity.Person.Registered",
  "time": "2026-07-22T10:00:00Z",
  "data": { "workspaceId": "uuid", "actorId": "uuid", "payload": {} }
}
```

## 6.3 Event Versioning

Breaking changes create new event types. Old types supported for 6 months.

## 6.4 Ownership

Every event has exactly one producer engine. Multiple engines can consume.

## 6.5 Replay & Dead-Letter

7-day retention. Consumers can replay. Failed events (3 retries) go to DLQ.

---

# Part 7 — AI Rules

## 7.1 AI Gateway Only

No direct provider calls. All AI through the AI Gateway.

## 7.2 Prompt Management

Versioned, A/B testable, rollback-capable prompts.

## 7.3 Model Routing

Route by task type, priority, tenant tier, cost constraints.

## 7.4 Token Accounting

Per-tenant metering. Usage-based billing. User-provided API key option.

## 7.5 Human Approval

AI cannot perform destructive actions without human approval.

---

# Part 8 — UX Rules

## 8.1 Workspace-Aware UI

Active workspace always visible. One click to switch.

## 8.2 Dynamic Navigation

Assembled from registered products. No product owns the sidebar.

## 8.3 Progressive Disclosure

Show only what's needed. Complex features revealed progressively.

## 8.4 Accessibility

WCAG 2.1 AA target. Keyboard navigation, screen reader support.

## 8.5 Responsive

Every task works on mobile under 30 seconds.

## 8.6 Light/Dark Themes

Configurable per user and per workspace.

## 8.7 AI-First

AI Assistant accessible from any screen.

---

# Part 9 — Engineering Rules

## 9.1 Domain-Driven Design

Each engine is a bounded context. Ubiquitous language from Part 2.

## 9.2 Clean Architecture

```
API Layer -> Application Layer -> Domain Layer -> Infrastructure Layer
```

Dependencies point inward.

## 9.3 Module Structure

```
{engine}/
  {engine}.module.ts, .controller.ts, .service.ts
  dto/, interfaces/, guards/, events/, capabilities/, test/
  README.md
```

## 9.4 Testing Standards

| Type | Target | Scope |
|------|--------|-------|
| Unit | 80%+ | Service methods, edge cases |
| Integration | 70%+ | API endpoints, auth variants |
| E2E | Critical paths | Login > create > verify > delete |
| Security | Mandatory | Auth bypass, injection, isolation |

## 9.5 Performance

- API p95 < 500ms (excl. AI)
- No N+1 queries
- Pagination on all lists
- Indexed query patterns

---

# Part 10 — Future Compatibility

## 10.1 Adding New Products

Register with Product Registry. Consume engine APIs. Register capabilities. Emit events. No platform modification needed.

## 10.2 Marketplace

Third-party developers build: Plugins, Connectors, Workflows, AI Agents, Themes, Templates, Importers, Exporters. Security review required before publication.

## 10.3 Mobile Strategy

Thin client over engine APIs. Mobile-first: CheckIN, Broadcast, Chat, Contacts, Notifications, Business Card, QR, Voice AI.

## 10.4 Business Agents

Autonomous AI agents operate within existing permission framework. No bypass.

| Agent | Capabilities |
|-------|-------------|
| Sales Agent | crm.contacts.*, crm.deals.*, communication.send |
| Marketing Agent | content.articles.*, website.publish |
| HR Agent | hr.employees.*, workflow.execute |
| Finance Agent | finance.invoices.*, finance.payments.* |
| Relationship Agent | relationship.graph.*, communication.send |

## 10.5 Network Effects

Three compounding network effects:
1. **Relationship Network** - each user adds connections
2. **Opportunity Network** - each opportunity creates matches
3. **Business Network** - each company adds graph nodes

## 10.6 Analytics & BI

Data Lake built from events. Events carry workspaceId for scoped analytics. Customer dashboards use widget registration.

---

## Enforcement

Automated compliance checks:

| Check | Verifies |
|-------|----------|
| Data ownership | No cross-engine DB access |
| Tenant isolation | Every query scoped by workspaceId |
| API standards | REST conventions followed |
| Event format | CloudEvents compliance |
| Authorization | Every endpoint has capability checks |
| Audit | Every mutation has audit logging |
| N+1 prevention | No unbounded relation loading |

Violations are architectural defects. Must be corrected before merge.

---

## Amendment Process

1. Documented proposal (ADR with label CONSTITUTION-AMENDMENT)
2. Chief Architect review
3. Majority approval by engineering leads
4. Updated version with changelog

---

> **This constitution is ratified and effective immediately. It supersedes any conflicting provisions in other documents. Every line of code, every API, every database migration, every AI agent output, every pull request — everything must conform.**
