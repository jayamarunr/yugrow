---
Title: Data Ownership Rules
Version: 1.0
Status: Draft
Owner: Chief Architect
Last Updated: 2026-07-21
Dependencies:
  - Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md
  - Volume-2-Architecture/DOMAIN-MODEL.md
Related Documents:
  - governance/security-policy.md
  - adr/ADR-0001-Platform-Architecture.md
---

# Data Ownership Rules

> **The definitive rules for data ownership, access, and sharing across Yugrow's engine-based architecture. Every byte of data has exactly one owner.**

---

## Table of Contents

| # | Section |
|---|---------|
| 1 | The Cardinal Rule |
| 2 | Engine Data Ownership Matrix |
| 3 | Data Access Patterns |
| 4 | Cross-Engine Data Sharing |
| 5 | Tenant Data Isolation |
| 6 | Data Retention & Deletion |
| 7 | Data Export & Portability |
| 8 | Privacy & Compliance |
| 9 | Audit & Immutability |

---

# 1. The Cardinal Rule

> **Every piece of data in Yugrow has exactly one owner engine. The owning engine is solely responsible for creating, reading, updating, and deleting that data. No other engine or product may access the owning engine's database directly.**

**Violation of this rule is an architectural defect** — not an optimization opportunity.

### What This Means

| Can Do | Cannot Do |
|--------|-----------|
| Read data via owning engine's API | Read directly from another engine's database |
| Subscribe to owning engine's events | Write directly to another engine's tables |
| Cache read data (with TTL) | Bypass API to bulk-export another engine's data |
| Request data transformations | Create duplicate copies of owned data |

---

# 2. Engine Data Ownership Matrix

## Identity Engine

| Owns | Does Not Own |
|------|-------------|
| User records | Business data of any kind |
| Password hashes | Organization structure |
| Authentication sessions | Relationship data |
| MFA secrets | Trust signals |
| API keys | Opportunities |
| Role definitions | Communications |
| Permission assignments | Workflow definitions |
| Login attempts | AI prompts or agents |

## Organization Engine

| Owns | Does Not Own |
|------|-------------|
| Tenant records | User authentication |
| Business groups | User profiles (name, email are in Identity) |
| Legal entities | Relationship data |
| Brands, branches | Opportunities |
| Departments, teams | Communications |
| Memberships | Workflow definitions |
| Subscriptions | AI prompts |
| Tenant settings | Financial transactions |

## Relationship Engine

| Owns | Does Not Own |
|------|-------------|
| Connection graph | Trust signals |
| Relationship types | References or endorsements |
| Relationship context | Communications |
| Business cards | Opportunities |
| Connection requests | User authentication |
| Relationship strength scores | Organization hierarchy |

## Trust Engine

| Owns | Does Not Own |
|------|-------------|
| Reference requests & responses | Relationship data |
| Collaborations | Communications |
| Endorsements | Opportunities |
| Trust evidence | User authentication |
| Trust scores | Organization structure |
| Reputation history | Business card data |
| Verification records | |

## Opportunity Engine

| Owns | Does Not Own |
|------|-------------|
| Opportunities | Contacts (in Relationship Engine) |
| Opportunity types | Communications |
| Broadcast policies | User authentication |
| Opportunity interests | Organization structure |
| AI matches | Trust scores |
| Deals (thin CRM) | Workflow definitions |
| Pipelines (thin CRM) | |
| Opportunity activities | |

## Communication Engine

| Owns | Does Not Own |
|------|-------------|
| Conversations | Relationship data |
| Messages | Opportunities |
| Notifications | Trust signals |
| Notification templates | User authentication |
| Channel configurations | Organization structure |
| Delivery status | |

## Workflow Engine

| Owns | Does Not Own |
|------|-------------|
| Workflow definitions | Any business data |
| Workflow executions | User profiles |
| Execution logs | Relationships |
| Schedule configurations | Opportunities |

## AI Engine

| Owns | Does Not Own |
|------|-------------|
| Prompt templates | Any primary business data |
| AI provider configs | User authentication |
| Agent definitions | Organization structure |
| Knowledge bases & documents | Trust scores (reads via API) |
| Token usage records | |
| Guardrail rules | |
| AI request/response logs | |

---

# 3. Data Access Patterns

## Pattern 1: Engine API (Primary)

```
Product/Engine → Engine API → Engine Database
```

Used for all synchronous data operations. Every engine exposes REST/gRPC APIs for its owned data.

## Pattern 2: Event Subscription

```
Engine A → Event Bus → Engine B (consumer)
```

Used for async data propagation. Engine B receives events from Engine A and can update its own data in response — but never modifies Engine A's data.

## Pattern 3: Cached Read

```
Engine A API → [Cache Layer] → Consumer
```

Reads from an engine API can be cached (Redis, with appropriate TTL). Cache is never the source of truth.

## Pattern 4: Aggregated Query (Context Engine — Future)

```
Consumer → Context Engine API → [Multiple Engine APIs]
```

The Context Engine (future) provides pre-joined, read-only views across engine boundaries. It never stores primary data — only indexes and summaries.

---

# 4. Cross-Engine Data Sharing

## Sharing Rules

| Scenario | Rule |
|----------|------|
| Engine A needs Engine B's data | Call Engine B's API. Never access its database. |
| Engine A needs to react to Engine B's changes | Subscribe to Engine B's events. |
| Product needs data from multiple engines | Call each engine's API separately or use GraphQL federation. |
| AI Engine needs cross-engine context | Call each engine's API. Context Engine (future) provides aggregated views. |
| Report needs data from multiple engines | Use event-sourced analytics store (read-only copies populated via events). |

## Prohibited Patterns

| Pattern | Why It's Prohibited |
|---------|-------------------|
| Direct database access across engines | Breaks encapsulation, creates coupling, makes extraction impossible |
| Shared database between engines | Violates single-owner rule |
| Dual-write (two engines writing same entity) | Creates consistency nightmares |
| Engine A storing a copy of Engine B's data | Creates stale data, ownership confusion |
| Products embedding engine logic | Duplicates capability, creates maintenance burden |

---

# 5. Tenant Data Isolation

## Isolation Model

| Aspect | Approach |
|--------|----------|
| **Strategy** | Row-level tenant isolation (orgId on every tenant-scoped table) |
| **Enforcement** | Database-level RLS (Row-Level Security) + application-level JWT context |
| **Cross-Tenant Access** | Prohibited by default. Explicit API for platform admin (audited). |
| **Tenant Deletion** | Soft delete with configurable retention period (default 90 days) |
| **Data Resurrection** | Possible within retention period. Permanent after retention expiry. |

## Tenant ID Propagation

```
Request → Gateway (extract orgId from JWT)
                ↓
         Engine API (orgId in every query)
                ↓
         Database (orgId in WHERE clause, RLS enforced)
                ↓
         Events (orgId in event payload)
```

---

# 6. Data Retention & Deletion

## Retention by Data Category

| Category | Active Retention | Post-Deletion Retention | Notes |
|----------|-----------------|------------------------|-------|
| User accounts | Until deactivated | 90 days (grace period) | Permanent delete after grace |
| Authentication logs | 1 year | — | Aggregate after 1 year |
| Relationships | Until deleted | 30 days | Soft delete |
| Trust evidence | Indefinite | 90 days | Legal hold capable |
| Opportunities | Until closed | 1 year | Archive after 1 year |
| Communications | Configurable (30d–indefinite) | 30 days | Per-tenant setting |
| Workflow logs | 90 days | — | Aggregate after 90 days |
| AI request logs | 30 days | — | No PII in logs |
| Financial records | Indefinite | Legal retention | Regulatory requirement |

## Deletion Cascade

When a tenant is deleted:

```
1. Organization Engine: Mark tenant as deleted
2. → All engines receive Organization.Tenant.Deactivated
3. Each engine soft-deletes its owned data for that tenant
4. After retention period: Hard delete (or anonymize)
5. Audit logs retained (immutable)
```

---

# 7. Data Export & Portability

## Tenant Data Export

| Format | Scope | Trigger |
|--------|-------|---------|
| JSON | All tenant data | Self-serve in settings |
| CSV | Tabular data (relationships, opportunities) | Self-serve in settings |
| Full export | Complete tenant data | Admin request |
| Scheduled | Automated periodic export | Enterprise plan feature |

## Export Process

```
User requests export
  ↓
Platform initiates parallel reads from each engine API
  ↓
Engine A → Export its owned data
Engine B → Export its owned data
Engine C → Export its owned data
  ↓
Aggregate into tenant data package
  ↓
Notify user when ready (Communication Engine)
  ↓
Download from secure S3 URL (expires in 7 days)
```

---

# 8. Privacy & Compliance

## Regulatory Compliance

| Regulation | Requirements | Engine Responsibilities |
|------------|-------------|------------------------|
| GDPR | Right to access, rectification, erasure, portability | All engines must support data export and deletion by userId |
| DPDP (India) | Consent management, data localization | Identity Engine: consent records; Organization Engine: data residency |
| CCPA | Right to know, delete, opt-out | All engines: personal data tracking |

## PII Classification

| Category | Examples | Handling |
|----------|----------|----------|
| Sensitive PII | Password hashes, MFA secrets, payment info | Encrypted at rest, minimal access, never in logs |
| Standard PII | Name, email, phone, address | Encrypted at rest, scoped access |
| Business Data | Company name, role, skills | Standard encryption |
| Public Data | Profile name, avatar | Default public, user-configurable privacy |

## Privacy by Design Rules

1. **Minimum necessary** — Engines only collect data needed for their function
2. **Consent-based** — Communications engine requires opt-in for each channel
3. **Purpose limitation** — Data used only for the purpose it was collected
4. **Right to deletion** — All engines support per-user hard deletion
5. **No PII in logs** — AI engine strips PII from request/response logs
6. **Privacy as default** — Relationship visibility defaults to private

---

# 9. Audit & Immutability

## Audit Requirements

| Data Type | Audit Requires | Retention |
|-----------|---------------|-----------|
| Authentication events | Who, when, success/failure, IP | 1 year |
| Data mutations | Who, what, before/after, when | 3 years |
| Permission changes | Who changed, what changed, when | 3 years |
| Tenant configuration | Who changed, what changed, when | 3 years |
| AI requests | Who, what model, token count (no PII) | 30 days |
| Financial transactions | Full immutable record | 7 years (legal) |

## Immutable Audit Store

```
Engine → Audit Event → Immutable Log Store (append-only)
                              ↓
                    Query API (read-only)
                              ↓
                    Compliance Reports
```

The audit store is append-only. No engine can modify or delete audit records.

---

> **These data ownership rules are binding on all engine implementations. Violations must be corrected before code can be merged.**
