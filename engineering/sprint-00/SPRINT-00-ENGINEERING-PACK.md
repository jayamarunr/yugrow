---
Title: Sprint 0 Engineering Pack
Version: 1.0
Status: Draft
Owner: Chief Architect
Last Updated: 2026-07-16
---

# Sprint 0 Engineering Pack

> **The authoritative guide for bootstrapping Yugrow.**
>
> Every AI coding agent and developer should read this before writing any code.

---

## Table of Contents

1. [Repository Conventions](#1-repository-conventions)
2. [Folder Structure](#2-folder-structure)
3. [Branching Strategy](#3-branching-strategy)
4. [Coding Standards](#4-coding-standards)
5. [Local Development Guide](#5-local-development-guide)
6. [Docker Compose](#6-docker-compose)
7. [Environment Configuration](#7-environment-configuration)
8. [CI/CD Pipeline](#8-cicd-pipeline)
9. [Database Conventions](#9-database-conventions)
10. [API Standards](#10-api-standards)
11. [Logging Strategy](#11-logging-strategy)
12. [Error Handling](#12-error-handling)
13. [Security Baseline](#13-security-baseline)
14. [Definition of Done](#14-definition-of-done)
15. [Sprint 0 Task Breakdown](#15-sprint-0-task-breakdown)

---

## 1. Repository Conventions

| Convention | Standard |
|-----------|----------|
| Package manager | pnpm 9+ |
| Monorepo tool | pnpm workspaces (not Turborepo) |
| TypeScript | Strict mode — no `any`, no implicit returns |
| Formatting | Prettier (single quotes, trailing commas, 100 width) |
| Commits | Conventional Commits (`feat|fix|refactor|docs|test|chore`) |
| Branches | `main`, `develop`, `feat/*`, `fix/*`, `release/*` |

## 2. Folder Structure

```
yugrow/
  apps/
    web/              — Next.js 14 frontend
    admin/            — Admin panel (future)
    mobile/           — Flutter app (future)
  packages/
    backend/          — NestJS 10 API server
    shared/           — Shared types, constants, utilities
  infrastructure/
    docker/           — Docker Compose configuration
    k8s/              — Kubernetes manifests (future)
    terraform/        — Infrastructure as Code (future)
  agents/             — AI agent playbooks
  engineering/        — Sprint engineering artifacts
  Volume-*            — Documentation volumes
  governance/         — Organization structure, policies
```

## 3. Branching Strategy

```
main                — Production-ready, protected
develop             — Integration branch, protected
feat/<description>  — Feature branches (merge to develop)
fix/<description>   — Bug fix branches (merge to develop)
release/<version>   — Release candidates (merge to main)
```

## 4. Coding Standards

Full reference: `Volume-3-Engineering/CODING-STANDARDS.md`

| Area | Standard |
|------|----------|
| TypeScript | Strict mode, explicit return types, no `any` |
| NestJS | Module → Controller → Service → Repository |
| Next.js | Server components by default, `'use client'` when needed |
| Naming | PascalCase (classes), camelCase (functions/vars), kebab-case (files) |
| Database | snake_case (tables/columns), UUID PKs, soft deletes |
| API | RESTful, kebab-case routes, consistent error format |
| Testing | Jest (unit/integration), Playwright (E2E), co-located test files |

## 5. Local Development Guide

```bash
# Prerequisites: Node.js 20+, Docker Desktop, pnpm 9+

# 1. Start infrastructure
docker compose -f infrastructure/docker/docker-compose.yml up -d

# 2. Install dependencies
pnpm install

# 3. Copy environment configuration
cp .env.example .env

# 4. Generate Prisma client
pnpm db:generate

# 5. Run database migrations
pnpm db:migrate

# 6. Start all dev servers
pnpm dev
```

## 6. Docker Compose

File: `infrastructure/docker/docker-compose.yml`

| Service | Image | Port | Purpose |
|---------|-------|------|---------|
| PostgreSQL | postgres:16-alpine | 5432 | Primary database |
| Redis | redis:7-alpine | 6379 | Caching, sessions, rate limiting |
| MinIO | minio/minio | 9000 (API), 9001 (Console) | S3-compatible object storage |
| Mailpit | axllent/mailpit | 1025 (SMTP), 8025 (UI) | Email testing |

## 7. Environment Configuration

File: `.env.example`

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://yugrow:yugrow@localhost:5432/yugrow` |
| `REDIS_URL` | Redis connection string | `redis://localhost:6379` |
| `JWT_SECRET` | JWT signing key | Change in production |
| `JWT_EXPIRATION` | Access token TTL | `15m` |
| `JWT_REFRESH_EXPIRATION` | Refresh token TTL | `7d` |
| `STORAGE_ENDPOINT` | S3-compatible storage URL | `http://localhost:9000` |
| `AI_OPENAI_KEY` | OpenAI API key | Set when AI features are built |

## 8. CI/CD Pipeline

File: `.github/workflows/ci.yml`

```
Push/PR → Lint → Test → Build
```

| Step | What It Does |
|------|-------------|
| Lint | TypeScript type-check + ESLint on all packages |
| Test | Jest unit + integration tests with PostgreSQL test container |
| Build | Compile all packages (Next.js, NestJS) |

## 9. Database Conventions

### Prisma Schema Standards

```prisma
model Example {
  id        String   @id @default(uuid())
  orgId     String
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  deletedAt DateTime?

  @@index([orgId])
}
```

- All tables: UUID primary key, `orgId`, `createdAt`, `updatedAt`, `deletedAt`
- All queries scoped by `orgId` (multi-tenant)
- Soft deletes via `deletedAt` (no hard deletes)
- JSONB for flexible attributes
- Indexes on all foreign keys

## 10. API Standards

### Base URL: `http://localhost:4000/api/v1`

### Authentication: `Authorization: Bearer <jwt_token>`

### Response Format
```json
{ "data": { ... }, "meta": { "total": 100, "page": 1 } }
{ "error": { "code": "VALIDATION_ERROR", "message": "...", "details": [...] } }
```

### Status Codes: 200, 201, 400, 401, 403, 404, 409, 422, 429, 500

### Pagination: Cursor-based (`?cursor=abc&limit=20`) or offset-based (`?page=1&pageSize=20`)

### Rate Limiting: 100 req/min per tenant, returned via `X-RateLimit-*` headers

## 11. Logging Strategy

- Structured JSON logging via Pino (NestJS)
- Include: `requestId`, `tenantId`, `userId`, `correlationId`
- No `console.log` in production code
- Log levels: `debug` (dev), `info` (default), `warn`, `error`, `fatal`
- Global logging interceptor on all requests

## 12. Error Handling

- Global exception filter returns consistent `{ error: { code, message, details } }`
- Typed exception hierarchy: `NotFoundException`, `ConflictException`, `ValidationException`
- All unhandled errors return 500 with logged stack trace (never exposed to client)
- Validation errors return 400 with field-level details

## 13. Security Baseline

| Control | Standard |
|---------|----------|
| Authentication | JWT with short-lived access tokens + refresh token rotation |
| Authorization | RBAC (roles: Admin, Manager, Member, Viewer) |
| MFA | TOTP (Sprint 1) |
| Input validation | Class-validator DTOs on all endpoints |
| Rate limiting | Redis-backed, per-tenant |
| Audit logging | Immutable log of all mutations |
| Secrets | None in code — environment variables or vault |
| CORS | Restricted to known origins |
| Helmet | Security headers on all responses |

## 14. Definition of Done

A task is complete only when ALL of these pass:

- [ ] Functional requirements implemented
- [ ] Unit tests passing
- [ ] Integration tests passing
- [ ] Security review completed (auth, input validation, rate limiting)
- [ ] Logging and metrics included
- [ ] API documented
- [ ] UI accessible (if applicable)
- [ ] Documentation updated (README, ADRs if needed)
- [ ] Code reviewed
- [ ] Deployable to Dev environment

## 15. Sprint 0 Task Breakdown

### Completed (20/40)

- Monorepo bootstrap (root config, workspaces, TypeScript, Prettier)
- Docker Compose (PostgreSQL, Redis, MinIO, Mailpit)
- CI/CD pipeline (GitHub Actions)
- Shared types (BaseEntity, ApiResponse, TenantContext, etc.)
- Engineering documentation (sprint-goal, architecture, tasks, API, DB, UI, testing, DoD)
- Coding standards (Volume-3-Engineering/CODING-STANDARDS.md)
- AI agent playbooks (9 agents)
- SETUP.md

### Remaining (20/40)

**Backend:**
- Prisma schema and initial migration
- Configuration module (env vars)
- Global exception filter
- Validation pipe setup
- Pino logging middleware
- Health check endpoint (`GET /api/health`)
- NestJS app entry point (main.ts)

**Frontend:**
- Tailwind CSS configuration
- Shadcn/ui component library setup
- Login page (UI)
- Dashboard shell (layout + navigation)
- API client (axios/fetch wrapper)

**Infrastructure:**
- Docker health checks
- Local dev startup script

**Flutter:**
- Flutter project scaffold
- Login screen
- API service client

**CI/CD:**
- Docker image build workflow
- Staging deployment workflow
