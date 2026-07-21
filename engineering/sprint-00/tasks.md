---
Sprint: 0
Title: Task Breakdown
Owner: Chief Architect
---

# Sprint 0 — Tasks

> Tasks suitable for GitHub Issues. Assignable to AI agents.

## Epic 1: Monorepo Bootstrap ✅

| Task | Status | Notes |
|------|--------|-------|
| Root package.json with pnpm workspaces | ✅ Done | |
| pnpm-workspace.yaml | ✅ Done | |
| tsconfig.json (strict mode) | ✅ Done | |
| .prettierrc | ✅ Done | |
| .env.example | ✅ Done | |
| .gitignore | ✅ Done | |
| turbo.json (deprecated — not using turbo) | ✅ Done | Remove later |
| CI/CD pipeline (.github/workflows/ci.yml) | ✅ Done | Lint → Test → Build |

## Epic 2: Infrastructure

| Task | Status | Notes |
|------|--------|-------|
| Docker Compose (Postgres 16, Redis 7, MinIO, Mailpit) | ✅ Done | |
| Docker Compose health checks | ⏳ | |
| Local dev startup script | ⏳ | |

## Epic 3: Backend Foundation

| Task | Status | Notes |
|------|--------|-------|
| NestJS app scaffold | ✅ Done | package.json configured |
| Prisma schema (initial) | ⏳ | |
| Configuration module (env vars) | ⏳ | |
| Global exception filter | ⏳ | |
| Validation pipe setup | ⏳ | |
| Logging middleware (pino) | ⏳ | |
| Health check endpoint (`GET /api/health`) | ⏳ | |
| Database migration (initial) | ⏳ | |

## Epic 4: Frontend Foundation

| Task | Status | Notes |
|------|--------|-------|
| Next.js app scaffold | ✅ Done | package.json configured |
| Tailwind CSS configuration | ⏳ | |
| Shadcn/ui setup | ⏳ | |
| Login page (UI only) | ⏳ | |
| Dashboard shell (layout + navigation) | ⏳ | |
| API client setup (axios/fetch) | ⏳ | |

## Epic 5: Shared Package

| Task | Status | Notes |
|------|--------|-------|
| BaseEntity type | ✅ Done | |
| ApiResponse type | ✅ Done | |
| ApiError type | ✅ Done | |
| TenantContext type | ✅ Done | |
| PaginationParams type | ✅ Done | |
| UserRole type | ✅ Done | |

## Epic 6: Flutter App Shell

| Task | Status | Notes |
|------|--------|-------|
| Flutter project scaffold | ⏳ | |
| Login screen (UI only) | ⏳ | |
| API service client | ⏳ | |

## Epic 7: Documentation

| Task | Status | Notes |
|------|--------|-------|
| SETUP.md (local dev guide) | ✅ Done | |
| Sprint 0 engineering pack | 🟡 In progress | |

## Epic 8: CI/CD

| Task | Status | Notes |
|------|--------|-------|
| Lint workflow | ✅ Done | |
| Test workflow | ✅ Done | |
| Build workflow | ✅ Done | |
| Docker image build | ⏳ | |
| Deploy to staging | ⏳ | |

---

## Summary

| Status | Count |
|--------|-------|
| ✅ Done | 20 |
| 🟡 In Progress | 1 |
| ⏳ Not Started | 19 |
| **Total** | **40** |
