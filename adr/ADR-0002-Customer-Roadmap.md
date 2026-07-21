---
Title: Customer Roadmap — Agencies First
Number: ADR-0002
Status: Accepted
Date: 2026-07-16
Owner: Chief Architect
Dependencies:
  - YUGROW-CONSTITUTION.md
Related Documents:
  - adr/ADR-0001-Platform-Architecture.md
  - docs/00-Product-Charter/11-Roadmap.md
---

# ADR-0002: Customer Roadmap

## Decision

Yugrow will target customer segments in the following sequence, not simultaneously:

```
Year 1 → Digital Agencies
Year 2 → SMEs
Year 3 → Mid Market
Year 4 → Enterprise
Year 5 → Governments
```

Enterprise is deliberately last.

## Context

Most startups fail by trying to build for "everyone" or by targeting enterprise customers too early. Enterprise sales cycles (12–18 months), compliance requirements, and integration expectations make them unsuitable as an initial customer segment.

Digital agencies are the ideal first customer because they:
- Need almost everything Yugrow builds (CRM, websites, marketing, invoices, projects, automation, AI)
- Have moderate compliance requirements
- Make decisions quickly
- Are willing to try new platforms
- Provide rich feedback that improves the product for downstream segments

## Options Considered

| Option | Pros | Cons |
|--------|------|------|
| **Agencies first** (chosen) | Fast feedback, aligned needs, quick decisions | Smaller revenue per customer |
| SMEs first | Larger addressable market | Broader requirements, harder to focus |
| Enterprise first | High revenue per customer | 12–18 month sales cycles, complex compliance |
| Everyone simultaneously | Maximum TAM | Guaranteed lack of focus, likely failure |

## Chosen: Agencies → SMEs → Mid Market → Enterprise → Governments

This sequence ensures:
- Each segment prepares the product for the next
- Learnings from agencies simplify SME onboarding
- SME scale proves reliability for mid market
- Mid market case studies open enterprise doors

## Consequences

- Positive: Clear product priorities at every stage
- Positive: Marketing and sales can be focused on one segment at a time
- Positive: Platform matures naturally with each segment
- Risk: May miss enterprise-specific requirements early
- Mitigation: Principle 10 (Enterprise First) ensures architecture supports enterprise scale even while targeting agencies
