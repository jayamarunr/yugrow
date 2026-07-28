# Founder Decisions

> **Every founder decision that shapes Yugrow's product, architecture, and business model.**
>
> When in doubt, consult this file. If a decision is not here, it hasn't been made yet.
>
> Format: `FD-NNN` — sequential, never deleted, never modified (addendums appended if needed).

---

## FD-001 — One Identity Per Person

**Date:** 2026-07-22
**Category:** Identity

One mobile number = one Person. No duplicate accounts. A Person can own multiple workspaces and be a member of others, but always under a single identity.

**Why:** Prevents fragmentation of the Business Graph. Every relationship, trust evidence, and opportunity is tied to the person, not an account.

---

## FD-002 — Active Workspace Context

**Date:** 2026-07-22
**Category:** Architecture

Every action in Yugrow happens inside an Active Workspace. Every request carries Person ID + Workspace ID + Role + Capabilities. Switching workspaces changes the entire app — navigation, permissions, data, branding.

**Why:** The workspace is the operating system of Yugrow. One person can represent different entities (Personal, Company A, NGO) at different times, and the platform must reflect that instantly.

**Addendum:** Default Active Workspace — users can set a default. Most-used workspace auto-selects on login.

---

## FD-003 — Event Attendance Does Not Imply Expertise

**Date:** 2026-07-22
**Category:** Intelligence, Platform Law

A SaaS developer at an agri expo is there to sell software, not because they're in agriculture. Attendance may inform networking context, but must **never** be used as a primary signal for opportunity matching, skill inference, or content recommendations.

**Why:** Prevents incorrect assumptions that degrade trust in the platform. Broadcast matching uses skills + geography, not event attendance.

---

## FD-004 — CheckIN Is Frictionless

**Date:** 2026-07-22
**Category:** Product, UX

CheckIN asks nothing beyond "which workspace?" No business intent questions, no goal selection, no role selection (beyond workspace). The only choice: which workspace to represent.

**Flow:** Check in → See people → Connect → Accepted → Chat. Three steps. Under 30 seconds.

**Why:** Someone at a business event already has intent. Every extra question reduces adoption.

---

## FD-005 — Relationships Are Permanent, Presence Is Temporary

**Date:** 2026-07-22
**Category:** Data Model

Relationships, once established, are permanent unless explicitly removed by either party. Presence auto-expires. No checkout button. Venue outlives events. Events outlive presence. Relationships outlive everything.

**Why:** Networking is about building lasting connections. Events are just the context where they start.

---

## FD-006 — Broadcast Uses Skills + Geography, Not Event Attendance

**Date:** 2026-07-22
**Category:** Product, Intelligence

Broadcast matching is driven by: declared skills, declared industries, current business intent, declared geographic scope, relationship proximity, trust signals. NOT by event attendance history.

**Opportunity Radius:** Connections → Event Attendees → Venue → City → State → Country → Global.

**Why:** Ensures opportunities reach people who can actually act on them, not people who happened to attend a related event.

---

## FD-007 — Every Interaction Must Reduce Friction

**Date:** 2026-07-22
**Category:** UX, Platform Law

If a feature asks users to provide information that can be inferred later or is not essential to the immediate task, the feature should be redesigned. The temptation with enterprise software is always to add one more dropdown, one more required field. Resist it.

**Why:** Friction reduces adoption. The platform succeeds when networking feels effortless.

---

## FD-008 — Pricing: Monetize Capability, Not Existence

**Date:** 2026-07-22
**Category:** Business Model

Unlimited workspaces at every tier. Charge for features (AI, team members, CRM, analytics), not for creating workspaces. Every new workspace strengthens the Business Graph — charging for them slows network growth.

**Tiers:** Free (core networking, 1 member per workspace, basic website) → Pro (AI, custom domains) → Business (team, CRM, analytics) → Enterprise (groups, SSO, compliance).

**Why:** GitHub doesn't charge per repository. They charge for collaboration features. Same principle.

---

## FD-009 — Bring Your Own AI (BYOAI)

**Date:** 2026-07-22
**Category:** Product, Architecture

Yugrow is provider-agnostic. Users connect their preferred AI providers (OpenAI, Anthropic, Gemini, DeepSeek, Ollama, etc.) through the AI Gateway. Every product calls a common interface (generate text, generate image, analyze document). The gateway handles provider differences.

**Optional Yugrow AI:** Available for new users who don't have their own keys. Removes onboarding friction.

**Why:** Keeps Yugrow independent of any single AI vendor. Large enterprises with strict AI policies can use approved providers. Pricing stays about platform workflow, not tokens.

---

## FD-010 — Commerce Is Configuration, Not Code

**Date:** 2026-07-22
**Category:** Architecture, Business Model

Pricing, plans, feature flags, usage limits, coupons, trials, and regional pricing are configurable through Platform Administration — not hardcoded in application logic. A Commerce Engine owns: plans, subscriptions, pricing, usage metering, billing, coupons, taxes, payment providers.

**As a super admin you can:** Create/edit/delete plans, update the feature matrix, change usage limits, create coupons, configure regional pricing, toggle feature flags — all without deployment.

**Why:** Pricing strategy evolves faster than code. The platform should never require a deployment to change a price or add a promotion.

---

## FD-011 — Platform Administration Is Internal

**Date:** 2026-07-22
**Category:** Architecture

Pricing is not part of the Finance product. Finance is for customers. Pricing is for Yugrow. Create a separate Platform Administration area: Plans, Pricing, Features, Billing, Coupons, Usage Limits, Feature Flags, AI Models, API Keys, Marketplace, Support, Audit Logs, Monitoring, System Health.

**Why:** Keeps customer-facing products completely separate from the platform's operational controls. Different domains, different interfaces, different access controls.

---

## FD-012 — Build Vertical Slices, Not Horizontal Layers

**Date:** 2026-07-22
**Category:** Engineering

Build complete user journeys across multiple engines rather than completing one engine at a time. A vertical slice through Identity → Workspace → Website → CheckIN → Relationship → Communication → Broadcast proves the platform works end-to-end.

**Target:** Time from signup to first accepted business connection.

**Why:** A working demoable feature is worth more than 100% completion of an isolated engine. Real users validate real assumptions.

---

*No decision in this file is final. As the platform evolves and the market teaches us what works, decisions can be refined. But every change should be recorded as an addendum, not a deletion.*

---

## FD-031 — Venue Discovery: Per-Capability Providers, No Google Until Evidence

**Date:** 2026-07-25
**Category:** Product, Architecture

**Addendum (2026-07-25):** This decision evolved through three iterations:
1. Original: Google Places primary
2. Revised: OpenStreetMap primary, Google fallback
3. **Final:** Per-capability provider selection. No Google. Evaluate Mapbox before any premium spend.

**Decision:** Yugrow uses **different providers per capability**, not a single map vendor. Google is excluded until user evidence proves search quality is blocking adoption.

**Why:** Yugrow solves a different problem than most apps. The question isn't "Which map provider is best?" — it's "Which provider best supports **verified professional presence** at the lowest cost?" Yugrow only needs five capabilities: show a map, search venues, geocode addresses, drop a pin, validate geofence radius. It does **not** need turn-by-turn navigation, traffic, satellite imagery, street view, indoor maps, or routing — which are the expensive features driving Google's pricing.

**Per-capability provider selection:**

```
Capability              Provider              Cost
─────────────────────   ───────────────────   ──────────
Map display             OpenStreetMap         Free
                        (MapLibre / Flutter Map)
Venue search            Mapbox (evaluate      Low
& autocomplete          before any Google spend)
Forward/reverse         Nominatim             Free
geocoding                                    (respect usage limits)
Geofence validation     Built-in (client)     Free
                        (no provider needed)
Routing                 None needed           —
Traffic                 None needed           —
```

**Architecture (Phase 1):**

```
Venue Search
│
├── 1. Recent venues (user's history)
├── 2. Nearby verified Yugrow venues
├── 3. Mapbox Geocoding (search & autocomplete)
├── 4. Nominatim (fallback geocoding)
└── 5. Create New Venue
```

**Why Mapbox before Google:** Mapbox offers maps, geocoding, and autocomplete under one platform at much friendlier pricing. Its Flutter support is mature. If Mapbox is sufficient (likely), Google is never needed. MapTiler is another strong option, especially if privacy becomes a factor.

**Nominatim concern for growth:** The public Nominatim service is acceptable for Alpha with usage limits respected. As Yugrow grows, plan to migrate to a managed provider (Mapbox, MapTiler) or host a private Nominatim instance. Nominatim is not a long-term production dependency — it's an Alpha bootstrap.

**Venue data model:**

```
Venue
├── Name
├── Coordinates
├── External ID (OSM or Google Place ID)  ← Reference only
├── Yugrow Status          ← pending → trusted → verified → archived
├── Venue Evidence
│   ├── Coordinates confirmed
│   ├── Host confirmed
│   ├── Multiple independent events
│   ├── Multiple successful check-ins
│   └── No fraud reports
└── Trust Evidence         ← Check-in count, event history
```

**Venue lifecycle (mirrors Topics):**

```
User creates      Pending
     ↓
Used repeatedly   Trusted   ← Multiple independent events, check-ins
     ↓
Evidence met      Verified  ← Coordinates + Host confirmed, no fraud
     ↓
Deactivated       Archived
```

This symmetry with Topics (community creates → platform observes → platform verifies → platform normalises) is intentional. The same evidence-driven pattern recurs across the platform.

**Key constraints:**
- The external provider (OSM/Google) is a **discovery source only**. Yugrow owns venue identity, validation, trust, status, and check-in rules.
- A venue is not verified solely by usage count — it requires **multiple evidence signals** (coordinates confirmed, host confirmed, multiple independent events, successful check-ins, no fraud reports).
- Once a venue exists in Yugrow with sufficient evidence, it graduates from `pending` → `trusted` → `verified` — and Google/OSM is never called for that venue again.
- Search order ensures Yugrow's own venue database becomes the primary source over time, naturally reducing external API dependency.
- Community-driven verification: first person creates a venue, subsequent uses validate it. Aligned with the future Contribution Economy.

**Why not Google for Alpha:**
- $100+/month for 50K API calls is material for a pre-revenue startup
- The first 50-100 users will create events at a handful of venues (coworking spaces, incubators, hotels, conference centres — maybe 2,000-5,000 venues total for an entire city)
- OpenStreetMap is sufficient for this scale
- If user testing later shows venue search is the #1 friction point, that's evidence to justify the Google expense

**What to spend the $100/month on instead (prioritised):**
1. Crash reporting (Sentry)
2. Product analytics (PostHog)
3. Push notifications
4. Email delivery
5. Reliable hosting
6. _Then_ premium venue search (if evidence supports it)

**Metric for the first real meetup — Venue Creation Success Rate:**

Track:
- Existing venue selected
- New venue created successfully
- User abandoned venue creation
- Time taken to select/create a venue

If 70%+ abandon because they can't find or create a venue, that's evidence to move premium venue search up the priority list. If most complete the flow successfully, the cost was wisely deferred.

**Provider Confidence (future concept — not implemented yet):**

As the platform matures, provider selection should be governed by measurable triggers rather than intuition. Each capability has a primary provider, a fallback, and an evidence-based migration trigger:

| Capability | Primary | Fallback | Migration Trigger |
|---|---|---|---|
| Venue Search | Yugrow (verified venues) | Mapbox | Search success rate drops below target |
| Geocoding | Nominatim | Mapbox | Rate limits or latency impact users |
| Map Display | OpenStreetMap | MapTiler | Tile performance or reliability issues |

This makes provider changes measurable rather than opinion-driven, consistent with the evidence-before-investment pattern across the repository.

**Related:** FD-009 (BYOAI — provider-agnostic architecture), FD-030 (Professional Presence Platform — venues as presence sources), FD-004 (CheckIN Is Frictionless). The provider abstraction pattern makes this a configuration change, not an architecture change, when the time comes to switch.

---

## FD-025 — Founder Tooling Must Never Become User-Facing Functionality

**Date:** 2026-07-23
**Category:** Engineering, Product

Founder tools (test endpoints, seed data, debug UI, simulation controls) exist to accelerate product validation. They must remain isolated from production user flows — hidden behind gestures, flagged in the API, and never surfaced in the main navigation.

If users need the same capability, it must be redesigned as a product feature — not exposed directly from the Founder Console.

**Why:** Prevents years of technical debt. The line between "debug toggle" and "user setting" is the most expensive distinction to undo. Founder tools optimize for speed. Product features optimize for trust, UX, permissions, and scale. Never mix the two.

**Related:** The `/checkin/test/*` API namespace is explicitly excluded from production routing. A single feature flag can disable all founder endpoints in production environments.

---

## FD-026 — Validation Before Acceleration

**Date:** 2026-07-23
**Category:** Product, Engineering, Strategy

Never optimize or expand a feature until real users have demonstrated that it creates value. Evidence outranks intuition. Scale amplifies strengths — but it also amplifies mistakes.

**Why:** The most dangerous moment in a product's life is when it has enough features to feel real but hasn't yet validated which ones matter. Every feature built before validation risks solving a problem that doesn't exist, at the cost of delaying the problems that do.

**Related:** FD-012 (Build Vertical Slices), FD-024 (Conceptual Integrity). Validation milestones replace sprint numbers until evidence accumulates.

---

## FD-027 — Every Screen Must Answer One Question

**Date:** 2026-07-23
**Category:** Product, UX, Architecture

Every screen in Yugrow must answer exactly one question for the user. If a screen starts answering two questions, it's time to split it.

| Screen | Question |
|--------|----------|
| Events | Where should I go today? |
| Live | Who is here now? |
| Network | What relationships have I built? |
| Me | Who am I professionally? |
| Create Event | How do I bring professionals together? |
| Event Details | Why should I attend? |
| Chat | What should we discuss next? |

**Why:** This single principle prevents feature creep at the screen level. When a developer is tempted to add "one more section" to a screen, FD-027 forces the question: *"Does this answer the screen's primary question?"* If not, it either doesn't belong or deserves its own screen. Over time, this keeps Yugrow remarkably clean as the product grows.

**Related:** FD-024 (Conceptual Integrity), FD-026 (Validation Before Acceleration). Together, these three decisions form the product philosophy guardrail: strengthen existing concepts, validate before expanding, and never let a screen lose focus.

---

## FD-028 — Shared UI Components Represent Domain Objects

**Date:** 2026-07-23
**Category:** UI, Engineering, Architecture

A domain object (Event, Person, Relationship, Workspace, etc.) should have one canonical UI representation. New screens compose these shared components rather than creating alternate visual representations of the same object.

**Why:** Every time a new feature needs to display an Event, it should reuse `EventCard` rather than creating a new layout. Improvements to the shared component immediately benefit every screen that uses it — Home, Search, Host Preview, Recommendations, Relationship History — without duplicating design or logic.

**Related:** FD-024 (Conceptual Integrity). A reusable EventCard strengthens the Event concept rather than letting it fragment across multiple inconsistent visual representations.

---

## FD-029 — Sharing Should Celebrate Professional Progress, Not Vanity Metrics

**Date:** 2026-07-23
**Category:** Product, Marketing, UX

Whenever Yugrow generates content for social sharing (event recaps, connection summaries, attendance cards), it should highlight **relationships, learning, contribution, or participation** rather than raw counts or gamified achievements.

**Approved styles:**
- *"7 new professional connections"* ✅
- *"Met founders, engineers and investors"* ✅
- *"3 conversations started"* ✅
- *"Spoke at AI Summit Chennai"* ✅
- *"Hosted AI Meetup — 126 attendees"* ✅

**Avoid:**
- *"654 professionals"* ❌ — encourages quantity over quality
- *"Top 1% networker"* ❌ — gamification, not professional value
- *"Collected 200 connections"* ❌ — not meaningful

**Why:** Someone should feel proud to share a Yugrow card because it reflects a meaningful professional experience — not because it says they "collected" hundreds of people. This distinction makes the brand credible over time, and prevents the platform from drifting toward vanity metrics that weaken trust.

**Related:** FD-024 (Conceptual Integrity). Celebrating relationships instead of counts strengthens the Relationship concept rather than weakening it into a popularity score.

---

## FD-030 — Yugrow Is a Professional Presence Platform

**Date:** 2026-07-23
**Category:** Product, Architecture, Strategy

Yugrow is a **Professional Presence Platform**. Events are one source of verified professional presence — not the product itself.

**Professional presence is the foundation. Events are one source of professional presence — not the platform itself.**

Every future feature must either **create, verify, interpret, or preserve** professional presence. Features that do none of these do not belong in the platform.

**How this changes the product narrative:**

| | Old framing | New framing |
|--|-------------|-------------|
| Product | "A networking app for events" | "A professional presence platform" |
| Event role | The product | One source of presence among many |
| Moat | Event check-in | Verified physical presence |
| Future scope | More event features | More presence sources |

**Evolution in phases:**

```
Phase 1 (today)     Professional Events
                    Meetups, conferences, workshops, expos
                    │
Phase 2             Professional Places
                    Coworking spaces, innovation hubs, campuses, offices
                    │
Phase 3             Professional Networks
                    Broadcast, opportunities, trust evidence, discovery
```

Events are the Phase 1 bootstrap — they provide trust, density, easier validation, and easier moderation. But the architecture never lost the original capability: *check into any place and discover professionals around you.* Events were simply the strongest structured way to start.

**What this means in practice:**

| Proposal | Decision | Reason |
|----------|----------|--------|
| Build an event platform (compete with Luma/Eventbrite) | ❌ No | Events are a presence source, not the product |
| Support company offices as check-in locations | ✅ Yes | Offices create verified professional presence |
| Add QR/NFC check-in | ✅ Yes | Verifies presence |
| Add Bluetooth proximity detection | ✅ Yes | Verifies presence (with user consent) |
| Build opportunity recommendations | ✅ Yes | Interprets presence |
| Build AI auto-connections | ❌ No | Invents relationships; violates Design Axiom |
| Build photo feeds / social media features | ❌ No | Neither creates nor interprets presence |
| Build a chat platform (compete with Slack/WhatsApp) | ❌ No | Conversation is downstream of relationship, not standalone |
| Support coworking spaces | ✅ Yes | Professional presence context |
| Support university campuses | ✅ Yes | Professional presence context |
| Support spontaneous presence (no event) | ✅ Later | Architecture supports it; validation doesn't yet |
| Add free-form event categories (Party, Dinner, Hangout, Singles, Coffee, Friends) | ❌ Never | Violates professional context constraint (Constitution §0.4) |
| Allow personal profile fields (age, relationship status, hobbies, photo gallery) as primary signals | ❌ Never | Would shift the platform toward people-discovery, not context-discovery |
| Add social-only event types (dating, nightlife, entertainment) | ❌ Never | Outside the definition of a Professional Event |

**Why:** The platform's moat is **verified physical presence**. Every feature that strengthens this moat compounds the platform's value. Every feature that dilutes it (virtual networking, AI-generated connections, social media feeds) weakens the one thing competitors cannot replicate. This decision protects the moat.

**Why Phase 1 starts with events, not everywhere:** Events give Yugrow trust, density, easier validation, and easier moderation. The "check in anywhere" vision was never wrong — it was simply too broad for an MVP. Events are the strongest source of verified professional presence to start with. The architecture preserves the original capability; the product sequence determines when to unlock it. See Constitution §1.4 (The Two Horizons) for the complete model.

**Related:**
- FD-024 (Conceptual Integrity) — Every feature must strengthen an existing concept
- Constitution §0.1 (Design Axiom) — Never invent relationships, only reveal and record
- Constitution §0.2 (Three-Layer Model) — Events are Reality; relationships are Interpretation
- Constitution §0.4 (Professional Context) — Defines what a Professional Event is and the four constraints that protect it
- Constitution §1.4 (The Two Horizons) — Horizon 1 (Events) → Horizon 2 (Ambient Presence)

---

## FD-031 — URL Structure and Brand Architecture

**Date:** 2026-07-24
**Category:** Product, Architecture, Brand

Yugrow uses **subdomains for products** and **path-based URLs for domain entities**.

### Brand architecture

```
yugrow.in          Platform website (products, docs, blog, pricing, developers, company)
yugrow.app         CheckIn — Professional Presence Platform (the app)
```

### Product subdomains

Each major product gets its own subdomain under `yugrow.in`:

| Product | Domain | Status |
|---------|--------|--------|
| CheckIn | `yugrow.app` | Available — validation phase |
| Broadcast | `broadcast.yugrow.in` | Coming soon |
| CRM | `crm.yugrow.in` | Coming soon |
| Website Builder | `builder.yugrow.in` | Coming soon |
| HR | `hr.yugrow.in` | Coming soon |
| Finance | `finance.yugrow.in` | Coming soon |

**Why subdomains for products:**
- Each product is independently deployable and versioned
- Shared platform identity (users know it's official Yugrow)
- Easier SSL, authentication, and SSO across products
- Products can evolve at different speeds without coupling

### Domain entity URLs

All domain entities use **path-based URLs** under `yugrow.in` with namespace prefixes:

| Namespace | Entity | Example |
|-----------|--------|---------|
| `/u/` | Person | `yugrow.in/u/jayam` |
| `/o/` | Organization / Workspace | `yugrow.in/o/yugrow` |
| `/e/` | Event | `yugrow.in/e/ai-summit-chennai` |
| `/v/` | Venue | `yugrow.in/v/tidel-park` |
| `/t/` | Topic | `yugrow.in/t/artificial-intelligence` |

**Why not subdomains for entities:** Users are resources, not applications. The `yugrow.in/jayam` pattern is familiar (GitHub, LinkedIn, X). Subdomains are reserved for independently deployable products.

**Why namespaces:** Prevents collisions. A person named "Microsoft" should not own `yugrow.in/microsoft` — that belongs to the organization. Namespaces (`/u/`, `/o/`) keep all entity types distinct and unambiguous.

### What every user gets at signup

Every person who signs up automatically receives a permanent public address:

```
yugrow.in/u/{username}
```

Initially this contains: Profile, Looking For, Links, Professional Identity.

Over time it evolves into: Website, Portfolio, Events attended, Blogs, Products, Booking, Contact — all under the same URL. No breaking changes.

This URL is the foundation of the Website Builder. The first website the builder publishes is the user's own professional identity page.

### The journey

```
User signs up
    ↓
yugrow.in/u/jayam created immediately
    ↓
Today: Professional profile + links
    ↓
Later: Full website (Website Builder)
    ↓
Later: Custom domain (jayam.com)
```

**Related:**
- FD-024 (Conceptual Integrity) — Every feature strengthens an existing concept
- Constitution §1.2 — The Professional Graph

---

## FD-032 — System Conversations

**Date:** 2026-07-28
**Category:** Product, Architecture

Every person has a permanent, trusted conversation with Yugrow itself. This System Conversation is created automatically at onboarding completion and serves as the user's ongoing relationship channel with the platform.

### What the Yugrow conversation contains

```
Yugrow
│
├── Welcome message
├── Product tips & onboarding guidance
├── Release notes & version updates
├── Feedback & bug reports
├── Beta invitations
├── Survey requests
├── Feature announcements
├── Personal replies from the team
├── Proactive messages (profile incomplete, follow-up reminders, etc.)
└── Support (human-escalated when needed)
```

### Architectural principles

1. **No new engine** — System Conversations are a product pattern on top of the existing Conversation Engine. The same models (Conversation, Message, Participant) are reused.
2. **System actors are identified** — Yugrow is a `system_persona` participant in each conversation. Admins can reply as Yugrow.
3. **Feedback pipeline** — Every message a professional sends to Yugrow enters a feedback pipeline (initially manual via Founder Console, later automated via Feedback Intelligence Engine).
4. **Proactive messages** — Yugrow can initiate conversations (tips, reminders, announcements) through the same engine.
5. **Success stories are special** — Messages flagged as "wins" (e.g., "I met my co-founder") enter a separate pipeline for founder review and potential marketing use.

### What is NOT built yet

The Feedback Intelligence Engine (automated classification, clustering, GitHub issue generation, user notification) remains dormant. Only the System Conversation itself is built in Alpha.

### Why this is a Founder Decision

This defines a long-term product philosophy:

> *Every professional has a permanent, trusted conversation with Yugrow.*

Not a support ticket system. Not a chatbot. A relationship channel. This shapes how Yugrow communicates with every professional for the lifetime of the platform.

**Related:**
- FUTURE-BOUNDED-CONTEXTS.md — Feedback Intelligence Engine (dormant), System Conversations (design note), Product Memory (design note)
- PRODUCT-STORY-LANGUAGE.md — Yugrow Chat screen story
- Constitution §0.2 (Three-Layer Model) — People are Reality; profiles are Interpretation
