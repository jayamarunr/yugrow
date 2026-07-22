# Yugrow

> **Business relationships made effortless.**

Yugrow is a **Business Relationship Operating System** — an AI-native platform that helps professionals discover, connect, and grow with each other. Not a CRM. Not a social network. A presence platform for real-world business relationships.

---

## Quick Start

```bash
# Install dependencies
pnpm install

# Generate Prisma client
cd apps/api && npx prisma generate && cd ../..

# Build the API
cd apps/api && npx nest build && cd ../..

# Run Flutter mobile app (Chrome)
cd apps/mobile && flutter run -d chrome
```

If debug WebSocket fails, build and serve the release version instead:

```bash
cd apps/mobile
flutter build web --release
cd build/web && python -m http.server 8080
```

> **Note:** The API server has a known path alias issue at runtime (`@database/index` resolution). See [apps/api/README.md](apps/api/README.md) for workarounds.

---

## What We've Built

### ✅ Yugrow Flutter — Complete Networking Experience (MVP)

A polished Flutter mobile app implementing the full relationship creation loop. Built with **Warm Professional** design philosophy — confidence of Stripe + humanity of Airbnb + precision of Linear. No backend required for preview — all data is mock.

```
Arrival → Become Visible → Discovery → Profile → Connect → Acceptance → First Message
```

| Feature | Status | Details |
|---------|--------|---------|
| **Arrival** | ✅ Built | Event list, greeting, ecosystem metrics (Businesses, Professionals, Visitors, Here Now) |
| **Event Detail** | ✅ Built | Full breakdown, "Your Opportunity" section, "Who's here" taxonomy, multi-day support |
| **Proximity Gate** | ✅ Built | 3-second simulated check-in → "You're now visible" celebration |
| **Live Discovery** | ✅ Built | 15+ professional cards, heartbeat with rotating arrival messages, "Show More" pagination |
| **Professional Cards** | ✅ Built | Avatar, name, title, company, actionable `lookingFor` chip, mutual connections, Quick Connect `+` button, "Checked in" label |
| **Profile Preview** | ✅ Built | Full profile with "Why you should connect" section, skills, looking for, recent activity |
| **Connection Flow** | ✅ Built | One-tap Connect → randomized acceptance (2s/5s/10s) → "You're Connected" with event context |
| **First Message** | ✅ Built | 3 deterministic conversation starters generated from profile (role, industry, skills, lookingFor) |
| **Dark Mode** | ✅ Built | Full dark theme, system-aware |

### ✅ Design System (v2.0)

Complete experience system with Warm Professional philosophy.

**Signature concepts:**
- **"Relationships are the color"** — Deep Emerald (#115E59) appears only at Connected, Accepted, Opportunity Found
- **"Design around People, not Data"** — profiles before dashboards
- **Inspired by:** Leica, Bang & Olufsen, Porsche, Muji, Aesop, Apple Hardware — not SaaS
- **Everything under 250ms** — Linear-fast motion
- **Three-profile architecture:** Professionals, Organizations, Events — one design language

**Key documents:**

| Document | Description |
|----------|-------------|
| [Yugrow Flow v2.0](docs/YUGROW-FLOW-EXPERIENCE-SYSTEM.md) | Complete experience system (19 parts) |
| [Design Principles](docs/YUGROW-DESIGN-PRINCIPLES.md) | 10 non-negotiable principles |
| [Design Kit v1.0](docs/YUGROW-DESIGN-KIT.md) | Implementation reference with Flutter + Web code |
| [Founder Decisions](docs/FOUNDER-DECISIONS.md) | 14 irreversible product decisions |

### ✅ Backend — CheckIN + Communication + Product

| Feature | Status | Details |
|---------|--------|---------|
| Venue CRUD | ✅ Built | User-contributed pin-dropping |
| Event CRUD | ✅ Built | Anyone can create |
| Presence (Check-in) | ✅ Built | Auto-expires, workspace-aware |
| Live Discovery | ✅ Built | Ranked by mutual connections |
| Connection Flow | ✅ Built | One-tap, auto-context attached |
| Conversations | ✅ Built | Belongs to Relationship |
| Messages (text) | ✅ Built | Immutable, text-only |
| Context Display | ✅ Built | Event + Venue + Date |
| 20+ API endpoints | ✅ Built | POST/GET conversations, messages, context |
| Product Registration | ✅ Built | Admin APIs for products, capabilities, plans |
| **Server startup** | ❌ Blocked | Path alias resolution issue |

### ✅ Architecture & Strategy

| Document | Status |
|----------|--------|
| Platform Constitution (58 rules) | ✅ Frozen |
| Enterprise Architecture (v2.0, 27 parts) | ✅ Frozen |
| Product Strategy Bible | ✅ Approved |
| 19 Engine Specifications | ✅ Complete |
| Business Object Bible | ✅ Complete |
| Intelligence Layer | ✅ Complete |
| Founder Decisions — 14 decisions | ✅ Codified |
| CheckIN Minimum Lovable PRD | ✅ Approved |
| AI Agent Playbooks (9 roles) | ✅ Active |

---

---

## Repository Structure

```
yugrow/
├── apps/
│   ├── api/          # NestJS 10 backend (CheckIN, Communication, Product)
│   ├── mobile/       # Flutter app (15+ screens: Arrival, Discovery, Profile, First Message, etc.)
│   └── web/          # Next.js 14 web app
├── packages/
│   ├── database/     # Prisma schema (25+ models)
│   ├── ui/           # YDL Design System + Journey Engine
│   ├── auth/         # Auth module
│   ├── config/       # Shared config
│   ├── core/         # Core utilities
│   ├── logger/       # Logging
│   ├── sdk/          # Platform SDK
│   ├── shared/       # Shared types
│   └── types/        # Type definitions
├── docs/
│   ├── YUGROW-FLOW-EXPERIENCE-SYSTEM.md   # Design system (v2.0)
│   ├── YUGROW-DESIGN-PRINCIPLES.md         # 10 design principles
│   ├── YUGROW-DESIGN-KIT.md               # Component implementation kit
│   └── FOUNDER-DECISIONS.md               # 14 irreversible product decisions
├── architecture/       # Architecture diagrams & docs
├── governance/         # Coding standards, security, principles
├── backlog/           # Epics, features, ideas
├── knowledge/         # Research, decisions, meeting notes
├── playbooks/         # Human playbooks by role (stubs — planned)
├── agents/            # AI agent instructions (9 playbooks + code review checklist)
├── Volume-0-Company/  # Manifesto, strategy, flywheel
├── Volume-1-Product/  # Product charter, portfolio
├── Volume-2-Architecture/  # EA, engineering blueprint
└── adr/              # Architecture Decision Records
```

---

## Project Status Dashboard

| Area | Score | Status |
|------|-------|--------|
| **Vision** | 10/10 | Clear, differentiated, human-first |
| **Product Thinking** | 9.8/10 | CheckIN-first strategy, ruthless simplification |
| **Flutter Experience** | 9.5/10 | 15+ screens, full networking loop, Warm Professional design |
| **Architecture** | 10/10 | Frozen. 19 engines, 58 constitutional rules |
| **Design Philosophy** | 9.5/10 | Warm Professional, "Relationships are the color" |
| **UX Principles** | 9.5/10 | 10 principles, FD-001 through FD-014 codified |
| **Documentation** | 10/10 | Constitution through Design Kit — foundational phase complete |
| **AI Agent System** | 9/10 | 9 playbooks covering all engineering roles + code review checklist |

> **Foundational phase: COMPLETE.**
>
> The question has shifted from *"What should we build?"* to *"Does this implementation deserve to exist?"*
>
> Every PR must answer: What user problem does this solve? What design principle does it support? How does it improve the magic moment?

### The Complete Networking Loop

```
✅ Open App → ✅ Choose Event → ✅ Arrive → ✅ Become Visible →
✅ Discover Professionals → ✅ Open Profile → ✅ Quick Connect / Full Connect →
✅ Acceptance (randomized) → ✅ "You're Connected" with event context →
✅ Say Hello → ✅ First Message with conversation starters
```

**Next up:** My Connections (Relationship Hub) — Sprint 5

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Backend** | NestJS 10 + TypeScript |
| **Database** | PostgreSQL + Prisma 5 |
| **Mobile** | Flutter 3.44 + Dart 3.12 + flutter_lucide 1.11 + Google Fonts (Inter) |
| **Design Tokens** | AppColors, AppSpacing, AppRadius — custom theme with dark mode |
| **Web** | Next.js 14 + React 18 |
| **Monorepo** | Turborepo 2.10 + pnpm |
| **Auth** | OTP-based (phone), API key (admin) |

---

## Key Documents

| Resource | File |
|----------|------|
| 📜 Constitution | [YUGROW-CONSTITUTION.md](YUGROW-CONSTITUTION.md) |
| 📖 Yugrow Bible | [YUGROW-BIBLE.md](YUGROW-BIBLE.md) |
| 💡 Founder Decisions (FD-001–FD-014) | [docs/FOUNDER-DECISIONS.md](docs/FOUNDER-DECISIONS.md) |
| 🏛️ Enterprise Architecture | [Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md](Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md) |
| 🎨 Yugrow Flow v2.0 | [docs/YUGROW-FLOW-EXPERIENCE-SYSTEM.md](docs/YUGROW-FLOW-EXPERIENCE-SYSTEM.md) |
| 🧩 Design Principles | [docs/YUGROW-DESIGN-PRINCIPLES.md](docs/YUGROW-DESIGN-PRINCIPLES.md) |
| 🛠️ Design Kit v1.0 | [docs/YUGROW-DESIGN-KIT.md](docs/YUGROW-DESIGN-KIT.md) |
| 🌟 Product Strategy | [Volume-1-Product/PRODUCT-STRATEGY-BIBLE.md](Volume-1-Product/PRODUCT-STRATEGY-BIBLE.md) |
| 📋 CheckIN PRD | [backlog/Features/CHECKIN-MINIMUM-LOVABLE-PRD.md](backlog/Features/CHECKIN-MINIMUM-LOVABLE-PRD.md) |
| 🗺️ Roadmap | [ROADMAP.md](ROADMAP.md) |
| 🏁 Milestones | [MILESTONES.md](MILESTONES.md) |
| 🏛️ ADRs | [adr/](adr/) |
| 🤖 AI Agents (9 playbooks) | [agents/](agents/) |
| 📘 Human Playbooks (planned) | [playbooks/](playbooks/) |

---

## Platform Vision

```
Presence Platform (CheckIN)    ← NOW — real-world networking
    ↓
Identity + Workspace           ← Core infrastructure
    ↓
Relationships + Communication  ← Graph + conversation
    ↓
Broadcast + Discovery          ← Opportunities
    ↓
CRM + Workflow                 ← Business management
    ↓
Commerce + Marketplace         ← Monetization
```

### North Star

> **Meaningful Connections Created** — accepted connection + event context + conversation started.

Not check-ins. Not DAU. The real value is relationships formed.

### The Yugrow Success Story

> *"I went to an expo. I discovered someone valuable I didn't know. We connected in 30 seconds. We continued the conversation after the event."*

---

## License

See [LICENSE](LICENSE) file.
