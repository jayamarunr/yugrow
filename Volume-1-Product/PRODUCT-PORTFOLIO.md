---
Title: Yugrow Product Portfolio
Version: 0.1
Status: Draft
Owner: Chief Product Officer
Last Updated: 2026-07-16
Dependencies:
  - Volume-1-Product/PRODUCT-CHARTER.md
Related Documents:
  - engineering/WP-LOG.md
---

# Yugrow Product Portfolio

> **Yugrow is not a single product — it is a Business Cloud.**
>
> Every product plugs into Yugrow Core. Shared services are built once and reused by every module.
> Philosophy: *Nothing gets built unless it can be reused by another module.*

---

## Portfolio Overview

| Product | Purpose | Phase | Dependencies |
|---------|---------|-------|--------------|
| **Platform Engines** | 13 engines: Identity, Org, Relationship, Trust, Opportunity, Communication, Workflow, AI, Integration, Search, Policy, Recommendation, Context | Foundation | None |
| **Yugrow Content** | Content Operating System — AI-powered content creation with multi-provider support, multi-channel publishing | Phase 1 | Engines |
| **Yugrow Sites** | Website builder — renders content from Yugrow Content, page builder, hosting | Phase 1 | Content, Engines |
| **Yugrow CRM** | Sales pipeline, deal management, forecasting, relationship tracking | Phase 1 | Engines |
| **Yugrow CheckIN** | Event attendance, networking, QR/NFC connection building | Phase 2 | Engines |
| **Yugrow Broadcast** | Multi-level opportunity distribution, geographic expansion, AI audience targeting | Phase 2 | Engines |
| **Yugrow Finance** | Accounting, invoicing, expenses, taxes, banking | Phase 3 | Engines |
| **Yugrow HR** | Employee management, payroll, attendance, performance | Phase 3 | Engines |
| **Yugrow Marketing** | Campaign management, email, social media, audience segmentation | Phase 3 | Engines |
| **Publish Service** | Multi-channel content distribution (platform service, not a product) | Phase 1 | Integration Engine |
| **Yugrow Marketplace** | Apps, plugins, AI agents, templates | Phase 4 | Core |
| **Yugrow Ads** | Advertising engine, business discovery, sponsored listings | Phase 4 | Core, Marketplace |
| **Yugrow AI** | AI Gateway, AI Studio, AI Agents | Cross-platform | Core |

---

## Platform Rule

Every new feature must answer **YES** to at least one of:

- Does it help businesses **acquire** customers?
- Does it help businesses **convert** leads?
- Does it help businesses **operate** more efficiently?
- Does it help businesses **grow**?
- Does it **make the platform stronger** (reusable service, API, or integration)?

If the answer is no, it doesn't belong in Yugrow.

---

## Shared Services (Build Once)

These services live in **Yugrow Core** and are consumed by every product:

| Service | Consumers | What It Prevents |
|---------|-----------|------------------|
| Identity & Auth | All products | Each product having its own login |
| Organizations | All products | Fragmented customer data |
| RBAC Permissions | All products | Each product implementing its own roles |
| AI Gateway | Growth, Operations, Finance, CheckIN, Marketplace | Each product integrating AI separately |
| Notification Hub | All products | Each product building its own email/SMS sender |
| Billing & Subscriptions | All products, Marketplace | Fragmented payment logic |
| Integration Hub | All products, Marketplace | Each product building its own connectors |
| Audit Logs | All products | Inconsistent compliance data |
| Search | All products | Each product building its own search |

---

## Reusability Rule

> **Nothing gets built unless it can be reused by another module.**

**Examples of violations (will not happen):**

| Violation | Correct Approach |
|-----------|-----------------|
| CRM has its own email sender | Yugrow Core has an Email Service |
| CheckIN has its own notifications | Yugrow Core has Notification Hub |
| HR stores employees separately from CRM users | Everyone is a User within an Organization |
| Websites has its own file upload | Yugrow Core has File Storage Service |
| Books has its own report builder | Yugrow Core has Analytics Platform |

## How Products Relate to Work Packages

| Product | Work Package |
|---------|-------------|
| Yugrow Core | WP-000 (Foundation) + WP-001 (Identity) |
| Yugrow Growth | WP-002 (Websites) + WP-003 (CRM) + WP-004 (Automation) |
| Yugrow Operations | WP-005 (Business) |
| Yugrow Finance | WP-005 (Business) |
| CheckIN by Yugrow | WP-006 (Networking) |
| Yugrow Marketplace | WP-007 (Marketplace) |
| Yugrow Ads | WP-008 (Advertising) |
| Yugrow AI | Cross-cutting across all WPs |
