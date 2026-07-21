---
Title: Yugrow Engineering Blueprint
Version: 1.0
Status: Draft
Owner: Chief Architect
Classification: Internal — All engineers and AI agents must follow this
Last Updated: 2026-07-16
Dependencies:
  - YUGROW-CONSTITUTION.md
  - Volume-1-Product/PRODUCT-CHARTER.md
  - Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md
Related Documents:
  - Volume-3-Engineering/CODING-STANDARDS.md
  - engineering/sprint-00/SPRINT-00-ENGINEERING-PACK.md
  - agents/ai-code-review-checklist.md
---

# Yugrow Engineering Blueprint

> **The engineering contract for the Yugrow Platform.**
>
> Every line of code, every API, every database migration, every deployment — everything must conform to this blueprint. If there is a conflict, this document takes precedence over implementation details.

---

## Table of Contents

| Part | Title |
|------|-------|
| I | Engineering Philosophy |
| II | Architecture Overview |
| III | Coding Standards |
| IV | API Standards |
| V | Database Standards |
| VI | Testing Standards |
| VII | Security Standards |
| VIII | AI Standards |
| IX | Deployment Standards |
| X | Release Standards |

---

# Part I — Engineering Philosophy

## The 10 Engineering Principles

| # | Principle | Meaning |
|---|-----------|---------|
| 1 | **Every module must be reusable** | Nothing is built for a single feature. Shared concerns live in Yugrow Core. |
| 2 | **Every feature must expose APIs** | No capability is hidden behind a UI. If it exists, it has an API contract. |
| 3 | **Every database change requires a migration** | No raw SQL, no manual schema changes. All changes via Prisma migrations. |
| 4 | **No secrets in source code** | API keys, passwords, tokens — never committed. Environment variables or vault only. |
| 5 | **Everything observable** | Every service emits logs, metrics, and traces. No blind spots. |
| 6 | **Every AI decision must be explainable** | AI outputs are reviewable, overridable, and auditable. No black boxes. |
| 7 | **Everything tested** | Unit tests for logic, integration tests for APIs, E2E for critical paths. No untested code ships. |
| 8 | **Platform before product** | Build shared capabilities before application-specific features. Yugrow Core first. |
| 9 | **Cloud neutral** | No dependency on a single cloud provider. Run on AWS, Azure, GCP, or on-prem. |
| 10 | **Security first** | Authentication, authorization, encryption, audit — built in from the start. |

## Platform Over Product

Yugrow is not a CRM. It is not a website builder. It is not an ERP.

**Yugrow is a platform.** CRM, Books, HR, CheckIN — all are applications *on* the platform. The platform lives longer than any individual application.

This means:
- Shared services (Identity, AI Gateway, Workflow, Notifications, Billing) are built before any application
- Every application consumes platform services rather than reinventing them
- New applications can be built by composing existing platform services

## The Yugrow Engineering Workflow

```
1. Requirements    — What problem are we solving?
2. Architecture    — How does it fit into Yugrow?
3. Database        — What data is required?
4. API             — What contracts are needed?
5. UI/UX           — How should it behave?
6. Security        — What are the risks?
7. Testing         — How will we validate it?
8. Implementation  — Generate code (AI-assisted)
9. Review          — Human review and integration
10. Documentation  — Update architecture and API docs
```

---

# Part II — Architecture Overview

## Architecture Philosophy

**Yugrow is an engine-based platform, not a service-oriented one.**

The fundamental unit of architecture is the **engine** — a business capability with data sovereignty, API contract, event emission, and AI integration. Products are thin orchestration layers that compose engines.

For the full architecture document, see `ENTERPRISE-ARCHITECTURE.md` (v2.0).

## Engine Stack

```
                        YUGROW PLATFORM
================================================================================
 Identity Engine → Organization Engine → Relationship Engine → Trust Engine ⭐
  → Opportunity Engine ⭐⭐⭐ → Communication Engine → Workflow Engine → AI Engine
  → Context Engine (Future)
================================================================================
Products consume these engines (CRM, CheckIN, Finance, HR, Sites, Marketing)
```

## System Context

```
External Users (Business Owners, Employees, Customers, Partners)
       │
       ▼
Yugrow Platform — Engine Layer
       │
       ├── Identity Engine (Auth, Profiles, Sessions)
       ├── Organization Engine (Tenants, Hierarchy, Teams)
       ├── Relationship Engine (Graph, Business Cards, Discovery)
       ├── Trust Engine ⭐ (References, Collaborations, Scores)
       ├── Opportunity Engine ⭐⭐⭐ (Matching, Broadcast, Lifecycle)
       ├── Communication Engine (Chat, Email, WhatsApp, Push)
       ├── Workflow Engine (Automation, Triggers, Actions)
       └── AI Engine (Models, Prompts, Agents, Knowledge)
       │
       ├── Product Layer (Thin orchestration)
       │   ├── CRM (Pipeline, Deals, Forecast)
       │   ├── CheckIN (Events, Networking)
       │   ├── Finance (Accounting, Invoices)
       │   ├── HR (People, Payroll)
       │   ├── Sites (Content, Blog)
       │   └── Marketing (Campaigns, Social)
       │
       └── Marketplace (Future — third-party extensions)
```

## Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| Frontend | Next.js 14 + React 18 + TypeScript | Web application |
| Mobile | Flutter | Mobile application |
| Business Backend | NestJS 10 + TypeScript | Engine APIs |
| AI Backend | FastAPI (Python) | AI Gateway, agents, RAG |
| Database | PostgreSQL 16 | Primary data store |
| ORM | Prisma 5 | Database access and migrations |
| Cache | Redis 7 | Sessions, caching, rate limiting |
| Storage | MinIO (S3-compatible) | File and image storage |
| Messaging | RabbitMQ (start), Kafka (scale) | Async communication |
| Search | PostgreSQL FTS + pgvector | Full-text and vector search |
| Containers | Docker | Local development |
| Orchestration | Kubernetes | Production |
| CI/CD | GitHub Actions | Automated pipeline |
| IaC | Terraform | Infrastructure provisioning |
| Observability | OpenTelemetry + Prometheus + Grafana + Loki | Monitoring |

## Architecture Pattern: Engine-Based Modular Monolith

| Phase | Pattern | Rationale |
|-------|---------|-----------|
| MVP — Phase 2 | Engine-Based Modular Monolith | Each engine is a domain module. Clear boundaries, fast development, single deploy. |
| Phase 3+ | Extracted Engine Services | Extract high-load engines (AI Engine, Opportunity Engine) as independent services. |

Each engine has clear domain boundaries defined by its API. Extraction is a deployment change, not a code rewrite.

## Full Architecture Reference

See `Volume-2-Architecture/` for the complete architecture library:

| Document | Contents |
|----------|----------|
| `ENTERPRISE-ARCHITECTURE.md` (v2.0) | Engine architecture, platform principles, 20 parts |
| `ENGINE-SPECIFICATIONS.md` | Full specifications for all 9 engines |
| `DOMAIN-MODEL.md` | Authoritative entity definitions |
| `EVENT-CATALOG.md` | All events, payloads, and cross-engine flows |
| `PRODUCT-SPECIFICATIONS.md` | How products consume engines |
| `DATA-OWNERSHIP-RULES.md` | Data sovereignty and access rules |
| `AI-ARCHITECTURE.md` | AI Gateway, models, prompts, agents, RAG |
| `SECURITY-PRIVACY-MODEL.md` | Auth, encryption, compliance, privacy |
| `ENGINEERING-BLUEPRINT.md` | This document — coding standards, API standards, testing |

---

# Part III — Coding Standards

## Language: TypeScript (Strict Mode)

| Rule | Standard |
|------|----------|
| Strict mode | Enabled in all packages |
| Return types | Explicit on all public functions |
| `any` | Forbidden — use `unknown` and narrow |
| Interfaces | Prefer over `type` for object shapes |
| Null safety | Optional chaining (`?.`) and nullish coalescing (`??`) |
| Immutability | `Readonly` on params and properties that shouldn't mutate |

## Framework: NestJS

### Module Structure
```
module/
  module.controller.ts    — HTTP endpoints only (no business logic)
  module.service.ts       — Business logic
  module.module.ts        — NestJS module definition
  dto/                    — Validation DTOs
  entities/               — Prisma entity types
  interfaces/             — TypeScript interfaces
  guards/                 — Auth/permission guards
  decorators/             — Custom decorators
  test/                   — Unit and integration tests
```

### Conventions
- Controllers handle HTTP concerns only
- Services contain all business logic
- No direct database access in controllers
- Typed exceptions for all error states
- Async/await over raw promises

## Framework: Next.js

### Component Types
- **Server Components** — default (data fetching, static content)
- **Client Components** — only when interactivity is needed (`'use client'`)

### Styling
- Tailwind CSS — no CSS modules or styled-components
- Shadcn/ui for primitive components (Button, Input, Card, etc.)
- Design tokens in Tailwind config

## Naming Conventions

| Artifact | Convention | Example |
|----------|-----------|---------|
| Packages | kebab-case | `crm-service` |
| Classes | PascalCase | `class ContactService` |
| Functions | camelCase | `function getContacts()` |
| Files (code) | kebab-case | `contact-service.ts` |
| Files (components) | PascalCase | `ContactCard.tsx` |
| Database tables | snake_case | `contact_activities` |
| API routes | kebab-case | `GET /api/v1/contacts` |
| Git branches | type/description | `feat/add-crm-pipeline` |

## Full Standards Reference

See `Volume-3-Engineering/CODING-STANDARDS.md` for:
- Monorepo structure
- Complete TypeScript standards
- NestJS backend standards
- Next.js frontend standards
- Error handling patterns
- Logging standards
- Git conventions (Conventional Commits, PR checklist)

---

# Part IV — API Standards

## REST Conventions

| Method | Path | Action |
|--------|------|--------|
| GET | `/api/v1/resources` | List |
| GET | `/api/v1/resources/:id` | Get by ID |
| POST | `/api/v1/resources` | Create |
| PATCH | `/api/v1/resources/:id` | Update |
| DELETE | `/api/v1/resources/:id` | Delete |

## Response Format

```json
// Success
{ "data": { ... }, "meta": { "total": 100, "page": 1, "pageSize": 20 } }

// Error
{ "error": { "code": "VALIDATION_ERROR", "message": "...", "details": [...] } }
```

## HTTP Status Codes

| Code | Usage |
|------|-------|
| 200 | Success |
| 201 | Created |
| 400 | Validation error |
| 401 | Unauthenticated |
| 403 | Unauthorized (wrong role) |
| 404 | Not found |
| 409 | Conflict (duplicate) |
| 422 | Unprocessable entity |
| 429 | Rate limited |
| 500 | Internal server error |

## Pagination

- **Cursor-based** for real-time lists: `?cursor=abc&limit=20`
- **Offset-based** for admin tables: `?page=1&pageSize=20`

## Authentication

`Authorization: Bearer <jwt_token>`

Rate limiting: 100 req/min per tenant (Redis-backed).

---

# Part V — Database Standards

## Prisma Schema Conventions

```prisma
model Example {
  id        String   @id @default(uuid())
  orgId     String
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  deletedAt DateTime?

  @@index([orgId])
}
```

| Rule | Standard |
|------|----------|
| Primary keys | UUID (never auto-increment) |
| Tenant isolation | `orgId` on every table |
| Timestamps | `createdAt`, `updatedAt` on every table |
| Soft deletes | `deletedAt` — never hard delete |
| Flexible attributes | `Json?` with `@default("{}")` |
| Indexes | All foreign keys, frequently queried columns |
| Migrations | Prisma migrations only — no raw SQL changes |

## Multi-Tenancy

- All queries scoped by `orgId`
- Tenant context injected via JWT middleware
- No query without a tenant filter

---

# Part VI — Testing Standards

## Testing Pyramid

```
     ╱╲
    ╱ E2E ╲           Playwright (critical journeys)
   ╱───────╲
  ╱Integration╲       Jest + Supertest (API endpoints)
 ╱─────────────╲
╱   Unit Tests   ╲    Jest (services, utilities)
╱─────────────────╲
```

## Coverage Targets

| Type | Target |
|------|--------|
| Unit | 80%+ |
| Integration | 70%+ |
| E2E | All critical paths |

## Test Conventions

- Tests co-located with source files: `contact.service.spec.ts`
- Unit tests: all public methods, edge cases
- Integration tests: every API endpoint, auth variants, error states
- E2E: login → create resource → verify → delete

---

# Part VII — Security Standards

| Control | Standard |
|---------|----------|
| Authentication | JWT (short-lived access + refresh rotation); MFA TOTP |
| Authorization | RBAC — Admin, Manager, Member, Viewer |
| Input validation | Class-validator DTOs on all endpoints |
| Rate limiting | Redis-backed, per-tenant, 100 req/min |
| CORS | Restricted to known origins |
| Headers | Helmet — CSP, HSTS, X-Frame-Options, XSS protection |
| Encryption at rest | AES-256 |
| Encryption in transit | TLS 1.3 |
| Secrets | Environment variables or vault — never in code |
| Audit | Immutable log of all mutations |
| OWASP | Top 10 protection on all code |

## Security Review Checklist (Every PR)

- [ ] Input validation on all user-facing endpoints
- [ ] Authentication enforced on protected routes
- [ ] Authorization checked (user has permission)
- [ ] No SQL injection (parameterized queries via Prisma)
- [ ] No XSS (output encoding, CSP headers)
- [ ] No hardcoded secrets
- [ ] Multi-tenant isolation verified
- [ ] Rate limiting applied

---

# Part VIII — AI Standards

## AI-Native by Design

AI is the primary experience. Every feature asks: *"Can AI make this better?"*

## AI Principles

| Principle | Implementation |
|-----------|---------------|
| Multi-provider | OpenAI, Anthropic, DeepSeek, Gemini — route by cost/latency/capability |
| Explainable | All AI outputs are reviewable, overridable, and auditable |
| Cost-controlled | Token tracking per tenant; usage-based billing |
| Cached | Response caching for identical prompts |
| Guarded | Content filtering, PII detection, bias checks |
| Fallback | Automatic retry with alternative model on failure |

## AI Gateway Architecture

```
Client → AI Gateway → Model Router → Provider (OpenAI/Anthropic/etc.)
                ↓
          Token Tracker → Billing Service
                ↓
          Cache (Redis) → Repeated prompts skip inference
```

---

# Part IX — Deployment Standards

## Environment Pipeline

```
Dev → Test/QA → UAT → Production
```

| Environment | Configuration |
|-------------|---------------|
| Development | Docker Compose, local DB, hot-reload |
| Test/QA | K8s namespace, test data, automated tests |
| UAT | Production-like, staging config, release validation |
| Production | Multi-zone K8s, HA, DR-ready, monitoring |

## CI/CD Pipeline

```
Push/PR → Lint → Test → Build → Docker Image → Deploy to Staging → (manual) → Production
```

## Infrastructure as Code

All infrastructure defined in Terraform. No manual server configuration.

---

# Part X — Release Standards

## Versioning

Semantic versioning: `MAJOR.MINOR.PATCH`

| Bump | When |
|------|------|
| MAJOR | Breaking API or database changes |
| MINOR | New features, backward compatible |
| PATCH | Bug fixes, no API changes |

## Release Process

```
1. Feature complete on develop branch
2. Create release branch: release/vX.Y.Z
3. Run full test suite
4. Deploy to UAT
5. QA validation
6. Deploy to Production
7. Tag release in Git
8. Merge to main
```

## Definition of Done (Every Feature)

- [ ] Functional requirements met
- [ ] Unit tests passing
- [ ] Integration tests passing
- [ ] Security review completed
- [ ] Logging and metrics included
- [ ] API documented
- [ ] UI accessible (where applicable)
- [ ] Documentation updated
- [ ] Code reviewed
- [ ] Deployable to Dev environment

---

## Document References

| For details on | See |
|----------------|-----|
| Platform services, domain model, multi-tenancy | `Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md` |
| Full coding standards, Git conventions | `Volume-3-Engineering/CODING-STANDARDS.md` |
| Sprint 0 tasks, Docker Compose, local setup | `engineering/sprint-00/SPRINT-00-ENGINEERING-PACK.md` |
| AI agent playbooks, prompt templates | `agents/` (9 agent playbooks) |
| AI pre-coding checklist | `agents/ai-code-review-checklist.md` |
| Product strategy, MVP scope, edition strategy | `Volume-1-Product/PRODUCT-CHARTER.md` |
| Company principles, decision framework | `YUGROW-CONSTITUTION.md` |

---

> **This blueprint is the engineering contract for Yugrow. Every AI agent, every developer, every contributor — reads this first and follows it.**
