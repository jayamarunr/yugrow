---
Title: Yugrow is an AI-Native Business Operating System
Number: ADR-0001
Status: Accepted
Date: 2026-07-16
Owner: Chief Architect
Dependencies:
  - YUGROW-CONSTITUTION.md
Related Documents:
  - adr/ADR-0002-Customer-Roadmap.md
  - docs/00-Product-Charter/00-Decisions.md
---

# ADR-0001: Platform Architecture

## Decision

**Yugrow is an AI-Native Business Operating System — not a CRM, not a collection of apps.**

The platform follows a five-layer hierarchy:

```
Yugrow
  ↓
Yugrow Core (Platform Services)
  ↓
Applications (Business Applications)
  ↓
Independent Products
  ↓
Marketplace
```

## Context

Early discussions described Yugrow as "CRM, websites, marketing, accounting, HR, etc." This framing is misleading and architecturally dangerous. It implies Yugrow is a suite of disconnected modules rather than a single coherent platform.

The wrong framing leads to:
- Duplicate services across applications
- Inconsistent user experience
- Difficulty reasoning about shared capabilities
- Marketing confusion ("is it a CRM or a platform?")

## Options Considered

| Option | Pros | Cons |
|--------|------|------|
| **Platform with applications** (chosen) | Clear separation of concerns, reusable services, scalable | Requires more upfront architectural discipline |
| Suite of apps sharing a database | Faster initial development | Tight coupling, impossible to scale independently |
| Single monolithic app | Simplest to build | Cannot scale team or product |

## Chosen: Platform with Applications

Yugrow Core provides shared platform services. Applications consume these services. Independent products leverage the platform while maintaining their own market identity. A future marketplace will enable third-party extensions.

## Consequences

- Positive: Clear architectural boundaries, reusable capabilities, independent scaling
- Positive: Marketing message becomes coherent — "One platform, intelligent ecosystem"
- Positive: New applications can be built by composing existing platform services
- Risk: Requires discipline to avoid service duplication
- Mitigation: Principle 2 (Platform Before Product) and regular architecture reviews

## Platform Layer Definitions

| Layer | Examples | Owned By |
|-------|----------|----------|
| **Yugrow Core** | Identity, AI Gateway, Workflow, Search, Storage, Billing, Communication, Geo, Analytics | Platform Team |
| **Applications** | CRM, Sites, Marketing, Books, People, Flow, Docs | Product Teams |
| **Independent Products** | CheckIN, Opportunity Network | Product Teams |
| **Marketplace** | Third-party extensions (future) | Ecosystem |
