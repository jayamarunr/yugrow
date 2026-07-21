---
Sprint: 0
Title: Platform Architecture
Owner: Chief Architect
---

# Sprint 0 — Architecture

## System Context

```
┌──────────────┐     ┌─────────────────────────────────────────┐     ┌──────────────┐
│   Browser    │────▶│           Yugrow Platform                │◀────│   Mobile App  │
│  (Next.js)   │     │         (NestJS + Prisma)                │     │   (Flutter)   │
└──────────────┘     └─────────────────────────────────────────┘     └──────────────┘
                              │           │           │
                              ▼           ▼           ▼
                      ┌──────────┐ ┌──────────┐ ┌──────────┐
                      │PostgreSQL│ │  Redis   │ │  MinIO   │
                      │ (Primary)│ │ (Cache)  │ │(Storage) │
                      └──────────┘ └──────────┘ └──────────┘
```

## Monorepo Structure

```
yugrow/
  apps/
    web/              — Next.js 14, React 18, Tailwind, Shadcn/ui
    admin/            — Admin panel (Next.js) — future
    mobile/           — Flutter app — future sprint

  packages/
    backend/          — NestJS 10, TypeScript, Prisma 5
      src/
        common/       — Guards, interceptors, pipes, filters
        config/       — Environment configuration
        modules/      — Domain modules (identity, org, user...)
        prisma/       — Prisma schema, migrations, seed
    shared/           — Shared types, constants, utilities
      src/
        types/        — BaseEntity, ApiResponse, TenantContext
        constants/    — Roles, permissions, enums
        utils/        — Helpers, validators

  infrastructure/
    docker/           — Docker Compose (Postgres, Redis, MinIO, Mailpit)
    k8s/              — Kubernetes manifests — future
    terraform/        — Infrastructure as Code — future

  agents/             — AI agent playbooks
  engineering/        — Sprint engineering artifacts
  Volume-*            — Documentation volumes
  governance/         — Org structure, security policy
```

## Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| Frontend | Next.js 14 + React 18 + TypeScript | Web application |
| Mobile | Flutter (future sprint) | Mobile application |
| Backend | NestJS 10 + TypeScript | API server |
| Database | PostgreSQL 16 + Prisma 5 | Primary data store |
| Cache | Redis 7 | Session, rate limiting, caching |
| Storage | MinIO (S3-compatible) | File and image storage |
| Auth | JWT + OIDC-ready | Authentication |
| CI/CD | GitHub Actions | Automated pipeline |
| Container | Docker + Docker Compose | Local development |

## Key Patterns

- **Multi-tenancy**: Row-level tenant isolation via `orgId` on every query
- **Repository pattern**: Prisma accessed through injectable services
- **Exception filters**: Global exception filter → consistent error responses
- **Validation pipes**: Class-validator DTOs on all endpoints
- **Authentication guard**: JWT guard on all protected routes
- **Logging interceptor**: Structured JSON logging (pino) on all requests
