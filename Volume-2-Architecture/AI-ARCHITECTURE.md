---
Title: AI Architecture
Version: 1.0
Status: Draft
Owner: Chief Architect
Last Updated: 2026-07-21
Dependencies:
  - Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md
  - Volume-2-Architecture/ENGINE-SPECIFICATIONS.md
  - adr/ADR-0003-Hybrid-Architecture.md
Related Documents:
  - Volume-2-Architecture/DATA-OWNERSHIP-RULES.md
  - agents/ai-code-review-checklist.md
---

# AI Architecture

> **How AI is built into every engine of the Yugrow platform — model routing, prompts, agents, knowledge bases, and the AI Gateway.**

---

## Table of Contents

| # | Section |
|---|---------|
| 1 | AI Principles |
| 2 | AI Gateway Architecture |
| 3 | Model Strategy |
| 4 | Prompt Management |
| 5 | AI Agents |
| 6 | Knowledge Bases & RAG |
| 7 | AI Integration per Engine |
| 8 | Token Tracking & Cost Management |
| 9 | Guardrails & Safety |
| 10 | AI Observability |

---

# 1. AI Principles

| # | Principle | Implication |
|---|-----------|-------------|
| 1 | **AI-Native by Design** | Every engine has an AI integration point. AI is not an add-on — it is a primary interface. |
| 2 | **Multi-Provider** | No single AI vendor lock-in. Route by cost, latency, capability, or availability. |
| 3 | **Human Control** | All AI outputs are reviewable, overridable, and auditable. No black boxes. |
| 4 | **Explainable** | Every AI decision includes reasoning. Scores have explanations. Matches have context. |
| 5 | **Cost-Controlled** | Token tracking per tenant. Usage-based billing. Cost alerts and caps. |
| 6 | **Private by Default** | No training on customer data. PII stripping in logs. Tenant data isolation. |
| 7 | **Graceful Degradation** | AI failures never block core workflows. Fallback models and cached responses. |

---

# 2. AI Gateway Architecture

## System Architecture

```
Engine/Product
      │
      ▼
┌─────────────────────────────────────────────────────┐
│                   AI Gateway (FastAPI)              │
│                                                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────┐  │
│  │ Router   │→ │ Prompt   │→ │ Guardrails       │  │
│  │ (model)  │  │ Manager  │  │ (safety, PII)    │  │
│  └──────────┘  └──────────┘  └────────┬─────────┘  │
│       │                                │            │
│       ▼                                ▼            │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────┐  │
│  │ Cache    │  │ Token    │  │ Fallback         │  │
│  │ (Redis)  │  │ Tracker  │  │ Handler          │  │
│  └──────────┘  └──────────┘  └──────────────────┘  │
└──────────────────────┬──────────────────────────────┘
                       │
                       ▼
           ┌─────────────────────┐
           │   Provider Layer    │
           │                     │
           │  OpenAI  Anthropic  │
           │  DeepSeek  Gemini   │
           │  Open Source (local)│
           └─────────────────────┘
```

## Components

| Component | Responsibility | Technology |
|-----------|---------------|------------|
| **Router** | Select optimal model based on request type, cost, latency | Custom logic + provider health checks |
| **Prompt Manager** | Versioned prompt templates, A/B testing, variable injection | PostgreSQL + cache |
| **Guardrails** | Content filtering, PII detection, bias checks, rate limiting | Custom + provider APIs |
| **Cache** | Response caching for identical prompts | Redis (TTL-based) |
| **Token Tracker** | Usage metering per tenant, cost calculation | PostgreSQL + async writes |
| **Fallback Handler** | Automatic retry with alternative model on failure | Circuit breaker pattern |

---

# 3. Model Strategy

## Provider Matrix

| Provider | Models | Best For | Cost Tier | Status |
|----------|--------|----------|-----------|--------|
| OpenAI | GPT-4o, GPT-4o-mini | General purpose, content generation, analysis | Premium | Primary |
| Anthropic | Claude 4, Claude 4 Haiku | Complex reasoning, safety-critical tasks | Premium | Primary |
| DeepSeek | DeepSeek-V3, DeepSeek-R1 | Cost-effective, strong reasoning | Budget | Primary |
| Gemini | Gemini 2.5 Pro, Flash | Multimodal, Google ecosystem | Standard | Secondary |
| Open Source | Llama 4, Mistral | Self-hosted, data-sensitive workloads | Self-hosted | Future |

## Model Routing Logic

```
Request comes in with:
  - Engine: Identity, Relationship, Opportunity, etc.
  - Task Type: classification, generation, analysis, embedding, chat
  - Priority: real-time, async, batch
  - Tenant Tier: free, growth, business, enterprise

Routing Decision:
  1. If cached → Return cached response
  2. If real-time + enterprise → GPT-4o or Claude 4
  3. If real-time + growth → GPT-4o-mini or Claude Haiku
  4. If async/batch → DeepSeek-V3 (best cost/quality ratio)
  5. If embedding → Provider-specific embedding model
  6. If fallback (primary failed) → Next available provider
```

---

# 4. Prompt Management

## Prompt Template Structure

Every prompt has:
- **Name** — unique identifier
- **Category** — engine + use case (e.g., `opportunity.matching`)
- **Current Version** — active version ID
- **Templates** — versioned content with variables
- **Model** — target model for this prompt
- **Parameters** — temperature, max_tokens, top_p

## Prompt Versioning

```
Prompt.Created (v1)
  ↓
Prompt.Updated (v2) — incremental improvement
  ↓
A/B Test (v2 vs v3) — split traffic
  ↓
Winner promoted to default
  ↓
Loser retired (still accessible for rollback)
```

## Prompt Categories

| Category | Example Prompts |
|----------|----------------|
| Identity | Login anomaly detection, duplicate user detection |
| Relationship | Connection suggestions, duplicate detection, relationship summary |
| Trust | Reference verification, fake profile detection, trust score calculation |
| Opportunity | Categorization, semantic matching, candidate ranking, follow-up suggestions |
| Communication | Smart reply, sentiment analysis, translation, email drafting |
| AI Agents | System prompts for each agent role |

---

# 5. AI Agents

## Agent Architecture

```
Agent Definition:
  - Name: e.g., "Opportunity Matcher"
  - System Prompt: Role, behavior, constraints
  - Model: Assigned model (e.g., GPT-4o)
  - Tools: Available functions the agent can call
    - Search Knowledge Base
    - Query Engine API
    - Send Notification
  - Knowledge Bases: Linked document collections
  - Schedule: Cron or event-triggered
```

## Agent Catalog

| Agent | Engine | Purpose | Trigger |
|-------|--------|---------|---------|
| Opportunity Matcher | Opportunity | Match candidates to opportunities | Event: Opportunity.Created |
| Trust Verifier | Trust | Verify reference authenticity | Event: Trust.Reference.Provided |
| Connection Suggester | Relationship | Suggest new connections | Scheduled (daily) |
| Content Writer | AI | Generate blog posts, emails, social | On demand |
| Fraud Detector | Identity | Detect anomalous login patterns | Real-time |
| Smart Responder | Communication | Suggest replies to messages | Real-time |
| Workflow Advisor | Workflow | Suggest automation rules | Scheduled (weekly) |

---

# 6. Knowledge Bases & RAG

## Architecture

```
Document Upload
  ↓
Chunking (fixed/semantic/sentence)
  ↓
Embedding Generation (provider-specific model)
  ↓
Vector Storage (pgvector in PostgreSQL)
  ↓
Query → Embed → Similarity Search → Context → LLM → Response
```

## Knowledge Base Types

| Type | Content | Use Case |
|------|---------|----------|
| Tenant Knowledge Base | Org documents, policies, product info | RAG for tenant-specific queries |
| Platform Knowledge Base | Yugrow docs, help articles | Customer support, AI assistance |
| Public Knowledge Base | Industry data, public resources | Market intelligence |

## RAG Flow

```
User Query
  ↓
1. Embed query
2. Search vector store (top-K similar chunks)
3. Retrieve context
4. Inject into prompt template
5. Call LLM with context
6. Return grounded response with citations
```

---

# 7. AI Integration per Engine

## Identity Engine

| AI Feature | Implementation |
|------------|---------------|
| Login anomaly detection | ML model on login patterns (location, device, time, velocity) |
| Duplicate user detection | Embedding similarity + fuzzy matching |
| Smart MFA prompts | Risk-based authentication (low risk = no MFA, high risk = MFA required) |

## Organization Engine

| AI Feature | Implementation |
|------------|---------------|
| Org hierarchy suggestions | Industry pattern matching |
| Naming standardization | LLM-based normalization |
| Team composition recommendations | Analysis of successful team structures |

## Relationship Engine

| AI Feature | Implementation |
|------------|---------------|
| Connection suggestions | Graph analysis + shared context + opportunity alignment |
| Duplicate detection | Embedding similarity on profiles and business cards |
| Relationship strength prediction | Historical interaction + trust signals + collaboration history |
| Network insights | Centrality analysis, influence scoring |

## Trust Engine ⭐

| AI Feature | Implementation |
|------------|---------------|
| Fake profile detection | Behavioral analysis + pattern recognition |
| Reference authenticity verification | Consistency checking + cross-referencing |
| Trust score computation | Weighted combination of all trust signals |
| Anomaly detection | Unusual endorsement patterns, score manipulation attempts |

## Opportunity Engine ⭐⭐⭐

| AI Feature | Implementation |
|------------|---------------|
| Semantic matching | Embedding-based matching (not keyword search) |
| Opportunity categorization | LLM-based classification from natural language |
| Candidate ranking | Multi-factor scoring (match + trust + relationship) |
| Broadcast optimization | ML-based timing and level selection |
| Follow-up suggestions | Context-aware timing and message drafting |
| Deal stage prediction | Historical pipeline analysis |

## Communication Engine

| AI Feature | Implementation |
|------------|---------------|
| Smart reply suggestions | LLM-generated context-aware replies |
| Sentiment analysis | Classification model on message content |
| Language translation | Translation model for cross-language communication |
| Email drafting | LLM-generated email from context |
| Best channel prediction | ML-based channel selection |

## Workflow Engine

| AI Feature | Implementation |
|------------|---------------|
| Workflow suggestions | Pattern recognition from manual actions |
| Condition optimization | Analysis of workflow success rates |
| Natural language creation | "When deal is won, send thank-you email" → workflow definition |

---

# 8. Token Tracking & Cost Management

## Tracking Architecture

```
Every AI Request
  ↓
Record: tenant, user, provider, model, prompt_tokens, completion_tokens, cost
  ↓
Async write to token_usage table
  ↓
Real-time counters in Redis (per-tenant, per-hour)
  ↓
Threshold checks → Alert if approaching limit
```

## Cost Controls

| Control | Mechanism | Configuration |
|---------|-----------|---------------|
| Per-tenant monthly cap | Hard or soft limit | Tenant setting |
| Model tier restriction | Free tier → cheap models only | Plan-based |
| Rate limiting | Requests/minute per tenant | Redis-backed |
| Cache hit optimization | Identical prompts return cached | Automatic |
| Batch processing | Non-real-time → cheap models | Queue-based |

---

# 9. Guardrails & Safety

## Guardrail Layers

```
Input → Layer 1: PII Detection → Block/Redact
         Layer 2: Content Policy → Block/Warn/Log
         Layer 3: Prompt Injection → Block
         Layer 4: Rate Limit → Throttle
         → AI Model →
Output → Layer 5: Output Validation → Verify format
         Layer 6: Content Policy → Block/Warn/Log
         Layer 7: PII Detection → Redact
         → Response
```

## Prohibited Content Categories

- PII (passwords, SSN, credit cards, banking details)
- Profanity, hate speech, harassment
- Violence, self-harm, dangerous content
- Sexual content
- Prompt injection attempts
- Competitor model extraction attempts

---

# 10. AI Observability

## Metrics

| Metric | What It Measures | Alert Threshold |
|--------|-----------------|-----------------|
| Request latency | Time from request to response (p50, p95, p99) | p95 > 5s |
| Error rate | Percentage of failed requests | > 5% |
| Cache hit rate | Percentage served from cache | < 20% |
| Token usage per tenant | Monthly consumption | 80% of cap |
| Cost per tenant | Monthly AI cost | Budget threshold |
| Guardrail triggers | Content policy violations | > 10/day |

## Logging

- All AI requests logged (engine, prompt version, model, tokens, latency)
- No PII in logs (stripped by guardrails)
- All guardrail violations logged for review
- A/B test results logged for prompt optimization

---

> **This AI architecture is the blueprint for all AI features across the Yugrow platform. Every AI feature must route through the AI Gateway, respect tenant data isolation, and be observable by default.**
