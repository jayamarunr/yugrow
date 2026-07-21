---
Title: Phase 1 Implementation — Platform Core First
Number: ADR-0005
Status: Accepted
Date: 2026-07-22
Owner: Chief Architect
Dependencies:
  - adr/ADR-0004-Engine-Based-Architecture.md
  - engineering/DEFINITION-OF-DONE.md
Related Documents:
  - Volume-2-Architecture/ENGINE-SPECIFICATIONS.md
  - Volume-2-Architecture/PRODUCT-SPECIFICATIONS.md
---

# ADR-0005: Phase 1 Implementation Order

## Decision

Phase 1 implementation follows the **Platform Core First** strategy:

### Sprint 1 — Platform Core
1. Identity Engine (Authentik/OIDC, JWT, RBAC, sessions)
2. Organization Engine (tenant hierarchy, memberships)
3. Platform SDK (EventBus, AI SDK, Storage SDK, Notification SDK, Config, Feature Flags, Audit)
4. AI Gateway (multi-provider: OpenAI, Claude, Gemini, DeepSeek, Ollama)
5. Event Bus (platform event infrastructure)
6. Audit Engine (immutable audit store)
7. File Platform (S3-compatible storage)
8. Search Platform (universal hybrid search)

### Sprint 2 — Core Engines
1. Relationship Engine

### Sprint 3
2. Opportunity Engine

### Sprint 4
3. Communication Engine

### Sprint 5
4. Trust Engine

### Sprint 6+ — Products
1. Yugrow Content (first product — showcases AI Gateway + Publish)
2. Yugrow Sites
3. Yugrow CRM
4. Yugrow CheckIN
5. Yugrow Broadcast
6. Yugrow Finance, HR, Marketing

## Context

The architecture documents (ADR-0004, Enterprise Architecture v2.0) define 13 engines and 9 products. A build order is needed to sequence implementation for maximum reuse and minimum rework.

## Rationale

| Decision | Why |
|----------|-----|
| **Platform before products** | Every product shares Identity, Organization, AI, Event Bus, and Audit. Building these first prevents rework. |
| **Identity first** | Everything depends on auth. No engine or product works without it. |
| **Organization second** | Multi-tenancy is required by every subsequent engine. |
| **Relationship before Opportunity** | Opportunity Engine broadcasts through the relationship graph. |
| **Trust after Opportunity** | Trust verification is a downstream step in the opportunity lifecycle. |
| **Content as first product** | Showcases AI Gateway + Publish Service. Solves an immediate customer pain point. Independent of CRM. |

## Consequences

- Positive: Foundation engines are solid before any product is built
- Positive: Each sprint produces a deployable, testable module
- Positive: AI Gateway can be validated with Content product before CRM complexity
- Risk: Products take longer to reach the market
- Mitigation: Content product (Sprint 6) delivers immediate customer value while demonstrating the platform
- Risk: Requirements may shift during platform build
- Mitigation: Architecture documents are treated as living; ADRs capture changes

## Engine Module Structure

Every engine follows the standard structure defined in `apps/api/src/modules/ENGINE-TEMPLATE.md`:

```
{engine}/
  {engine}.module.ts
  {engine}.controller.ts
  {engine}.service.ts
  dto/
  entities/
  interfaces/
  guards/
  events/
  capabilities/
  test/
  README.md
```

## Definition of Done

All engines and products must pass the Definition of Done checklist defined in `engineering/DEFINITION-OF-DONE.md` before being considered complete.
