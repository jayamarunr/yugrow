# Founder Decisions

> **Every founder decision that shapes Yugrow's product, architecture, and business model.**
>
> When in doubt, consult this file. If a decision is not here, it hasn't been made yet.
>
> Format: `FD-NNN` — sequential, never deleted, never modified (addendums appended if needed).

---

## FD-001 — One Identity Per Person

**Date:** 2026-07-22
**Category:** Identity

One mobile number = one Person. No duplicate accounts. A Person can own multiple workspaces and be a member of others, but always under a single identity.

**Why:** Prevents fragmentation of the Business Graph. Every relationship, trust evidence, and opportunity is tied to the person, not an account.

---

## FD-002 — Active Workspace Context

**Date:** 2026-07-22
**Category:** Architecture

Every action in Yugrow happens inside an Active Workspace. Every request carries Person ID + Workspace ID + Role + Capabilities. Switching workspaces changes the entire app — navigation, permissions, data, branding.

**Why:** The workspace is the operating system of Yugrow. One person can represent different entities (Personal, Company A, NGO) at different times, and the platform must reflect that instantly.

**Addendum:** Default Active Workspace — users can set a default. Most-used workspace auto-selects on login.

---

## FD-003 — Event Attendance Does Not Imply Expertise

**Date:** 2026-07-22
**Category:** Intelligence, Platform Law

A SaaS developer at an agri expo is there to sell software, not because they're in agriculture. Attendance may inform networking context, but must **never** be used as a primary signal for opportunity matching, skill inference, or content recommendations.

**Why:** Prevents incorrect assumptions that degrade trust in the platform. Broadcast matching uses skills + geography, not event attendance.

---

## FD-004 — CheckIN Is Frictionless

**Date:** 2026-07-22
**Category:** Product, UX

CheckIN asks nothing beyond "which workspace?" No business intent questions, no goal selection, no role selection (beyond workspace). The only choice: which workspace to represent.

**Flow:** Check in → See people → Connect → Accepted → Chat. Three steps. Under 30 seconds.

**Why:** Someone at a business event already has intent. Every extra question reduces adoption.

---

## FD-005 — Relationships Are Permanent, Presence Is Temporary

**Date:** 2026-07-22
**Category:** Data Model

Relationships, once established, are permanent unless explicitly removed by either party. Presence auto-expires. No checkout button. Venue outlives events. Events outlive presence. Relationships outlive everything.

**Why:** Networking is about building lasting connections. Events are just the context where they start.

---

## FD-006 — Broadcast Uses Skills + Geography, Not Event Attendance

**Date:** 2026-07-22
**Category:** Product, Intelligence

Broadcast matching is driven by: declared skills, declared industries, current business intent, declared geographic scope, relationship proximity, trust signals. NOT by event attendance history.

**Opportunity Radius:** Connections → Event Attendees → Venue → City → State → Country → Global.

**Why:** Ensures opportunities reach people who can actually act on them, not people who happened to attend a related event.

---

## FD-007 — Every Interaction Must Reduce Friction

**Date:** 2026-07-22
**Category:** UX, Platform Law

If a feature asks users to provide information that can be inferred later or is not essential to the immediate task, the feature should be redesigned. The temptation with enterprise software is always to add one more dropdown, one more required field. Resist it.

**Why:** Friction reduces adoption. The platform succeeds when networking feels effortless.

---

## FD-008 — Pricing: Monetize Capability, Not Existence

**Date:** 2026-07-22
**Category:** Business Model

Unlimited workspaces at every tier. Charge for features (AI, team members, CRM, analytics), not for creating workspaces. Every new workspace strengthens the Business Graph — charging for them slows network growth.

**Tiers:** Free (core networking, 1 member per workspace, basic website) → Pro (AI, custom domains) → Business (team, CRM, analytics) → Enterprise (groups, SSO, compliance).

**Why:** GitHub doesn't charge per repository. They charge for collaboration features. Same principle.

---

## FD-009 — Bring Your Own AI (BYOAI)

**Date:** 2026-07-22
**Category:** Product, Architecture

Yugrow is provider-agnostic. Users connect their preferred AI providers (OpenAI, Anthropic, Gemini, DeepSeek, Ollama, etc.) through the AI Gateway. Every product calls a common interface (generate text, generate image, analyze document). The gateway handles provider differences.

**Optional Yugrow AI:** Available for new users who don't have their own keys. Removes onboarding friction.

**Why:** Keeps Yugrow independent of any single AI vendor. Large enterprises with strict AI policies can use approved providers. Pricing stays about platform workflow, not tokens.

---

## FD-010 — Commerce Is Configuration, Not Code

**Date:** 2026-07-22
**Category:** Architecture, Business Model

Pricing, plans, feature flags, usage limits, coupons, trials, and regional pricing are configurable through Platform Administration — not hardcoded in application logic. A Commerce Engine owns: plans, subscriptions, pricing, usage metering, billing, coupons, taxes, payment providers.

**As a super admin you can:** Create/edit/delete plans, update the feature matrix, change usage limits, create coupons, configure regional pricing, toggle feature flags — all without deployment.

**Why:** Pricing strategy evolves faster than code. The platform should never require a deployment to change a price or add a promotion.

---

## FD-011 — Platform Administration Is Internal

**Date:** 2026-07-22
**Category:** Architecture

Pricing is not part of the Finance product. Finance is for customers. Pricing is for Yugrow. Create a separate Platform Administration area: Plans, Pricing, Features, Billing, Coupons, Usage Limits, Feature Flags, AI Models, API Keys, Marketplace, Support, Audit Logs, Monitoring, System Health.

**Why:** Keeps customer-facing products completely separate from the platform's operational controls. Different domains, different interfaces, different access controls.

---

## FD-012 — Build Vertical Slices, Not Horizontal Layers

**Date:** 2026-07-22
**Category:** Engineering

Build complete user journeys across multiple engines rather than completing one engine at a time. A vertical slice through Identity → Workspace → Website → CheckIN → Relationship → Communication → Broadcast proves the platform works end-to-end.

**Target:** Time from signup to first accepted business connection.

**Why:** A working demoable feature is worth more than 100% completion of an isolated engine. Real users validate real assumptions.

---

*No decision in this file is final. As the platform evolves and the market teaches us what works, decisions can be refined. But every change should be recorded as an addendum, not a deletion.*
