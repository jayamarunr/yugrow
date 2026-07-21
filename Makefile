# Yugrow Platform — Makefile
# Shortcuts for common development commands.

.PHONY: infra-up infra-down infra-logs setup dev

# Infrastructure
infra-up:
	docker compose -f infrastructure/docker/docker-compose.yml up -d

infra-down:
	docker compose -f infrastructure/docker/docker-compose.yml down

infra-logs:
	docker compose -f infrastructure/docker/docker-compose.yml logs -f

# Development
setup:
	pnpm install
	pnpm db:generate
	pnpm db:push

dev:
	pnpm dev

# Database
db-generate:
	pnpm db:generate

db-push:
	pnpm db:push

db-studio:
	pnpm db:studio

# Quick start
start: infra-up setup dev
