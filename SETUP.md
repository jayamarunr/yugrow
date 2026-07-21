# Yugrow — Local Development Setup

## Prerequisites

- Node.js 20+
- pnpm 9+
- Docker Desktop

## Quick Start

```bash
# 1. Start infrastructure
docker compose -f infrastructure/docker/docker-compose.yml up -d

# 2. Install dependencies
pnpm install

# 3. Copy environment variables
cp .env.example .env

# 4. Generate Prisma client
pnpm db:generate

# 5. Run database migrations
pnpm db:migrate

# 6. Start development servers
pnpm dev
```

## What's Running

| Service | URL |
|---------|-----|
| Web App | http://localhost:3000 |
| API | http://localhost:4000 |
| PostgreSQL | localhost:5432 |
| Redis | localhost:6379 |
| MinIO Console | http://localhost:9001 |
| Mailpit | http://localhost:8025 |

## Project Structure

```
yugrow/
  apps/
    web/          — Next.js frontend
  packages/
    backend/      — NestJS API
    shared/       — Shared types, utilities
  infrastructure/
    docker/       — Docker Compose
  agents/         — AI agent playbooks
  Volume-*        — Documentation volumes
```

## Commands

| Command | Description |
|---------|-------------|
| `pnpm dev` | Start all dev servers |
| `pnpm build` | Build all packages |
| `pnpm lint` | Lint all packages |
| `pnpm test` | Run all tests |
| `pnpm db:migrate` | Run database migrations |
| `pnpm db:studio` | Open Prisma Studio |
| `pnpm format` | Format code with Prettier |
