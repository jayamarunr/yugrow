---
Sprint: 0
Title: Definition of Done
Owner: Chief Architect
---

# Sprint 0 — Definition of Done

> A task or epic is complete only when ALL criteria below are satisfied.

## Code Quality

- [ ] TypeScript strict mode — no `any`, no implicit `any`
- [ ] No console.log — all logging through structured logger
- [ ] All environment variables documented in `.env.example`
- [ ] No hardcoded secrets, URLs, or credentials
- [ ] Lint passes (no warnings, no errors)
- [ ] Formatting consistent (Prettier defaults)

## Testing

- [ ] Unit tests cover all new services/utilities
- [ ] Integration tests cover all new API endpoints
- [ ] Tests pass locally and in CI
- [ ] Edge cases covered: empty results, invalid input, unauthorized, not found

## Documentation

- [ ] API contract documented (or updated)
- [ ] README or SETUP.md updated if developer workflow changed
- [ ] Architecture decisions recorded as ADR (if applicable)
- [ ] Sprint artifacts committed to `engineering/` folder

## Security

- [ ] Authentication enforced on protected routes
- [ ] Input validation on all user-facing endpoints
- [ ] No secrets in code
- [ ] Multi-tenant isolation verified (if applicable)

## Operations

- [ ] Health check endpoint works
- [ ] Logging works (structured JSON)
- [ ] Docker Compose starts without errors
- [ ] CI pipeline passes

## Git

- [ ] Conventional commit format (`feat|fix|refactor|docs|test|chore`)
- [ ] PR description references the task or issue
- [ ] Branch name follows convention (`feat/description`, `fix/description`)

---

## Sprint 0 — Specific DoD

- [ ] Developer can clone repo and run `docker compose up && pnpm dev` successfully
- [ ] Health endpoint returns 200 with database connection status
- [ ] CI pipeline (lint → test → build) passes on pull request
- [ ] Sprint 1 can begin without blocked dependencies
