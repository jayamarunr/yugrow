---
Title: Yugrow North Star Metrics
Version: 1.0
Status: Ratified
Owner: Chief Product Officer
Last Updated: 2026-07-22
---

# Yugrow North Star Metrics

> **The metrics that define Yugrow's success. Not vanity metrics — product metrics that drive decision-making.**

---

## North Star

> **Active Opportunities Connected Through Trusted Networks**

Every metric below feeds into this single north star. The north star measures Yugrow's core value: helping businesses discover opportunities, build trusted relationships, and grow.

---

## Platform Metrics

| Metric | Definition | Why It Matters |
|--------|-----------|----------------|
| **Active Workspaces** | Workspaces with activity in the last 30 days | Core adoption measure |
| **Daily Active Users (DAU)** | Unique persons with API activity per day | Engagement baseline |
| **Multi-Product Adoption** | % of workspaces using 2+ products | Platform stickiness |
| **AI Tasks Completed** | AI-generated outputs accepted by users | AI value delivery |
| **Time to First Value** | Time from signup to first meaningful action | Onboarding quality |
| **Net Promoter Score (NPS)** | User satisfaction survey | Product-market fit signal |

## Relationship Metrics

| Metric | Definition | Why It Matters |
|--------|-----------|----------------|
| **New Connections Created** | Relationships established per day/week | Network growth |
| **Connection Request Accept Rate** | % of requests accepted | Network quality |
| **Mutual Connections per User** | Average mutual connections | Network density |
| **Trust Requests Accepted** | Reference responses provided | Trust signal adoption |
| **Introductions Made** | Users introduced through platform | Network effect strength |

## Broadcast / Opportunity Metrics

| Metric | Definition | Why It Matters |
|--------|-----------|----------------|
| **Opportunities Posted** | New opportunities created | Supply-side health |
| **Match Rate** | % of opportunities with at least one match | Matching quality |
| **Response Rate** | % of matches that receive interest | Engagement quality |
| **Time to First Match** | Average time from post to first match | Platform efficiency |
| **Successful Outcomes** | Opportunities that convert to deals/projects | Core value delivery |
| **Broadcast Revenue** | Revenue from paid broadcast tiers | Monetization signal |

## Content Metrics

| Metric | Definition | Why It Matters |
|--------|-----------|----------------|
| **Content Items Created** | Articles, blogs, social posts generated | Creation velocity |
| **AI Acceptance Rate** | % of AI-generated content published without major edits | AI quality signal |
| **Cross-Channel Publishing** | Average channels per content item | Publish adoption |
| **Content Performance** | Views, clicks, conversions per piece | Content value |
| **Scheduled Content** | % published on schedule | Workflow adoption |

## Website Metrics

| Metric | Definition | Why It Matters |
|--------|-----------|----------------|
| **Sites Created** | Websites built | Product adoption |
| **Custom Domains Connected** | Domains pointing to Yugrow sites | Professional adoption |
| **Site Traffic** | Monthly visitors across all sites | Value delivery |
| **Conversion Rate** | Visitor to lead/contact conversion | Business value |

---

## Leading vs. Lagging Indicators

| Type | Examples |
|------|----------|
| **Leading** (predict future success) | DAU, connections created, opportunities posted, AI acceptance rate |
| **Lagging** (confirm past success) | Revenue, NPS, successful outcomes, multi-product adoption |

---

## Metric Targets (Year 1)

| Metric | Target | Timeline |
|--------|--------|----------|
| Active Workspaces | 1,000 | Month 12 |
| DAU | 5,000 | Month 12 |
| Multi-Product Adoption | 40% | Month 12 |
| AI Acceptance Rate | 70% | Month 6 |
| Connection Accept Rate | 60% | Month 6 |
| Broadcast Match Rate | 50% | Month 9 |
| NPS | 40+ | Month 12 |

---

## Instrumentation

Every engine emits events for metrics tracking:

```
Events -> Event Bus -> Metrics Pipeline -> Dashboards
                                              |
                                        +-----+-----+
                                        |           |
                                   Grafana     Product Reviews
```

Each event carries the minimum data needed for metric calculation. No PII in metric events.

---

> These metrics are reviewed monthly. Targets are adjusted as product-market fit evolves.
