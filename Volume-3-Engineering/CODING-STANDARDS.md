---
Title: Yugrow Coding Standards
Version: 0.1
Status: Draft
Owner: Chief Architect
Last Updated: 2026-07-16
Dependencies:
  - YUGROW-CONSTITUTION.md
Related Documents:
  - Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md
  - Volume-3-Engineering/TESTING-STRATEGY.md
  - Volume-3-Engineering/DEVOPS.md
---

# Yugrow Coding Standards

> **Every AI agent and human engineer must follow these standards.**
>
> Code that doesn't comply will be rejected during review.

---

## 1. Monorepo Structure

```
apps/
  web/          — Next.js frontend
  admin/        — Admin panel (Next.js)
  mobile/       — Flutter app

packages/
  ui/           — Shared UI component library
  auth/         — Authentication module
  crm/          — CRM domain module
  websites/     — Websites domain module
  marketing/    — Marketing domain module
  books/        — Accounting domain module
  hr/           — HR domain module
  ai/           — AI Gateway module
  notifications/— Notification module
  workflow/     — Workflow engine module
  integrations/ — Integration hub module
  shared/       — Shared types, utilities, constants

infrastructure/
  docker/       — Docker Compose files
  k8s/          — Kubernetes manifests
  terraform/    — Infrastructure as Code

tools/
  scripts/      — Automation scripts
```

## 2. Naming Conventions

| Artifact | Convention | Example |
|----------|-----------|---------|
| Packages | kebab-case | `packages/crm-service` |
| Classes | PascalCase | `class ContactService` |
| Functions | camelCase | `function getContacts()` |
| Variables | camelCase | `const contactName` |
| Constants | UPPER_SNAKE | `const MAX_RETRY_COUNT` |
| Files (code) | kebab-case | `contact-service.ts` |
| Files (components) | PascalCase | `ContactCard.tsx` |
| Database tables | snake_case | `contact_activities` |
| Database columns | snake_case | `created_at` |
| API routes | kebab-case | `GET /api/v1/contacts` |
| Environment vars | UPPER_SNAKE | `DATABASE_URL` |
| Git branches | type/description | `feat/add-crm-pipeline` |

## 3. TypeScript Standards

- **Strict mode** enabled in all packages
- **Explicit return types** on all public functions
- **No `any`** — use `unknown` and narrow with type guards
- **Interfaces** over types for object shapes (use `type` for unions/primitives)
- **Readonly** on immutable parameters and properties
- **Optional chaining** (`?.`) and nullish coalescing (`??`) preferred over logical OR

```typescript
// ✅ Good
interface Contact {
  readonly id: string;
  name: string;
  email: string;
  createdAt: Date;
}

async function getContact(id: string): Promise<Contact | null> {
  return prisma.contact.findUnique({ where: { id } });
}

// ❌ Bad
function getContact(id: any): any {
  return prisma.contact.findUnique({ where: { id } });
}
```

## 4. NestJS Backend Standards

### Module Structure
```
packages/contacts/
  src/
    contact.controller.ts
    contact.service.ts
    contact.module.ts
    dto/
      create-contact.dto.ts
      update-contact.dto.ts
    entities/
      contact.entity.ts
    interfaces/
      contact.interface.ts
    decorators/
      current-user.decorator.ts
    guards/
      permissions.guard.ts
    test/
      contact.service.spec.ts
      contact.controller.spec.ts
  prisma/
    schema.prisma
```

### Controller Standards
- Controllers handle HTTP concerns only — no business logic
- Use validation pipes on all DTOs
- Consistent response format: `{ data, meta, error }`

### Service Standards
- Services contain business logic
- No direct database access in controllers
- Throw typed exceptions (`NotFoundException`, `ConflictException`)
- Async/await over raw promises

## 5. Next.js Frontend Standards

### Component Structure
```
components/
  ui/           — Primitive UI components (Button, Input, Card)
  layout/       — Layout components (Sidebar, Header, Shell)
  forms/        — Form components and schemas
  tables/       — Data tables with sorting/filtering
  modals/       — Modal dialogs and drawers
  charts/       — Chart components

app/
  (auth)/       — Auth-required routes
  (public)/     — Public routes
  api/          — API routes (if any)
```

### Component Conventions
- Server components by default, client components only when needed
- Use `'use client'` explicitly when required
- Tailwind CSS for styling — no CSS modules or styled-components
- Shadcn/ui component library as the base
- React Hook Form + Zod for form validation

## 6. API Standards

### REST Conventions

| Method | Path | Action |
|--------|------|--------|
| GET | `/api/v1/contacts` | List contacts |
| GET | `/api/v1/contacts/:id` | Get contact |
| POST | `/api/v1/contacts` | Create contact |
| PATCH | `/api/v1/contacts/:id` | Update contact |
| DELETE | `/api/v1/contacts/:id` | Delete contact |

### Response Format
```typescript
// Success
{
  "data": { ... },
  "meta": { "total": 100, "page": 1, "pageSize": 20 }
}

// Error
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email is required",
    "details": [{ "field": "email", "message": "Email is required" }]
  }
}
```

### Pagination
- Cursor-based for lists (`?cursor=abc&limit=20`)
- Offset-based for admin tables (`?page=1&pageSize=20`)

## 7. Database Standards

### Prisma Conventions
- All models have `id` (UUID), `createdAt`, `updatedAt`, `orgId`
- Soft deletes with `deletedAt` timestamp
- JSONB for flexible attributes
- Indexes on all foreign keys and frequently queried columns

```prisma
model Contact {
  id        String   @id @default(uuid())
  orgId     String
  name      String
  email     String?
  phone     String?
  metadata  Json?    @default("{}")
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  deletedAt DateTime?

  activities ContactActivity[]
  deals      Deal[]

  @@index([orgId])
  @@index([email])
}
```

### Multi-Tenancy
- All queries scoped by `orgId`
- Middleware injects tenant context from JWT
- Never write a query without a tenant filter

## 8. Error Handling

```typescript
// Custom exception hierarchy
class AppException extends Error {
  constructor(
    public code: string,
    public message: string,
    public statusCode: number = 500,
    public details?: Record<string, unknown>
  ) { super(message); }
}

class NotFoundException extends AppException {
  constructor(resource: string, id: string) {
    super('NOT_FOUND', `${resource} with id ${id} not found`, 404);
  }
}
```

## 9. Logging Standards

- Structured JSON logging (`@nestjs/config` + `pino`)
- Include: `requestId`, `tenantId`, `userId`, `correlationId`
- No console.log in production code
- Log levels: debug (dev), info (default), warn, error, fatal

## 10. Testing Standards

| Test Type | Framework | Coverage Target |
|-----------|-----------|-----------------|
| Unit | Jest | 80%+ |
| Integration | Jest + Supertest | 70%+ |
| E2E | Playwright | Critical paths |
| Component | Storybook + Vitest | All components |

- Every service must have unit tests
- Every API endpoint must have integration tests
- Test files co-located with source: `contact.service.spec.ts`

## 11. Git Standards

### Conventional Commits
```
<type>(<scope>): <description>

feat(crm):      add contact pipeline stages
fix(auth):      resolve token refresh race condition
refactor(api):  extract pagination middleware
docs:           update setup guide
test(contacts): add integration tests
chore:          update dependencies
security:       fix XSS vulnerability in email templates
```

### Branch Strategy
```
main          — Production-ready
develop       — Integration branch
feat/*        — Feature branches
fix/*         — Bug fixes
release/*     — Release candidates
```

### PR Requirements
- [ ] Follows coding standards
- [ ] Includes tests
- [ ] Updates documentation if API/behavior changed
- [ ] No secrets or credentials
- [ ] Error handling is complete
- [ ] Logging is appropriate
- [ ] Lint passes
- [ ] Build passes

## 12. Code Review Checklist

- [ ] Architecture follows the Enterprise Architecture blueprint
- [ ] Multi-tenant isolation is maintained
- [ ] No hardcoded secrets, URLs, or credentials
- [ ] Input validation is complete
- [ ] Authentication and authorization are enforced
- [ ] Error states are handled in UI
- [ ] Loading states are shown during async operations
- [ ] Responsive design is considered
- [ ] Accessibility basics are covered (ARIA labels, keyboard nav)
- [ ] Performance: no N+1 queries, pagination applied
