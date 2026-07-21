---
Title: Definition of Done — Engines & Products
Version: 1.0
Status: Ratified
Owner: Chief Architect
Last Updated: 2026-07-22
Effective: Immediately
---

# Definition of Done

> **Every engine, every product, every feature must meet this definition before it is considered complete. No exceptions.**

---

## Engine DoD

An engine is only considered complete when all of the following are satisfied:

### 1. Architecture
- [ ] Engine boundary documented in `Volume-2-Architecture/ENGINE-SPECIFICATIONS.md`
- [ ] Data model reviewed and approved
- [ ] Cross-engine dependencies documented
- [ ] ADR created for any significant architectural decisions

### 2. API Contract
- [ ] All endpoints documented (OpenAPI/Swagger)
- [ ] Request/response schemas defined
- [ ] Error codes documented
- [ ] Versioning strategy applied
- [ ] Rate limits configured

### 3. Database
- [ ] Prisma schema written and reviewed
- [ ] Migration created and tested
- [ ] Indexes defined for query patterns
- [ ] Soft deletes implemented
- [ ] orgId present on all tenant-scoped tables
- [ ] Audit fields (createdAt, updatedAt, deletedAt) on all tables

### 4. Domain Logic
- [ ] Service layer implements all business rules
- [ ] Validation on all inputs
- [ ] Authorization checks on every endpoint
- [ ] Multi-tenant isolation verified (every query scoped by orgId)

### 5. Events
- [ ] All state-change events defined in `EVENT-CATALOG.md`
- [ ] Events follow CloudEvents 1.0 format
- [ ] Events are published for every create/update/delete
- [ ] Idempotent event consumers

### 6. Testing
- [ ] Unit tests for all service methods (80%+ coverage)
- [ ] Integration tests for all API endpoints
- [ ] Auth variants tested (authenticated, unauthenticated, wrong role)
- [ ] Error states tested
- [ ] Edge cases covered

### 7. Documentation
- [ ] README.md with purpose, setup, and usage
- [ ] OpenAPI spec published
- [ ] Key workflows documented
- [ ] Environment variables documented

### 8. Observability
- [ ] Structured logging on all endpoints
- [ ] Prometheus metrics (request count, latency, error rate)
- [ ] Health check endpoint
- [ ] OpenTelemetry tracing spans

### 9. Security
- [ ] Authentication enforced on all protected routes
- [ ] Authorization checked (user has required role/permission)
- [ ] Input validation on all user-facing endpoints
- [ ] No secrets in code (vault-injected)
- [ ] Rate limiting applied
- [ ] CORS configured

### 10. Audit
- [ ] All mutations logged to AuditLog
- [ ] Audit events include orgId, userId, action, resource, details
- [ ] Immutable audit store (append-only)

### 11. Performance
- [ ] Baseline performance test completed
- [ ] N+1 query patterns eliminated
- [ ] Pagination on all list endpoints
- [ ] Caching strategy documented

---

## Product DoD

A product is only considered complete when all of the following are satisfied:

### 1. Product Definition
- [ ] Product documented in `PRODUCT-SPECIFICATIONS.md`
- [ ] Feature Registry defined with SaaS tier mapping
- [ ] Engine dependencies documented
- [ ] Owned vs. consumed boundaries clear

### 2. UI/UX
- [ ] All user flows work end-to-end
- [ ] Responsive design (desktop, tablet, mobile)
- [ ] Loading, empty, error states handled
- [ ] Accessibility review completed

### 3. Integration
- [ ] All engine APIs integrated
- [ ] Feature flags wired to Organization Engine
- [ ] Events published for product-specific actions
- [ ] Publish Service integration (if applicable)

### 4. Quality
- [ ] E2E tests for critical user journeys
- [ ] Performance meets baseline targets
- [ ] Security review completed
- [ ] Documentation written

---

## Feature DoD

A feature is only considered complete when:

- [ ] Feature declared in Product Feature Registry
- [ ] Engine capabilities consumed (not duplicated)
- [ ] API endpoints documented
- [ ] Unit tests written
- [ ] Integration tests written
- [ ] Audit logging added
- [ ] Feature flag wired
- [ ] Security review passed

---

> This Definition of Done applies to every engine, product, and feature built on the Yugrow Platform. Violations must be corrected before code can be merged.
