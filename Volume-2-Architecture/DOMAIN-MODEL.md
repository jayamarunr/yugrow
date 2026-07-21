---
Title: Core Domain Model
Version: 1.0
Status: Draft
Owner: Chief Architect
Last Updated: 2026-07-21
Dependencies:
  - Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md
  - Volume-2-Architecture/ENGINE-SPECIFICATIONS.md
Related Documents:
  - Volume-2-Architecture/EVENT-CATALOG.md
  - Volume-2-Architecture/DATABASE-DESIGN.md
---

# Yugrow Core Domain Model

> **The authoritative entity definitions for the Yugrow platform. Every database schema, every API response, every event payload derives from this model.**

---

## Table of Contents

| # | Domain |
|---|--------|
| 1 | Platform Foundation |
| 2 | Identity Domain |
| 3 | Organization Domain |
| 4 | Relationship Domain |
| 5 | Trust Domain |
| 6 | Opportunity Domain |
| 7 | Communication Domain |
| 8 | Workflow Domain |
| 9 | AI Domain |
| 10 | Context Domain (Future) |

---

## Entity Definition Template

Every entity in this model is defined with:

```
EntityName
├── id: UUID (PK)
├── orgId: UUID (tenant scope) — except platform-level entities
├── Attributes — core fields
├── Relations — associations to other entities
├── Timestamps — createdAt, updatedAt, deletedAt
└── Indexes — query optimization indices
```

---

# 1. Platform Foundation

## BaseEntity (Abstract)

All entities inherit these base fields:

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | Primary key |
| createdAt | DateTime | Record creation timestamp |
| updatedAt | DateTime | Last update timestamp |
| deletedAt | DateTime? | Soft delete timestamp |
| version | Int | Optimistic concurrency control |

## TenantScopedEntity (Abstract)

Used for all tenant-scoped entities:

| Field | Type | Description |
|-------|------|-------------|
| orgId | UUID | Tenant ID for multi-tenant isolation |

---

# 2. Identity Domain

Engine: **Identity Engine**

## User

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | UUID | PK | |
| email | String | Unique, indexed | Verified email address |
| passwordHash | String | Not null | Argon2id hash |
| displayName | String | Not null | Public-facing name |
| avatarUrl | String? | | Profile image URL |
| phone | String? | | Phone number |
| status | Enum | Active, Suspended, Deactivated | Account state |
| locale | String | Default: 'en' | Language preference |
| timezone | String | Default: 'UTC' | Timezone |
| lastLoginAt | DateTime? | | Last successful login |
| emailVerified | Boolean | Default: false | Email verification status |
| phoneVerified | Boolean | Default: false | Phone verification status |

**Relations:**
- Has many `Membership` (via Organization Engine)
- Has many `Session`
- Has many `RoleAssignment`
- Has one `UserProfile`

## UserProfile

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| userId | UUID | FK → User |
| headline | String? | Professional headline |
| bio | String? | Biography or summary |
| industry | String? | Industry classification |
| skills | String[] | List of skills |
| socialLinks | Json | Social media URLs |
| company | String? | Current company |
| position | String? | Current position |
| privacySettings | Json | Per-field visibility controls |

## Role

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| name | String | Role name (admin, manager, member, viewer) |
| description | String? | Human-readable description |
| isSystem | Boolean | System-defined (cannot delete) |
| orgId | UUID? | Null for global roles |

## Permission

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| resource | String | Engine or resource name |
| action | String | create, read, update, delete, manage |
| description | String? | Human-readable description |
| conditions | Json? | ABAC conditions (future) |

## RoleAssignment

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| userId | UUID | FK → User |
| roleId | UUID | FK → Role |
| orgId | UUID | Scope of assignment |
| teamId | UUID? | Optional team-level scope |

## Session

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| userId | UUID | FK → User |
| refreshToken | String | Hashed refresh token |
| deviceInfo | Json | User agent, device type, OS |
| ipAddress | String | Login IP |
| expiresAt | DateTime | Session expiry |
| lastActivityAt | DateTime | Last request timestamp |
| isRevoked | Boolean | Manual revocation flag |

## APIKey

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| userId | UUID | FK → User |
| name | String | Key identifier |
| keyHash | String | Hashed API key value |
| permissions | String[] | Scoped permissions |
| expiresAt | DateTime? | Optional expiry |
| lastUsedAt | DateTime? | Last usage timestamp |
| isRevoked | Boolean | Revocation flag |

## MFASetting

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| userId | UUID | FK → User (unique) |
| method | Enum | TOTP, SMS, WebAuthn |
| isEnabled | Boolean | |
| secret | String | Encrypted TOTP secret |
| backupCodes | String[] | Hashed backup codes |

---

# 3. Organization Domain

Engine: **Organization Engine**

## Tenant

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| name | String | Organization name |
| slug | String | Unique URL-friendly identifier |
| logoUrl | String? | Organization logo |
| status | Enum | Active, Trial, Suspended, Cancelled |
| tier | Enum | Free, Growth, Business, Enterprise |
| settings | Json | Locale, timezone, currency, branding |

## BusinessGroup

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| tenantId | UUID | FK → Tenant |
| name | String | Group name |
| type | Enum | Holding, Parent, Division |

## LegalEntity

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| businessGroupId | UUID | FK → BusinessGroup |
| name | String | Legal name |
| registrationNumber | String | Company registration |
| taxId | String | Tax/VAT/GST ID |
| address | Json | Registered address |
| country | String | Country of registration |

## Brand

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| legalEntityId | UUID | FK → LegalEntity |
| name | String | Brand name |
| domain | String? | Website domain |
| logoUrl | String? | Brand logo |
| brandColor | String? | Primary brand color |

## Branch

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| brandId | UUID | FK → Brand |
| name | String | Branch name |
| address | Json | Physical address |
| timezone | String | Local timezone |
| phone | String? | Branch contact |
| isHeadOffice | Boolean | Head office flag |

## Department

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| branchId | UUID | FK → Branch |
| name | String | Department name |
| headUserId | UUID? | FK → User (department head) |
| parentDepartmentId | UUID? | Self-referential hierarchy |

## Team

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| departmentId | UUID | FK → Department |
| name | String | Team name |
| leadUserId | UUID? | FK → User (team lead) |
| parentTeamId | UUID? | Self-referential |

## Membership

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| userId | UUID | FK → User |
| tenantId | UUID | FK → Tenant |
| teamId | UUID? | FK → Team |
| role | Enum | Admin, Manager, Member, Viewer |
| status | Enum | Invited, Active, Suspended |
| joinedAt | DateTime | Membership start |
| invitedBy | UUID? | FK → User (inviter) |

## Subscription

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| tenantId | UUID | FK → Tenant (unique) |
| plan | Enum | Free, Growth, Business, Enterprise |
| status | Enum | Active, PastDue, Cancelled, Expired |
| billingCycle | Enum | Monthly, Annual |
| features | Json | Enabled feature flags |
| currentPeriodStart | DateTime | |
| currentPeriodEnd | DateTime | |
| canceledAt | DateTime? | |

---

# 4. Relationship Domain

Engine: **Relationship Engine**

## Relationship

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| orgId | UUID | Tenant scope |
| sourceUserId | UUID | FK → User |
| targetUserId | UUID | FK → User |
| sourceEntityType | Enum | User, Organization |
| targetEntityType | Enum | User, Organization |
| typeId | UUID | FK → RelationshipType |
| strength | Float | 0.0 to 1.0 computed score |
| status | Enum | Active, Archived, Blocked |
| sourceNotes | String? | Private notes from source |
| targetNotes | String? | Private notes from target |

**Indexes:** `(sourceUserId, targetUserId)` unique, `(orgId, typeId)`, `(sourceUserId, strength)`

## RelationshipType

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| name | String | Type name |
| category | Enum | Professional, Personal, Community |
| isSystem | Boolean | System-defined type |
| description | String? | |

**Predefined types:** Business Partner, Customer, Supplier, Employee, Vendor, Friend, Mentor, Investor, Advisor, Community Member, Met at Event

## RelationshipContext

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| relationshipId | UUID | FK → Relationship |
| source | Enum | Manual, CheckIn, Referral, Website, Invite, Import |
| sourceDetail | String? | Event name, referral source, etc. |
| firstMetAt | DateTime? | When the connection was made |
| tags | String[] | User-defined tags |
| notes | String? | Free-form notes |

## BusinessCard

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| userId | UUID | FK → User (owner) |
| name | String | Name on card |
| title | String | Job title |
| company | String | Company name |
| phone | String | Phone number |
| email | String | Email address |
| website | String? | Website URL |
| socialLinks | Json | Social media profiles |
| avatarUrl | String? | Photo |
| design | Json | Card design preferences |

## BusinessCardCollection

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| userId | UUID | FK → User (collector) |
| cardId | UUID | FK → BusinessCard (shared card) |
| receivedAt | DateTime | |
| notes | String? | Private notes about this card |

## ConnectionRequest

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| orgId | UUID | Tenant scope |
| senderId | UUID | FK → User |
| recipientId | UUID | FK → User |
| message | String? | Personal message |
| status | Enum | Pending, Accepted, Declined, Expired |
| relationshipTypeId | UUID? | Proposed type |
| expiresAt | DateTime | |

---

# 5. Trust Domain

Engine: **Trust Engine**

## ReferenceRequest

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| orgId | UUID | Tenant scope |
| requesterId | UUID | FK → User (seeking reference) |
| targetId | UUID | FK → User (being referenced) |
| relationshipId | UUID | FK → Relationship |
| context | String | Why the reference is needed |
| dimensions | Json | Areas to evaluate (reliability, expertise, communication, professionalism) |
| status | Enum | Requested, Provided, Declined, Verified, Expired |
| expiresAt | DateTime | |

## ReferenceResponse

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| requestId | UUID | FK → ReferenceRequest |
| providerId | UUID | FK → User (person providing reference) |
| ratings | Json | Dimension ratings (1-5) |
| comments | String | Detailed feedback |
| isVerified | Boolean | Authenticity verified |
| submittedAt | DateTime | |

## Collaboration

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| orgId | UUID | Tenant scope |
| participants | UUID[] | FK → User (involved parties) |
| projectName | String | Name of project or work |
| description | String | Work description |
| startDate | DateTime | |
| endDate | DateTime? | |
| outcome | Enum | Successful, Partial, Unsuccessful |
| verifierId | UUID? | FK → User (who verified this) |
| evidenceUrls | String[] | Supporting documents |

## Endorsement

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| orgId | UUID | Tenant scope |
| endorserId | UUID | FK → User |
| targetId | UUID | FK → User |
| skill | String | Endorsed skill or quality |
| context | String? | How they know this skill |
| weight | Float | Default 1.0 (based on endorser's trust score) |

## TrustEvidence

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| userId | UUID | FK → User |
| type | Enum | Certificate, License, Verification, Portfolio, Testimonial |
| title | String | Evidence title |
| description | String? | |
| fileUrl | String | Document or verification link |
| issuedAt | DateTime? | |
| expiresAt | DateTime? | |
| isVerified | Boolean | Authenticity check passed |

## TrustScore

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| userId | UUID | FK → User (unique) |
| overall | Float | 0.0 to 1.0 composite score |
| reliability | Float | Dimension score |
| expertise | Float | Dimension score |
| communication | Float | Dimension score |
| professionalism | Float | Dimension score |
| confidence | Float | How confident in this score |
| updatedAt | DateTime | |

## ReputationHistory

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| userId | UUID | FK → User |
| previousScore | Float | Score before change |
| newScore | Float | Score after change |
| delta | Float | Change amount |
| reason | String | What caused the change |
| sourceEvent | Json | Reference to triggering event |
| timestamp | DateTime | |

---

# 6. Opportunity Domain

Engine: **Opportunity Engine**

## Opportunity

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| orgId | UUID | Tenant scope |
| typeId | UUID | FK → OpportunityType |
| title | String | Opportunity title |
| description | String | Detailed description |
| status | Enum | Draft, Published, Paused, Closed |
| stageId | UUID | FK → OpportunityStage |
| creatorId | UUID | FK → User |
| ownerId | UUID | FK → User (responsible person) |
| visibility | Enum | Public, Connections, Custom |
| tags | String[] | |
| budget | Decimal? | Budget or value range |
| currency | String | |
| location | Json? | Geographic preference |
| expiresAt | DateTime? | |
| metadata | Json | Type-specific fields |

## OpportunityType

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| name | String | Type name |
| icon | String | Icon identifier |
| schema | Json | Type-specific field definitions |
| isSystem | Boolean | |

**Predefined types:** Employee, Supplier, Buyer, Investor, Distributor, Customer, Speaker, Freelancer, Mentor, Franchise, Manufacturer

## OpportunityStage

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| name | String | Stage name |
| order | Int | Display order |
| typeId | UUID | FK → OpportunityType |
| isFinal | Boolean | Terminal stage |

**Default stages:** Draft → Published → Matching → Interest → Evaluation → Negotiation → Deal → Project → Closed

## BroadcastPolicy

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| opportunityId | UUID | FK → Opportunity |
| levels | Json[] | Array of broadcast level configs |
| strategy | Enum | Sequential, Simultaneous, AI-Optimized |

## BroadcastLevel

| Field | Type | Description |
|-------|------|-------------|
| level | Int | 1-8 |
| audience | Enum | Connections, Mutual, Nearby, City, State, Country, Region, Global |
| delayMinutes | Int | Delay before broadcasting to this level |
| budget | Decimal? | Cost for this level |
| priority | Int | Priority ranking |
| expiresAt | DateTime? | Level expiry |

## OpportunityInterest

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| opportunityId | UUID | FK → Opportunity |
| userId | UUID | FK → User |
| message | String? | Expression of interest |
| status | Enum | Pending, Reviewed, Shortlisted, Rejected, Accepted |
| matchScore | Float? | AI match score at time of interest |
| submittedAt | DateTime | |
| reviewedAt | DateTime? | |

## OpportunityMatch

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| opportunityId | UUID | FK → Opportunity |
| candidateId | UUID | FK → User |
| score | Float | Match score (0.0 to 1.0) |
| reasoning | String | AI explanation of the match |
| matchedDimensions | Json | Which criteria matched |
| isAutoBroadcast | Boolean | Generated by broadcast |
| createdAt | DateTime | |

## Deal (Thin CRM Layer)

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| opportunityId | UUID | FK → Opportunity |
| orgId | UUID | Tenant scope |
| name | String | Deal name |
| value | Decimal | Deal value |
| currency | String | |
| probability | Int | Win probability percentage |
| expectedCloseAt | DateTime | |
| stage | Enum | Qualification, Proposal, Negotiation, Won, Lost |
| ownerId | UUID | FK → User |

## Pipeline (Thin CRM Layer)

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| orgId | UUID | Tenant scope |
| name | String | Pipeline name |
| stages | Json[] | Custom stage definitions |
| isDefault | Boolean | Default pipeline for org |

## OpportunityActivity

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| opportunityId | UUID | FK → Opportunity |
| type | Enum | StageChange, Interest, Communication, Note, System |
| data | Json | Activity payload |
| userId | UUID | FK → User (who performed) |
| timestamp | DateTime | |

---

# 7. Communication Domain

Engine: **Communication Engine**

## Conversation

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| orgId | UUID | Tenant scope |
| subject | String? | Conversation subject |
| participants | UUID[] | FK → User |
| channelType | Enum | Chat, Email, WhatsApp, SMS |
| status | Enum | Active, Archived, Closed |
| metadata | Json | Channel-specific data |
| lastMessageAt | DateTime | |

## Message

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| conversationId | UUID | FK → Conversation |
| senderId | UUID | FK → User |
| body | String | Message content |
| attachments | Json[] | File attachments |
| status | Enum | Sending, Sent, Delivered, Read, Failed |
| externalId | String? | Provider-specific message ID |
| metadata | Json | Channel-specific metadata |
| sentAt | DateTime | |

## Notification

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| userId | UUID | FK → User (recipient) |
| channel | Enum | Push, Email, SMS, InApp |
| templateId | UUID? | FK → Template |
| title | String | Notification title |
| body | String | Notification body |
| data | Json | Action payload |
| status | Enum | Queued, Sent, Delivered, Read, Failed |
| readAt | DateTime? | |
| externalId | String? | Provider message ID |

## NotificationTemplate

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| orgId | UUID | Tenant scope |
| name | String | Template name |
| channel | Enum | Push, Email, SMS, InApp |
| subject | String? | Email subject |
| body | String | Template body with variables |
| variables | String[] | Expected variable names |

---

# 8. Workflow Domain

Engine: **Workflow Engine**

## Workflow

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| orgId | UUID | Tenant scope |
| name | String | Workflow name |
| description | String? | |
| isActive | Boolean | Enabled/disabled |
| trigger | Json | Event trigger configuration |
| conditions | Json[] | AND/OR condition tree |
| actions | Json[] | Ordered action list |
| lastExecutedAt | DateTime? | |
| executionCount | Int | |

## WorkflowExecution

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| workflowId | UUID | FK → Workflow |
| triggerEvent | Json | The event that triggered this |
| status | Enum | Running, Completed, Failed, Cancelled |
| actionsResults | Json[] | Per-action outcome |
| startedAt | DateTime | |
| completedAt | DateTime? | |
| error | String? | Error message if failed |

---

# 9. AI Domain

Engine: **AI Engine**

## AIProvider

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| name | String | Provider name |
| baseUrl | String | API endpoint |
| apiKeyRef | String | Reference to vault-stored key |
| models | Json[] | Available models |
| isActive | Boolean | |

## Prompt

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| orgId | UUID | Tenant scope |
| name | String | Prompt name |
| currentVersionId | UUID | FK → PromptVersion |
| category | String | Use case category |

## PromptVersion

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| promptId | UUID | FK → Prompt |
| version | Int | Version number |
| content | String | Prompt template |
| variables | String[] | Template variables |
| model | String | Target model |
| temperature | Float | |
| maxTokens | Int | |
| authorId | UUID | FK → User |
| changelog | String | What changed |

## Agent

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| orgId | UUID | Tenant scope |
| name | String | Agent name |
| instructions | String | System prompt |
| model | String | Assigned model |
| tools | Json[] | Available tools |
| knowledgeBaseIds | UUID[] | Linked knowledge bases |
| isActive | Boolean | |

## KnowledgeBase

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| orgId | UUID | Tenant scope |
| name | String | Knowledge base name |
| chunkingStrategy | Enum | Fixed, Semantic, Sentence |
| embeddingModel | String | |

## KnowledgeDocument

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| knowledgeBaseId | UUID | FK → KnowledgeBase |
| filename | String | Original filename |
| contentType | String | MIME type |
| content | Text | Extracted text |
| chunkCount | Int | Number of chunks |
| status | Enum | Processing, Ready, Failed |

## TokenUsage

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| orgId | UUID | Tenant scope |
| userId | UUID? | FK → User |
| provider | String | AI provider |
| model | String | Model name |
| promptTokens | Int | |
| completionTokens | Int | |
| totalTokens | Int | |
| cost | Decimal | Calculated cost |
| timestamp | DateTime | |

## GuardrailRule

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| orgId | UUID? | Null for global rules |
| category | Enum | PII, Profanity, Violence, Hate, Sexual, Custom |
| action | Enum | Block, Warn, Log |
| severity | Enum | Low, Medium, High |
| isActive | Boolean | |

---

# 10. Context Domain (Future)

Engine: **Context Engine**

## ContextIndex

| Field | Type | Description |
|-------|------|-------------|
| id | UUID | PK |
| entityId | UUID | Referenced entity |
| entityType | Enum | User, Relationship, Opportunity |
| engine | String | Source engine |
| eventType | String | Source event type |
| summary | Text | AI-generated summary |
| timestamp | DateTime | |

> **This domain model is the authoritative reference for all database schemas. Changes must be reviewed by the Chief Architect and reflected in Prisma migrations.**
