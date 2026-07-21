---
Title: Yugrow Platform Constitution v1.0
Version: 1.0
Status: Ratified
Owner: Chief Architect
Last Updated: 2026-07-22
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
