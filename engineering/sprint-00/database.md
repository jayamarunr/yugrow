---
Sprint: 0
Title: Database Schema
Owner: Database Architect
---

# Sprint 0 — Database Schema

> Sprint 0 establishes the Prisma schema and migration pipeline.
> No business tables yet — those begin in Sprint 1 (Identity, Organizations, Users).

## Prisma Setup

```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}
```

## Migration Strategy

| Command | Description |
|---------|-------------|
| `pnpm db:generate` | Generate Prisma client from schema |
| `pnpm db:migrate` | Run pending migrations |
| `pnpm db:studio` | Open Prisma Studio (data browser) |

## Conventions (For Sprint 1+)

All models will follow:
- `id` — UUID primary key (`@default(uuid())`)
- `orgId` — Tenant isolation foreign key
- `createdAt` — Auto-set timestamp
- `updatedAt` — Auto-updated timestamp
- `deletedAt` — Soft delete (nullable)
- Indexes on all foreign keys and frequently queried columns

```prisma
// Example — Sprint 1 model
model User {
  id        String   @id @default(uuid())
  orgId     String
  email     String   @unique
  name      String?
  role      UserRole @default(MEMBER)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  deletedAt DateTime?

  organization Organization @relation(fields: [orgId], references: [id])

  @@index([orgId])
  @@index([email])
}
```

## Seed Data (Sprint 1)

An initial seed script will create:
- Default admin user
- Default organization
- Base roles and permissions

## Connection Configuration

```env
DATABASE_URL=postgresql://yugrow:yugrow@localhost:5432/yugrow
```
