---
Title: Engine Specifications
Version: 1.0
Status: Draft
Owner: Chief Architect
Last Updated: 2026-07-21
Dependencies:
  - Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md
  - adr/ADR-0004-Engine-Based-Architecture.md
Related Documents:
  - Volume-2-Architecture/DOMAIN-MODEL.md
  - Volume-2-Architecture/EVENT-CATALOG.md
  - Volume-2-Architecture/PRODUCT-SPECIFICATIONS.md
---

# Engine Specifications

> **Complete specifications for every Yugrow engine — identity, data ownership, API contracts, events, and AI integration.**

---

## Table of Contents

| # | Engine |
|---|--------|
| 1 | Identity Engine |
| 2 | Organization Engine |
| 3 | Workspace Engine |
| 4 | Permission Engine |
| 5 | Relationship Engine |
| 6 | Trust Engine ⭐ |
| 7 | Opportunity Engine ⭐⭐⭐ |
| 8 | Communication Engine |
| 9 | Discovery Engine ⭐ |
| 10 | Recommendation Engine ⭐ |
| 11 | Workflow Engine |
| 12 | AI Engine |
| 13 | Integration Engine |
| 14 | Edge Platform |
| 15 | Search Engine |
| 16 | Policy Engine |
| 17 | Context Engine (Future) |
| 18 | Signal Engine (Future) |
| 19 | Intelligence Engine (Future) |

---

## Engine Specification Template

Every engine is specified with the following structure:

```
1. Purpose       — What business capability does this engine provide?
2. Data Model   — What entities does it own?
3. API Contract — What endpoints does it expose?
4. Events       — What events does it emit and consume?
5. AI Integration — How does AI interact with this engine?
6. Dependencies — Which other engines does it depend on?
7. Consumers    — Which products and engines consume it?
```

---

# Engine 1 — Identity Engine

## Purpose

The Identity Engine answers: **Who are you?**

It is the foundation of the entire platform. Every user, every session, every authentication decision flows through this engine. It manages authentication (login, MFA, OAuth/OIDC, SSO), authorization (RBAC/ABAC), user profiles, session management, and security credentials.

## Data Model

| Entity | Description |
|--------|-------------|
| User | Platform user — email, password hash, display name, avatar, status |
| UserProfile | Extended profile — phone, timezone, locale, preferences, privacy settings |
| Role | Named set of permissions — Admin, Manager, Member, Viewer |
| Permission | Granular access right — resource + action + optional conditions |
| RoleAssignment | User-to-role binding scoped to an organization or team |
| Session | Authenticated session — refresh token, device info, expiry |
| APIKey | Programmatic access credential — scoped to specific permissions |
| MFASetting | MFA configuration per user — TOTP secret, backup codes, method |
| LoginAttempt | Authentication event log — success, failure, IP, timestamp |

## API Contract

```
POST   /api/v1/identity/auth/login           — Authenticate (email/password)
POST   /api/v1/identity/auth/oauth           — OAuth/OIDC login
POST   /api/v1/identity/auth/magic-link      — Request magic link
POST   /api/v1/identity/auth/refresh         — Refresh access token
POST   /api/v1/identity/auth/logout          — Invalidate session
POST   /api/v1/identity/auth/mfa/setup       — Configure MFA
POST   /api/v1/identity/auth/mfa/verify      — Verify MFA code
GET    /api/v1/identity/users/me             — Get current user profile
PATCH  /api/v1/identity/users/me             — Update profile
GET    /api/v1/identity/users                — List users (admin)
GET    /api/v1/identity/users/:id            — Get user by ID
POST   /api/v1/identity/users               — Create user (admin)
PATCH  /api/v1/identity/users/:id            — Update user (admin)
DELETE /api/v1/identity/users/:id            — Deactivate user
GET    /api/v1/identity/roles                — List roles
POST   /api/v1/identity/roles               — Create role
PATCH  /api/v1/identity/roles/:id            — Update role
GET    /api/v1/identity/permissions          — List permissions
POST   /api/v1/identity/api-keys             — Create API key
DELETE /api/v1/identity/api-keys/:id         — Revoke API key
```

## Events

**Emits:**
- `Identity.User.Registered` — New user created
- `Identity.User.LoggedIn` — Successful authentication
- `Identity.User.LoggedOut` — Session invalidated
- `Identity.User.Updated` — Profile changed
- `Identity.User.Deactivated` — Account deactivated
- `Identity.Role.Created` — New role defined
- `Identity.Role.Assigned` — Role assigned to user
- `Identity.MFA.Enabled` — MFA configured
- `Identity.Login.Failed` — Failed authentication attempt

**Consumes:**
- `Organization.Tenant.Provisioned` — Create admin user for new tenant

## AI Integration

- Anomaly detection in login patterns (unusual location, device, time)
- Fraud detection for account takeovers
- Duplicate user detection during registration
- Smart role suggestions based on user behavior patterns

## Capability Registry

```
Identity Engine
├── Authenticate (email, password, OAuth, magic link, SSO)
├── Authorize (RBAC, permission checks)
├── Manage MFA (TOTP setup, verify, reset)
├── Manage Sessions (create, refresh, revoke)
├── Manage API Keys (create, scope, revoke)
├── Manage Roles (create, update, assign permissions)
├── User Profile CRUD
├── User Registration
├── Password Reset
├── Deactivate User
└── Anomaly Detection (AI)
```

## Dependencies

- None (foundational engine)

## Consumers

- All engines
- All products (CRM, CheckIN, Finance, HR, Sites, Marketing)

---

# Engine 2 — Organization Engine

## Purpose

The Organization Engine answers: **Where do you belong?**

It manages the multi-tenant hierarchy — from holding companies down to individual teams. It supports complex organizational structures: franchises, agencies, multi-country businesses, and multi-brand companies.

## Data Model

| Entity | Description |
|--------|-------------|
| Tenant | Top-level organization — name, slug, status, settings |
| BusinessGroup | Holding company or parent entity |
| LegalEntity | Legally registered entity — tax ID, registration number, address |
| Brand | Market-facing brand — name, logo, domain, branding config |
| Branch | Physical or operational location — address, timezone, contact |
| Department | Functional division — name, head, parent department |
| Team | Working group — name, lead, members, parent team |
| Membership | User's affiliation with a tenant — role, status, joined date |
| Subscription | Tenant's plan — tier, features, billing cycle, status |
| TenantSetting | Per-tenant configuration — locale, currency, timezone, branding |

## Tenant Hierarchy

```
Tenant
  ↓
Business Group
  ↓
Legal Entity
  ↓
Brand
  ↓
Branch
  ↓
Department
  ↓
Team
```

## API Contract

```
POST   /api/v1/organization/tenants              — Create tenant
GET    /api/v1/organization/tenants/:id           — Get tenant details
PATCH  /api/v1/organization/tenants/:id           — Update tenant
GET    /api/v1/organization/tenants/:id/hierarchy — Get org hierarchy
POST   /api/v1/organization/groups               — Create business group
POST   /api/v1/organization/entities              — Create legal entity
POST   /api/v1/organization/brands               — Create brand
POST   /api/v1/organization/branches              — Create branch
POST   /api/v1/organization/departments           — Create department
POST   /api/v1/organization/teams                 — Create team
GET    /api/v1/organization/teams/:id/members     — List team members
POST   /api/v1/organization/memberships           — Add user to org
PATCH  /api/v1/organization/memberships/:id       — Update membership role
DELETE /api/v1/organization/memberships/:id       — Remove member
GET    /api/v1/organization/subscriptions         — Get subscription details
PATCH  /api/v1/organization/subscriptions/:id     — Update subscription
GET    /api/v1/organization/settings              — Get org settings
PATCH  /api/v1/organization/settings              — Update org settings
```

## Events

**Emits:**
- `Organization.Tenant.Provisioned` — New tenant created
- `Organization.Tenant.Updated` — Tenant settings changed
- `Organization.Tenant.Deactivated` — Tenant suspended/deleted
- `Organization.Member.Invited` — User invited to join
- `Organization.Member.Joined` — User accepted invitation
- `Organization.Member.Removed` — User removed from org
- `Organization.Team.Created` — New team formed
- `Organization.Subscription.Changed` — Plan upgraded/downgraded

**Consumes:**
- `Identity.User.Registered` — Optionally create default org for new user
- `Billing.Subscription.Updated` — Sync subscription changes

## AI Integration

- Org hierarchy suggestions based on industry patterns
- Naming standardization across entities
- Anomaly detection in org structure changes
- Smart team composition recommendations

## Capability Registry

```
Organization Engine
├── Create Tenant
├── Update Tenant Settings
├── Manage Tenant Hierarchy (groups, entities, brands, branches)
├── Manage Departments & Teams
├── Manage Memberships (invite, join, remove)
├── Manage Subscriptions
├── Manage Feature Flags
└── Org Structure Visualization
```

## Dependencies

- Identity Engine (for user membership)

## Consumers

- Relationship Engine (org context for connections)
- Opportunity Engine (org context for opportunities)
- All products

---

# Engine 3 — Relationship Engine

## Purpose

The Relationship Engine answers: **Who are you connected with?**

This is one of the most important data stores in Yugrow. Instead of storing flat "contacts," it stores rich relationships with context — where you met, what type of relationship, how strong the connection is, and how you're connected to the broader network.

## Data Model

| Entity | Description |
|--------|-------------|
| Relationship | Connection between two entities (users, orgs) — type, strength, status |
| RelationshipType | Classification — partner, customer, supplier, employee, vendor, friend, mentor, investor, advisor, community member |
| RelationshipContext | Metadata — where met (event, referral, platform), when, notes, tags |
| BusinessCard | Digital business card — name, title, company, phone, email, social links |
| BusinessCardCollection | User's collection of received business cards |
| ConnectionRequest | Pending invitation — sender, recipient, message, status |
| ConnectionAudit | History of relationship changes |

## API Contract

```
GET    /api/v1/relationships                    — List my relationships
GET    /api/v1/relationships/:id                — Get relationship details
POST   /api/v1/relationships                    — Create relationship (direct)
PATCH  /api/v1/relationships/:id                — Update relationship
DELETE /api/v1/relationships/:id                — Remove relationship
GET    /api/v1/relationships/types              — List relationship types
POST   /api/v1/connections/request              — Send connection request
PATCH  /api/v1/connections/request/:id          — Accept/reject request
GET    /api/v1/connections/mutual/:userId       — Find mutual connections
GET    /api/v1/relationships/network/:userId    — View network graph
POST   /api/v1/business-cards                   — Create business card
GET    /api/v1/business-cards                   — List my business cards
POST   /api/v1/business-cards/share             — Share business card
GET    /api/v1/relationships/discover           — Suggested connections
GET    /api/v1/relationships/stats              — Network statistics
```

## Events

**Emits:**
- `Relationship.Connected` — Two entities connected
- `Relationship.Disconnected` — Relationship removed
- `Relationship.Updated` — Relationship metadata changed
- `Relationship.Request.Sent` — Connection request sent
- `Relationship.Request.Accepted` — Connection request accepted
- `Relationship.Request.Declined` — Connection request declined
- `Relationship.BusinessCard.Shared` — Business card exchanged
- `Relationship.Discovery.Suggested` — AI-suggested connection

**Consumes:**
- `Identity.User.Registered` — Suggest initial connections
- `Opportunity.Matched` — Create relationship between matched parties
- `Trust.ReferenceVerified` — Strengthen relationship trust signal
- `CheckIN.Event.Attended` — Add relationship context (met at event)

## AI Integration

- Suggest connections based on shared orgs, industries, opportunities
- Duplicate detection and merge suggestions
- Relationship strength prediction
- Network visualization and centrality analysis
- "How you know each other" AI-generated summaries

## Capability Registry

```
Relationship Engine
├── Create Connection
├── Remove Connection
├── Merge Duplicate Relationships
├── Business Card Exchange
├── QR Connect (scan-to-connect)
├── Import Contacts (from CSV, Google, Outlook)
├── Export Contacts (to CSV, vCard)
├── Suggest Connections (AI)
├── Find Mutual Connections
├── Network Visualization
├── Relationship Context (add notes, tags, source)
└── Discovery (find people near you)
```

## Dependencies

- Identity Engine (for user identity)
- Organization Engine (for org-level relationships)

## Consumers

- Trust Engine (uses relationship graph for reference verification)
- Opportunity Engine (uses relationships for broadcast routing)
- Communication Engine (uses relationships for message routing)
- CRM product
- CheckIN product

---

# Engine 4 — Trust Engine ⭐

## Purpose

The Trust Engine answers: **Can people trust you?**

This is Yugrow's secret sauce and core differentiator. Instead of public star ratings or review systems, it maintains private professional trust built from evidence — verified collaborations, mutual connections, reference requests, recommendations, endorsements, and reliability history.

Trust is built from evidence, not popularity.

## Data Model

| Entity | Description |
|--------|-------------|
| ReferenceRequest | Request for a professional reference — target, requester, context |
| ReferenceResponse | Reference provider's response — rating (on dimensions), comments, verified |
| Collaboration | Verified joint work — project name, dates, role, outcome, verifier |
| Endorsement | Skill or quality endorsement — skill, endorser, context |
| TrustEvidence | Verifiable proof — document links, verification URLs, certificates |
| TrustScore | Computed reputation metric — overall score, dimension scores, confidence |
| ReputationHistory | Changes to trust score over time — event, delta, reason |
| TrustDimension | Score category — reliability, expertise, communication, professionalism |

## API Contract

```
POST   /api/v1/trust/references/request          — Request a reference
GET    /api/v1/trust/references/incoming          — References requested of me
GET    /api/v1/trust/references/outgoing          — References I requested
POST   /api/v1/trust/references/:id/respond       — Provide reference response
GET    /api/v1/trust/references/:id               — Get reference details
POST   /api/v1/trust/collaborations               — Register a collaboration
GET    /api/v1/trust/collaborations               — List collaborations
PATCH  /api/v1/trust/collaborations/:id           — Update collaboration
POST   /api/v1/trust/endorsements                 — Endorse a skill
GET    /api/v1/trust/endorsements                 — List endorsements
DELETE /api/v1/trust/endorsements/:id             — Remove endorsement
GET    /api/v1/trust/score/:userId                — Get trust score
GET    /api/v1/trust/score/:userId/history        — Get score history
GET    /api/v1/trust/evidence/:userId             — Get trust evidence
POST   /api/v1/trust/evidence                     — Add trust evidence
GET    /api/v1/trust/verify/:opportunityId        — Trust verification for opportunity
```

## Events

**Emits:**
- `Trust.Reference.Requested` — Reference request sent
- `Trust.Reference.Provided` — Reference response submitted
- `Trust.Reference.Verified` — Reference authenticity verified
- `Trust.Collaboration.Registered` — New collaboration recorded
- `Trust.Endorsement.Given` — Skill endorsement made
- `Trust.Score.Updated` — Trust score changed
- `Trust.Evidence.Added` — New trust evidence submitted
- `Trust.Verification.Completed` — Trust check for opportunity done

**Consumes:**
- `Relationship.Connected` — Seed initial trust signal
- `Relationship.Disconnected` — Recalculate trust if needed
- `Opportunity.Interest.Registered` — Trigger trust verification
- `Collaboration.Verified` — Strengthen trust from project completion

## AI Integration

- Fake profile detection
- Reference authenticity verification (pattern analysis)
- Trust score computation and weighting
- Anomaly detection in endorsement patterns
- Automated reference reminders and follow-ups
- Industry-specific trust dimension weighting

## Capability Registry

```
Trust Engine
├── Request Reference
├── Provide Reference Response
├── Verify Reference Authenticity
├── Register Collaboration
├── Verify Collaboration
├── Give Endorsement
├── Remove Endorsement
├── Compute Trust Score
├── View Trust Score History
├── Add Trust Evidence
├── Verify Trust (for opportunity matching)
├── Fraud Detection (AI)
└── Fake Profile Detection (AI)
```

## Dependencies

- Identity Engine (for user identity)
- Relationship Engine (for relationship graph used in verification)

## Consumers

- Opportunity Engine (trust verification during matching)
- HR product (candidate trust assessment)
- CheckIN product (event participant trust)
- All products that need reputation context

---

# Engine 5 — Opportunity Engine ⭐⭐⭐

## Purpose

The Opportunity Engine answers: **What are you looking for?**

This is the heart of Yugrow. Everything becomes an opportunity — finding employees, suppliers, buyers, investors, distributors, customers, speakers, freelancers, mentors, franchises, manufacturers. One universal model serves all opportunity types.

## Data Model

| Entity | Description |
|--------|-------------|
| Opportunity | Universal opportunity record — type, title, description, status, org |
| OpportunityType | Classification — job, supplier, buyer, investor, distributor, customer, speaker, freelancer, mentor, franchise, manufacturer |
| OpportunityStage | Lifecycle stage — draft, published, matching, interest, evaluation, negotiation, deal, project, closed |
| BroadcastPolicy | Routing rules — levels (connections → mutual → nearby → city → state → country → region → global), time delays, budget, priority, expiration |
| OpportunityInterest | Expression of interest — user, message, status, timestamp |
| OpportunityMatch | AI-generated match — opportunity, candidate, score, ranking, explanation |
| Deal | Thin CRM layer — commercial terms, value, close date, probability |
| Pipeline | Sales/revenue pipeline — stages, values, forecast |
| OpportunityActivity | Activity log — status changes, communications, notes |

## Opportunity Lifecycle

```
Create Opportunity
  ↓
AI Categorization
  ↓
Match Candidates
  ↓
Broadcast (per policy)
  ↓
Receive Interest
  ↓
Evaluate Candidates
  ↓
Trust Verification (calls Trust Engine)
  ↓
Communication (calls Communication Engine)
  ↓
Deal (thin CRM)
  ↓
Project
  ↓
Payment
  ↓
Relationship Strengthened
```

**Note:** CRM appears late in the lifecycle — after trust verification and communication.

## API Contract

```
POST   /api/v1/opportunities                      — Create opportunity
GET    /api/v1/opportunities                      — List opportunities (filtered)
GET    /api/v1/opportunities/:id                  — Get opportunity details
PATCH  /api/v1/opportunities/:id                  — Update opportunity
DELETE /api/v1/opportunities/:id                  — Close/cancel opportunity
POST   /api/v1/opportunities/:id/broadcast        — Trigger broadcast
GET    /api/v1/opportunities/:id/matches          — Get AI matches
POST   /api/v1/opportunities/:id/interest         — Express interest
GET    /api/v1/opportunities/types                — List opportunity types
GET    /api/v1/opportunities/:id/timeline         — Get lifecycle timeline
POST   /api/v1/opportunities/:id/stage            — Advance stage
GET    /api/v1/deals                              — List deals (CRM)
POST   /api/v1/deals                              — Create deal
PATCH  /api/v1/deals/:id                          — Update deal
GET    /api/v1/pipelines                          — List pipelines
POST   /api/v1/pipelines                          — Create pipeline
```

## Events

**Emits:**
- `Opportunity.Created` — New opportunity posted
- `Opportunity.Published` — Opportunity made visible
- `Opportunity.Matched` — AI found candidate matches
- `Opportunity.Interest.Registered` — Candidate expressed interest
- `Opportunity.Broadcast.Sent` — Broadcast dispatched at a level
- `Opportunity.Stage.Changed` — Lifecycle stage advanced
- `Opportunity.Deal.Created` — Deal initiated
- `Opportunity.Deal.Won` — Deal closed successfully
- `Opportunity.Deal.Lost` — Deal lost
- `Opportunity.Closed` — Opportunity finalized

**Consumes:**
- `Relationship.Connected` — Expand broadcast audience
- `Trust.Verification.Completed` — Trust results available
- `Communication.Message.Sent` — Log communication on opportunity
- `Identity.User.Registered` — Identify potential candidates

## Broadcast Levels

```
Level 1 — My Connections          (immediate, no cost)
Level 2 — Trusted Mutual          (1 hour delay)
Level 3 — Nearby (15 km)          (2 hour delay, small fee)
Level 4 — City                    (4 hour delay)
Level 5 — State                   (8 hour delay)
Level 6 — Country                 (24 hour delay)
Level 7 — Region                  (48 hour delay, premium fee)
Level 8 — Global                  (72 hour delay, premium fee)
```

Each level configurable with time delay, budget, AI ranking, priority, and expiration.

## AI Integration

- Semantic matching (not keyword search) — understands intent
- Opportunity categorization from natural language
- Candidate ranking and scoring
- Broadcast optimization — best level for each opportunity type
- Follow-up suggestions for interested candidates
- Deal stage prediction and forecasting
- Duplicate opportunity detection

## Capability Registry

```
Opportunity Engine
├── Create Opportunity
├── Broadcast (multi-level routing)
├── Match Candidates (AI)
├── Rank Candidates (AI)
├── Recommend Opportunities (AI)
├── Express Interest
├── Evaluate Interest
├── Manage Opportunity Lifecycle
├── Expansion (related opportunities)
├── Expiration Management
├── Create Deal (thin CRM)
├── Manage Pipeline (thin CRM)
├── Forecast Revenue
└── Opportunity Analytics
```

## Dependencies

- Identity Engine (for user identity)
- Relationship Engine (for broadcast routing)
- Trust Engine (for candidate verification)
- Communication Engine (for messaging between parties)

## Consumers

- CRM product (pipeline, deals, forecast)
- CheckIN product (event-based opportunities)
- HR product (job opportunities)
- All products that manage business opportunities

---

# Engine 6 — Trust Evidence Engine ⭐

## Purpose

The Trust Evidence Engine answers: **What evidence supports trusting this person or business?**

It owns objective Trust Evidence — verified collaborations, references, endorsements, certifications, identity verification, and transaction history. It does NOT produce a single trust score. Different use cases (hiring, procurement, investment, partnership) weight evidence differently. The Recommendation Engine computes context-specific rankings using evidence from the Trust Engine combined with signals from Relationship, Communication, and other engines.

## Key Distinction

| Concept | Owner | Description |
|---------|-------|-------------|
| **Trust Evidence** | Trust Engine | Objective facts — "6 projects completed, 18 invoices paid, 5 endorsements" |
| **Reputation Dimensions** | Trust Engine | Evidence grouped by context — Business, Technical, Financial, Communication, Hiring, Community |
| **Contextual Ranking** | Recommendation Engine (future) | Evidence weighted per use case — hiring vs. procurement vs. investment |

## Reputation Dimensions

| Dimension | Evidence Types | Used When |
|-----------|---------------|-----------|
| Business | Collaborations, invoices paid, contracts signed | Partnering, procurement, B2B |
| Technical | Skills, certifications, project outcomes | Hiring, freelancing, consulting |
| Financial | Payment history, transaction volume | Investment, credit, supplier evaluation |
| Communication | Response rate, response quality, references | Sales, customer support, networking |
| Hiring | Employee history, team outcomes, referrals | Recruitment |
| Community | Event participation, endorsements given | Networking, community building |

## Data Model

| Entity | Description |
|--------|-------------|
| TrustEvidence | Individual evidence record — type, category, value, source, verification status |
| ReputationDimension | Evidence grouping — business, technical, financial, communication, hiring, community |
| ReferenceRequest | Request for a professional reference |
| ReferenceResponse | Reference provider's response |
| Collaboration | Verified joint work or project |
| Endorsement | Skill or quality endorsement |
| TrustEvidenceFile | Supporting file for evidence (certificates, documents) |

## API Contract

```
GET    /api/v1/trust/evidence/:personId              — Get all evidence
GET    /api/v1/trust/evidence/:personId/:category     — Get evidence by dimension
POST   /api/v1/trust/evidence                         — Add evidence record
POST   /api/v1/trust/references/request               — Request reference
GET    /api/v1/trust/references/incoming              — Incoming requests
POST   /api/v1/trust/references/:id/respond           — Provide reference
POST   /api/v1/trust/collaborations                   — Register collaboration
GET    /api/v1/trust/collaborations/:personId          — List collaborations
POST   /api/v1/trust/endorsements                     — Endorse a skill
DELETE /api/v1/trust/endorsements/:id                 — Remove endorsement
```

## Events

**Emits:**
- `Trust.Evidence.Added` — New evidence recorded
- `Trust.Evidence.Verified` — Evidence authenticity confirmed
- `Trust.Reference.Requested` — Reference request sent
- `Trust.Reference.Provided` — Reference response submitted
- `Trust.Reference.Verified` — Reference verified
- `Trust.Collaboration.Registered` — New collaboration recorded
- `Trust.Endorsement.Given` — Skill endorsement made

**Consumes:**
- `Relationship.Connected` — Seed initial trust evidence
- `Relationship.Disconnected` — Archive related evidence
- `Opportunity.Deal.Won` — Record successful collaboration as evidence
- `Communication.Message.Sent` — Track response rate for communication dimension

## Explainability

Every recommendation that uses trust evidence must include explanations:

```json
{
  "explanation": {
    "summary": "Strong match: verified exporter with mutual connections",
    "evidence": [
      { "type": "identity_verified", "label": "Identity Verified" },
      { "type": "mutual_connections", "label": "4 mutual connections" },
      { "type": "collaboration", "label": "3 completed projects" }
    ]
  }
}
```

No black-box recommendations.

### Immutability

Trust evidence is **immutable**. Once created, evidence cannot be edited or silently modified. Only three state transitions are permitted: Active, Revoked, Expired.

- Evidence records use `CREATE` only — no `UPDATE` permitted
- Revocations create a new record referencing the original
- `isVerified` is set once during verification and never changed

## Capability Registry

```
Trust Evidence Engine
├── Read Evidence (by person, by dimension)
├── Add Evidence
├── Verify Evidence
├── Request Reference
├── Respond to Reference
├── Register Collaboration
├── Give Endorsement
├── Remove Endorsement
├── Upload Certification
└── Request Verification
```

## Dependencies

- Identity Engine (for person identity)
- Relationship Engine (for relationship graph used in verification)

## Consumers

- Recommendation Engine (context-specific ranking)
- Opportunity Engine (trust verification during matching)
- Discovery Engine (trust-weighted discovery)
- All products needing reputation context

---

# Engine 7 — Communication Engine

## Purpose

The Communication Engine answers: **How do people collaborate?**

**Conversations are the business object. Channels are transports.**

A Conversation is a thread of messages between participants, independent of the channel. The same conversation can span in-app chat, WhatsApp, email, SMS, and push notifications — all linked by a single Conversation ID. Every conversation has a **Conversation Context** — it belongs to something (a Relationship, a Broadcast, an Opportunity, an Event, a CRM Contact, an Invoice, a Project).

## Conversation Context

Every conversation belongs to a parent business object:

```
Conversation
  |
  +-- contextType: "relationship", "opportunity", "broadcast", "event", "deal", "invoice", "project"
  +-- contextId: UUID of the parent object
```

This ensures users always understand why a conversation exists. The context is set when the conversation is created and is immutable.

## Data Model

| Entity | Description |
|--------|-------------|
| Conversation | Thread of messages — participants, subject, context type, context ID |
| ConversationContext | Link to parent business object (Relationship, Opportunity, Broadcast, etc.) |
| Message | Individual message — sender, body, attachments, timestamp, channel |
| ChannelType | Transport medium — chat, WhatsApp, email, SMS, push, voice (future), video (future) |
| ChannelConfig | Per-user/per-org channel configuration |
| Notification | Outbound notification — recipient, channel, template, status |
| NotificationTemplate | Reusable template — channel-specific format, variables |

## API Contract

```
POST   /api/v1/communication/conversations        — Start conversation
GET    /api/v1/communication/conversations        — List conversations
GET    /api/v1/communication/conversations/:id    — Get conversation
POST   /api/v1/communication/conversations/:id/messages — Send message
GET    /api/v1/communication/conversations/:id/messages — Get messages
PATCH  /api/v1/communication/messages/:id         — Update message status
POST   /api/v1/communication/notifications/send   — Send notification
GET    /api/v1/communication/notifications        — List notifications
PATCH  /api/v1/communication/notifications/:id/read — Mark as read
GET    /api/v1/communication/templates            — List templates
POST   /api/v1/communication/templates            — Create template
POST   /api/v1/communication/channels/link        — Link external channel (WhatsApp, email)
GET    /api/v1/communication/channels             — List linked channels
```

## Events

**Emits:**
- `Communication.Conversation.Started` — New conversation created
- `Communication.Message.Sent` — Message delivered
- `Communication.Message.Read` — Message marked as read
- `Communication.Notification.Sent` — Notification dispatched
- `Communication.Notification.Delivered` — Notification confirmed
- `Communication.Channel.Linked` — External channel connected

**Consumes:**
- `Opportunity.Interest.Registered` — Notify opportunity creator
- `Opportunity.Deal.Created` — Send deal notification
- `Workflow.Action.Triggered` — Execute communication action
- `Organization.Member.Invited` — Send invitation email

## AI Integration

- Smart reply suggestions
- Sentiment analysis on conversations
- Language translation for cross-language communication
- Email and message drafting assistance
- Best channel prediction (when to use WhatsApp vs email vs chat)
- Conversation summarization
- Follow-up reminders

## Capability Registry

```
Communication Engine
├── Start Conversation
├── Send Message
├── Send Bulk Message
├── Schedule Message
├── Send Notification (push, email, SMS)
├── Manage Templates
├── Link External Channel (WhatsApp, Email, SMS)
├── Message Status Tracking
├── Smart Reply Suggestions (AI)
├── Sentiment Analysis (AI)
├── Language Translation (AI)
└── Conversation History Search
```

## Dependencies

- Identity Engine (for user identity and preferences)

## Consumers

- Opportunity Engine (messaging between matched parties)
- All products (in-app communication)
- Workflow Engine (automated notifications)

---

# Engine 7 — Workflow Engine

## Purpose

The Workflow Engine answers: **What should happen automatically?**

It provides event-driven automation — when something happens in one engine, trigger actions in another. No manual work for routine processes.

## Data Model

| Entity | Description |
|--------|-------------|
| Workflow | Automation rule — trigger, conditions, actions, status |
| WorkflowTrigger | Event that starts the workflow — event type, source engine, filter |
| WorkflowCondition | Logic gate — AND/OR conditions on event data |
| WorkflowAction | Automated response — send notification, create record, call API |
| WorkflowSchedule | Time-based trigger — cron expression, timezone |
| WorkflowExecution | Log of a workflow run — trigger event, actions taken, result, timestamp |
| WorkflowTemplate | Pre-built workflow for common patterns |

## API Contract

```
POST   /api/v1/workflows                         — Create workflow
GET    /api/v1/workflows                         — List workflows
GET    /api/v1/workflows/:id                     — Get workflow details
PATCH  /api/v1/workflows/:id                     — Update workflow
DELETE /api/v1/workflows/:id                     — Delete workflow
POST   /api/v1/workflows/:id/activate            — Enable workflow
POST   /api/v1/workflows/:id/deactivate          — Disable workflow
GET    /api/v1/workflows/:id/executions          — Get execution history
POST   /api/v1/workflows/test                    — Dry-run a workflow
GET    /api/v1/workflows/templates               — List templates
```

## Events

**Emits:**
- `Workflow.Created` — New workflow defined
- `Workflow.Triggered` — Workflow activated by event
- `Workflow.Action.Executed` — Action completed
- `Workflow.Action.Failed` — Action errored
- `Workflow.Completed` — All actions done
- `Workflow.Disabled` — Workflow turned off

**Consumes:**
- All engine events — workflow can trigger on any event
- `Opportunity.Stage.Changed` — Common trigger pattern
- `Opportunity.Interest.Registered` — Common trigger pattern

## AI Integration

- Workflow suggestion based on usage patterns
- Condition optimization recommendations
- Anomaly detection in workflow execution
- Natural language workflow creation ("When a deal is won, send a thank-you email")

## Capability Registry

```
Workflow Engine
├── Create Workflow
├── Activate/Deactivate Workflow
├── Test Workflow (dry-run)
├── View Execution History
├── Schedule Workflow
├── Natural Language Create (AI)
├── Workflow Templates (pre-built)
└── Workflow Suggestions (AI)
```

## Dependencies

- All engines (it reacts to all events)

## Consumers

- All products (automation features)
- All engines (can trigger automated responses)

---

# Engine 8 — AI Engine

## Purpose

The AI Engine answers: **How can AI automate this process?**

It is the central nervous system for all AI operations — model routing, prompt management, agent orchestration, knowledge bases, token tracking, and guardrails. Every other engine uses AI through this engine.

## Data Model

| Entity | Description |
|--------|-------------|
| AIProvider | External AI provider config — OpenAI, Anthropic, DeepSeek, Gemini, open-source |
| AIModel | Specific model — GPT-4o, Claude 4, DeepSeek-V3, Gemini 2.5 |
| Prompt | Versioned prompt template — name, content, variables, model, temperature |
| PromptVersion | Specific version of a prompt — content, author, changelog |
| Agent | Configurable AI agent — instructions, tools, model, knowledge bases |
| KnowledgeBase | Document collection for RAG — documents, embeddings, chunking strategy |
| KnowledgeDocument | Source document — file, content, metadata, status |
| TokenUsage | Token consumption record — provider, model, prompt tokens, completion tokens, cost |
| AIRequest | Full request/response log — prompt, response, latency, tokens |
| GuardrailRule | Content safety rule — category, action (block/warn/log), severity |

## API Contract

```
POST   /api/v1/ai/chat                           — Chat completion
POST   /api/v1/ai/complete                       — Text completion
POST   /api/v1/ai/embed                          — Generate embeddings
POST   /api/v1/ai/analyze                        — Structured analysis
GET    /api/v1/ai/prompts                        — List prompt templates
POST   /api/v1/ai/prompts                        — Create prompt template
PATCH  /api/v1/ai/prompts/:id                    — Update prompt template
POST   /api/v1/ai/prompts/:id/versions           — Create new version
GET    /api/v1/ai/agents                         — List agents
POST   /api/v1/ai/agents                         — Create agent
PATCH  /api/v1/ai/agents/:id                     — Update agent
POST   /api/v1/ai/knowledge-bases                — Create knowledge base
POST   /api/v1/ai/knowledge-bases/:id/documents  — Upload document
DELETE /api/v1/ai/knowledge-bases/:id/documents/:docId — Remove document
GET    /api/v1/ai/usage                          — Get token usage
GET    /api/v1/ai/usage/:tenantId                — Get tenant usage
```

## Events

**Emits:**
- `AI.Request.Started` — AI request initiated
- `AI.Request.Completed` — AI response received
- `AI.Request.Failed` — AI request errored
- `AI.Token.Threshold.Exceeded` — Tenant approaching token limit
- `AI.Guardrail.Triggered` — Content safety rule activated
- `AI.Agent.Action.Taken` — Agent performed an action

**Consumes:**
- All engine events — AI can learn from and react to all platform events

## AI Integration

The AI Engine integrates with every other engine through:
1. **Chat API** — Any engine can call AI for natural language processing
2. **Embedding API** — Any engine can generate embeddings for semantic search
3. **Analysis API** — Any engine can request structured data analysis
4. **Agents** — Persistent AI agents that monitor and act on engine events
5. **Knowledge Bases** — Engine-specific document collections for RAG

## Capability Registry

```
AI Engine
├── Chat Completion
├── Text Completion
├── Generate Embeddings
├── Analyze Content (structured analysis)
├── Manage Prompts (create, version, A/B test)
├── Manage Agents (create, configure, deploy)
├── Manage Knowledge Bases (upload, chunk, embed)
├── Search Knowledge Base (RAG)
├── Track Usage (tokens, cost per tenant)
├── Manage Guardrails
├── Route Model (select best provider/model)
└── Fallback (automatic retry with alternative model)
```

## Dependencies

- Identity Engine (for auth and tenant context)

## Consumers

- All engines (every engine integrates with AI)
- All products

---

# Engine 9 — Integration Engine

## Purpose

The Integration Engine answers: **How does Yugrow connect to the outside world?**

It manages all external system integrations — connectors, webhooks, API gateways, data transformation, and third-party service orchestration. Every external connection flows through this engine, ensuring that integrations are secure, observable, and swappable without modifying other engines.

## Data Model

| Entity | Description |
|--------|-------------|
| Connector | External system connection — type, credentials (vault ref), config |
| ConnectorType | Integration category — CRM, ERP, Payment, Email, SMS, Social, Storage |
| Webhook | Outbound event notification — URL, events, secret, retry config |
| WebhookDelivery | Delivery record — status, attempt, response, timestamp |
| IntegrationFlow | Multi-step integration — source, transform, destination |
| DataMapping | Field mapping between Yugrow and external system |
| SyncSchedule | Scheduled sync configuration — frequency, direction, filters |
| ConnectionLog | Integration activity log — requests, responses, errors |

## API Contract

```
POST   /api/v1/integration/connectors              — Create connector
GET    /api/v1/integration/connectors               — List connectors
PATCH  /api/v1/integration/connectors/:id           — Update connector
DELETE /api/v1/integration/connectors/:id           — Remove connector
POST   /api/v1/integration/connectors/:id/test      — Test connection
POST   /api/v1/integration/webhooks                 — Register webhook
GET    /api/v1/integration/webhooks                 — List webhooks
DELETE /api/v1/integration/webhooks/:id             — Remove webhook
GET    /api/v1/integration/webhooks/:id/deliveries  — View delivery log
POST   /api/v1/integration/flows                    — Create integration flow
GET    /api/v1/integration/flows                    — List flows
POST   /api/v1/integration/sync                     — Trigger manual sync
GET    /api/v1/integration/logs                     — View connection logs
```

## Events

**Emits:**
- `Integration.Connector.Created` — New connector added
- `Integration.Connector.Disconnected` — External system disconnected
- `Integration.Webhook.Delivered` — Webhook sent successfully
- `Integration.Webhook.Failed` — Webhook delivery failed
- `Integration.Sync.Completed` — Data sync finished
- `Integration.Sync.Failed` — Data sync errored
- `Integration.Flow.Executed` — Integration flow completed

**Consumes:**
- All engine events — any event can trigger an integration flow
- `Opportunity.Deal.Won` — Sync to external CRM
- `Organization.Subscription.Changed` — Update external billing

## Capability Registry

```
Integration Engine
├── Create Connector (any external system)
├── Test Connection
├── Register Webhook
├── Create Integration Flow
├── Schedule Sync
├── Transform Data
├── Map Fields
├── View Connection Logs
└── Connection Health Monitoring
```

## AI Integration

- Smart field mapping suggestions based on data analysis
- Anomaly detection in integration data flows
- Automated error resolution suggestions
- Connector health prediction

## Dependencies

- Identity Engine (for auth, API keys)
- Organization Engine (for tenant-scoped integrations)

## Consumers

- All products (integrations are product-agnostic)
- Marketplace (third-party connectors)

---

# Engine 10 — Search Engine

## Purpose

The Search Engine answers: **Where is the information I need?**

It provides universal hybrid search across every Business Object in the platform — People, Companies, Invoices, Events, Products, Messages, Files, Projects, Opportunities — without users needing to know which engine owns the data.

## Data Model

| Entity | Description |
|--------|-------------|
| SearchIndex | Indexed document — object type, object ID, title, content, embedding |
| SearchQuery | Query log — text, filters, results, user, timestamp |
| SearchResult | Cached result — objects, scores, ranking factors |
| SynonymGroup | Domain-specific synonyms — configurable per tenant |
| SearchBoost | Weight adjustment — field, value, boost factor |

## API Contract

```
GET    /api/v1/search                   — Universal search
POST   /api/v1/search                   — Advanced search (with filters)
GET    /api/v1/search/objects           — List indexed object types
POST   /api/v1/search/reindex           — Trigger full reindex
POST   /api/v1/search/synonyms          — Configure synonyms
GET    /api/v1/search/trending          — Trending searches
GET    /api/v1/search/suggest           — Autocomplete suggestions
```

## Search Types

| Type | Technology | Use Case |
|------|-----------|----------|
| Full-Text Search | PostgreSQL FTS | Keyword search, name lookup, document content |
| Semantic Search | pgvector (embeddings) | Natural language queries, meaning-based search |
| Graph Search | Business Knowledge Graph | Relationship-aware queries ("people I can reach") |
| Hybrid Search | RRF (Reciprocal Rank Fusion) | Combined full-text + semantic results |

## Events

**Emits:**
- `Search.Query.Executed` — Search performed (aggregated, no PII)
- `Search.Index.Updated` — Index refreshed for an object type

**Consumes:**
- All engine events — indexes are updated when Business Objects change

## Capability Registry

```
Search Engine
├── Universal Search (all objects, one query)
├── Object-Specific Search (filter by type)
├── Natural Language Search (AI)
├── Autocomplete Suggestions
├── Spelling Correction
├── Synonym Management
├── Search Analytics (trending, popular)
├── Reindex (full or incremental)
└── Custom Ranking (boost by field/value)
```

## AI Integration

- Natural language query understanding
- Semantic embedding generation
- Query rewriting for better results
- Personalized ranking (trust-weighted results)

## Dependencies

- All engines (indexes their Business Objects)

## Consumers

- All products (search bar, API)
- AI Engine (RAG context retrieval)

---

# Engine 11 — Policy Engine

## Purpose

The Policy Engine answers: **What rules should govern this action?**

It enables enterprise-grade governance without code changes. Policies evaluate conditions and enforce actions — approval workflows, entitlement gates, compliance rules, quotas, and routing logic.

**Separate from Workflow Engine:** Workflow automates *processes*. Policy Engine governs *constraints*.

## Data Model

| Entity | Description |
|--------|-------------|
| Policy | Governance rule — trigger, conditions, actions, priority, status |
| PolicyCondition | Evaluation logic — field, operator, value, AND/OR grouping |
| PolicyAction | Enforcement — RequireApproval, Block, Log, Notify, Redirect |
| PolicyEvaluation | Evaluation record — policy, input, result, timestamp |
| Approval | Pending approval request — policy, requester, resource, status |
| ApprovalStep | Approval workflow step — approver, decision, comments, timestamp |
| Entitlement | License/plan entitlement — feature, plan tier, max value |

## API Contract

```
POST   /api/v1/policies                       — Create policy
GET    /api/v1/policies                       — List policies
PATCH  /api/v1/policies/:id                   — Update policy
DELETE /api/v1/policies/:id                   — Delete policy
POST   /api/v1/policies/:id/simulate          — Test policy (dry-run)
POST   /api/v1/policies/evaluate              — Evaluate event against policies
GET    /api/v1/policies/evaluations           — View evaluation history
POST   /api/v1/approvals                      — Create approval request
GET    /api/v1/approvals                      — List pending approvals
PATCH  /api/v1/approvals/:id                  — Approve/reject
GET    /api/v1/entitlements                   — Check entitlements
POST   /api/v1/entitlements/check             — Verify feature access
```

## Policy Examples

```
Rule 1: IF Invoice.Amount > $50,000 THEN RequireApproval(CFO)
Rule 2: IF Broadcast.Level == Global THEN RequireEntitlement(Premium)
Rule 3: IF Opportunity.Type == Government THEN EnableComplianceMode
Rule 4: IF User.Role != Admin THEN MaxExportLimit(1000)
Rule 5: IF ConnectionRequest.Weekly > 100 THEN RateLimit(24h)
```

## Events

**Emits:**
- `Policy.Created` — New policy defined
- `Policy.Evaluated` — Policy check completed
- `Policy.Action.Triggered` — Policy action executed (approval, block, notify)
- `Approval.Requested` — Approval workflow started
- `Approval.Decided` — Approval approved/rejected

**Consumes:**
- All engine events — policies can evaluate any event
- `Opportunity.Deal.Created` — Check approval policy
- `Invoice.Created` — Check amount threshold

## Capability Registry

```
Policy Engine
├── Define Policy (IF-THEN rules)
├── Evaluate Policy (real-time)
├── Simulate Policy (dry-run before enable)
├── Approval Workflow
├── Entitlement Check
├── Quota Management
├── Policy Audit Log
└── Policy Templates (pre-built, industry-specific)
```

## AI Integration

- Policy suggestion based on usage patterns
- Anomaly detection in policy violations
- Conflict detection between policies
- Natural language policy creation ("Block broadcasts over $10K without CFO approval")

## Dependencies

- Identity Engine (for user roles in conditions)
- Organization Engine (for tenant-level policies)

## Consumers

- All engines (policies evaluate events from any engine)
- All products (enforcement of business rules)

---

# Engine 12 — Recommendation Engine

## Purpose

The Recommendation Engine answers: **What is the best option?**

AI *generates* candidates. The Recommendation Engine *ranks* them. This separation ensures ranking logic is deterministic, auditable, and customizable without retraining models.

## Data Model

| Entity | Description |
|--------|-------------|
| Recommendation | Generated recommendation — type, target, items, scores, explanation |
| RecommendationType | Category — opportunity, connection, content, action, partner |
| RankingFactor | Scoring dimension — name, source, weight, value |
| RankingProfile | Configurable ranking — factor weights per use case |
| RecommendationFeedback | User feedback — relevance rating, click, conversion |

## API Contract

```
POST   /api/v1/recommendations/rank           — Rank items (given candidates)
POST   /api/v1/recommendations/personalized    — Get personalized recommendations
GET    /api/v1/recommendations/factors         — List ranking factors
PATCH  /api/v1/recommendations/profiles/:id    — Customize ranking profile
POST   /api/v1/recommendations/feedback        — Submit recommendation feedback
```

## Ranking Flow

```
Candidates (from AI Engine or other sources)
  ↓
Recommendation Engine: Multi-factor ranking
  ├── Trust Score (Trust Engine)
  ├── Relationship Distance (Relationship Engine)
  ├── Collaboration History (Trust Engine)
  ├── Skill Match Percentage (AI Engine)
  ├── Location Proximity (Organization Engine)
  ├── Past Success Rate (Opportunity Engine)
  ├── Response Rate (Communication Engine)
  └── Availability (User profile)
  ↓
Scored & Ranked Results (with explanations)
```

## Ranking Factors

| Factor | Source | Default Weight | Configurable |
|--------|--------|---------------|--------------|
| Trust Score | Trust Engine | High | Yes |
| Relationship Distance | Relationship Engine | High | Yes |
| Collaboration History | Trust Engine | Medium | Yes |
| Skill Match | AI Engine | Medium | Yes |
| Industry Relevance | Organization Engine | Medium | Yes |
| Location Proximity | Organization Engine | Low | Yes |
| Response Rate | Communication Engine | Medium | Yes |
| Past Deal Success | Opportunity Engine | Medium | Yes |
| Mutual Connections | Relationship Engine | Low | Yes |

## Events

**Emits:**
- `Recommendation.Generated` — New recommendation created
- `Recommendation.Clicked` — User interacted with recommendation
- `Recommendation.Converted` — Recommendation led to an action

**Consumes:**
- `Opportunity.Matched` — Rank AI-generated matches
- `Relationship.Discovery.Suggested` — Rank connection suggestions
- `AI.Request.Completed` — Rank AI-generated candidates

## Capability Registry

```
Recommendation Engine
├── Rank Items (score and order candidates)
├── Personalized Recommendations
├── Custom Ranking Profiles
├── Multi-Factor Scoring
├── Explainable Rankings (factor breakdown)
├── A/B Test Ranking Profiles
├── Feedback Collection
└── Ranking Analytics
```

## AI Integration

- Ranking profile optimization from user feedback
- Anomaly detection in ranking patterns
- Natural language explanation generation ("Recommended because...")

## Dependencies

- Trust Engine (trust scores)
- Relationship Engine (relationship distance)
- Communication Engine (response rates)
- AI Engine (skill match, semantic similarity)

## Consumers

- Opportunity Engine (rank matched candidates)
- Relationship Engine (rank connection suggestions)
- All products (recommendations in UI)

---

# Engine 3 — Workspace Engine

## Purpose

The Workspace Engine answers: **Where are you working?**

It manages identity context — the active workspace a person is acting as. A single person can belong to multiple workspaces (Personal, Company A, Company B, Brand, Community) and switch between them. Every action in Yugrow carries an Actor Context: the Person + the Active Workspace.

## Data Model

| Entity | Description |
|--------|-------------|
| Workspace | Context for work — PERSONAL, COMPANY, BRAND, NONPROFIT, COMMUNITY, EVENT |
| Membership | Person's relationship to a workspace (OWNER, EMPLOYEE, CONTRACTOR, etc.) |
| ActiveWorkspace | The currently active workspace for a person (session-level) |
| WorkspaceHierarchy | Parent-child relationships between workspaces (holding company structure) |

## Identity Model

```
Person (Jay)
  |
  +-- Membership: OWNER --> Workspace: Yugrow Technologies
  |     +-- Role: CEO
  |
  +-- Membership: OWNER --> Workspace: The Data Company
  |     +-- Role: Director
  |
  +-- Membership: EMPLOYEE --> Workspace: Client Company
        +-- Role: Consultant

Active Context: Yugrow Technologies (acting as Company)
```

## API Contract

```
POST   /api/v1/workspaces                       — Create workspace
GET    /api/v1/workspaces                       — List my workspaces
GET    /api/v1/workspaces/:id                   — Get workspace details
PATCH  /api/v1/workspaces/:id                   — Update workspace
DELETE /api/v1/workspaces/:id                   — Deactivate workspace
POST   /api/v1/workspaces/:id/members           — Invite member
GET    /api/v1/workspaces/:id/members           — List members
PATCH  /api/v1/workspaces/:id/members/:personId — Update membership
DELETE /api/v1/workspaces/:id/members/:personId — Remove member
POST   /api/v1/workspaces/switch                — Switch active workspace
GET    /api/v1/workspaces/current               — Get current workspace context
```

## Events

**Emits:**
- `Workspace.Created` — New workspace provisioned
- `Workspace.Updated` — Workspace settings changed
- `Workspace.Switched` — Person switched active workspace
- `Workspace.Member.Added` — Member invited
- `Workspace.Member.Removed` — Member removed
- `Workspace.Member.RoleChanged` — Role assignment changed

## Capability Registry

```
Workspace Engine
├── Create Workspace
├── Switch Workspace Context
├── Manage Members
├── Manage Workspace Settings
└── Manage Workspace Hierarchy
```

## Dependencies

- Identity Engine (for Person identity)

## Consumers

- All engines (every action needs workspace context)
- All products

---

# Engine 4 — Permission Engine

## Purpose

The Permission Engine answers: **Can this user perform this action in this workspace?**

It implements the 5-layer authorization model: Identity > Workspace > Membership > Role > Capability. Every product asks the Permission Engine: "Can this person do X in workspace Y?" The UI is projected from capabilities — not hardcoded per role.

## 5-Layer Authorization Model

```
Layer 1 — Identity:      Who are you?              (Person, authenticated by Authentik)
Layer 2 — Workspace:     Where are you working?     (Active workspace context)
Layer 3 — Membership:    What's your relationship?  (Owner, Employee, Contractor, etc.)
Layer 4 — Role:          What's your function?      (CEO, Sales Manager, Developer)
Layer 5 — Capability:    What can you do?           (crm.contacts.create, website.publish)
```

## Capability Naming

Capabilities are atomic and namespaced by product:

```
{product}.{resource}.{action}

Examples:
  crm.contacts.create
  crm.contacts.delete
  content.article.publish
  website.site.publish
  broadcast.send
  broadcast.send.global
  finance.invoice.approve
  hr.payroll.run
  checkin.event.create
  ai.use.claude
  ai.use.openai
```

## Data Model

| Entity | Description |
|--------|-------------|
| Capability | Atomic permission — product.resource.action |
| CapabilityScope | ABAC scope — restricts capability by attribute (branch, brand, region) |
| CapabilityGrant | Temporary capability grant with expiry |
| RoleCapability | Links roles to capabilities |
| PermissionCheck | Log of permission evaluation requests |

## API Contract

```
POST   /api/v1/permissions/check                — Can user perform action?
POST   /api/v1/permissions/check-batch           — Check multiple permissions
GET    /api/v1/permissions/my                    — Get my capabilities
GET    /api/v1/permissions/:workspaceId/users/:personId — Get user's capabilities
POST   /api/v1/permissions/capabilities          — Define new capability
GET    /api/v1/permissions/capabilities          — List capabilities
POST   /api/v1/permissions/grants               — Grant temporary capability
DELETE /api/v1/permissions/grants/:id            — Revoke temporary grant
```

## Capability Registry

```
Permission Engine
├── Check Permission (can user do X?)
├── Batch Check Permissions
├── Get User Capabilities
├── Manage Capability Definitions
├── Grant Temporary Capability
├── Manage ABAC Scopes
└── Permission Audit Log
```

## AI Integration

- Anomaly detection in permission usage
- Smart role suggestions based on usage patterns
- Access review automation ("Who has access to X?")
- Capability gap analysis

## Dependencies

- Identity Engine (for Person)
- Workspace Engine (for workspace context)

## Consumers

- All engines (API-level authorization)
- All products (UI-level feature visibility)

---

# Engine 12 — Edge Platform

## Purpose

The Edge Platform answers: **How do users reach Yugrow?**

It manages domains, SSL certificates, CDN integration, reverse proxy, routing, preview deployments, redirects, and custom hostnames. Every product uses it for URL management — websites, profiles, events, broadcasts, portals.

## Data Model

| Entity | Description |
|--------|-------------|
| Domain | Domain record — name, verification status, SSL status, tenant |
| Subdomain | Auto-provisioned subdomain (tenant.yugrow.com) |
| CustomDomain | User-connected custom domain with verification |
| SSLCertificate | SSL certificate record — provider, expiry, auto-renew |
| Route | URL-to-product mapping — domain, path, target product, environment |
| Redirect | Redirect rule — source, destination, type (301/302), status |
| CDNConfig | CDN configuration — caching rules, origin, purge |
| PreviewDeployment | Temporary preview URL for staging |

## Subdomain Auto-Provisioning

When any entity is created, a subdomain is auto-provisioned:

| Entity | Subdomain Pattern | Example |
|--------|------------------|---------|
| Person | person-slug.yugrow.com | jay.yugrow.com |
| Workspace | workspace-slug.yugrow.com | thedatacompany.yugrow.com |
| Website | site-slug.yugrow.com | acmesite.yugrow.com |
| Event | event-slug.yugrow.com | chennai-meetup.yugrow.com |
| Opportunity | type.yugrow.com/slug | jobs.yugrow.com/flutter-dev |
| Content | person.yugrow.com/blog/slug | jay.yugrow.com/blog/ai-future |

## Custom Domain Flow

```
1. User configures CNAME: www.mycompany.com → cname.yugrow.com
2. Edge Platform: Verify DNS (TXT record or CNAME check)
3. Edge Platform: Provision SSL (Let's Encrypt auto)
4. Edge Platform: Configure routing to the target product
5. Traffic flows: Visitor → mycompany.com → CDN → Edge → Product
```

## Multi-Domain per Tenant

```
Tenant: ABC Holdings
  Brand A: branda.com → Website
  Brand B: brandb.com → Website
  Events: events.abcholdings.com → CheckIN
  Careers: careers.abcholdings.com → Broadcast (jobs)
```

## Environment Support

```
Development: dev.tenant.yugrow.com or dev.tenant.com
Staging:     staging.tenant.yugrow.com or staging.tenant.com
Production:  tenant.yugrow.com or tenant.com
```

## API Contract

```
POST   /api/v1/edge/domains                     — Register domain
GET    /api/v1/edge/domains                     — List domains
POST   /api/v1/edge/domains/:id/verify          — Verify domain ownership
DELETE /api/v1/edge/domains/:id                 — Remove domain
POST   /api/v1/edge/domains/:id/ssl             — Provision SSL
GET    /api/v1/edge/routes                      — List routes
POST   /api/v1/edge/routes                      — Create route
PATCH  /api/v1/edge/routes/:id                  — Update route
POST   /api/v1/edge/redirects                   — Create redirect
GET    /api/v1/edge/preview                     — Create preview URL
```

## Events

**Emits:**
- `Edge.Domain.Registered` — New domain registered
- `Edge.Domain.Verified` — Domain ownership verified
- `Edge.Domain.SSL.Provisioned` — SSL certificate issued
- `Edge.Domain.SSL.Expiring` — Certificate approaching expiry
- `Edge.Route.Created` — New route configured
- `Edge.Redirect.Created` — Redirect rule added

## Capability Registry

```
Edge Platform
├── Register Domain
├── Verify Domain Ownership
├── Provision SSL (auto Let's Encrypt)
├── Configure Route (domain -> product -> environment)
├── Create Redirect
├── Create Preview URL
├── Manage CDN Config
└── Domain Analytics
```

## Dependencies

- Identity Engine (for auth)
- Workspace Engine (for workspace context)
- Organization Engine (for multi-brand hierarchy)

## Consumers

- Yugrow Sites (website domains)
- Yugrow Content (blog domains)
- Yugrow CheckIN (event subdomains)
- Yugrow Broadcast (opportunity URLs)
- Yugrow CRM (client portals)
- All products needing custom URLs

---

# Engine 9 — Discovery Engine

## Purpose

The Discovery Engine answers: **What should I discover?**

It is the gateway to the Yugrow network. Instead of starting at a dashboard, users start at Discovery — finding people, companies, events, products, services, jobs, investors, partners, and communities relevant to them.

Discovery is not search. Search finds what you ask for. Discovery finds what you should know about.

## Data Model

| Entity | Description |
|--------|-------------|
| DiscoveryFeed | Personalized feed — items, scores, reasons, ranking |
| DiscoverySource | Source type — people, companies, events, opportunities, communities |
| DiscoveryPreference | User preferences — industries, locations, topics, intent |
| DiscoveryResult | Cached discovery result — source, score, factors, timestamp |
| TrendingItem | Trending business — companies, skills, industries, locations |

## Discovery Feed Types

```
Discover
├── Nearby Companies (within 15km)
├── Nearby Events (upcoming, within city)
├── Trending Opportunities (by industry)
├── Recommended Partners (by trust + mutual connections)
├── Recommended Suppliers (by industry + location)
├── Recommended Buyers (by product/service match)
├── People You Should Meet (by network graph)
├── Growing Companies (by activity signals)
└── Communities (by industry + location)
```

## API Contract

```
GET    /api/v1/discovery/feed              — Get personalized discovery feed
GET    /api/v1/discovery/nearby/companies  — Discover nearby companies
GET    /api/v1/discovery/nearby/events     — Discover nearby events
GET    /api/v1/discovery/people            — Discover people to meet
GET    /api/v1/discovery/trending          — Trending businesses & topics
PATCH  /api/v1/discovery/preferences       — Update discovery preferences
POST   /api/v1/discovery/feedback          — Rate discovery relevance
```

## Events

**Emits:**
- `Discovery.Feed.Generated` — Personalized feed created
- `Discovery.Item.Clicked` — User interacted with discovery item
- `Discovery.Preference.Updated` — User updated discovery preferences

**Consumes:**
- `Relationship.Connected` — Update discovery graph
- `Opportunity.Created` — Add to trending opportunities
- `CheckIN.Event.Attended` — Update event discovery
- `Identity.Person.Registered` — Seed initial discovery preferences

## Capability Registry

```
Discovery Engine
├── Get Discovery Feed (personalized)
├── Discover Nearby Companies
├── Discover Nearby Events
├── Discover People
├── Trending Discovery
├── Update Preferences
└── Discovery Feedback
```

## AI Integration

- Personalized feed ranking based on behavior, relationships, trust
- Trending detection from platform-wide activity signals
- Natural language discovery ("Find rice exporters in Chennai")
- Intent-based discovery (understanding what the user wants)

## Dependencies

- Relationship Engine (for network graph)
- Trust Engine (for trust-based ranking)
- Opportunity Engine (for trending opportunities)
- Communication Engine (for engagement signals)
- Search Engine (for hybrid discovery queries)

## Consumers

- CheckIN (event discovery)
- Broadcast (opportunity discovery)
- CRM (lead discovery)
- All products (discovery feed)

---

# Engine 10 — Recommendation Engine

## Purpose

The Recommendation Engine answers: **What is the best option for me?**

AI generates candidates. The Recommendation Engine ranks them. This separation ensures ranking logic is deterministic, auditable, and customizable without retraining models.

## Data Model

| Entity | Description |
|--------|-------------|
| Recommendation | Generated recommendation — type, target, items, scores, explanation |
| RecommendationType | Category — opportunity, connection, content, action, partner |
| RankingFactor | Scoring dimension — name, source, weight, value |
| RankingProfile | Configurable ranking — factor weights per use case |
| RecommendationFeedback | User feedback — relevance rating, click, conversion |

## Recommendation Types

| Type | Description | Used By |
|------|-------------|---------|
| Opportunity Recommendations | Opportunities matched to user profile | CRM, Broadcast, CheckIN |
| Connection Recommendations | People you should connect with | Relationship, CheckIN |
| Content Recommendations | Relevant content from knowledge base | Content, AI Assistant |
| Action Recommendations | Suggested next actions | Workflow Engine |
| Partner Recommendations | Suggested business partners | Broadcast, CRM |
| Supplier/Buyer/Investor Recommendations | B2B matching | Broadcast, Marketplace |

## Ranking Flow

```
Candidates (from AI Engine, Discovery Engine, or Opportunity Engine)
  |
  v
Recommendation Engine: Multi-factor ranking
  +-- Trust Score (Trust Engine)
  +-- Relationship Distance (Relationship Engine)
  +-- Collaboration History (Trust Engine)
  +-- Skill Match Percentage (AI Engine)
  +-- Location Proximity (Organization Engine)
  +-- Past Success Rate (Opportunity Engine)
  +-- Response Rate (Communication Engine)
  +-- Availability (User profile)
  +-- Industry Relevance (Organization Engine)
  |
  v
Scored & Ranked Results (with explanations)
```

## API Contract

```
POST   /api/v1/recommendations/rank           — Rank items (given candidates)
POST   /api/v1/recommendations/personalized    — Get personalized recommendations
GET    /api/v1/recommendations/factors         — List ranking factors
PATCH  /api/v1/recommendations/profiles/:id    — Customize ranking profile
POST   /api/v1/recommendations/feedback        — Submit recommendation feedback
```

## Events

**Emits:**
- `Recommendation.Generated` — New recommendation created
- `Recommendation.Clicked` — User interacted with recommendation
- `Recommendation.Converted` — Recommendation led to an action

**Consumes:**
- `Opportunity.Matched` — Rank AI-generated matches
- `Discovery.Feed.Generated` — Rank discovery items
- `Relationship.Discovery.Suggested` — Rank connection suggestions

## Capability Registry

```
Recommendation Engine
+-- Rank Items (score and order candidates)
+-- Personalized Recommendations
+-- Custom Ranking Profiles
+-- Multi-Factor Scoring
+-- Explainable Rankings (factor breakdown)
+-- A/B Test Ranking Profiles
+-- Feedback Collection
+-- Ranking Analytics
```

## AI Integration

- Ranking profile optimization from user feedback
- Anomaly detection in ranking patterns
- Natural language explanation generation ("Recommended because...")

## Dependencies

- Trust Engine (trust scores)
- Relationship Engine (relationship distance)
- Discovery Engine (discovery signals)
- Communication Engine (response rates)
- AI Engine (skill match, semantic similarity)

## Consumers

- Opportunity Engine (rank matched candidates)
- Relationship Engine (rank connection suggestions)
- Discovery Engine (rank discovery feed)
- All products (recommendations in UI)

---

# Engine 17 — Context Engine (Future)

## Purpose

The Context Engine answers: **What is the full story of this relationship?**

It is the institutional memory of Yugrow. Instead of every product maintaining its own fragmented history, the Context Engine continuously builds a rich understanding of every relationship and opportunity by combining data from all other engines.

## Planned Data Model

| Entity | Description |
|--------|-------------|
| ContextIndex | Cross-engine index — entity ID, engine, event type, summary |
| RelationshipTimeline | Chronological history — when met, opportunities exchanged, collaborations, communications |
| AISummary | AI-generated summary — relationship overview, key events, trust signals |
| ContextQuery | Natural language query against cross-engine data |

## Planned Capabilities

- Cross-engine data correlation
- Relationship timeline generation
- AI-generated relationship summaries
- "What do we know about X?" — unified answer across all engines
- Context-aware AI recommendations

## Dependencies (Future)

- All engines (consumes events from all)

## Consumers (Future)

- AI Engine (context for better recommendations)
- All products (rich context without building it themselves)

---

# Engine 18 — Signal Engine (Future)

## Purpose

The Signal Engine answers: **What activity has occurred across the platform?**

It is a normalized signal layer. Every engine emits signals instead of requiring other engines to query them directly. The Recommendation Engine, AI Engine, and Intelligence Engine consume signals rather than querying individual engines.

## Signal Model

| Field | Description |
|-------|-------------|
| signalType | Normalized event type (e.g., "message.sent", "connection.accepted", "invoice.paid") |
| sourceEngine | Engine that emitted the signal |
| sourceId | Reference to the source event or record |
| actorId | Person who performed the action |
| targetEntityType | Entity affected (Person, Opportunity, Invoice, etc.) |
| targetEntityId | UUID of the affected entity |
| workspaceId | Tenant context |
| metadata | Additional signal data |
| timestamp | When the signal occurred |
| importance | 0.0 to 1.0 — computed from signal type and context |

## Examples

```
Signal: { type: "connection.accepted", actorId: "jay", targetEntityType: "Relationship" }
Signal: { type: "invoice.paid", actorId: "sarah", targetEntityType: "Invoice" }
Signal: { type: "broadcast.responded", actorId: "ravi", targetEntityType: "Opportunity" }
Signal: { type: "content.published", actorId: "jay", targetEntityType: "Article" }
```

## Activity Feed

Every Business Object has an Activity Feed powered by signals:

```
GET /api/v1/signals/feed/:entityType/:entityId
  -> Signals for a specific object, ordered by timestamp
```

This enables the Business Timeline — chronological history of every object across all engines.

## Benefits

- Recommendation Engine queries one signal store instead of 10 engines
- AI Engine builds context from a single signal timeline
- Activity Feed is universal across all objects
- New engines automatically contribute signals without integration work
- Analytics and Intelligence Engine consume normalized data

---

# Engine 19 — Intelligence Engine (Future)

## Purpose

The Intelligence Engine answers: **What should the business know?**

It owns derived insights, trends, patterns, predictions, KPIs, and benchmarks. It consumes signals and evidence but does not own operational data.

## Capabilities

- Trend detection ("Export opportunities increased 18%")
- Relationship health ("You haven't contacted XYZ for 8 months")
- Performance benchmarks ("Supplier response rate is declining")
- Predictive insights ("This event generated 46 new relationships last year")
- Anomaly detection ("Unusual broadcast response pattern detected")

---

> **This document is a living specification. Engine boundaries, API contracts, and event catalogs will evolve as implementation progresses. All changes must be reviewed by the Chief Architect and recorded as ADRs.**
