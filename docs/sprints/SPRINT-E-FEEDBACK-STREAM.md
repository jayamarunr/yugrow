---
Title: Sprint E — Feedback Stream Activation
Version: 1.0
Status: Planning (dormant — do not implement until activation condition met)
Owner: Product
Last Updated: 2026-07-28
---

# Sprint E — Feedback Stream Activation

> **This sprint is dormant. Do not implement until the activation condition is met.**
>
> During Alpha Hardening, all energy goes to the First Independent Success milestone.

---

## Sprint Goal

Activate a single shared feedback conversation — the **Feedback Stream** — enabling all Alpha testers to see each other's bug reports and feature suggestions, eliminating duplicates, and providing transparent product evolution through founder-controlled status updates.

---

## Business Problem

During Alpha testing with multiple professionals, the same bugs and suggestions will be reported independently through private Yugrow conversations. The founder receives the same screenshot from five different people, responds to each individually, and has no shared view of what's been reported, accepted, or fixed.

The Feedback Stream solves this by making feedback **visible** rather than **siloed**.

---

## Activation Condition

This sprint must **NOT** begin until ALL of the following are true:

| # | Condition | Status |
|---|-----------|--------|
| 1 | First Meetup completed | ⬜ |
| 2 | Duplicate reports become measurable friction | ⬜ |
| 3 | Manual founder triage no longer scales | ⬜ |

If the First Meetup reveals that professionals don't naturally send feedback, or that duplicates aren't a problem, this sprint may be deferred or descoped.

---

## Conversation Types (Context)

This sprint introduces the **third and final** conversation type within the existing Conversation Engine. No new engine is created.

```
                    Conversation Engine
                    ┌────────────────────┐
                    │  private           │
                    │  A ↔ B             │  ✅ Existing
                    └────────────────────┘
                    ┌────────────────────┐
                    │  system            │
                    │  Yugrow ↔ Person   │  ✅ Existing (FD-032)
                    └────────────────────┘
                    ┌────────────────────┐
                    │  feedback          │
                    │  Everyone ↔ Yugrow │  🆕 This sprint
                    └────────────────────┘
```

| Type | Participants | Purpose | Status |
|------|-------------|---------|--------|
| `private` | Person ↔ Person | One-to-one relationships | ✅ Frozen |
| `system` | Yugrow ↔ Person | Trusted platform communication | ✅ Frozen (FD-032) |
| `feedback` | Everyone ↔ Yugrow | Shared product evidence | 🆕 Sprint E |

All three live inside the existing `Conversation` model using `contextType`, which already accepts arbitrary string values with zero schema changes.

---

## User Stories

### Tester Stories

| ID | Story | Priority |
|----|-------|----------|
| F-01 | As an alpha tester, I can see existing feedback items before creating a new report, so I know if my issue has already been reported. | P0 |
| F-02 | As an alpha tester, I can add "Same here" + evidence (screenshot, text) to an existing report instead of creating a duplicate. | P0 |
| F-03 | As an alpha tester, I can see the status of every feedback item (New, Accepted, Planned, In Progress, Released, Closed). | P0 |
| F-04 | As an alpha tester, I receive a notification in my private Yugrow conversation when the status of a report I participated in changes. | P1 |

### Founder Stories

| ID | Story | Priority |
|----|-------|----------|
| F-05 | As the founder, I can create a structured feedback post with title, description, and category (Bug / Suggestion / Question). | P0 |
| F-06 | As the founder, I can update the status of any feedback item (New → Accepted → Planned → In Progress → Released → Closed). | P0 |
| F-07 | As the founder, I can reply to a feedback item publicly so everyone sees updates. | P0 |
| F-08 | As the founder, I can see how many professionals are affected by each feedback item. | P1 |

---

## Status Lifecycle

Every feedback item moves through this lifecycle:

```
                        ┌──────────┐
                        │   New    │
                        └────┬─────┘
                             │
                        ┌────▼─────┐
                        │ Accepted │
                        └────┬─────┘
                             │
                        ┌────▼─────┐
                        │ Planned  │
                        └────┬─────┘
                             │
                        ┌────▼────────┐
                        │ In Progress │
                        └────┬────────┘
                             │
                        ┌────▼─────┐
                        │ Released │
                        └────┬─────┘
                             │
                        ┌────▼─────┐
                        │  Closed  │
                        └──────────┘
```

| Status | Meaning |
|--------|---------|
| **New** | Reported but not yet reviewed |
| **Accepted** | Confirmed as valid by founder |
| **Planned** | Scheduled for a future sprint |
| **In Progress** | Currently being implemented |
| **Released** | Available in a shipped version |
| **Closed** | No further action needed (resolved, rejected, or duplicate) |

### Notification Flow

When status changes, all professionals who participated in that feedback item receive a message in their **private Yugrow conversation**:

```
❤️ Yugrow

"Venue Search" status changed:

Accepted → In Progress

Sprint 12
```

This reuses the existing `sendSystemMessage()` method — no new notification infrastructure.

---

## Technical Approach

### Schema

**No schema changes required.** The existing `Conversation` model accepts `contextType: 'feedback'` with zero migration needed. Verified by Architecture Readiness Review (2026-07-28).

### Backend (Additive — no refactoring)

| Method | Endpoint | Purpose |
|--------|----------|---------|
| `createFeedbackPost()` | `POST /conversations/feedback/posts` | Founder creates a feedback item |
| `getFeedbackPosts()` | `GET /conversations/feedback/posts` | List all feedback items with status |
| `updateFeedbackStatus()` | `PATCH /conversations/feedback/posts/:id/status` | Change status + notify participants |
| `replyToFeedback()` | `POST /conversations/feedback/posts/:id/replies` | Add a public reply |

These are new methods in `CommunicationService`, not a new engine.

### Mobile (Additive)

| Component | Purpose |
|-----------|---------|
| `FeedbackScreen` | List view of all feedback items as structured cards |
| `FeedbackPostCard` | Card showing title, reporter, status badge, affected count |
| `FeedbackDetailScreen` | Full post with threaded replies |
| `FeedbackStatusBadge` | Reusable status chip (New=blue, Accepted=green, Planned=yellow, etc.) |

The user-facing name is **"Build Yugrow Together"** — not "Feedback Stream." The internal type remains `feedback`.

### Existing Components to Reuse

| Component | How |
|-----------|-----|
| `MessageScreen` | Base for the feedback detail view |
| `MessageRenderer` | Render status cards and founder replies |
| `FeedbackStatusCard` | Already built in Sprint D — reuse for status updates |
| `sendSystemMessage()` | Deliver status change notifications to private Yugrow chat |
| `FeedbackInboxScreen` | Founder tool — extend to show feedback items with status filtering |

---

## Out of Scope

The following are explicitly **not** built in Sprint E:

| Capability | Reason |
|------------|--------|
| ❌ AI classification | Belongs to dormant Feedback Intelligence Engine |
| ❌ Automatic duplicate detection | Belongs to dormant Feedback Intelligence Engine |
| ❌ GitHub integration | Belongs to dormant Feedback Intelligence Engine |
| ❌ Jira integration | Belongs to dormant Feedback Intelligence Engine |
| ❌ Product Memory | Separate dormant capability |
| ❌ Community Engine | Separate dormant capability — this is not a community |
| ❌ Voting / reactions | Not validated as valuable yet |
| ❌ Search | Not needed at Alpha scale |
| ❌ User-to-user messaging in feedback | Purpose is professional ↔ Yugrow, not peer chat |
| ❌ Private feedback | Use the existing private Yugrow conversation for sensitive reports |
| ❌ Screenshot uploads | Infrastructure not ready — defer to future sprint |

---

## Acceptance Criteria

| # | Criterion | Type |
|---|-----------|------|
| 1 | A single shared "Build Yugrow Together" conversation exists | Technical |
| 2 | Founder can create structured feedback posts with title + description + category | Founder |
| 3 | Founder can update status (New → Accepted → Planned → In Progress → Released → Closed) | Founder |
| 4 | Status changes notify all affected professionals via private Yugrow conversation | Technical |
| 5 | Testers can see all existing feedback items before creating a new one | Tester |
| 6 | Testers can reply to an existing feedback item with "Same here" + optional text | Tester |
| 7 | Feedback items render as structured cards (title, reporter, status, replies) | UI |
| 8 | Private Yugrow conversation continues working unchanged | Regression |
| 9 | Existing private conversations continue working unchanged | Regression |
| 10 | No Community Engine is created | Architecture |
| 11 | No schema migration is required | Architecture |

---

## Future Evolution

After Sprint E, the Feedback Stream can evolve in two directions:

### Path 1: Feedback Intelligence Engine (dormant)

When feedback volume exceeds manual triage capacity, the dormant **Feedback Intelligence Engine** activates, adding:

- Automatic duplicate grouping
- Priority scoring
- AI-drafted user stories
- GitHub/Jira integration
- Automated status transitions

This automates the same workflow Sprint E establishes manually.

### Path 2: Product Memory (dormant)

When the Feedback Stream has accumulated enough history, **Product Memory** activates, enabling:

- "You reported this in April. Fixed in v1.2."
- Personalized context in system conversations
- Feature traceability back to originating feedback

### Community Engine (dormant — distinct from Feedback Stream)

If professionals begin forming organic peer groups, the dormant **Community Engine** can be activated. The Feedback Stream is deliberately **not** a community.

---

## Risks

| Risk | Mitigation |
|------|------------|
| Testers don't use the Feedback Stream | Defer or descope — evidence-driven |
| Feedback Stream turns into general chat | Strict moderation: founder-controlled posts only |
| Status updates create notification noise | Only notify participants of the affected item |
| Scope creep toward Community Engine | Enforce Out of Scope section |
