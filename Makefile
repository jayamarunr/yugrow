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
	node scripts/bootstrap/bootstrap.js

dev-no-docker:
	node scripts/bootstrap/bootstrap.js --skip-docker

verify:
	node scripts/bootstrap/bootstrap.js --verify-only

# Database
db-generate:
	pnpm db:generate

db-push:
	pnpm db:push

db-studio:
	pnpm db:studio

# Quality Assurance
.PHONY: qa qa-run qa-run-headed qa-run-grep qa-report qa-clean qa-loop qa-dashboard qa-baseline qa-visual

qa-setup:
	pnpm --filter web add -D @playwright/test
	npx playwright install chromium

qa-run:
	node qa/pipeline.js

qa-run-headed:
	node qa/pipeline.js --headed

qa-run-grep:
	node qa/pipeline.js --grep "$(FILTER)"

qa-loop:
	node qa/auto-fix-loop.js

qa-dashboard:
	@echo "Open QA Dashboard at:"
	@echo "  file:///$(subst /,\\,$(shell pwd))/qa/dashboard.html"

qa-baseline:
	node qa/visual-diff.js --update

qa-visual:
	node qa/visual-diff.js

qa-report:
	@echo "Latest QA Report:"
	@type qa\reports\QA-LATEST.md 2>nul || echo "No QA report found. Run 'make qa-run' first."

qa-clean:
	rm -rf qa/reports/*
	rm -rf qa/screenshots/current/*
	rm -rf qa/videos/*
	rm -rf qa/traces/*
	rm -rf qa/failures/*
	rm -rf qa/test-results/
	@echo "QA artifacts cleaned."

qa-clean-all: qa-clean
	rm -rf qa/screenshots/baseline/*
	rm -rf qa/reports/visual-diff/*
	@echo "All QA artifacts including baselines cleaned."

qa:
	pnpm build
	node qa/pipeline.js

# Quick start
start: infra-up setup dev
