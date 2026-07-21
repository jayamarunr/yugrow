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

> **Note:** The API server has a known path alias issue at runtime (`@database/index` resolution). See [apps/api/README.md](apps/api/README.md) for workarounds.

---

## What We've Built

### ✅ CheckIN — Presence Platform (MVP)

The killer feature. Real-world networking with instant digital follow-up.

```
Physical World → Venue → Event → "I'm Here" → Live Discovery → Connect → Relationship Created → Chat
```

| Feature | Status | Details |
|---------|--------|---------|
| Venue CRUD | ✅ Built | User-contributed pin-dropping |
| Event CRUD | ✅ Built | Anyone can create |
| Presence (Check-in) | ✅ Built | Auto-expires, workspace-aware |
| Live Discovery | ✅ Built | Ranked by mutual connections |
| Connection Flow | ✅ Built | One-tap, auto-context attached |
| Analytics | ✅ Built | 6 event types tracked |
| **Backend** | ✅ Built | NestJS 10, 14+ endpoints |
| **Flutter App** | ✅ Built | 8 screens, runs on Chrome |
| **Server startup** | ❌ Blocked | Path alias resolution issue |

### ✅ Communication Lite

Auto-creates a conversation when two people connect. Just text, context, and notifications.

| Feature | Status | Details |
|---------|--------|---------|
| Conversations | ✅ Built | Belongs to Relationship |
| Messages (text) | ✅ Built | Immutable, text-only |
| Context Display | ✅ Built | Event + Venue + Date |
| 6 API endpoints | ✅ Built | POST/GET conversations, messages, context |

### ✅ Product Registration Framework

Admin APIs for registering products with capabilities, plans, and feature flags.

### ✅ Yugrow Flow — Design System (v2.0)

Complete experience system — 19 parts covering brand through implementation.

**Philosophy:** Warm Professional — confidence of Stripe + humanity of Airbnb + precision of Linear.

**Key documents:**

| Document | Description |
|----------|-------------|
| [Yugrow Flow v2.0](docs/YUGROW-FLOW-EXPERIENCE-SYSTEM.md) | Complete experience system (19 parts) |
| [Design Principles](docs/YUGROW-DESIGN-PRINCIPLES.md) | 10 non-negotiable principles |
| [Design Kit v1.0](docs/YUGROW-DESIGN-KIT.md) | Implementation reference with code |

**Signature concepts:**
- **"Relationships are the color"** — Deep Emerald appears only at Connected, Accepted, Opportunity Found
- **"Design around People, not Data"** — profiles before dashboards
- **Inspired by:** Leica, Bang & Olufsen, Porsche, Muji, Aesop — not SaaS
- **Everything under 250ms** — Linear-fast motion

### ✅ Architecture & Strategy

| Document | Status |
|----------|--------|
| Platform Constitution (58 rules) | ✅ Frozen |
| Enterprise Architecture (v2.0, 27 parts) | ✅ Frozen |
| Product Strategy Bible | ✅ Approved |
| 19 Engine Specifications | ✅ Complete |
| Business Object Bible | ✅ Complete |
| Intelligence Layer | ✅ Complete |
| DECISIONS.md — 12 Founder Decisions | ✅ Codified |
| CheckIN Minimum Lovable PRD | ✅ Approved |

---

## Repository Structure

```
yugrow/
├── apps/
│   ├── api/          # NestJS 10 backend (CheckIN, Communication, Product)
│   ├── mobile/       # Flutter app (8 screens)
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
│   └── YUGROW-DESIGN-KIT.md               # Component implementation kit
├── architecture/       # Architecture diagrams & docs
├── governance/         # Coding standards, security, principles
├── backlog/           # Epics, features, ideas
├── knowledge/         # Research, decisions, meeting notes
├── playbooks/         # Human playbooks by role
├── agents/            # AI agent instructions
├── Volume-0-Company/  # Manifesto, strategy, flywheel
├── Volume-1-Product/  # Product charter, portfolio
├── Volume-2-Architecture/  # EA, engineering blueprint
└── adr/              # Architecture Decision Records
```

---

## Project Status Dashboard

| Area | Status | Notes |
|------|--------|-------|
| **Architecture** | ✅ **10/10** | Frozen. 19 engines, 58 constitutional rules |
| **Product Vision** | ✅ **10/10** | CheckIN-first strategy, warm professional identity |
| **Experience System** | ✅ **9/10** | Warm Professional v2.0, design kit complete |
| **Backend (CheckIN MVP)** | ✅ Built | 14 endpoints, cannot start (path alias bug) |
| **Backend (Communication)** | ✅ Built | 6 endpoints, auto-conversation on connect |
| **Backend (Product Reg)** | ✅ Built | Admin CRUD, plan assignments |
| **Flutter Mobile App** | ✅ Built | 8 screens, runs on Chrome |
| **Database Schema** | ✅ Built | 25+ models, Prisma + PostgreSQL |
| **Journey Engine** | ✅ Built | Frontend orchestration layer |
| **Server Deployment** | ❌ Blocked | Path alias resolution (`@database/index`) |
| **Tests** | ⏳ Not Run | Pending server fix |
| **Real-world Experiment** | ⏳ Planned | 20-50 people at a meetup |

### The Complete Loop

```
✅ Physical World → ✅ Venue → ✅ Event → ✅ "I'm Here" →
✅ Live Discovery → ✅ Connection Request → ✅ Relationship Created →
✅ Conversation Auto-Created → ✅ "Say Hello"
```

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Backend** | NestJS 10 + TypeScript |
| **Database** | PostgreSQL + Prisma 5 |
| **Mobile** | Flutter 3.x + Riverpod + GoRouter |
| **Web** | Next.js 14 + React 18 |
| **Design System** | Yugrow Flow (Inter, Lucide, Deep Emerald #0F766E) |
| **Monorepo** | Turborepo 2.10 + pnpm |
| **Auth** | OTP-based (phone), API key (admin) |

---

## Key Documents

| Resource | File |
|----------|------|
| 📜 Constitution | [YUGROW-CONSTITUTION.md](YUGROW-CONSTITUTION.md) |
| 📖 Yugrow Bible | [YUGROW-BIBLE.md](YUGROW-BIBLE.md) |
| 💡 Founder Decisions | [DECISIONS.md](DECISIONS.md) |
| 🏛️ Enterprise Architecture | [Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md](Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md) |
| 🎨 Yugrow Flow v2.0 | [docs/YUGROW-FLOW-EXPERIENCE-SYSTEM.md](docs/YUGROW-FLOW-EXPERIENCE-SYSTEM.md) |
| 🧩 Design Principles | [docs/YUGROW-DESIGN-PRINCIPLES.md](docs/YUGROW-DESIGN-PRINCIPLES.md) |
| 🛠️ Design Kit v1.0 | [docs/YUGROW-DESIGN-KIT.md](docs/YUGROW-DESIGN-KIT.md) |
| 🌟 Product Strategy | [Volume-1-Product/PRODUCT-STRATEGY-BIBLE.md](Volume-1-Product/PRODUCT-STRATEGY-BIBLE.md) |
| 📋 CheckIN PRD | [backlog/Features/CHECKIN-MINIMUM-LOVABLE-PRD.md](backlog/Features/CHECKIN-MINIMUM-LOVABLE-PRD.md) |
| 🗺️ Roadmap | [ROADMAP.md](ROADMAP.md) |
| 🏁 Milestones | [MILESTONES.md](MILESTONES.md) |
| 🏛️ ADRs | [adr/](adr/) |
| 🤖 AI Agents | [agents/](agents/) |
| 📘 Playbooks | [playbooks/](playbooks/) |

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
