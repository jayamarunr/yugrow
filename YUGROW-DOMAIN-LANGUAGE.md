---
Title: Yugrow Domain Language
Version: 1.0
Status: Draft
Owner: Chief Architect
Last Updated: 2026-07-23
Dependencies:
  - YUGROW-PRESENCE-MODEL.md
  - PLATFORM-CONSTITUTION.md
  - BUSINESS-OBJECT-BIBLE.md
Related Documents:
  - YUGROW-CONSTITUTION.md
  - DOMAIN-MODEL.md
  - ENGINE-SPECIFICATIONS.md
  - SPRINT-7-OPPORTUNITY-ENGINE.md
---

# Yugrow Domain Language

> Every great platform has a precise vocabulary.
> This document is Yugrow's.

---

## How to use this document

Every term has:

1. **Definition** — what it is
2. **Not** — what it is not (prevents drift)
3. **Relationship** — how it connects to other terms
4. **Example** — real-world usage

**Rule:** When two engineers disagree about a word, this document wins.

---

## Core Concepts

### Presence

> An intentional, time-bound signal that a person is physically present and open to professional interaction.

**Not:** Online status, active indicator, availability toggle, attendance record, gamification mechanic.

**Relationship:** Creates Discovery. Enables Recommendations. Triggers Opportunities. Expires into Memory.

**Example:** "Raj checked in as Manufakt Automation at AI Summit Chennai. He is present for 60 minutes."

### Person

> A real individual with exactly one identity and one login.

**Not:** A user account, a profile, a contact, a lead.

**Relationship:** Owns their Presence. Initiates Connections. Belongs to Workspaces.

**Example:** "Priya is one person. She can represent her own brand or her employer."

### Workspace

> The professional identity a person chooses to represent during an event.

**Not:** An employer, a tenant, an organization, a role.

**Relationship:** A Person can have multiple Workspaces. Every Presence carries exactly one Workspace.

**Example:** "Jay is checking in as 'Arun Consulting' not as 'Personal.'"

### Organization

> A persistent business entity represented by people through their Workspace choices.

**Not:** A company profile, an employer, a brand page.

**Relationship:** Emerges from aggregate Workspace-tagged Presence. Becomes discoverable when multiple people from the same Organization are present.

**Example:** "Manufakt Automation has 4 people here today. The Organization is present because its people are present."

### Event

> A temporary context where Presence can exist.

**Not:** A calendar item, a meetup group, a webinar, a conference.

**Relationship:** Contains Venue. Hosts Presence. Bounds Discovery. Expires fully when ended.

**Example:** "AI Summit Chennai is an Event. Presence exists inside it. When it ends, all presence expires."

### Venue

> A physical location where an Event takes place.

**Not:** A GPS coordinate, a virtual room, an address.

**Relationship:** Contains an Event. Triggers geofence. Provides proximity context.

**Example:** "Chennai Trade Centre is the Venue. AI Summit Chennai is the Event inside it."

---

## Interaction Concepts

### Discovery

> Browsing everyone who is present.

**Not:** Search, feed, algorithm, random browsing.

**Relationship:** The raw view of Presence. Becomes Recommendation after ranking.

**Example:** "Raj opens Live and browses 247 professionals. That's Discovery."

### Connection

> Human acceptance of a relationship.

**Not:** Follow, subscribe, friend, link, add.

**Relationship:** One tap. No form. Creates a Relationship. Preserves origin context (Event + Venue + Date).

**Example:** "Priya taps Connect. Raj accepts. They are now Connected. Origin: AI Summit Chennai."

### Relationship

> A mutually accepted professional connection created through intentional interaction.

**Not:** A contact, a follower, a subscriber, a lead.

**Relationship:** Created by Connection. Owns Conversations. Accumulates TrustEvidence. Remembers origin.

**Example:** "Raj and Priya are in a Relationship. It was created at AI Summit Chennai. They can now message."

### Conversation

> Communication after a relationship exists.

**Not:** A chat room, a group message, a thread, a comment.

**Relationship:** Belongs to a Relationship. Text only in v1. Immutable. Auto-created on Connection acceptance.

**Example:** "After connecting, Raj sends 'Great meeting you at the expo!' That's a Conversation."

### Intent

> A self-expressed professional goal visible during an event.

**Not:** A search query, an AI inference, a skill tag.

**Relationship:** Expressed via "Looking for" field. Feeds Opportunity detection. Is deterministic, not inferred.

**Example:** "Priya's profile says 'Looking for distributors.' That's her Intent."

### Signal

> A single verifiable fact about a person's current state.

**Not:** An inference, a prediction, a guess, a score.

**Relationship:** Building block of Opportunity. Types: presence, intent, industry, role, mutual, workspace, trust.

**Example:** "Priya checked in 4 minutes ago. That is a Signal."

### Opportunity

> A deterministic alignment between Presence and Intent.

**Not:** A deal, a lead, a suggestion, a match.

**Relationship:** Created by the Opportunity Engine. Consumes Signals. Becomes a Recommendation after ranking. Expires when Presence expires.

**Example:** "Raj is looking for distributors. Priya is looking for automation products. That is an Opportunity."

### Recommendation

> A ranked presentation of Opportunities.

**Not:** An ad, a promotion, a suggestion, a discovery feed.

**Relationship:** Output of the Opportunity Engine. Presented in "Worth meeting" section. Ordered by Intent > Trust > Presence > Discovery.

**Example:** "Priya appears first in Raj's recommendations because her Intent directly matches his."

### Broadcast

> A time-sensitive message intended for people who are currently present.

**Not:** A post, a tweet, a status update, an announcement.

**Relationship:** Presence-independent mode of the Opportunity Engine. Becomes contextual when Presence data is available. Sprint 9.

**Example:** "Raj broadcasts 'Looking for manufacturing partners.' 43 people at AI Summit see it."

### Memory

> Information that remains after Presence disappears.

**Not:** A log, an archive, a history, a timeline.

**Relationship:** What persists after Presence expires. Includes Relationships (with origin), Events attended, People met. Does not include live signals.

**Example:** "Raj met Priya at AI Summit Chennai 3 months ago. That is Memory."

---

## Platform Concepts

### Engine

> A domain service with a single responsibility.

**Not:** A microservice, a feature, a product, a module.

**Relationship:** Engines compose the platform. Each engine owns one domain. Engines do not know about products.

**Example:** "The Presence Engine knows who is present. It does not know about connections or recommendations."

### Product

> A user-facing experience built on one or more Engines.

**Not:** A feature, a page, a screen.

**Relationship:** Consumes Engines. Does not own domain logic. Can be composed with other Products.

**Example:** "CheckIN is a Product. It uses Presence Engine + Relationship Engine."

### Capability

> An atomic action a user can perform.

**Not:** A permission, a role, a feature flag.

**Relationship:** Format: {product}.{resource}.{action}. Projected as UI (menus, buttons, routes).

**Example:** "checkin.presence.create — the user can check in to an event."

### Journey

> A guided multi-step experience that achieves a user goal.

**Not:** An onboarding flow, a tutorial, a wizard.

**Relationship:** Wraps one or more Products. Can adapt based on UserContext. Awards an Achievement on completion.

**Example:** "Start a Business is a Journey. It includes CheckIN, Broadcast, and CRM steps."

### TrustEvidence

> Verifiable proof that strengthens a professional profile.

**Not:** A review, a rating, a testimonial, a badge.

**Relationship:** Accumulated on a Relationship. Types: event attendance history, connection quality, conversation engagement.

**Example:** "Raj has attended 12 events and has 47 active relationships. That is TrustEvidence."

### Context

> The circumstances surrounding an interaction.

**Not:** Metadata, tags, categories, labels.

**Relationship:** Captured automatically at Connection creation: Event + Venue + Date. Preserved permanently in the Relationship.

**Example:** "Raj and Priya connected 'at AI Summit Chennai, Chennai Trade Centre, July 23 2026.' That is Context."

---

## Prohibited Terms

These words have no place in Yugrow's domain language:

| Term | Replaced by | Why |
|------|------------|-----|
| Follow | Connect | Follow is passive. Connect is intentional. |
| Friend | Connection | Friend is social. Connection is professional. |
| Like | — | Yugrow does not have likes. |
| Comment | Message | Message is 1:1. Comment is public. Yugrow does public later. |
| Post | Broadcast | Post is permanent. Broadcast is time-sensitive. |
| Feed | Discovery | Feed is algorithmic. Discovery is raw presence. |
| Profile | Person | Profile is a page. Person is an identity. |
| Check-in | Presence | Check-in is an action. Presence is a state. |
| Attendance | Presence | Attendance is a record. Presence is a signal. |
| Online | Present | Online is technical. Present is human. |
| Status | Intent | Status is vague. Intent is specific. |

---

## Term Relationships Map

```
Person ──has──> Workspace
Person ──creates──> Presence
Person ──expresses──> Intent
Person ──initiates──> Connection

Presence ──enables──> Discovery
Discovery ──feeds──> Recommendation
Recommendation ──ranks──> Opportunity
Opportunity ──aligns──> Intent + Presence

Connection ──creates──> Relationship
Relationship ──owns──> Conversation
Relationship ──accumulates──> TrustEvidence
Relationship ──remembers──> Context

Presence ──expires into──> Memory
Memory ──preserves──> Relationship + Context
Memory ──does not preserve──> Presence + Discovery

Broadcast ──targets──> Presence (indirect)
Organization ──emerges from──> Workspace-tagged Presence
Event ──contains──> Presence
Venue ──hosts──> Event
```

---

## FD-024 — Conceptual Integrity

> Every new feature must strengthen an existing concept before introducing a new one.

**Before adding a new term to this document, ask:**
1. Can this be expressed using existing terms?
2. Does it strengthen an existing concept?
3. Does it violate any existing definition?

**If the answer to all three is yes, the feature may proceed.**
**If not, reject it.**
