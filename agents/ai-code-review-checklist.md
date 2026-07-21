---
Title: AI Pre-Coding Checklist
Version: 0.1
Status: Active
Owner: Chief Architect
Last Updated: 2026-07-16
Dependencies:
  - YUGROW-CONSTITUTION.md
  - governance/coding-standards.md
Related Documents:
  - DRB.md
  - governance/yugrow-principles.md
---

# AI Pre-Coding Checklist

> **Every AI agent must pass this checklist before generating production code.**
>
> No code is committed until all items are checked.

---

## 🏛️ Strategic Alignment

- [ ] **Does this follow the Constitution?**
  - Verify against the 12 Engineering Principles in YUGROW-CONSTITUTION.md
- [ ] **Does it follow the Product Charter?**
  - Ensure the feature aligns with the defined mission, vision, and product scope
- [ ] **Does it comply with the Architecture?**
  - Confirm it fits within the documented bounded contexts and platform layers

---

## 🧱 Engineering Standards

- [ ] **Does it follow the Coding Standards?**
  - Idiomatic code, language-appropriate patterns, no anti-patterns
- [ ] **Does it introduce technical debt?**
  - If yes, document it explicitly with a plan to address it
- [ ] **Are there tests?**
  - Unit tests for business logic, integration tests for services, E2E for critical paths
- [ ] **Is it documented?**
  - API docs, README updates, architecture decisions recorded

---

## 🔒 Security & Compliance

- [ ] **Is it secure?**
  - Input validation, authentication, authorization, no secrets in code
- [ ] **Is it privacy-compliant?**
  - GDPR, DPDP, CCPA considerations addressed
- [ ] **Does it follow least privilege?**
  - Service accounts, API keys, and permissions are minimal

---

## ☁️ Platform Requirements

- [ ] **Is it cloud agnostic?**
  - No hardcoded cloud provider dependencies, uses abstractions
- [ ] **Is it observable?**
  - Structured logging, metrics, traces emitted
- [ ] **Does it handle failure gracefully?**
  - Circuit breakers, retries with backoff, graceful degradation
- [ ] **Is it scalable?**
  - Stateless where possible, horizontally scalable, avoids singletons

---

## ✅ Before Commit

- [ ] All checklist items are satisfied
- [ ] Any exceptions are documented with rationale
- [ ] Code reviewed by another agent or engineer
- [ ] PR description references the relevant requirement or ADR
