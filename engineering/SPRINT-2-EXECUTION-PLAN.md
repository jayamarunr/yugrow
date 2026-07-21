---
Title: Sprint 2 Execution Plan — Relationship Engine
Version: 1.0
Status: Draft — Pending Review
Owner: Chief Architect
Date: 2026-07-22
Dependencies: Sprint 1 (Identity, Workspace, Permission, Organization, Audit, File, Edge)
---

# Sprint 2 Execution Plan

> **Build the Relationship Engine — Yugrow's most important data store.**

---

## Overview

**Goal:** Build the Relationship Engine that stores rich relationships (not flat contacts) with context, types, strength scoring, business cards, connection requests, and discovery.

**Why Sprint 2?** Everything depends on relationships — CheckIN, Broadcast, CRM, Trust, Communication all consume the relationship graph. Building it now unlocks every downstream engine.

**Estimated Effort:** 2-3 weeks for a senior developer / AI pairing.

---

## 1. Prisma Models

### New Models

```prisma
model RelationshipType {
  id          String   @id @default(uuid())
  name        String   @unique  // "Business Partner", "Customer", "Supplier", etc.
  category    String   // "Professional", "Personal", "Community"
  description String?
  isSystem    Boolean  @default(false)

  relationships Relationship[]
}

model Relationship {
  id              String             @id @default(uuid())
  workspaceId     String
  sourcePersonId  String
  targetPersonId  String
  typeId          String
  strength        Float              @default(0.5)  // 0.0 to 1.0, AI-computed
  status          RelationshipStatus @default(ACTIVE)
  sourceNotes     String?
  targetNotes     String?

  type            RelationshipType   @relation(fields: [typeId], references: [id])

  createdAt       DateTime           @default(now())
  updatedAt       DateTime           @updatedAt
  deletedAt       DateTime?

  @@unique([workspaceId, sourcePersonId, targetPersonId])
  @@index([workspaceId, sourcePersonId])
  @@index([workspaceId, targetPersonId])
  @@index([workspaceId, typeId])
  @@index([workspaceId, strength])
}

enum RelationshipStatus {
  ACTIVE
  ARCHIVED
  BLOCKED
}

model RelationshipContext {
  id              String   @id @default(uuid())
  relationshipId  String
  source          String   // "manual", "checkin", "referral", "website", "invite", "import", "api"
  sourceDetail    String?  // Event name, referral source, etc.
  firstMetAt      DateTime?
  tags            String[] // User-defined tags
  notes           String?

  relationship    Relationship @relation(fields: [relationshipId], references: [id])

  createdAt       DateTime @default(now())

  @@index([relationshipId])
}

model ConnectionRequest {
  id              String   @id @default(uuid())
  workspaceId     String
  senderId        String
  recipientId     String
  message         String?
  status          ConnectionRequestStatus @default(PENDING)
  relationshipTypeId String?
  expiresAt       DateTime?

  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt

  @@index([workspaceId, recipientId, status])
  @@index([workspaceId, senderId])
}

enum ConnectionRequestStatus {
  PENDING
  ACCEPTED
  DECLINED
  EXPIRED
}

model BusinessCard {
  id          String   @id @default(uuid())
  workspaceId String
  personId    String   // Owner of this card
  name        String
  title       String?
  company     String?
  phone       String?
  email       String?
  website     String?
  socialLinks Json?    @default("{}")
  avatarUrl   String?
  design      Json?    @default("{}")

  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
  deletedAt   DateTime?

  @@index([workspaceId])
  @@index([personId])
}

model BusinessCardCollection {
  id          String   @id @default(uuid())
  collectorId String   // Person who collected this card
  cardId      String
  notes       String?

  collectedAt DateTime @default(now())

  @@unique([collectorId, cardId])
}
```

### Relationship Type Seed Data

```typescript
const relationshipTypes = [
  { name: 'Business Partner', category: 'Professional', isSystem: true },
  { name: 'Customer', category: 'Professional', isSystem: true },
  { name: 'Supplier', category: 'Professional', isSystem: true },
  { name: 'Employee', category: 'Professional', isSystem: true },
  { name: 'Vendor', category: 'Professional', isSystem: true },
  { name: 'Friend', category: 'Personal', isSystem: true },
  { name: 'Mentor', category: 'Professional', isSystem: true },
  { name: 'Investor', category: 'Professional', isSystem: true },
  { name: 'Advisor', category: 'Professional', isSystem: true },
  { name: 'Community Member', category: 'Community', isSystem: true },
  { name: 'Met at Event', category: 'Professional', isSystem: true },
];
```

---

## 2. Module Structure

```
apps/api/src/modules/relationship/
├── relationship.module.ts
├── relationship.controller.ts      # HTTP endpoints
├── relationship.service.ts         # Business logic
│
├── dto/
│   ├── create-relationship.dto.ts
│   ├── update-relationship.dto.ts
│   ├── create-connection-request.dto.ts
│   ├── create-business-card.dto.ts
│   └── query-relationships.dto.ts
│
├── interfaces/
│   └── relationship-service.interface.ts
│
├── events/
│   └── relationship.events.ts
│
├── capabilities/
│   └── index.ts
│
├── test/
│   ├── relationship.service.spec.ts
│   └── relationship.controller.spec.ts
│
└── README.md
```

---

## 3. API Contract

### Relationships

| Method | Path | Description | Capability |
|--------|------|-------------|------------|
| GET | `/api/v1/relationships` | List my relationships (paginated) | `relationship.graph.read` |
| GET | `/api/v1/relationships/:id` | Get relationship details | `relationship.graph.read` |
| POST | `/api/v1/relationships` | Create relationship directly | `relationship.graph.create` |
| PATCH | `/api/v1/relationships/:id` | Update relationship | `relationship.graph.update` |
| DELETE | `/api/v1/relationships/:id` | Remove relationship (soft) | `relationship.graph.delete` |
| GET | `/api/v1/relationships/mutual/:personId` | Find mutual connections | `relationship.graph.read` |
| GET | `/api/v1/relationships/network/:personId` | View network graph | `relationship.graph.read` |
| GET | `/api/v1/relationships/stats` | Network statistics | `relationship.graph.read` |

### Relationship Types

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/relationships/types` | List relationship types |

### Connection Requests

| Method | Path | Description | Capability |
|--------|------|-------------|------------|
| POST | `/api/v1/connections/request` | Send connection request | `relationship.connections.request` |
| PATCH | `/api/v1/connections/request/:id` | Accept/decline request | `relationship.connections.respond` |

### Business Cards

| Method | Path | Description | Capability |
|--------|------|-------------|------------|
| POST | `/api/v1/business-cards` | Create business card | `relationship.cards.create` |
| GET | `/api/v1/business-cards` | List my cards | `relationship.cards.read` |
| POST | `/api/v1/business-cards/share` | Share card with someone | `relationship.cards.share` |

---

## 4. Events

### Emitted

| Event | When | Payload |
|-------|------|---------|
| `Relationship.Connected` | Two entities connected | relationshipId, sourcePersonId, targetPersonId, type |
| `Relationship.Disconnected` | Relationship removed | relationshipId |
| `Relationship.Updated` | Metadata changed | relationshipId, changes |
| `Relationship.Request.Sent` | Connection request sent | requestId, senderId, recipientId |
| `Relationship.Request.Accepted` | Request accepted | requestId, relationshipId |
| `Relationship.Request.Declined` | Request declined | requestId |
| `Relationship.BusinessCard.Shared` | Card exchanged | cardId, senderId, recipientId |
| `Relationship.Discovery.Suggested` | AI-suggested connection | personId, suggestedPersonId, reason |

### Consumed

| Event | Source Engine | Action |
|-------|--------------|--------|
| `Identity.Person.Registered` | Identity | Seed initial connection suggestions |
| `CheckIN.Event.Attended` | CheckIN | Add "Met at Event" relationship context |
| `Opportunity.Deal.Won` | Opportunity | Strengthen relationship score |
| `Trust.Reference.Verified` | Trust | Update trust signal on relationship |

---

## 5. Service Methods

```typescript
class RelationshipService {
  // Core CRUD
  async create(data: CreateRelationshipDto): Promise<Relationship>
  async getById(id: string): Promise<Relationship>
  async list(filters: RelationshipFilters): Promise<PaginatedResult>
  async update(id: string, data: UpdateRelationshipDto): Promise<Relationship>
  async delete(id: string): Promise<void>

  // Connection Requests
  async sendRequest(data: CreateConnectionRequestDto): Promise<ConnectionRequest>
  async respondToRequest(id: string, accept: boolean): Promise<void>

  // Business Cards
  async createCard(data: CreateBusinessCardDto): Promise<BusinessCard>
  async listCards(personId: string): Promise<BusinessCard[]>
  async shareCard(cardId: string, recipientId: string): Promise<void>

  // Network
  async getMutualConnections(personId: string, targetPersonId: string): Promise<Person[]>
  async getNetworkGraph(personId: string): Promise<NetworkGraph>
  async getStats(personId: string): Promise<RelationshipStats>

  // Relationship Strength
  async recalculateStrength(relationshipId: string): Promise<void>
  async suggestConnections(personId: string): Promise<Suggestion[]>
}
```

---

## 6. Strength Scoring Algorithm

Relationship strength is a computed value (0.0 to 1.0) based on:

| Factor | Weight | Source |
|--------|--------|--------|
| Direct interactions | 30% | Communication Engine |
| Collaboration history | 25% | Trust Engine |
| Trust score | 20% | Trust Engine |
| Mutual connections | 15% | Relationship Engine |
| Time since last interaction | 10% | Communication Engine |

```typescript
function calculateStrength(factors: StrengthFactors): number {
  return (
    factors.interactions * 0.30 +
    factors.collaborations * 0.25 +
    factors.trustScore * 0.20 +
    factors.mutualConnections * 0.15 +
    factors.recency * 0.10
  );
}
```

---

## 7. Dependencies

| Dependency | Type | Notes |
|-----------|------|-------|
| Identity Engine | Required | Person identity for relationship endpoints |
| Workspace Engine | Required | Workspace context for all relationships |
| Permission Engine | Required | Capability checks on all endpoints |
| Trust Engine | Optional | Enhances strength scoring when available |
| Communication Engine | Optional | Enhances strength scoring when available |
| Audit Engine | Required | Log all relationship mutations |

---

## 8. Capability Registry

```typescript
export const RelationshipCapabilities = {
  'CreateConnection': 'relationship.graph.create',
  'ReadConnections': 'relationship.graph.read',
  'UpdateConnection': 'relationship.graph.update',
  'DeleteConnection': 'relationship.graph.delete',
  'SendRequest': 'relationship.connections.request',
  'RespondToRequest': 'relationship.connections.respond',
  'CreateCard': 'relationship.cards.create',
  'ReadCards': 'relationship.cards.read',
  'ShareCard': 'relationship.cards.share',
  'ImportContacts': 'relationship.contacts.import',
  'ExportContacts': 'relationship.contacts.export',
  'MergeDuplicates': 'relationship.graph.merge',
} as const;
```

---

## 9. Tests

### Unit Tests (80%+ coverage)

| Test | Description |
|------|-------------|
| create() | Creates relationship, emits event |
| create() with invalid type | Throws error |
| getById() | Returns relationship with context |
| getById() not found | Throws NotFoundException |
| list() with filters | Paginated, filtered results |
| list() tenant isolation | Only returns workspace-scoped |
| update() | Updates fields, emits event |
| delete() | Soft deletes, emits event |
| sendRequest() | Creates pending request, emits event |
| respondToRequest() accept | Creates relationship from request |
| respondToRequest() decline | Marks request declined |
| shareCard() | Adds card to recipient's collection |
| getMutualConnections() | Returns intersection |
| suggestConnections() | Returns ranked suggestions |

### Integration Tests

| Test | Description |
|------|-------------|
| Full CRUD flow | Create > Read > Update > Delete |
| Connection request flow | Send > Accept > Relationship Created |
| Business card flow | Create > Share > Collection updated |
| Auth — unauthenticated | Returns 401 |
| Auth — missing capability | Returns 403 |
| Tenant isolation — wrong workspace | Returns empty/404 |

---

## 10. Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Large relationship graphs slow queries | High | Index on (workspaceId, sourcePersonId), pagination by default, cursor-based for large sets |
| Duplicate relationships | Medium | Unique constraint on (workspaceId, sourcePersonId, targetPersonId) + merge capability |
| Strength scoring depends on other engines not built yet | Medium | Default strength = 0.5. Enhance when Trust/Communication engines exist |
| N+1 queries on network graph | High | Use batch loading, limit graph depth to 2 levels |
| Connection request spam | Medium | Rate limit per sender, expire pending requests after 30 days |

---

## 11. Acceptance Criteria

- [ ] All Prisma models created and migrated
- [ ] All API endpoints implemented and tested
- [ ] Events emitted for every state change
- [ ] Capability checks on all protected endpoints
- [ ] Unit tests pass (80%+ coverage)
- [ ] Integration tests pass
- [ ] OpenAPI documentation generated
- [ ] Strength scoring algorithm implemented
- [ ] Relationship type seed data loaded
- [ ] Tenant isolation verified
- [ ] README written
- [ ] Build passes with zero errors

---

## 12. Definition of Done

Refer to `engineering/DEFINITION-OF-DONE.md` — all 11 sections must pass before merge.
