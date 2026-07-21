---
Title: Presence Platform — Product Concept
Version: 0.2
Status: Concept
Owner: Founder / CPO
Last Updated: 2026-07-22
Target Release: Phase 1 (Presence Platform)
Related: Phase 1 → Phase 2 (Website/Content) → Phase 3 (Relationships/Trust)
---

# Presence Platform — Product Concept

> The product isn't CheckIN. The product is a **Professional Presence Network**.
> CheckIN is simply the first action.
> Presence can exist without an event — airports, coworking spaces, business centers, coffee shops, universities.

---

## Three First-Class Business Objects

```
Venue (Permanent)          ← Pin-dropping builds this over time
  ↓ contains
Events (Temporary)         ← Anyone can create these. Expire.
  ↓ contains
Presence (Temporary)       ← Auto-expires. Creates relationships.
  ↓ creates
Relationships (Permanent)  ← Outlive everything.
```

## Key Separation: CheckIN vs Broadcast

| | CheckIN (Presence Platform) | Broadcast (Opportunity Engine) |
|---|---|---|
| **Purpose** | "Who is here that I can connect with?" | "Which opportunities are relevant to me?" |
| **Driven by** | Presence, venue, event | Skills, intent, industry, geography |
| **Attendance ≠** | Expertise | — |
| **Monetization** | Event organizers (paid), Attendees (free) | Credits per broadcast |

**Rule:** Event attendance does NOT determine broadcast matching. A SaaS dev at an agri expo receives agri-related opportunities based on their *skills*, not their attendance.

**Travel rule:** Location changes the geographic pool of opportunities. If you're in Dubai, you receive Dubai broadcasts matching your skills — not random global broadcasts.

## The Core Loop

```
Arrive → Become Visible → Declare Intent → Discover → Request Connection → Accept → Conversation → Relationship → Trust → Opportunity → Business
```

The goal is **establishing permission to communicate**. This is a **permission-based business networking protocol** that compresses "exchange cards → find on LinkedIn → send request → hope they respond → follow up" into one seamless flow.

**Today's workflow** (high friction):
Collect cards → Add to CRM → Find on LinkedIn → Send request → Hope they respond → Ask for WhatsApp → Follow up later

**Presence Platform workflow** (low friction):
Declare presence → Discover → Connect → Accepted → Message immediately

---

## Core Behavior

| Decision | Rationale |
|----------|-----------|
| **No checkout button** | People forget. Presence expires automatically at event end or when checking into a different event. |
| **No indoor zones (postponed)** | Requires reliable indoor positioning — don't need it to validate the product. Use named areas (stages, halls) instead if needed. |
| **Event Connection Window** | 24-hour window after check-in to send connection requests. After that, no new requests tied to that event. Existing connections are permanent. |
| **Smart connection limits** | Daily cap on requests sent. Higher limits for verified/reputable users. Prevents 500-request spam. |

---

## The 5-Tab UX

### Tab 1: Live — "Who's here?"

The entry point. Creates FOMO. Shows event pulse.

```
📍 Chennai Trade Expo — Live

People checked in (last 60 min)    █████████████ 128
Connections nearby                                   32
Companies represented                               58
Countries                                              12

Last 15 min  •  Last 30 min  •  Last 60 min  •  Today

🔔 New attendee — ABC Imports (Rice Exporter) — checked in 30s ago
  [View profile] [Connect]

"Rice Importer from USA just checked in. You have 3 mutual connections."
```

- Dynamic time filter (15min / 30min / 60min / Today / Yesterday)
- **Live Arrivals** — real-time notifications of relevant new check-ins
- "Leaving Soon" — shows people who checked out or whose presence is expiring

### Tab 2: Recommended — "Who should I meet?"

AI-powered matchmaking.

```
You should meet
  Rajesh — Founder, AI Startup
  Why? Looking for Banking Partner
  You both know Anand
  Both attended Fintech Summit
  2 km away
```

Based on: Business Intent, mutual connections, past events, location.

### Tab 3: My Connections — "Who's here?"

People you're already connected to who are at this event.

### Tab 4: Opportunities — "What are people looking for?"

Aggregated intent signals from attendees.

```
Looking for:
  • Rice Importers (12 people)
  • Investors (8 people)
  • Logistics Partners (6 people)
  • Developers (15 people)
```

### Tab 5: Messages — "Follow up"

Direct messaging with people you've connected with at this event.

---

## Business Intent

When checking in, users declare their intent:

```
Today I'm here to:
☐ Find Customers
☐ Find Suppliers
☐ Find Investors
☐ Hire
☐ Get Hired
☐ Learn
☐ Meet Partners
☐ Network
☐ Sell
☐ Buy
[Custom: _____________]
```

This transforms CheckIN from a location app into a **real-time business matching platform**. It powers the Recommended tab and intelligent notifications.

---

## Connection Request

### Connection Intent

Every request includes a reason:

```
Connect with Rajesh
  Reason: ☐ Business Partnership
           ☐ Customer Inquiry
           ☐ Supplier Discussion
           ☐ Investment
           ☐ Hiring
           ☐ Networking
           ☐ Follow-up from this Event
  Message (optional): "Hi Rajesh, I saw you're looking for banking partners..."
```

This small context improves acceptance rates and sets conversation tone.

### 24-Hour Window

```
John checked in 18 minutes ago
  Connect now
  Connection window closes in 23h 41m
```

- Request expires after 24 hours if not accepted
- Sender can send another request later (after 7-day cooldown)
- Prevents spam while preserving opportunity

### Acceptance Signals (Private)

| Time to Accept | Signal |
|----------------|--------|
| < 10 minutes | 🏆 Fast Connector |
| < 1 hour | ⭐ Responsive |
| < 24 hours | ✓ Connected |

These are **private behavioral signals** — feed into recommendations and journey suggestions, not displayed publicly.

---

## Notifications

Not generic pushes. Relevance-filtered.

| Scenario | Notification |
|----------|-------------|
| Relevant person arrives | *"A Rice Importer from USA just checked in. View profile"* |
| Mutual connection arrives | *"Someone in Banking just arrived. You have 3 mutual connections."* |
| Someone is leaving | *"Priya is leaving in 12 minutes. Meet now?"* |
| Request accepted | *"Rajesh accepted your connection request. Send a message."* |
| Window closing | *"Your connection window at Chennai Trade Expo closes in 2 hours."* |

---

## Event Pulse (Event Momentum)

Live dashboard for each event:

```
AI Expo 2028 — Live
  People checked in (last hour): 128
  Connections nearby: 32
  Companies: 58
  Countries: 12
  Opportunities posted: 21

🔥 AI Stage — 42 people (trending)
🏢 Startup Zone — 18 people
🍽 Networking Lunch — 67 people
☕ Coffee Area — 35 people
```

This creates a reason to keep the app open and check back throughout the day.

---

## Professional Intent (Anti-Dating-App)

Every profile indicates **why they're attending**:
- Looking for customers
- Looking for suppliers
- Hiring
- Seeking investors
- Exploring partnerships
- Learning
- Speaking
- Recruiting distributors

This aligns expectations. The default experience emphasizes **professional intent**.

---

## Implementation Priority

| Priority | Feature | Depends On |
|----------|---------|------------|
| P0 | Check-in + auto-presence expiry | Identity, Relationship |
| P0 | Attendee list with time filter | Identity |
| P0 | Connection request with intent | Relationship |
| P0 | 24-hour window + expiry | Relationship |
| P1 | Live Arrivals notifications | Events, SDK |
| P1 | 5-tab UX (Live, My Connections, Messages) | UI Shell |
| P1 | Messaging after connection accepted | Communication |
| P2 | Business Intent on check-in | Relationship |
| P2 | Recommended tab (AI matching) | Discovery, AI |
| P2 | Opportunities tab (aggregated intents) | Discovery |
| P2 | Event Pulse dashboard | Analytics |
| P3 | Leaving Soon detection | Presence tracking |
| P3 | Smart connection limits | Permission |
| P3 | Private acceptance signals | Trust |

---

## Build Sequence (Within Phase 3)

1. **Core check-in flow**: Check in → see attendees → send request → accept → message
2. **24-hour window**: Connection lifecycle with expiry
3. **Live Tab**: Real-time attendee list with dynamic time filters
4. **Business Intent**: Intent declaration on check-in
5. **Recommended Tab**: AI-powered matchmaking
6. **Event Pulse**: Live event dashboard
7. **Notifications**: Relevance-filtered pushes

---

> **This concept becomes a formal PRD when Phase 3 implementation begins.**
> Pre-requisite: Phase 1 (Website, Content, Publish) and Phase 2 (Relationships, Trust, Communication) must be complete first.
