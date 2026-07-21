---
Title: Sprint 3 Design Review — Trust Evidence Engine
Version: 2.0
Status: Draft — Pending Approval
Owner: Chief Architect
Date: 2026-07-22
Dependencies: Sprint 2 (Relationship Engine)
---

# Sprint 3 Design Review — Trust Evidence Engine

> **Trust is subjective. Evidence is objective. The Trust Engine owns evidence. The Recommendation Engine computes context-specific rankings.**

---

## 1. Key Architectural Decision

**The Trust Engine does NOT produce a single trust score.**

Instead, it owns **Trust Evidence** — objective, verifiable facts about a person's professional history. The Recommendation Engine (future) computes context-specific rankings using this evidence together with Relationship, Opportunity, Communication, and Discovery signals.

### Why This Matters

| Approach | Problem |
|----------|---------|
| Single Trust Score (84/100) | Cannot represent different contexts. A good employee ≠ a good supplier ≠ a good investor. |
| Trust Evidence (verified projects, invoices paid, endorsements) | Flexible. Each use case weights evidence differently. Hiring emphasizes recommendations. Procurement emphasizes transactions. |

### Architecture

```
Trust Engine (Sprint 3)
  |
  +-- Owns: Evidence, References, Collaborations, Endorsements, Verifications
  |
  v
Recommendation Engine (Future)
  |
  +-- Consumes: Evidence from Trust Engine + Signals from Relationship, Comm, Opportunity
  +-- Computes: Context-specific rankings per use case (hiring, procurement, investment, partnership)
```

---

## 2. Why Trust Before Communication

| Reason | Explanation |
|--------|-------------|
| Every message carries trust context | Communication Engine can surface trust evidence alongside conversations |
| Recommendations need evidence | Evidence feeds directly into Recommendation Engine ranking |
| Introductions require trust | Introduction Engine (future) needs evidence to suggest meaningful connections |
| Relationship strength depends on trust evidence | Relationship Engine's strength scoring uses evidence as a primary factor |
| Communication creates evidence signals | Messages, responses, and engagement become evidence inputs |

---

## 2. Trust Evidence Inventory

The Trust Engine owns objective evidence. Each piece of evidence is independently verifiable:

| Evidence | Description | Source |
|----------|-------------|--------|
| **Identity Verified** | Person identity confirmed via Authentik/OIDC | Identity Engine |
| **Business Verified** | Company registration, tax ID, domain ownership | Organization Engine |
| **Mutual Connections** | Number of shared connections with the viewer | Relationship Engine |
| **Collaborations Completed** | Verified joint projects with outcomes | Trust Engine |
| **References Provided** | Reference responses from other platform users | Trust Engine |
| **Endorsements Received** | Skill endorsements from other users | Trust Engine |
| **Certifications** | Professional certifications uploaded and verified | Trust Engine |
| **Invoices Paid** | Number and value of completed financial transactions | Finance Engine |
| **Contracts Signed** | Contracts completed successfully | Finance/Opportunity |
| **Events Attended** | Number of CheckIN events attended | CheckIN |
| **Broadcast Responses** | Responses to broadcast opportunities | Broadcast |
| **Response Rate** | % of messages responded to within 24h | Communication Engine |
| **Account Age** | Days since registration | Identity Engine |
| **Reported Violations** | Confirmed policy violations | Audit/Admin |

## 3. Reputation Dimensions

Instead of one score, evidence contributes to multiple reputation dimensions:

| Dimension | Relevant Evidence | Used When |
|-----------|------------------|-----------|
| **Business Reputation** | Collaborations, invoices paid, contracts signed | Partnering, procurement, B2B |
| **Technical Reputation** | Skills, certifications, project outcomes | Hiring, freelancing, consulting |
| **Financial Reputation** | Payment history, transaction volume | Investment, credit, supplier evaluation |
| **Communication Reputation** | Response rate, response quality, references | Sales, customer support, networking |
| **Hiring Reputation** | Employee history, team outcomes, referrals | Recruitment, HR |
| **Community Reputation** | Event participation, endorsements given, introductions | Networking, community building |

---

## 3. Proposed Prisma Models

```prisma
model TrustEvidence {
  id              String   @id @default(uuid())
  personId        String
  workspaceId     String
  type            String              // "identity_verified", "business_verified", "collaboration", "certification"
  category        String              // Reputation dimension: "business", "technical", "financial", "communication", "hiring", "community"
  title           String
  description     String?
  value           Float?              // Numerical value if applicable
  source          String              // Engine or product that created this evidence
  sourceId        String?             // Reference to the source record
  fileUrl         String?
  expiresAt       DateTime?
  isVerified      Boolean  @default(false)
  verifiedBy      String?             // Person or engine that verified
  verifiedAt      DateTime?

  createdAt       DateTime @default(now())
  @@index([personId])
  @@index([personId, category])
  @@index([workspaceId])
}

model ReferenceRequest {
  id              String   @id @default(uuid())
  workspaceId     String
  requesterId     String              // Person seeking reference
  targetId        String              // Person being referenced
  relationshipId  String?
  context         String              // Why the reference is needed
  status          ReferenceStatus @default(PENDING)
  expiresAt       DateTime?

  createdAt       DateTime @default(now())
  @@index([workspaceId])
  @@index([targetId, status])
}

enum ReferenceStatus {
  PENDING
  PROVIDED
  DECLINED
  VERIFIED
  EXPIRED
}

model ReferenceResponse {
  id              String   @id @default(uuid())
  requestId       String
  providerId      String
  ratings         Json?               // Dimension ratings (1-5)
  comments        String?
  isVerified      Boolean @default(false)
  submittedAt     DateTime @default(now())

  @@index([requestId])
}

model Collaboration {
  id              String   @id @default(uuid())
  workspaceId     String
  participants    String[]            // Person IDs
  projectName     String
  description     String?
  startDate       DateTime
  endDate         DateTime?
  outcome         String?             // "successful", "partial", "unsuccessful"
  verifierId      String?             // Who verified this collaboration
  evidenceUrls    String[]

  createdAt       DateTime @default(now())
  @@index([workspaceId])
}

model Endorsement {
  id              String   @id @default(uuid())
  workspaceId     String
  endorserId      String
  targetId        String
  skill           String
  context         String?
  weight          Float    @default(1.0)

  createdAt       DateTime @default(now())
  @@index([targetId])
  @@unique([endorserId, targetId, skill])
}

model TrustEvidence {
  id              String   @id @default(uuid())
  personId        String
  type            String              // "certificate", "license", "verification", "portfolio"
  title           String
  description     String?
  fileUrl         String?
  issuedAt        DateTime?
  expiresAt       DateTime?
  isVerified      Boolean @default(false)

  createdAt       DateTime @default(now())
  @@index([personId])
}
```

---

## 4. Evidence API (Not Score API)

The Trust Engine exposes evidence through APIs. It does NOT compute scores.

```typescript
// Trust Engine returns evidence — not scores
GET /api/v1/trust/evidence/:personId

Response: {
  personId: "uuid",
  evidence: [
    { type: "identity_verified", category: "business", title: "Identity Verified", value: 1, source: "identity-engine" },
    { type: "collaboration", category: "business", title: "Completed 6 projects", value: 6, source: "trust-engine" },
    { type: "invoice_paid", category: "financial", title: "18 invoices paid", value: 18, source: "finance-engine" },
    { type: "endorsement", category: "technical", title: "12 skill endorsements", value: 12, source: "trust-engine" },
    { type: "response_rate", category: "communication", title: "92% response rate", value: 0.92, source: "communication-engine" },
  ],
  byDimension: {
    business: { count: 3, score: 0.85 },
    technical: { count: 2, score: 0.72 },
    financial: { count: 1, score: 0.90 },
    communication: { count: 1, score: 0.78 },
  }
}
```

Context-specific ranking is the responsibility of the Recommendation Engine:

```typescript
// Recommendation Engine computes context-specific ranking
// Example: Ranking suppliers for procurement
function rankSuppliers(candidates: Person[], procurementCriteria: Criteria): RankedResult[] {
  for (const candidate of candidates) {
    const evidence = trustEngine.getEvidence(candidate.id);
    const score = (
      evidence.business * 0.40 +
      evidence.financial * 0.30 +
      evidence.communication * 0.15 +
      relationshipStrength(candidate) * 0.10 +
      responseRate(candidate) * 0.05
    );
    results.push({ person: candidate, score, evidence });
  }
  return results.sortByScore();
}
```

Trust evidence is never displayed publicly in raw form. It is used for:
- Recommendation ranking (context-specific)
- Broadcast targeting (trust-weighted audience selection)
- Connection suggestions (evidence-based)
- Introduction eligibility
- Fraud detection signals
- Explainability ("Recommended because: 4 mutual connections, verified exporter, 18 invoices paid")

---

## 5. API Contract

| Method | Path | Description | Capability |
|--------|------|-------------|------------|
| GET | `/api/v1/trust/evidence/:personId` | Get all evidence for a person | `trust.evidence.read` |
| GET | `/api/v1/trust/evidence/:personId/:category` | Get evidence by reputation dimension | `trust.evidence.read` |
| POST | `/api/v1/trust/evidence` | Add evidence record | `trust.evidence.create` |
| POST | `/api/v1/trust/references/request` | Request reference | `trust.references.request` |
| GET | `/api/v1/trust/references/incoming` | Incoming reference requests | `trust.references.read` |
| POST | `/api/v1/trust/references/:id/respond` | Provide reference response | `trust.references.respond` |
| POST | `/api/v1/trust/collaborations` | Register collaboration | `trust.collaborations.create` |
| GET | `/api/v1/trust/collaborations/:personId` | List collaborations | `trust.collaborations.read` |
| POST | `/api/v1/trust/endorsements` | Endorse a skill | `trust.endorsements.create` |
| DELETE | `/api/v1/trust/endorsements/:id` | Remove endorsement | `trust.endorsements.delete` |
| POST | `/api/v1/trust/certifications` | Upload certification | `trust.certifications.create` |

---

## 6. Events

### Emitted

| Event | When |
|-------|------|
| `Trust.Evidence.Added` | New trust evidence recorded |
| `Trust.Evidence.Verified` | Evidence verified by trusted party |
| `Trust.Reference.Requested` | Reference request sent |
| `Trust.Reference.Provided` | Reference response submitted |
| `Trust.Reference.Verified` | Reference authenticity verified |
| `Trust.Collaboration.Registered` | New collaboration recorded |
| `Trust.Endorsement.Given` | Skill endorsement made |

### Consumed

| Event | Source | Action |
|-------|--------|--------|
| `Relationship.Connected` | Relationship Engine | Seed initial trust signal |
| `Opportunity.Deal.Won` | Opportunity Engine | Strengthen trust from success |
| `Communication.Message.Sent` | Communication Engine | Update response rate signal |
| `CheckIN.Event.Attended` | CheckIN | Update event participation signal |

---

## 7. Integration with Relationship Engine

The Trust Engine strengthens the Business Graph by adding trust signals as edge weights:

```
Person A ──[Relationship]── Person B
                │
        Trust Score: 0.85
        Signals: 3 collaborations, 2 references, 5 mutual connections
```

The Relationship Engine's `addStrengthSignal()` method accepts trust signals from the Trust Engine:

```typescript
await relationshipService.addStrengthSignal({
  relationshipId: 'uuid',
  signalType: 'collaboration',
  weight: 0.8,
  source: 'trust-engine',
});
```

---

## 8. Trust & Privacy

| Rule | Implementation |
|------|---------------|
| Evidence is never fully public | Aggregated or permission-based visibility only |
| No "star ratings" | Trust is built from objective evidence, not popular votes |
| References are private | Only the requester sees reference responses |
| Endorsements are visible | But attributed contextually |
| Users can opt out | Evidence collection is opt-out per workspace |
| Fraud detection | Anomalous endorsement/collaboration patterns are flagged |
| Explainability is required | Every recommendation includes "why" — evidence-based explanation |

### Immutability Principle

Trust evidence is **immutable**. Once created, evidence cannot be edited or silently modified. Only three state transitions are permitted:

```
Created → (Active)
Active → Revoked   (explicit revocation by creator or admin)
Active → Expired   (automatic, based on expiresAt timestamp)
```

This ensures:
- Audit trails are trustworthy
- Evidence cannot be retroactively altered
- Scoring/recommendation engines can cache evidence safely
- Disputes can be resolved by examining the immutable record

**Implementation:**
- `TrustEvidence` uses `CREATE` only — no `UPDATE` on evidence records
- Revocations create a new `TrustEvidence` record with `type: "revocation"` referencing the original
- The `isVerified` field is set once during verification and never changed
- Expiration is computed from `expiresAt`, never manually adjusted

## 9. Explainability

Every recommendation or ranking that uses trust evidence must include an explanation:

```json
{
  "personId": "uuid",
  "rank": 1,
  "score": 0.87,
  "explanation": {
    "summary": "Strong match based on verified business history and mutual connections",
    "evidence": [
      { "type": "identity_verified", "label": "Identity Verified", "icon": "badge-check" },
      { "type": "mutual_connections", "label": "4 mutual connections", "value": 4 },
      { "type": "collaboration", "label": "Completed 3 projects with trusted partners", "value": 3 },
      { "type": "response_rate", "label": "95% response rate", "value": 0.95 }
    ],
    "factors": [
      { "name": "Business Reputation", "weight": "high", "score": 0.92 },
      { "name": "Relationship Distance", "weight": "medium", "score": 0.78 },
      { "name": "Communication", "weight": "low", "score": 0.85 }
    ]
  }
}
```

No black-box recommendations. Every score is traceable to specific evidence.

---

## 10. Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Evidence gaming | High | Pattern detection, diminishing returns on bulk endorsements |
| Privacy concerns | Medium | Evidence never fully public, references private, opt-out available |
| Cold start problem | Medium | New users have empty evidence — platform provides "complete your profile" prompts |
| False evidence | Medium | Verification workflows for high-value evidence types |
| Data silos | Low | Trust Engine only reads — never owns — Relationship or Communication data |

---

## 11. Acceptance Criteria

- [ ] All Prisma models created and migrated
- [ ] TrustEvidence model stores individual evidence records with type, category, value
- [ ] Evidence can be added by engines via API (not just user-facing)
- [ ] Reference request/response workflow works end-to-end
- [ ] Collaborations can be registered and verified
- [ ] Endorsements with evidence categorization
- [ ] Evidence grouped by reputation dimension (business, technical, financial, etc.)
- [ ] Events emitted for all evidence state changes
- [ ] Capability checks on all protected endpoints
- [ ] Integration with Relationship Engine strength signals
- [ ] Tenant isolation verified
- [ ] Privacy controls implemented (evidence never fully public)
- [ ] No single "trust score" — evidence is the source of truth

---

## Approval

| Role | Decision | Date |
|------|----------|------|
| **Chief Architect** | ⏳ Pending Review | — |
| **Implementation** | ⏳ Pending Approval | — |
