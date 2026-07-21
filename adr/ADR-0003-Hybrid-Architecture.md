---
Title: Hybrid Backend Architecture — NestJS + FastAPI
Number: ADR-0003
Status: Accepted
Date: 2026-07-16
Owner: Chief Architect
Dependencies:
  - Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md
Related Documents:
  - services/ai-gateway/
  - Volume-2-Architecture/ENGINEERING-BLUEPRINT.md
---

# ADR-0003: Hybrid Backend Architecture

## Decision

Yugrow will use **two backend technologies**, each serving its strengths:

| Domain | Technology | Reason |
|--------|-----------|--------|
| **Business Platform** | NestJS (TypeScript) | CRM, HR, Books, Websites, RBAC, billing, workflows — rich enterprise ecosystem |
| **AI Platform** | FastAPI (Python) | AI Gateway, RAG, OCR, embeddings, agent orchestration — best AI/ML ecosystem |

The two platforms communicate via REST initially, then RabbitMQ for async events, and potentially Kafka at scale.

## Context

Yugrow is not just a CRM. It is an AI-native Business OS with workloads that span two fundamentally different domains:

1. **Business logic** (CRUD, RBAC, workflows, multi-tenancy, billing) — where TypeScript/NestJS has a mature ecosystem, excellent developer experience, and seamless frontend integration.
2. **AI workloads** (model routing, prompt management, RAG, embeddings, image generation, agent orchestration) — where Python/FastAPI has an unmatched ecosystem (LangChain, LlamaIndex, PyTorch, HuggingFace, etc.).

Forcing all AI workloads through a TypeScript backend would mean fighting the ecosystem at every step. Forcing business logic through Python would mean rebuilding mature enterprise patterns from scratch.

## Options Considered

| Option | Pros | Cons |
|--------|------|------|
| **NestJS only** | Single language, simpler deployment | Weak AI/ML ecosystem; would need to wrap Python tools |
| **FastAPI only** | Best AI ecosystem | Weak enterprise business patterns; frontend still needs JS |
| **Hybrid (chosen)** | Each domain uses its best ecosystem | Two runtimes to deploy; inter-service communication |

## Architecture

```
Next.js (Frontend)
     │
     ├── NestJS (Business API) ──┬── PostgreSQL
     │                           └── Redis
     │
     └── FastAPI (AI Gateway) ───┬── PostgreSQL
                                 ├── Redis
                                 ├── OpenAI / Anthropic / etc.
                                 └── Vector DB (future)
```

## Auth Boundary

NestJS owns authentication. FastAPI validates JWTs issued by NestJS. No duplicate auth logic.

## Consequences

- Positive: AI workloads can scale independently from business workloads
- Positive: Each team can work in the language best suited to their domain
- Positive: Model switching, prompt changes, and AI upgrades don't affect business modules
- Risk: Two runtimes increase DevOps complexity
- Mitigation: Both deploy as containers, managed by the same Kubernetes cluster and CI/CD
- Risk: Duplicate cross-cutting concerns (auth, logging)
- Mitigation: Shared JWT validation library; structured logging standard across both
