---
Sprint: 0
Title: Testing Strategy
Owner: QA Architect
---

# Sprint 0 — Testing Strategy

> Sprint 0 establishes the testing framework and conventions.
> Actual tests begin in Sprint 1 when business logic exists.

## Testing Pyramid

```
     ╱╲
    ╱ E2E ╲           ← Playwright (critical user journeys)
   ╱───────╲
  ╱Integration╲       ← Jest + Supertest (API endpoints)
 ╱─────────────╲
╱   Unit Tests   ╲    ← Jest (services, utilities)
╱─────────────────╲
```

## Framework Setup

| Layer | Framework | Config Location |
|-------|-----------|-----------------|
| Backend unit | Jest | `packages/backend/package.json` |
| Backend integration | Jest + Supertest | `packages/backend/test/` |
| Frontend | Vitest | `apps/web/package.json` |
| Shared | Vitest | `packages/shared/package.json` |
| E2E | Playwright | Future sprint |

## Coverage Targets

| Type | Target |
|------|--------|
| Unit tests (services) | 80%+ |
| Integration tests (API) | 70%+ |
| E2E (critical paths) | All critical paths |

## Test Location Convention

Tests are co-located with source files:

```
packages/backend/src/
  contact/
    contact.service.ts
    contact.service.spec.ts      ← unit test
    contact.controller.ts
    contact.controller.spec.ts   ← integration test
```

## What to Test in Sprint 0

| Test | Priority | Notes |
|------|----------|-------|
| Health endpoint | High | `GET /api/health` returns 200 |
| Configuration loading | High | Env vars load correctly |
| Exception filter | Medium | Unhandled errors return consistent format |
| Validation pipe | Medium | Invalid DTOs return 400 with details |
| Auth guard (if implemented) | High | Unauthenticated requests return 401 |

## CI Integration

Tests run automatically in CI (`.github/workflows/ci.yml`):

```
Push/PR → Lint → Test → Build
```

## Naming Conventions

```
// Service unit test
describe('ContactService', () => {
  describe('getContact', () => {
    it('should return a contact by id', async () => { ... });
    it('should return null when contact not found', async () => { ... });
    it('should enforce tenant isolation', async () => { ... });
  });
});

// Controller integration test
describe('GET /api/v1/contacts', () => {
  it('should return paginated contacts', async () => { ... });
  it('should return 401 without auth token', async () => { ... });
});
```
