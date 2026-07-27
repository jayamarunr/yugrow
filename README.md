# Yugrow

> **The purpose of the architecture is not to predict the future. It is to make it safe to discover the future.**

[Validation Phase](#-current-status) — *Does verified presence at professional events create better professional relationships?*

---

Yugrow is a **Professional Presence Platform** — not a CRM, not a social network, not an event platform. It helps professionals discover the right people at the right place and turn those introductions into lasting business relationships.

**Events are our first validated source of professional presence — not our final destination.** The architecture supports Horizon 1 (events) today and Horizon 2 (ambient presence at any professional place) when validation earns it. See [`CONSTITUTION.md`](./CONSTITUTION.md) §1.4.

---

## Quick Start

### Prerequisites
- Docker Desktop (PostgreSQL 17)
- Flutter 3.44+ / Dart 3.12+
- Node.js 20+
- pnpm

### Start Infrastructure

```bash
docker compose -f infrastructure/docker/docker-compose.yml up -d
```

### Start Development

**Single terminal (API + Web + Admin):**
```bash
pnpm dev
```

This starts all three services via Turborepo:

| Service | URL |
|---------|-----|
| **API (NestJS)** | http://localhost:3001 |
| **Web (Next.js)** | http://localhost:3000 |
| **Admin (Next.js)** | http://localhost:3003 |
| **Swagger Docs** | http://localhost:3001/api/docs |

**Flutter Mobile (separate terminal):**
```bash
cd apps/mobile
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3001
```

**Mobile on physical device (same WiFi):**
```bash
cd apps/mobile
flutter run --dart-define=API_BASE_URL=http://<YOUR_LOCAL_IP>:3001
```

### Setup (first time only)

```bash
pnpm install

# Generate Prisma client and push schema
cd packages/database
$env:DATABASE_URL="postgresql://yugrow:yugrow_password@localhost:5432/yugrow"
npx prisma generate
npx prisma db push
cd ../..

# Copy API .env
Copy-Item apps/api/.env.example apps/api/.env
```

---

## What We've Built

### ✅ Yugrow Flutter — Complete Professional Networking App

A Flutter mobile app implementing the full relationship lifecycle. Built with **Warm Professional** design philosophy.

**Current version:** `v0.2.0-alpha` (tagged)

### Application Shell

```
🏠 Events    📍 Live ●    🤝 Network    👤 Me
```

| Tab | Purpose | Question |
|-----|---------|----------|
| **Events** | Discover nearby events + host your own | Where should I go today? |
| **Live** | Check in, presence, discover people | Who's here right now? |
| **Network** | Relationships grouped by event | What relationships have I built? |
| **Me** | Professional identity, settings | Who am I professionally? |

| Feature | Status | Details |
|---------|--------|---------|
| **Application Shell** | ✅ Built | 4-tab navigation: Events, Live, Network, Me. Messages accessible from Network. |
| **Home (Events)** | ✅ Built | Nearby events timeline, greeting, empty state, long-press Y for Founder Console |
| **Host Event** | ✅ Built | Full form: event type, name, venue search/create, date, time, description, topics, visibility, audience size, hosted by. Preview card. Created in under 60s. Venues auto-imported from external providers (Mapbox/Nominatim) into Yugrow DB on selection. |
| **Attendee Preview** | ✅ Built | Live card preview showing event type, topics, date/time, venue, visibility. |
| **Post-Create Screen** | ✅ Built | 🎉 celebration, "I'm Here Now", "Copy Invite Link", "Back to Events" |
| **Event Check-In** | ✅ Built | Proximity gate → "I'm Here" → confirmation → discovery |
| **Live Presence** | ✅ Built | Ranked by mutual connections, heartbeat messages, real-time feel |
| **Connection Flow** | ✅ Built | One-tap Connect → acceptance → event context preserved |
| **Conversations** | ✅ Built | Per-relationship messaging, immutable text |
| **Founder Mode Banner** | ✅ Built | Amber banner when seeded test data is active |
| **Green Live Dot** | ✅ Built | Green indicator on Live tab when presence is active |
| **Presence Restore** | ✅ Built | Active presence survives app restarts |
| **Dark Mode** | ✅ Built | Full dark theme, system-aware |

### ✅ Founder Console

Hidden tools accessible via long-press Y logo on the Events tab (also accessible from Me tab).

```
Founder Console
├── App Info (version, build)
├── API Health (status, refresh)
├── Event Dashboard (real vs seeded counts per event)
├── Event Management
│   ├── Create Test Event (form: name, venue, city, visibility)
│   ├── List of active events with inline: [Edit] [End] [Duplicate] [Seed]
│   └── Edit form (name + visibility)
├── Sign in as Founder (real JWT authentication)
└── Test Data
    ├── Seed 20 Test Attendees
    ├── Clear All Presence
    └── Reset Demo Data
```

### ✅ Backend — NestJS API

| Feature | Status | Details |
|---------|--------|---------|
| Venue CRUD | ✅ Built | Search, create, get. Duplicate detection by name+city. External venue auto-import (Mapbox/Nominatim → Yugrow DB) on selection. |
| Event CRUD | ✅ Built | Create, list, get, update. PATCH + expire + duplicate endpoints. |
| Presence (Check-in) | ✅ Built | Auto-expires (4h default), workspace-aware, active-presence query |
| Live Discovery | ✅ Built | Ranked by mutual connections, person info, professional identity |
| Connection Flow | ✅ Built | One-tap, auto-context (event + venue + time), 24h window |
| Conversations | ✅ Built | Belongs to Relationship, auto-created on connection accept |
| Messages (text) | ✅ Built | Immutable, text-only, per-conversation |
| **Real JWT Authentication** | ✅ Built | `@nestjs/jwt`, HS256, 24h expiry, public decorator for routes |
| **Founder Demo Login** | ✅ Built | `POST /checkin/test/login` — creates/returns founder with real JWT |
| **Founder Mode APIs** | ✅ Built | `test/seed`, `test/clear-presence`, `test/reset`, `test/status` |
| **CORS** | ✅ Built | Configured via `CORS_ORIGIN` env var for multiple dev ports |
| 25+ API endpoints | ✅ Built | Full CheckIN + Communication + Identity |

### ✅ Architecture & Strategy

| Document | Status |
|----------|--------|
| Platform Constitution (58 rules) | ✅ Frozen |
| Enterprise Architecture (v2.0, 27 parts) | ✅ Frozen |
| Product Strategy Bible | ✅ Approved |
| 19 Engine Specifications | ✅ Complete |
| Business Object Bible | ✅ Complete |
| Intelligence Layer | ✅ Complete |
| **Founder Decisions — 27 decisions** | ✅ Codified |
| **Domain Language** | ✅ Frozen |
| **Presence Model** | ✅ Frozen |
| CheckIN Minimum Lovable PRD | ✅ Approved |
| AI Agent Playbooks (9 roles) | ✅ Active |

### ✅ Design Foundation (Frozen 2026-07-28)

| Document | Status |
|----------|--------|
| **YUGROW-DESIGN-LANGUAGE.md** — Colours, typography, components, spacing, icons | ✅ Frozen |
| **YUGROW-BRAND-LANGUAGE.md** — Brand identity, tone, vocabulary, writing principles | ✅ Frozen |
| **YUGROW-MOTION-LANGUAGE.md** — 4 allowed animations, timing, sound, haptics | ✅ Frozen |
| **YUGROW-ILLUSTRATION-LANGUAGE.md** — Empty states, success screens, photography, assets | ✅ Frozen |
| **PRODUCT-STORY-LANGUAGE.md** — Story every screen tells, narrative arc | ✅ Approved |

Design Language is to experience what the Constitution is to architecture. Every UI decision must reference these documents before implementation.

---

## Product Philosophy

### Positioning

> **The professional networking layer for real-world business events.**

Not an event platform. Events are the context. Networking is the product.

### Founder Decisions (27)

| # | Decision | Category |
|---|----------|----------|
| FD-001 | One Identity Per Person | Identity |
| FD-002 | Active Workspace Context | Architecture |
| FD-003 | Attendance ≠ Expertise | Intelligence |
| FD-004 | CheckIN Is Frictionless | Product |
| FD-005 | Relationships Are Permanent, Presence Is Temporary | Data |
| FD-006 | Broadcast Uses Skills + Geography | Product |
| FD-007 | Every Interaction Must Reduce Friction | UX |
| FD-008 | Monetize Capability, Not Existence | Pricing |
| FD-009 | Bring Your Own AI | AI |
| FD-010 | Commerce Is Configuration | Commerce |
| FD-011 | Platform Administration Is Internal | Architecture |
| FD-012 | Build Vertical Slices | Engineering |
| FD-013–FD-023 | (Additional decisions) | Various |
| FD-024 | Conceptual Integrity | Product |
| FD-025 | Founder Tooling Never Becomes User-Facing | Engineering |
| FD-026 | Validation Before Acceleration | Strategy |
| FD-027 | Every Screen Answers One Question | UX |

### Navigation Philosophy

Most apps organize navigation around **objects** (Chats, Contacts, Events). Yugrow organizes navigation around **questions** the professional asks:

- **Events** → *"Where should I go today?"*
- **Live** → *"Who's here right now?"*
- **Network** → *"What relationships have I built?"*
- **Me** → *"Who am I professionally?"*

Every future feature must answer one of these four questions to earn a place in the shell.

---

## The Complete Loop

```
✅ Sign In → ✅ Complete Profile → ✅ Find Event → ✅ Host / Join →
✅ Check In → ✅ Discover People → ✅ Connect → ✅ Conversation →
✅ Relationship Persists
```

### North Star

> **Meaningful Connections Created** — accepted connection + event context + conversation started.

Not check-ins. Not DAU. The real value is relationships formed.

### The Yugrow Success Story

> *"I went to an expo. I discovered someone valuable I didn't know. We connected in 30 seconds. We continued the conversation after the event."*

---

## Repository Structure

```
yugrow/
├── apps/
│   ├── api/              # NestJS 10 backend (CheckIN, Identity, Communication)
│   ├── mobile/           # Flutter app (Events, Live, Network, Me, Host Event, Founder Console)
│   └── web/              # Next.js 14 web app
├── packages/
│   ├── database/         # Prisma schema (25+ models)
│   ├── ui/               # YDL Design System + Journey Engine
│   ├── auth/             # Auth module
│   ├── config/           # Shared config
│   ├── core/             # Core utilities
│   ├── logger/           # Logging
│   ├── sdk/              # Platform SDK
│   ├── shared/           # Shared types
│   └── types/            # Type definitions
├── architecture/         # Architecture diagrams & docs
├── governance/           # Coding standards, security, principles
├── backlog/              # Epics, features, ideas
├── knowledge/            # Research, decisions, meeting notes
├── playbooks/            # Human playbooks by role
├── agents/               # AI agent instructions (9 playbooks)
├── Volume-0-Company/     # Manifesto, strategy, flywheel
├── Volume-1-Product/     # Product charter, portfolio
├── Volume-2-Architecture/# EA, engineering blueprint
├── adr/                  # Architecture Decision Records
├── docs/                 # Design system, principles, design kit
│
├── YUGROW-CONSTITUTION.md       # 58 non-negotiable rules
├── YUGROW-BIBLE.md              # Complete reference
├── YUGROW-DOMAIN-LANGUAGE.md    # Precise vocabulary
├── YUGROW-PRESENCE-MODEL.md     # Foundational model
├── DECISIONS.md                 # 27 founder decisions
├── MEETUP-CHECKLIST.md          # First meetup runbook
├── ALPHA-METRICS.md             # Per-meetup measurements
├── QUESTIONS.md                 # What we're trying to discover
├── MILESTONES.md                # Project milestones
├── ROADMAP.md                   # Product roadmap
└── LEARNINGS.md                 # What actually happened
```

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Backend** | NestJS 10 + TypeScript + JWT (HS256) |
| **Database** | PostgreSQL 17 + Prisma 5 (ORM) |
| **Mobile** | Flutter 3.44 + Dart 3.12 |
| **Icons** | flutter_lucide 1.11 |
| **Typography** | Google Fonts (Inter) |
| **State/Routing** | go_router 14, flutter_riverpod |
| **HTTP** | dio 5 |
| **Storage** | flutter_secure_storage 9 |
| **Design Tokens** | AppColors, AppSpacing, AppRadius — custom theme with dark mode |
| **Web** | Next.js 14 + React 18 |
| **Monorepo** | Turborepo 2.10 + pnpm |
| **Infrastructure** | Docker Compose (PostgreSQL, Redis, RabbitMQ, MinIO) |

---

## Current Status

| Area | Status |
|------|--------|
| **Foundation** | ✅ Frozen (Constitution, Architecture, Domain Language) |
| **Presence** | ✅ Complete (Check-in, auto-expiry, workspace-aware) |
| **Events** | ✅ Complete (Discovery, Host, Join, Check-in flow) |
| **Networking** | ✅ Complete (Discovery, Connect, Conversation) |
| **App Shell** | ✅ Complete (Events, Live, Network, Me) |
| **Founder Tools** | ✅ Complete (Console, Seed, Reset, Status) |
| **Authentication** | ✅ Complete (Real JWT, founder login, public routes) |
| **Documentation** | ✅ Complete (27 decisions, runbook, metrics, questions) |
| **Validation** | 🔜 **NEXT** (Run real meetups, collect evidence) |

**Tagged:** `v0.2.0-alpha`

---

## Key Documents

| Resource | File |
|----------|------|
| 📜 Constitution | [YUGROW-CONSTITUTION.md](YUGROW-CONSTITUTION.md) |
| 📖 Yugrow Bible | [YUGROW-BIBLE.md](YUGROW-BIBLE.md) |
| 💡 Founder Decisions (FD-001–FD-027) | [DECISIONS.md](DECISIONS.md) |
| 🏛️ Enterprise Architecture | [Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md](Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md) |
| 🎨 Yugrow Flow v2.0 | [docs/YUGROW-FLOW-EXPERIENCE-SYSTEM.md](docs/YUGROW-FLOW-EXPERIENCE-SYSTEM.md) |
| 🧩 Design Principles | [docs/YUGROW-DESIGN-PRINCIPLES.md](docs/YUGROW-DESIGN-PRINCIPLES.md) |
| 🛠️ Design Kit v1.0 | [docs/YUGROW-DESIGN-KIT.md](docs/YUGROW-DESIGN-KIT.md) |
| 🌟 Product Strategy | [Volume-1-Product/PRODUCT-STRATEGY-BIBLE.md](Volume-1-Product/PRODUCT-STRATEGY-BIBLE.md) |
| 📋 CheckIN PRD | [backlog/Features/CHECKIN-MINIMUM-LOVABLE-PRD.md](backlog/Features/CHECKIN-MINIMUM-LOVABLE-PRD.md) |
| 🔤 Domain Language | [YUGROW-DOMAIN-LANGUAGE.md](YUGROW-DOMAIN-LANGUAGE.md) |
| 🧭 Presence Model | [YUGROW-PRESENCE-MODEL.md](YUGROW-PRESENCE-MODEL.md) |
| 🗺️ Roadmap | [ROADMAP.md](ROADMAP.md) |
| 🏁 Milestones | [MILESTONES.md](MILESTONES.md) |
| 📊 Alpha Metrics | [ALPHA-METRICS.md](ALPHA-METRICS.md) |
| ❓ Open Questions | [QUESTIONS.md](QUESTIONS.md) |
| ✅ Meetup Checklist | [MEETUP-CHECKLIST.md](MEETUP-CHECKLIST.md) |
| 🏛️ ADRs | [adr/](adr/) |
| 🤖 AI Agents (9 playbooks) | [agents/](agents/) |

---

## License

See [LICENSE](LICENSE) file.
