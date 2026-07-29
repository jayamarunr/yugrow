---
Title: Yugrow Project Index
Version: 1.0
Status: Living (updated every sprint)
Owner: Project
Last Updated: 2026-07-28
---

# Yugrow Project Index

> The single entry point for every new session. Read this first.

---

## Vision

> **Professional Presence for the Real World.**
>
> Yugrow helps professionals discover the right people at the right place
> and turn those introductions into lasting business relationships.

---

## Current Status

| Layer | Status | Frozen |
|-------|--------|--------|
| **Philosophy Layer** (Constitution, Decisions, Future Contexts) | ✅ Complete | ✅ Yes |
| **Domain Layer** (Presence, Opportunity, Relationship, Event) | ✅ Complete | ✅ Yes |
| **Product Layer** (CheckIn) | ✅ Alpha | ❌ No (bug fixes only) |
| **Engineering Layer** (API, Mobile, Web, Infra) | ✅ Stable | ❌ No (bug fixes only) |
| **Experience Layer** (Design, Brand, Motion, Illustration, Story) | ✅ Complete | ✅ Yes |

### What is frozen (do not redesign)

- Platform Constitution — `CONSTITUTION.md`
- Founder Decisions — `DECISIONS.md`
- Future Bounded Contexts — `FUTURE-BOUNDED-CONTEXTS.md`
- Domain Language — `YUGROW-DOMAIN-LANGUAGE.md`
- Presence Model — `YUGROW-PRESENCE-MODEL.md`
- Opportunity Lifecycle — `YUGROW-OPPORTUNITY-LIFECYCLE.md`
- All architecture documents in `Volume-2-Architecture/`
- Venue system
- Authentication
- Professional Identity
- Conversation Engine
- System Conversations (FD-032)
- Design Language — `docs/YUGROW-DESIGN-LANGUAGE.md`
- Brand Language — `docs/YUGROW-BRAND-LANGUAGE.md`
- Motion Language — `docs/YUGROW-MOTION-LANGUAGE.md`
- Illustration Language — `docs/YUGROW-ILLUSTRATION-LANGUAGE.md`
- Product Story Language — `docs/PRODUCT-STORY-LANGUAGE.md`

---

## Active Sprint

| Field | Value |
|-------|-------|
| **Sprint** | Alpha Hardening |
| **Current Goal** | Zero new features. Journey testing, UI polish, mobile testing, crash hunting, performance measurement. Prepare for First Meetup. |
| **Tag** | `alpha-hardening` |
| **Next Milestone** | First successful meetup with real users |

---

## Quick Start

### Prerequisites
- Docker Desktop
- Flutter 3.44+ / Dart 3.12+
- Node.js 20+
- pnpm

### Start everything

```bash
# Terminal 1 — Infrastructure
docker compose -f infrastructure/docker/docker-compose.yml up -d

# Terminal 2 — Dev servers (API + Web + Admin)
pnpm dev

# Terminal 3 — Flutter (Chrome)
cd apps/mobile
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3001
```

### Ports

| Service | URL |
|---------|-----|
| API (NestJS) | http://localhost:3001 |
| Web (Next.js) | http://localhost:3000 |
| Admin (Next.js) | http://localhost:3003 |
| Swagger Docs | http://localhost:3001/api/docs |
| Flutter Web (dev) | http://localhost:3002 |
| Flutter (mobile device) | `--dart-define=API_BASE_URL=http://<YOUR_IP>:3001` |

---

## Repository Map

### Root documents

| File | Purpose |
|------|---------|
| `CONSTITUTION.md` | 58 non-negotiable platform laws |
| `DECISIONS.md` | 27+ Founder Decisions (FD-001 through FD-031+) |
| `FUTURE-BOUNDED-CONTEXTS.md` | Registry of dormant capabilities |
| `YUGROW-DOMAIN-LANGUAGE.md` | Precise vocabulary for every domain term |
| `YUGROW-PRESENCE-MODEL.md` | Foundational presence model |
| `YUGROW-OPPORTUNITY-LIFECYCLE.md` | Two-clock model for networking |
| `PROJECT-BOARD.md` | Milestone tracking |
| `ROADMAP.md` | Product roadmap |
| `CURRENT-CONTEXT.md` | **Active sprint context (update every session)** |

### Directories

| Directory | Contents |
|-----------|----------|
| `adr/` | Architecture Decision Records (ADR-0001 through ADR-0005) |
| `docs/` | Design documents (Design Language, Brand, Motion, Illustration, Story) |
| `Volume-0-Company/` through `Volume-7-Developer-Platform/` | Architecture volumes |
| `engineering/sprint-plans/` | Sprint plans and execution documents |
| `agents/` | AI agent playbooks (9 roles) |
| `backlog/` | Epics, Features, Ideas, Vision Parking Lot |
| `apps/api/` | NestJS backend |
| `apps/mobile/` | Flutter mobile app |
| `apps/web/` | Next.js marketing website |
| `apps/admin/` | Next.js admin panel |
| `packages/` | Shared packages (@ui, @core, @database, @auth, etc.) |
| `infrastructure/docker/` | Docker Compose for local dev |
| `playbooks/` | Human playbooks (meetup, testing, etc.) |

---

## Architecture Overview

### Engine Stack (19 engines)

| # | Engine | Status |
|---|--------|--------|
| 1 | Identity Engine | ✅ Built |
| 2 | Organization Engine | ✅ Built |
| 3 | Workspace Engine | ✅ Built |
| 4 | Permission Engine | ✅ Built |
| 5 | Relationship Engine | ✅ Built |
| 6 | Trust Engine | ⏳ Future |
| 7 | Opportunity Engine | ⏳ Sprint 7 |
| 8 | Communication Engine | ✅ Built |
| 9 | Workflow Engine | ⏳ Future |
| 10 | AI Engine | ⏳ Future |
| 11 | Integration Engine | ⏳ Future |
| 12 | Edge Platform | ✅ Built |
| 13 | Search Engine | ⏳ Future |
| 14 | Policy Engine | ⏳ Future |
| 15 | Recommendation Engine | ⏳ Future |
| 16 | Context Engine | ⏳ Future |
| 17 | Signal Engine | ⏳ Future |
| 18 | Intelligence Engine | ⏳ Future |
| 19 | Feedback Intelligence Engine | 💤 Dormant |

### Products

| Product | Phase | Status |
|---------|-------|--------|
| CheckIn | Phase 1 | ✅ Alpha |
| Broadcast | Phase 4 | ⏳ Future |
| CRM | Phase 5 | ⏳ Future |
| Builder | Future | ⏳ Future |
| HR | Phase 8 | ⏳ Future |
| Finance | Phase 6 | ⏳ Future |

---

## Founder Decisions Index

| # | Decision | Category |
|---|----------|----------|
| FD-001 | One Identity Per Person | Identity |
| FD-002 | Active Workspace Context | Architecture |
| FD-003 | Attendance ≠ Expertise | Intelligence |
| FD-004 | CheckIN Is Frictionless | Product |
| FD-005 | Relationships Permanent, Presence Temporary | Data |
| FD-006 | Broadcast Uses Skills + Geography | Product |
| FD-007 | Every Interaction Reduces Friction | UX |
| FD-008 | Monetize Capability, Not Existence | Pricing |
| FD-009 | Bring Your Own AI | AI |
| FD-010 | Commerce Is Configuration | Commerce |
| FD-011 | Platform Administration Is Internal | Architecture |
| FD-012 | Build Vertical Slices | Engineering |
| FD-024 | Conceptual Integrity | Product |
| FD-025 | Founder Tooling Never User-Facing | Engineering |
| FD-026 | Validation Before Acceleration | Strategy |
| FD-027 | Every Screen Answers One Question | UX |
| FD-031 | Venue Search | Product |
| FD-032 | Tailwind Workaround (pending permanent fix) | Engineering |

---

## Design Index

| Document | Status |
|----------|--------|
| `docs/YUGROW-DESIGN-LANGUAGE.md` | ✅ Frozen |
| `docs/YUGROW-BRAND-LANGUAGE.md` | ✅ Frozen |
| `docs/YUGROW-MOTION-LANGUAGE.md` | ✅ Frozen |
| `docs/YUGROW-ILLUSTRATION-LANGUAGE.md` | ✅ Frozen |
| `docs/PRODUCT-STORY-LANGUAGE.md` | ✅ Approved |

---

## Dormant Contexts

| Context | Type | Activation |
|---------|------|------------|
| Contribution Engine | Future engine | Phase 1 + Phase 2 complete |
| Topic Engine | Future engine | Topics exceed manual management |
| Commerce Engine | Future engine | Paid products exist |
| Broadcast Engine | Future engine | Users need opportunity distribution |
| Ambient Presence | Future engine | Events validated as trusted source |
| Knowledge Model (Full) | Future engine | AI needs explicit knowledge boundaries |
| Feedback Intelligence Engine | Future engine | Feedback volume exceeds manual triage |
| System Conversations | Design note | Feedback Engine activates |
| Product Memory | Design note | System Conversations + accumulated data |

---

## Known Issues

- **Tailwind PostCSS resolution** — Next.js 14.2 + pnpm monorepo can't resolve tailwindcss PostCSS plugin. Workaround: precompile via `cd apps/web && pnpm tailwind`. FD-032. Fix before Beta.
- **Flutter web font-subset.exe** — Blocked by Windows Application Control policy. Manual font copy workaround in place. Enable Developer Mode on Windows for permanent fix.
- **No crash reporting** — Firebase Crashlytics or Sentry not integrated yet. TBD before Closed Testing.

---

## Next Milestones

1. ✅ Architecture complete
2. ✅ Venue + Auth + Identity + Conversation frozen
3. ✅ Design Foundation frozen
4. 🔄 Web Sprint 1 — Landing page redesign
5. ⏳ Alpha validation — First real meetup
6. ⏳ Google Play Internal Testing
7. ⏳ Closed Testing (50 users)
8. ⏳ Production launch
