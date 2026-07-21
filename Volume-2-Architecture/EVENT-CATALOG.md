---
Title: Event Catalog
Version: 1.0
Status: Draft
Owner: Chief Architect
Last Updated: 2026-07-21
Dependencies:
  - Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md
  - Volume-2-Architecture/ENGINE-SPECIFICATIONS.md
Related Documents:
  - Volume-2-Architecture/DOMAIN-MODEL.md
---

# Event Catalog

> **The definitive catalog of all events in the Yugrow platform — who emits them, who consumes them, and what data they carry. Events follow the CloudEvents standard.**

---

## Table of Contents

| # | Event Source |
|---|-------------|
| 1 | Identity Engine Events |
| 2 | Organization Engine Events |
| 3 | Relationship Engine Events |
| 4 | Trust Engine Events |
| 5 | Opportunity Engine Events |
| 6 | Communication Engine Events |
| 7 | Workflow Engine Events |
| 8 | AI Engine Events |
| 9 | System Events |
| 10 | Cross-Engine Event Flows |

---

## Event Format (CloudEvents)

All events follow the CloudEvents 1.0 specification:

```json
{
  "specversion": "1.0",
  "id": "uuid",
  "source": "/yugrow/engine/{engine-name}",
  "type": "{engine}.{entity}.{action}",
  "datacontenttype": "application/json",
  "subject": "{entity-id}",
  "time": "2026-07-21T10:00:00Z",
  "data": {
    "orgId": "uuid",
    "actorId": "uuid",
    "payload": { }
  }
}
```

**Common Data Fields:**
| Field | Type | Description |
|-------|------|-------------|
| `orgId` | UUID | Tenant scope (null for platform events) |
| `actorId` | UUID | User who triggered the event |
| `payload` | Object | Event-specific data |

---

# 1. Identity Engine Events

## Identity.User.Registered
| Field | Description |
|-------|-------------|
| **Type** | `Identity.User.Registered` |
| **Emitted When** | A new user creates an account |
| **Consumed By** | Organization Engine, AI Engine |

**Payload:**
```json
{
  "userId": "uuid",
  "email": "user@example.com",
  "displayName": "John Doe",
  "authMethod": "email|google|magic-link",
  "timestamp": "2026-07-21T10:00:00Z"
}
```

## Identity.User.LoggedIn
| Field | Description |
|-------|-------------|
| **Type** | `Identity.User.LoggedIn` |
| **Emitted When** | Successful authentication |
| **Consumed By** | Audit, AI Engine (anomaly detection) |

**Payload:**
```json
{
  "userId": "uuid",
  "sessionId": "uuid",
  "ipAddress": "203.0.113.1",
  "deviceInfo": { "userAgent": "...", "deviceType": "mobile" },
  "authMethod": "password|google|magic-link|mfa",
  "timestamp": "2026-07-21T10:00:00Z"
}
```

## Identity.User.LoggedOut
| **Type** | `Identity.User.LoggedOut` |
| **Emitted When** | User explicitly logs out or session expires |
| **Consumed By** | Audit |

## Identity.User.Updated
| **Type** | `Identity.User.Updated` |
| **Emitted When** | User profile changes (name, avatar, settings) |
| **Consumed By** | Relationship Engine, Search Index |

## Identity.User.Deactivated
| **Type** | `Identity.User.Deactivated` |
| **Emitted When** | Account suspended or deleted |
| **Consumed By** | All engines (cleanup) |

## Identity.Role.Created
| **Type** | `Identity.Role.Created` |
| **Emitted When** | New role defined |
| **Consumed By** | Audit |

## Identity.Role.Assigned
| **Type** | `Identity.Role.Assigned` |
| **Emitted When** | Role assigned to a user |
| **Consumed By** | Audit, Notification Hub |

## Identity.MFA.Enabled
| **Type** | `Identity.MFA.Enabled` |
| **Emitted When** | User enables MFA |
| **Consumed By** | Audit, Security monitoring |

## Identity.Login.Failed
| **Type** | `Identity.Login.Failed` |
| **Emitted When** | Failed authentication attempt |
| **Consumed By** | Security monitoring, AI Engine (fraud detection) |

---

# 2. Organization Engine Events

## Organization.Tenant.Provisioned
| Field | Description |
|-------|-------------|
| **Type** | `Organization.Tenant.Provisioned` |
| **Emitted When** | New tenant created |
| **Consumed By** | Identity Engine, Billing, AI Engine |

**Payload:**
```json
{
  "tenantId": "uuid",
  "tenantName": "Acme Corp",
  "tier": "free|growth|business|enterprise",
  "ownerId": "uuid",
  "timestamp": "2026-07-21T10:00:00Z"
}
```

## Organization.Tenant.Updated
| **Type** | `Organization.Tenant.Updated` |
| **Emitted When** | Tenant settings changed |
| **Consumed By** | All engines (settings cache invalidation) |

## Organization.Tenant.Deactivated
| **Type** | `Organization.Tenant.Deactivated` |
| **Emitted When** | Tenant suspended or deleted |
| **Consumed By** | All engines (data isolation cleanup) |

## Organization.Member.Invited
| **Type** | `Organization.Member.Invited` |
| **Emitted When** | User invited to join org |
| **Consumed By** | Communication Engine (send invitation) |

## Organization.Member.Joined
| **Type** | `Organization.Member.Joined` |
| **Emitted When** | User accepts invitation |
| **Consumed By** | Relationship Engine, Team management |

## Organization.Member.Removed
| **Type** | `Organization.Member.Removed` |
| **Emitted When** | User removed from org |
| **Consumed By** | Relationship Engine, Opportunity Engine |

## Organization.Team.Created
| **Type** | `Organization.Team.Created` |
| **Emitted When** | New team formed |
| **Consumed By** | Identity Engine (default roles) |

## Organization.Subscription.Changed
| **Type** | `Organization.Subscription.Changed` |
| **Emitted When** | Plan upgraded/downgraded/cancelled |
| **Consumed By** | All engines (feature flag updates) |

---

# 3. Relationship Engine Events

## Relationship.Connected
| Field | Description |
|-------|-------------|
| **Type** | `Relationship.Connected` |
| **Emitted When** | Two entities establish a relationship |
| **Consumed By** | Trust Engine, Opportunity Engine, Communication Engine |

**Payload:**
```json
{
  "relationshipId": "uuid",
  "sourceUserId": "uuid",
  "targetUserId": "uuid",
  "type": "business-partner|customer|...",
  "context": { "source": "manual|checkin|referral", "sourceDetail": "..." },
  "timestamp": "2026-07-21T10:00:00Z"
}
```

## Relationship.Disconnected
| **Type** | `Relationship.Disconnected` |
| **Emitted When** | Relationship removed or archived |
| **Consumed By** | Trust Engine (recalculate scores), Opportunity Engine |

## Relationship.Updated
| **Type** | `Relationship.Updated` |
| **Emitted When** | Relationship metadata or type changes |
| **Consumed By** | AI Engine (context updates) |

## Relationship.Request.Sent
| **Type** | `Relationship.Request.Sent` |
| **Emitted When** | Connection request sent |
| **Consumed By** | Communication Engine (notify recipient) |

## Relationship.Request.Accepted
| **Type** | `Relationship.Request.Accepted` |
| **Emitted When** | Connection request accepted |
| **Consumed By** | Communication Engine, Trust Engine |

## Relationship.Request.Declined
| **Type** | `Relationship.Request.Declined` |
| **Emitted When** | Connection request declined |
| **Consumed By** | Communication Engine |

## Relationship.BusinessCard.Shared
| **Type** | `Relationship.BusinessCard.Shared` |
| **Emitted When** | Business card exchanged |
| **Consumed By** | AI Engine (context enrichment) |

## Relationship.Discovery.Suggested
| **Type** | `Relationship.Discovery.Suggested` |
| **Emitted When** | AI suggests a potential connection |
| **Consumed By** | Communication Engine (notify user) |

---

# 4. Trust Engine Events

## Trust.Reference.Requested
| Field | Description |
|-------|-------------|
| **Type** | `Trust.Reference.Requested` |
| **Emitted When** | Reference request sent |
| **Consumed By** | Communication Engine (notify reference provider) |

**Payload:**
```json
{
  "requestId": "uuid",
  "requesterId": "uuid",
  "targetId": "uuid",
  "relationshipId": "uuid",
  "context": "Seeking reference for partnership opportunity",
  "timestamp": "2026-07-21T10:00:00Z"
}
```

## Trust.Reference.Provided
| **Type** | `Trust.Reference.Provided` |
| **Emitted When** | Reference response submitted |
| **Consumed By** | Communication Engine (notify requester) |

## Trust.Reference.Verified
| **Type** | `Trust.Reference.Verified` |
| **Emitted When** | Reference authenticity verified |
| **Consumed By** | Opportunity Engine (trust verification completed) |

## Trust.Collaboration.Registered
| **Type** | `Trust.Collaboration.Registered` |
| **Emitted When** | New collaboration recorded |
| **Consumed By** | AI Engine (trust score update), Relationship Engine |

## Trust.Endorsement.Given
| **Type** | `Trust.Endorsement.Given` |
| **Emitted When** | Skill endorsement made |
| **Consumed By** | AI Engine (trust score update) |

## Trust.Score.Updated
| **Type** | `Trust.Score.Updated` |
| **Emitted When** | Trust score changes |
| **Consumed By** | Opportunity Engine (match ranking), AI Engine |

## Trust.Evidence.Added
| **Type** | `Trust.Evidence.Added` |
| **Emitted When** | New trust evidence submitted |
| **Consumed By** | AI Engine (score recalculation) |

## Trust.Verification.Completed
| **Type** | `Trust.Verification.Completed` |
| **Emitted When** | Trust check for an opportunity is done |
| **Consumed By** | Opportunity Engine (proceed in lifecycle) |

**Payload:**
```json
{
  "opportunityId": "uuid",
  "candidateId": "uuid",
  "trustScore": 0.85,
  "mutualConnections": 3,
  "verifiedReferences": 2,
  "riskFlags": [],
  "summary": "Candidate has strong mutual connections and verified references",
  "timestamp": "2026-07-21T10:00:00Z"
}
```

---

# 5. Opportunity Engine Events

## Opportunity.Created
| Field | Description |
|-------|-------------|
| **Type** | `Opportunity.Created` |
| **Emitted When** | New opportunity posted |
| **Consumed By** | AI Engine (categorization, matching) |

**Payload:**
```json
{
  "opportunityId": "uuid",
  "type": "supplier|buyer|investor|job|...",
  "title": "Rice Importer USA",
  "creatorId": "uuid",
  "orgId": "uuid",
  "visibility": "public|connections|custom",
  "timestamp": "2026-07-21T10:00:00Z"
}
```

## Opportunity.Published
| **Type** | `Opportunity.Published` |
| **Emitted When** | Opportunity made visible per broadcast policy |
| **Consumed By** | Broadcast Engine, AI Engine |

## Opportunity.Matched
| **Type** | `Opportunity.Matched` |
| **Emitted When** | AI finds candidate matches |
| **Consumed By** | Communication Engine (notify creator), Relationship Engine |

## Opportunity.Interest.Registered
| **Type** | `Opportunity.Interest.Registered` |
| **Emitted When** | Candidate expresses interest |
| **Consumed By** | Trust Engine (trigger verification), Communication Engine |

## Opportunity.Broadcast.Sent
| **Type** | `Opportunity.Broadcast.Sent` |
| **Emitted When** | Broadcast dispatched at a level |
| **Consumed By** | Communication Engine, Analytics |

## Opportunity.Stage.Changed
| **Type** | `Opportunity.Stage.Changed` |
| **Emitted When** | Lifecycle stage advances |
| **Consumed By** | Workflow Engine (trigger automation), Communication Engine |

**Payload:**
```json
{
  "opportunityId": "uuid",
  "previousStage": "matching",
  "newStage": "interest",
  "actorId": "uuid",
  "timestamp": "2026-07-21T10:00:00Z"
}
```

## Opportunity.Deal.Created
| **Type** | `Opportunity.Deal.Created` |
| **Emitted When** | Deal initiated from opportunity |
| **Consumed By** | Workflow Engine, Communication Engine, Analytics |

## Opportunity.Deal.Won
| **Type** | `Opportunity.Deal.Won` |
| **Emitted When** | Deal successfully closed |
| **Consumed By** | Relationship Engine (strengthen relationship), Trust Engine, Analytics |

## Opportunity.Deal.Lost
| **Type** | `Opportunity.Deal.Lost` |
| **Emitted When** | Deal lost |
| **Consumed By** | Analytics, AI Engine (learning) |

## Opportunity.Closed
| **Type** | `Opportunity.Closed` |
| **Emitted When** | Opportunity finalized (any outcome) |
| **Consumed By** | Analytics, Search Index |

---

# 6. Communication Engine Events

## Communication.Conversation.Started
| Field | Description |
|-------|-------------|
| **Type** | `Communication.Conversation.Started` |
| **Emitted When** | New conversation created |
| **Consumed By** | Relationship Engine (context enrichment) |

## Communication.Message.Sent
| **Type** | `Communication.Message.Sent` |
| **Emitted When** | Message delivered to channel |
| **Consumed By** | AI Engine (sentiment analysis, smart reply), Opportunity Engine (activity log) |

## Communication.Message.Read
| **Type** | `Communication.Message.Read` |
| **Emitted When** | Message marked as read |
| **Consumed By** | Analytics (engagement metrics) |

## Communication.Notification.Sent
| **Type** | `Communication.Notification.Sent` |
| **Emitted When** | Notification dispatched |
| **Consumed By** | Analytics (delivery metrics) |

## Communication.Notification.Delivered
| **Type** | `Communication.Notification.Delivered` |
| **Emitted When** | Notification confirmed received |
| **Consumed By** | Analytics |

## Communication.Channel.Linked
| **Type** | `Communication.Channel.Linked` |
| **Emitted When** | External channel (WhatsApp, email) connected |
| **Consumed By** | Communication Engine (enable channel) |

---

# 7. Workflow Engine Events

## Workflow.Created
| **Type** | `Workflow.Created` |
| **Emitted When** | New workflow defined |
| **Consumed By** | Audit |

## Workflow.Triggered
| **Type** | `Workflow.Triggered` |
| **Emitted When** | Workflow activated by event |
| **Consumed By** | Audit, Analytics |

## Workflow.Action.Executed
| **Type** | `Workflow.Action.Executed` |
| **Emitted When** | Workflow action completed |
| **Consumed By** | Audit, Source engine (if action affects it) |

## Workflow.Action.Failed
| **Type** | `Workflow.Action.Failed` |
| **Emitted When** | Workflow action errored |
| **Consumed By** | Audit, Notification Hub (alert admin) |

## Workflow.Completed
| **Type** | `Workflow.Completed` |
| **Emitted When** | All workflow actions done |
| **Consumed By** | Audit, Analytics |

## Workflow.Disabled
| **Type** | `Workflow.Disabled` |
| **Emitted When** | Workflow turned off |
| **Consumed By** | Audit |

---

# 8. AI Engine Events

## AI.Request.Started
| **Type** | `AI.Request.Started` |
| **Emitted When** | AI request initiated |
| **Consumed By** | Token tracking, Audit |

## AI.Request.Completed
| **Type** | `AI.Request.Completed` |
| **Emitted When** | AI response received |
| **Consumed By** | Token tracking, Analytics (latency, cost) |

**Payload:**
```json
{
  "requestId": "uuid",
  "provider": "openai|anthropic|deepseek",
  "model": "gpt-4o|claude-4|deepseek-v3",
  "promptTokens": 150,
  "completionTokens": 320,
  "totalTokens": 470,
  "cost": 0.0094,
  "latencyMs": 1240,
  "cached": false,
  "timestamp": "2026-07-21T10:00:00Z"
}
```

## AI.Request.Failed
| **Type** | `AI.Request.Failed` |
| **Emitted When** | AI request errored |
| **Consumed By** | Token tracking, Fallback handler |

## AI.Token.Threshold.Exceeded
| **Type** | `AI.Token.Threshold.Exceeded` |
| **Emitted When** | Tenant approaching token limit |
| **Consumed By** | Communication Engine (notify admin), Billing |

## AI.Guardrail.Triggered
| **Type** | `AI.Guardrail.Triggered` |
| **Emitted When** | Content safety rule activated |
| **Consumed By** | Audit, Security monitoring |

## AI.Agent.Action.Taken
| **Type** | `AI.Agent.Action.Taken` |
| **Emitted When** | AI agent performed an action |
| **Consumed By** | Audit, Source engine |

---

# 9. System Events

## Engine.Health.Changed
| **Type** | `System.Engine.Health.Changed` |
| **Emitted When** | Engine health status changes |
| **Consumed By** | Monitoring, Orchestration |

## Tenant.Provisioned
| **Type** | `System.Tenant.Provisioned` |
| **Emitted When** | New tenant fully provisioned |
| **Consumed By** | Analytics, Billing |

## System.Configuration.Changed
| **Type** | `System.Configuration.Changed` |
| **Emitted When** | Platform-level configuration updated |
| **Consumed By** | All engines (reload config) |

---

# 10. Cross-Engine Event Flows

## Flow: New User Registration → Opportunity Discovery

```
Identity.User.Registered
  ↓
Organization Engine: Create default membership
  ↓
AI Engine: Analyze user profile, identify opportunity types
  ↓
Opportunity Engine: Find matching opportunities
  ↓
Communication Engine: Send personalized opportunity digest
```

## Flow: Opportunity Created → Trust Verification

```
Opportunity.Created
  ↓
AI Engine: Categorize and embed
  ↓
Opportunity Engine: Match candidates
  ↓
Broadcast dispatched (per BroadcastPolicy)
  ↓
Opportunity.Interest.Registered
  ↓
Trust Engine: Trigger trust verification
  ↓
Trust.Verification.Completed
  ↓
Opportunity Engine: Update candidate ranking with trust data
  ↓
Communication Engine: Notify opportunity creator
```

## Flow: Deal Won → Relationship Strengthened

```
Opportunity.Deal.Won
  ↓
Relationship Engine: Strengthen relationship score
  ↓
Trust Engine: Record successful collaboration
  ↓
Trust.Score.Updated (for both parties)
  ↓
Workflow Engine: Trigger post-deal workflow
  ├── Communication Engine: Send thank-you
  ├── Create follow-up opportunity
  └── Analytics: Record revenue event
```

## Flow: CheckIN Event → New Connections

```
CheckIN: Event.Attended
  ↓
Relationship Engine: Add relationship context
  ├── Create new relationships (met at event)
  └── Strengthen existing relationships (attended same event)
  ↓
Trust Engine: Seed initial trust signal
  ↓
Opportunity Engine: Suggest relevant opportunities
```

---

> **This event catalog is the definitive reference for all inter-engine communication. Events must follow the CloudEvents format. New events require ADR approval.**
