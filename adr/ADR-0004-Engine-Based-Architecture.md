---
Title: Engine-Based Architecture — Products Consume Engines, Not the Reverse
Number: ADR-0004
Status: Accepted
Date: 2026-07-21
Owner: Chief Architect
Dependencies:
  - adr/ADR-0001-Platform-Architecture.md
  - Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md
Related Documents:
  - Volume-2-Architecture/ENGINE-SPECIFICATIONS.md
  - Volume-2-Architecture/DOMAIN-MODEL.md
  - Volume-2-Architecture/EVENT-CATALOG.md
  - Volume-2-Architecture/PRODUCT-SPECIFICATIONS.md
---

# ADR-0004: Engine-Based Architecture

## Decision

**Yugrow shifts from a service-oriented platform to an engine-based architecture. Products become thin consumers of platform engines. Engines are the center of the platform.**

The platform is defined by eight (soon nine) foundational engines:

```
Identity Engine → Organization Engine → Relationship Engine → Trust Engine
  → Opportunity Engine → Communication Engine → Workflow Engine → AI Engine
  → Context Engine (planned)
```

Products (CRM, CheckIN, Finance, HR) are thin layers that consume these engines. No product owns a fundamental capability — it accesses it through the engine layer.

## Context

The original architecture (ADR-0001) defined a five-layer hierarchy:

```
Yugrow → Yugrow Core → Applications → Independent Products → Marketplace
```

This was correct for its time, but it kept **services** as the organizing unit. Services map to implementation concerns (identity service, notification hub, file storage). They do not map to **business capabilities** that span multiple products.

Three problems emerged with the service-oriented model:

1. **Products still felt like silos.** Each product had its own relationship management, opportunity tracking, and communication logic — duplicating the same patterns.

2. **The "secret sauce" had no home.** Trust — Yugrow's core differentiator — was distributed across services with no single engine owning it.

3. **Opportunities and relationships are foundational, not product-specific.** A relationship created in CheckIN should flow naturally into CRM into Finance. With service-oriented architecture, this requires integration. With engine-based architecture, it is inherent.

## Options Considered

| Option | Pros | Cons |
|--------|------|------|
| **Engine-based architecture** (chosen) | Clear business capability boundaries, products stay thin, trust/relationships/opportunities have natural homes, AI has unified context | Requires rethinking existing service boundaries |
| **Service-oriented (current)** | Already partially documented, easier incremental change | Products still feel siloed, trust has no natural home, integration burden between products remains |
| **Product-centric** | Simplest for customers to understand | Duplication across products, no shared trust/relationship layer, hard to evolve |

## Chosen: Engine-Based Architecture

### The Engine Stack

```
                        YUGROW PLATFORM
================================================================================

                               Identity Engine
                         (Who are you?)

                               Organization Engine
                  (Where do you belong?)

                               Relationship Engine
                  (Who are you connected with?)

                               Trust Engine ⭐
                    (Can people trust you?)

                               Opportunity Engine ⭐⭐⭐
                  (What are you looking for?)

                               Communication Engine
                 (How do people collaborate?)

                               Workflow Engine
               (What should happen automatically?)

                               AI Engine
               (How can AI automate this process?)

                               Context Engine (Future)
               (What is the full story of this relationship?)
================================================================================

Products consume these engines
```

### Engine Properties

Every engine has:

| Property | Definition |
|----------|-----------|
| **Identity** | A clear name and purpose — what business capability it provides |
| **Data Sovereignty** | Owns its data model — no other engine or product directly accesses its tables |
| **API Contract** | Exposes all capabilities through a well-defined API |
| **Events** | Emits events when state changes — other engines react |
| **AI-Native** | Has an AI integration point — AI can read, write, and reason over its data |
| **Product-Agnostic** | No product ships inside an engine — engines are pure capability layers |
| **Composable** | Engines can be used independently or composed for higher-level workflows |

### How Products Consume Engines

| Product | Consumes From | Owns |
|---------|--------------|------|
| **CRM** | Identity, Relationship, Opportunity, Communication, Workflow | Pipeline, Deals, Forecast, Revenue |
| **CheckIN** | Identity, Relationship, Trust, Opportunity | Event attendance, Geofencing, Networking, Discovery |
| **Finance** | Identity, Organization, Workflow | Accounting, Invoices, Taxes, Banking |
| **HR** | Identity, Organization, Trust | Employees, Payroll, Attendance, Performance |
| **Sites** | Identity, AI, Workflow | Pages, Blog, Media, SEO |
| **Marketing** | Identity, Relationship, Opportunity, Communication | Campaigns, Segments, Social, Funnels |

Products become **thin orchestration layers** — they compose engine capabilities into user-facing workflows.

## Consequences

### Positive

- **Trust has a home.** The Trust Engine becomes Yugrow's moat — private professional trust, verified collaborations, reputation without public ratings.
- **Opportunities are universal.** A single opportunity model serves recruiting, sales, procurement, investment, partnerships — every business interaction.
- **Products stay thin.** New products can be built by composing existing engines. Adding a "Freelancer Marketplace" product simply configures the Opportunity Engine with new types.
- **Context is unified.** The Context Engine (planned) ties every engine together — every relationship, opportunity, trust signal, and conversation feeds into a shared understanding.
- **AI has a unified view.** The AI Engine can reason across all engines simultaneously — it understands the full relationship graph, trust network, and opportunity landscape.
- **Integration is inherent.** When CheckIN creates a relationship, it flows into the Relationship Engine. When CRM creates an opportunity, the Trust Engine can verify it. No point-to-point integration needed.

### Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Engine boundaries may be unclear initially | Engine Specifications document defines exact boundaries, data ownership, and API contracts for each engine |
| Performance concerns from multiple engine hops | Engines are deployed as a modular monolith initially (per ADR-0001), and can be extracted as scale demands |
| Over-engineering — building engines before products | Engines are built incrementally — Identity, Organization, and Relationship first (Sprint 1 foundation), then Trust and Opportunity (Sprint 2) |
| Context Engine scope creep | Context Engine is deferred to Phase 2 with clear boundaries — it indexes and correlates, it does not own primary data |

## Engine Implementation Priority

| Priority | Engine | Sprint | Rationale |
|----------|--------|--------|-----------|
| P0 | Identity Engine | Sprint 1 | Everything depends on identity |
| P0 | Organization Engine | Sprint 1 | Multi-tenancy foundation |
| P1 | Relationship Engine | Sprint 1-2 | Core differentiator, enables Trust and Opportunity |
| P1 | Communication Engine | Sprint 2 | Required for opportunity workflows |
| P2 | Trust Engine ⭐ | Sprint 2-3 | Secret sauce, builds on Relationship Engine |
| P2 | Opportunity Engine ⭐⭐⭐ | Sprint 2-3 | Heart of the platform, builds on Trust |
| P3 | Workflow Engine | Sprint 3 | Automation layer |
| P3 | AI Engine | Sprint 3 | AI-native integrations across all engines |
| P4 | Context Engine | Phase 2 | Institutional memory, deferred until engines are stable |

## References

- Full engine specifications: `Volume-2-Architecture/ENGINE-SPECIFICATIONS.md`
- Domain model: `Volume-2-Architecture/DOMAIN-MODEL.md`
- Event catalog: `Volume-2-Architecture/EVENT-CATALOG.md`
- Product specifications: `Volume-2-Architecture/PRODUCT-SPECIFICATIONS.md`
