---
Title: Product Specifications — Thin Product Layer
Version: 2.0
Status: Draft
Owner: Chief Architect
Last Updated: 2026-07-22
Dependencies:
  - Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md
  - Volume-2-Architecture/ENGINE-SPECIFICATIONS.md
Related Documents:
  - Volume-1-Product/PRODUCT-CHARTER.md
  - Volume-1-Product/PRODUCT-PORTFOLIO.md
---

# Product Specifications

> **How Yugrow products consume engines. Products are thin orchestration layers — they compose engine capabilities into user-facing workflows.**

---

## Table of Contents

| # | Product/Service |
|---|----------------|
| 1 | **Yugrow Content** (Content OS) |
| 2 | Yugrow Sites |
| 3 | Yugrow CRM |
| 4 | Yugrow CheckIN |
| 5 | Yugrow Broadcast |
| 6 | Yugrow Finance |
| 7 | Yugrow HR |
| 8 | Yugrow Marketing |
| 9 | Yugrow Engage (Ads — Future) |
| — | **Publish** (Platform Service) |

---

## Product Architecture

```
ENGINE LAYER                    PRODUCT LAYER              PUBLISH LAYER
Identity Engine                 Content                     Publish Service
Organization Engine             Sites                       - LinkedIn
Relationship Engine             CRM                         - Facebook
Trust Engine                    CheckIN                     - Instagram
Opportunity Engine              Broadcast                   - X (Twitter)
Communication Engine            Finance                     - Pinterest
Workflow Engine                 HR                          - Email
AI Engine                       Marketing                   - WhatsApp
Integration Engine              Engage (future)             - Webhook
Search Engine                           │
Policy Engine                           ▼
Recommendation Engine            Users interact with
                                 products that compose
                                 engine capabilities
```

**Products:**
- Do not own identity, relationships, trust, or opportunities
- Do own product-specific UI, workflows, and thin orchestration logic

**Publish is a platform service:**
- Not a product, not an engine
- Provides multi-channel content distribution
- Every product can use it (Content, CRM, Broadcast, HR)

---

## Feature Registry

Every product has a **Feature Registry** — declared features that can be enabled/disabled per tenant. Perfect for SaaS licensing, phased rollouts, and enterprise configuration.

Rules:
1. Every feature maps to one or more engine capabilities
2. Features can be enabled/disabled per tenant (plan-based)
3. Features can be enabled/disabled per user role
4. Feature flags are managed through the Organization Engine
5. New features declare their capability dependencies

---

# 1. Yugrow Content (Content OS)

## Purpose
A **Content Operating System** — create content once and publish it everywhere. Not a blog. Not a document editor. An AI-powered platform for content creation, management, and multi-channel distribution.

## Philosophy

> Create once. Publish everywhere.

```
Idea > AI Pipeline > Review > Approve > Publish Service > Website, LinkedIn, Facebook, Instagram, Email, WhatsApp
```

## AI Provider Registry

Users connect their own AI provider API keys and configure which model handles which task:

| Task | Configurable Providers |
|------|----------------------|
| Writing | Claude, GPT, Gemini, DeepSeek, Llama |
| Image Generation | GPT Image, Flux, Ideogram, Stable Diffusion |
| SEO Optimization | Perplexity, GPT, Claude |
| Translation | GPT, Gemini, Claude, DeepSeek |
| Social Rewrite | Gemini, Claude, GPT |

## AI Content Pipeline

Multi-step pipeline where each step can use a different provider:

```
Topic > Research AI > Writer AI > SEO AI > Fact Checker > Grammar > Image Gen > Social Gen > Email Gen > Approve > Publish
```

## Engines Consumed

| Engine | How Content Uses It |
|--------|-------------------|
| AI Engine | Model routing to user's configured providers |
| Workflow Engine | Content pipeline automation, approval workflows |
| Search Engine | Content discovery, SEO analysis |
| Integration Engine | Publish Service connectors |
| Communication Engine | Email newsletter delivery |
| Organization Engine | Team collaboration, content workspaces |
| Identity Engine | User authentication, role-based access |

## Owns

| Feature | Description |
|---------|-------------|
| Content Projects | Planning, calendars, campaigns |
| Articles & Blogs | Rich editor, drafts, versions, history |
| AI Prompts | User-configurable prompt templates per provider |
| Content Calendar | Visual calendar, scheduling, deadlines |
| AI Provider Config | User API key management, provider routing |
| SEO Analysis | Keyword research, readability, meta optimization |
| Asset Library | Images, media, brand assets |
| Version History | Full version history with diffs |
| Analytics | Content performance across all channels |

## Feature Registry

| Feature | Maps To | Tier |
|---------|---------|------|
| AI Content Generation | AI Engine: Chat/Complete | All |
| AI Provider Registry | Content owns: provider config | Growth+ |
| Multi-Provider Pipeline | Content owns: pipeline orchestration | Business+ |
| Content Calendar | Content owns: planning, scheduling | All |
| SEO Analysis | AI Engine: Analyze + Search Engine | Growth+ |
| Version History | Content owns: drafts, versions | Growth+ |
| Asset Library | Content owns: media management | All |
| Team Collaboration | Organization Engine: teams | Business+ |
| Repurpose Content | Content owns: social/email generation | Business+ |

---

# 2. Yugrow Sites

## Purpose
Website building, landing pages, content rendering. Renders content from Yugrow Content — no built-in blogging or content creation.

## Engines Consumed

| Engine | How Sites Uses It |
|--------|------------------|
| Identity Engine | Admin authentication, client portal access |
| Search Engine | Site search, content discovery |

## Owns

| Feature | Description |
|---------|-------------|
| Page Builder | Drag-and-drop builder, templates, themes |
| Content Display | Renders articles from Yugrow Content API |
| Media Library | Images, videos, documents |
| Hosting | Site publishing, custom domains, SSL |

## Feature Registry

| Feature | Maps To | Tier |
|---------|---------|------|
| Page Builder | Sites owns: drag-and-drop builder | All |
| Content Rendering | Sites reads from Content API | All |
| Media Library | Sites owns: images, documents | Growth+ |
| Custom Domain | Sites owns: hosting, SSL | Business+ |
| Site Search | Search Engine: Universal Search | Growth+ |

---

# 3. Yugrow CRM

## Purpose
Sales pipeline, deal management, revenue forecasting, and customer relationship tracking.

## Engines Consumed

| Engine | How CRM Uses It |
|--------|----------------|
| Relationship Engine | Contacts via Relationship Engine API |
| Opportunity Engine | Deals and pipelines on the universal Opportunity model |
| Communication Engine | Email and chat within deal context |
| Workflow Engine | Automated follow-ups, deal stage notifications |
| AI Engine | Lead scoring, deal prediction, email drafting |
| Publish Service | Announcements, personalized email campaigns |
| Identity Engine | User authentication, role-based access |

## Owns

| Feature | Description |
|---------|-------------|
| Pipeline UI | Visual pipeline with drag-and-drop stages |
| Deal Dashboard | Deal list, value tracking, win probability |
| Forecast | Revenue forecasting from pipeline data |
| Reports | Sales performance, conversion rates |
| Pipeline Config | Custom pipeline stages per org |

## Feature Registry

| Feature | Maps To | Tier |
|---------|---------|------|
| Pipeline Management | Opportunity Engine: Create, Lifecycle | All |
| Contact Management | Relationship Engine: Create, Import | Growth+ |
| Deal Tracking | Opportunity Engine: Match, Rank | All |
| Sales Forecast | Opportunity Engine: Aggregation | Business+ |
| Quotations | Opportunity Engine + Finance: Invoice | Business+ |
| AI Lead Scoring | AI Engine: Analyze | Business+ |
| Email Integration | Communication Engine: Send | Growth+ |
| Export Reports | Relationship Engine: Export | Growth+ |

---

# 4. Yugrow CheckIN

## Purpose
Event attendance, geofencing, networking, discovery, and in-person connection building.

## Engines Consumed

| Engine | How CheckIN Uses It |
|--------|-------------------|
| Relationship Engine | Create relationships from events, suggest connections |
| Trust Engine | Event participant trust scores, organizer verification |
| Opportunity Engine | Event-based opportunities |
| Communication Engine | Event notifications, in-event messaging |
| AI Engine | Matchmaking, networking suggestions |
| Identity Engine | User authentication, check-in identity verification |

## Owns

| Feature | Description |
|---------|-------------|
| Event Management | Event creation, registration, ticketing |
| Check-In | QR scanning, geofence verification, attendance tracking |
| Networking UI | In-event people discovery, quick connect, card exchange |
| Discovery | Events near you, recommended events |
| Event Analytics | Attendance metrics, engagement data |

## Feature Registry

| Feature | Maps To | Tier |
|---------|---------|------|
| Event Management | CheckIN owns: events, registration | All |
| QR Check-In | CheckIN owns: QR scanning, geofence | All |
| NFC Tap-to-Connect | CheckIN owns: NFC integration | All |
| Business Card Exchange | Relationship Engine: Business Card Exchange | All |
| Event Networking | Relationship Engine: Suggest, QR Connect | All |
| Event Discovery | CheckIN owns: event recommendations | Growth+ |
| AI Matchmaking | AI Engine: Analyze, Recommend | Business+ |
| Event Analytics | CheckIN owns: attendance metrics | Growth+ |

---

# 5. Yugrow Broadcast

## Purpose
Opportunity distribution through multi-level geographic broadcast. The premium experience for creating, targeting, and analyzing opportunities.

## Broadcast Levels

```
Level 1 - My Connections            (Free)
Level 2 - Trusted Mutual            (Growth)
Level 3 - Nearby (15 km)            (Growth)
Level 4 - City                      (Business)
Level 5 - State                     (Business)
Level 6 - Country                   (Enterprise)
Level 7 - Region                    (Enterprise)
Level 8 - Global                    (Enterprise + fee)
```

## Engines Consumed

| Engine | How Broadcast Uses It |
|--------|----------------------|
| Opportunity Engine | Core opportunity creation, lifecycle, matching |
| Relationship Engine | Audience targeting by relationship level |
| Trust Engine | Audience trust filtering, verified broadcast |
| Communication Engine | Notification delivery to candidates |
| AI Engine | Audience selection, content optimization |
| Policy Engine | Broadcast entitlement checks, geographic gating |
| Recommendation Engine | Audience ranking and targeting |
| Search Engine | Candidate discovery |
| Identity Engine | User authentication, role-based limits |

## Owns

| Feature | Description |
|---------|-------------|
| Broadcast Campaign | Campaign creation, targeting, scheduling |
| Geographic Expansion | Multi-level geographic routing |
| AI Audience Selection | AI chooses top-N most relevant recipients |
| Response Management | Track interest, replies, conversions |
| Broadcast Analytics | Reach, engagement, conversion, ROI |
| Monetization | Per-broadcast pricing, verified broadcast |

## Feature Registry

| Feature | Maps To | Tier |
|---------|---------|------|
| Broadcast to Connections | Opportunity Engine: Broadcast (L1) | Free |
| Broadcast to Mutual | Opportunity Engine: Broadcast (L2) | Growth |
| Broadcast to City | Opportunity Engine: Broadcast (L3-4) | Business |
| Broadcast to Country | Opportunity Engine: Broadcast (L5-6) | Enterprise |
| Broadcast to Global | Opportunity Engine: Broadcast (L7-8) | Enterprise+ |
| AI Audience Selection | AI Engine + Recommend Engine: Rank | Business+ |
| Verified Broadcast | Trust Engine: Verification | Business+ |
| Premium Matching | Recommend Engine + AI Engine | Business+ |

---

# 6. Yugrow Finance

## Purpose
Accounting, invoicing, expenses, taxes, banking, financial reporting.

## Engines Consumed

| Engine | How Finance Uses It |
|--------|-------------------|
| Organization Engine | Legal entities for invoicing, multi-entity accounting |
| Workflow Engine | Invoice approval flows, payment reminders |
| AI Engine | Transaction categorization, expense OCR |
| Communication Engine | Invoice delivery, payment notifications |
| Policy Engine | Approval policies for invoices over thresholds |
| Identity Engine | User authentication, role-based access |

## Owns

| Feature | Description |
|---------|-------------|
| Accounting | Chart of accounts, journal entries, general ledger |
| Invoices | Invoice creation, delivery, payment tracking |
| Expenses | Expense tracking, categorization, approval |
| Banking | Bank account connections, reconciliation |
| Taxes | Tax calculation, GST/VAT reporting, tax filings |
| Financial Reports | P&L, balance sheet, cash flow |

## Feature Registry

| Feature | Maps To | Tier |
|---------|---------|------|
| Accounting Ledger | Finance owns: journal entries | Growth+ |
| Invoice Generation | Finance owns: invoice creation | All |
| Expense Tracking | Finance owns: categorization | Growth+ |
| Bank Reconciliation | Finance owns: connections | Business+ |
| Tax Reporting | Finance owns: GST/VAT | Business+ |
| Invoice Approval | Policy Engine: Approval + Workflow | Business+ |

---

# 7. Yugrow HR

## Purpose
Employee management, payroll, attendance, performance reviews, team management.

## Engines Consumed

| Engine | How HR Uses It |
|--------|---------------|
| Organization Engine | Org hierarchy, departments, teams, reporting lines |
| Trust Engine | Employee trust signals, reference verification |
| Workflow Engine | Onboarding workflows, performance review cycles |
| AI Engine | Resume parsing, candidate matching, insights |
| Identity Engine | Employee accounts, role management |

## Owns

| Feature | Description |
|---------|-------------|
| Employee Records | Employee data, job history, documents |
| Payroll | Salary processing, deductions, payslips |
| Attendance | Time tracking, leave management, shift scheduling |
| Performance | Reviews, goals, feedback, OKRs |
| Onboarding | New hire workflows, document collection |

## Feature Registry

| Feature | Maps To | Tier |
|---------|---------|------|
| Employee Records | HR owns: employee data | Growth+ |
| Payroll Processing | HR owns: salary, deductions | Business+ |
| Time & Attendance | HR owns: tracking, leave | Growth+ |
| Performance Reviews | HR owns: reviews, OKRs | Business+ |
| Onboarding Workflows | Workflow Engine: Automation | Growth+ |
| Candidate Matching | Opportunity Engine: Match + AI: Analyze | Business+ |

---

# 8. Yugrow Marketing

## Purpose
Campaign management, email marketing, social media, audience segmentation, funnel analytics.

## Engines Consumed

| Engine | How Marketing Uses It |
|--------|----------------------|
| Relationship Engine | Contact list management via relationship graph |
| Opportunity Engine | Campaign-to-opportunity tracking |
| Communication Engine | Email campaigns, WhatsApp broadcasts, push |
| Workflow Engine | Campaign automation, drip sequences |
| AI Engine | Content generation, audience segmentation |
| Identity Engine | User authentication, audience identity |

## Owns

| Feature | Description |
|---------|-------------|
| Campaigns | Campaign creation, execution, tracking |
| Email Builder | Drag-and-drop email designer, templates |
| Social Media | Post scheduling, social listening, analytics |
| Audience Segments | Custom audience from relationship data |
| Funnels | Landing page funnels, conversion tracking |
| Analytics | Campaign performance, ROI, attribution |

## Feature Registry

| Feature | Maps To | Tier |
|---------|---------|------|
| Campaign Management | Marketing owns: campaigns | Growth+ |
| Email Builder | Marketing owns: email designer | Growth+ |
| Social Media Scheduling | Marketing owns: social posts | Business+ |
| Audience Segmentation | Relationship Engine + AI: Analyze | Business+ |
| Campaign Analytics | Marketing owns: ROI, attribution | Growth+ |
| AI Content Generation | AI Engine: Generate | Business+ |
| Drip Campaigns | Workflow Engine + Comm Engine | Business+ |

---

# 9. Yugrow Engage (Future)

Planned future product for advertising, sponsored content, and paid promotion within the Yugrow network.

---

## Publish Service (Platform Service)

**Not a product. Not an engine.** A platform service for multi-channel content distribution that every product can consume.

### Channels

| Channel | Protocol | Status |
|---------|----------|--------|
| Website | Yugrow Sites API | Launch |
| LinkedIn | LinkedIn API | Launch |
| Facebook | Graph API | Launch |
| Instagram | Graph API | Launch |
| X (Twitter) | Twitter API | Launch |
| Pinterest | Pinterest API | Phase 2 |
| Email | Communication Engine | Launch |
| WhatsApp | Communication Engine | Launch |
| Webhook | Custom endpoint | Launch |
| WordPress | WordPress REST API | Phase 2 |

### Workflow

```
Product (Content, CRM, Broadcast, HR)
  - Submit content + channel config
Publish Service:
  - Format content for each channel
  - Apply channel-specific transformations
  - Schedule publication
  - Handle retries and rate limits
  - Return delivery status
Analytics: Track performance per channel
```

### Who Uses It

| Product | What It Publishes |
|---------|------------------|
| Yugrow Content | Blog posts, articles, social posts, newsletters |
| Yugrow CRM | Announcements, personalized campaigns |
| Yugrow Broadcast | Opportunities to social channels |
| Yugrow HR | Job postings, employer brand content |
| Yugrow Marketing | Campaign content across channels |

---

## Product Data Flow

```
                    PRODUCT LAYER (Thin orchestration)
    Content  Sites  CRM  CheckIN  Broadcast  Finance  HR  Marketing
         |      |     |       |        |        |     |       |
         +------+-----+-------+--------+--------+-----+-------+
                            |
          +-----------------+-------------------------------+
          |                 |               |               |
     Identity          Relationship       Trust       Communication
     Engine            Engine             Engine       Engine
          |                 |               |               |
     Opportunity        Workflow         AI / Rec       Integration
     Engine             Engine           Engines        Engine
          |                                             |
     Search Engine                                Policy Engine
          |
     Publish Service -> LinkedIn, Facebook, Instagram, Email, Web
```

> Products are thin by design. Any capability that spans multiple products belongs in an engine. Publishing is a platform service available to all products.
