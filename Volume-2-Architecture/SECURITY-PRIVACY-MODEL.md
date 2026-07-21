---
Title: Security & Privacy Model
Version: 1.0
Status: Draft
Owner: Security Architect
Last Updated: 2026-07-21
Dependencies:
  - Volume-2-Architecture/ENTERPRISE-ARCHITECTURE.md
  - Volume-2-Architecture/DATA-OWNERSHIP-RULES.md
Related Documents:
  - governance/security-policy.md
  - adr/ADR-0001-Platform-Architecture.md
---

# Security & Privacy Model

> **The security and privacy architecture for the Yugrow platform — covering authentication, authorization, encryption, compliance, and privacy across all engines.**

---

## Table of Contents

| # | Section |
|---|---------|
| 1 | Security Principles |
| 2 | Trust Boundaries |
| 3 | Authentication Architecture |
| 4 | Authorization Model |
| 5 | Multi-Tenant Isolation |
| 6 | Encryption Strategy |
| 7 | Secrets Management |
| 8 | Audit & Compliance |
| 9 | Privacy Model |
| 10 | Incident Response |
| 11 | Security Checklist |

---

# 1. Security Principles

| # | Principle | Implementation |
|---|-----------|---------------|
| 1 | **Zero Trust** | Verify every request. No implicit trust based on network location. |
| 2 | **Least Privilege** | Every user, service, and API key gets minimum permissions. |
| 3 | **Defense in Depth** | Multiple security layers — WAF, auth, authorization, encryption, audit. |
| 4 | **Encrypt Everywhere** | AES-256 at rest. TLS 1.3 in transit. |
| 5 | **Audit Everything** | All access and mutations logged immutably. |
| 6 | **Shift Left** | Security reviews during design, not after implementation. |
| 7 | **No Secrets in Code** | All secrets vault-injected at runtime. |
| 8 | **Privacy by Design** | Compliance (GDPR, DPDP, CCPA) is a product feature. |

---

# 2. Trust Boundaries

## Trust Boundary Diagram

```
Internet
   │
   │ TLS 1.3
   ▼
┌──────────────────────────────────────────────────────────┐
│  Boundary 1: Public Edge                                 │
│  WAF, Rate Limiting, DDoS Protection, CDN                │
└────────────────────────┬─────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────┐
│  Boundary 2: API Gateway                                 │
│  JWT Validation, Rate Limiting, Request Routing          │
└────────────────────────┬─────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────┐
│  Boundary 3: Engine Layer                                │
│  AuthN/AuthZ, Business Logic, Data Access                │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐   │
│  │Identity  │ │Relationship│ │Opportunity│ │   AI    │   │
│  │ Engine   │ │  Engine   │ │  Engine   │ │ Engine  │   │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘   │
└────────────────────────┬─────────────────────────────────┘
                         │ mTLS (internal)
                         ▼
┌──────────────────────────────────────────────────────────┐
│  Boundary 4: Data Layer                                  │
│  PostgreSQL, Redis, S3 Storage                           │
│  Encryption at rest, Network isolation                   │
└──────────────────────────────────────────────────────────┘
```

## Service-to-Service Communication

- Internal engine-to-engine calls use mTLS
- Service mesh (Istio/Linkerd) manages certificate rotation
- No engine directly exposes its database to another engine

---

# 3. Authentication Architecture

## Authentication Methods

| Method | Protocol | Security Level | Timeline |
|--------|----------|---------------|----------|
| Email + Password | Custom (Argon2id) | Standard | Launch |
| Google OAuth | OAuth 2.0 / OIDC | Standard | Launch |
| Magic Link | Passwordless | Standard | Launch |
| SSO (SAML/OIDC) | SAML 2.0 / OIDC | Enterprise | Phase 2 |
| MFA (TOTP) | TOTP (RFC 6238) | High | Phase 2 |
| MFA (SMS) | SMS OTP | Medium | Phase 2 |
| MFA (WebAuthn) | FIDO2 / WebAuthn | High | Phase 3 |

## JWT Token Strategy

| Token | Lifetime | Storage | Purpose |
|-------|----------|---------|---------|
| Access Token | 15 minutes | Memory (web) / Secure storage (mobile) | API authentication |
| Refresh Token | 7 days (configurable) | HttpOnly cookie / Secure storage | Get new access tokens |
| ID Token | 15 minutes | Memory | User identity claims |

## Session Management

| Aspect | Approach |
|--------|----------|
| Token Revocation | Blacklist compromised tokens + refresh token rotation |
| Concurrent Sessions | Configurable per org (default: unlimited) |
| Session Timeout | Configurable idle timeout (default: 24h) |
| Force Logout | Admin can invalidate all sessions for a user |
| Device Tracking | Known devices tracked; new device notifications |

## Password Policy

| Requirement | Standard |
|-------------|----------|
| Minimum Length | 8 characters |
| Complexity | At least 1 uppercase, 1 lowercase, 1 number |
| Hashing Algorithm | Argon2id |
| Password History | Last 5 passwords remembered |
| Max Login Attempts | 5 before temporary lockout (15 min) |
| Reset Token Expiry | 1 hour |

---

# 4. Authorization Model

## RBAC Structure

```
Platform-Level Roles (system-wide):
├── Super Admin — Full platform access
└── Support — Read-only, tenant support scope

Tenant-Level Roles (per organization):
├── Admin — Full tenant access
├── Manager — Functional area management
├── Member — Standard user access
└── Viewer — Read-only access
```

## Permission Matrix

| Resource | Admin | Manager | Member | Viewer |
|----------|-------|---------|--------|--------|
| Users | CRUD | Read | Read | Read |
| Roles | CRUD | Read | — | — |
| Organization | CRUD | Read | Read | Read |
| Relationships | CRUD | CRUD | Create, Read | Read |
| Opportunities | CRUD | CRUD | Create, Read | Read |
| Trust Data | Read | Read | Read | — |
| Communications | CRUD | CRUD | Create, Read | Read |
| Workflows | CRUD | CRUD | Read | — |
| AI Settings | CRUD | Read | — | — |
| Billing | CRUD | Read | — | — |
| Analytics | Read | Read | Read | Read |

## API Key Scoping

API keys can be scoped by:
- **Engine** — which engines the key can access
- **Actions** — read, write, admin
- **Resources** — specific resource types
- **IP Ranges** — whitelisted source IPs
- **Expiration** — automatic expiry

---

# 5. Multi-Tenant Isolation

## Isolation Strategy

| Layer | Isolation Mechanism |
|-------|-------------------|
| Network | Tenant-specific VPCs or namespaces (enterprise) |
| API | JWT orgId claim on every request |
| Application | orgId filter on all queries |
| Database | Row-level security (RLS) policies |
| Cache | Tenant-prefixed keys |
| Storage | Tenant-prefixed paths with IAM policies |
| Events | orgId in event payload for consumer filtering |

## Database RLS Policy

```sql
-- Every tenant-scoped table has an RLS policy
CREATE POLICY tenant_isolation ON opportunities
  USING (org_id = current_setting('app.org_id')::UUID);
```

## Cross-Tenant Data Access

- Prohibited by default
- Explicit platform admin API for support operations (fully audited)
- Tenant data export/import controlled by Organization Engine

---

# 6. Encryption Strategy

## Encryption at Rest

| Data Store | Encryption Method | Key Management |
|-----------|------------------|----------------|
| PostgreSQL | AES-256 (TDE or disk-level) | Cloud KMS / HashiCorp Vault |
| Redis | Encryption in transit only | — |
| S3 Storage | AES-256 (SSE-S3 or SSE-KMS) | Cloud KMS |
| Backups | AES-256 | Separate backup key |
| Secrets | HashiCorp Vault / Cloud KMS | Hardware Security Module (HSM) |

## Encryption in Transit

| Traffic | Protocol | Cipher |
|---------|----------|--------|
| External (user ↔ API) | TLS 1.3 | TLS_AES_256_GCM_SHA384 |
| Internal (service ↔ service) | mTLS 1.3 | TLS_AES_256_GCM_SHA384 |
| Database connections | TLS 1.3 | Mutual TLS |
| Cache connections | TLS 1.3 | Mutual TLS |

## Data Classification & Encryption

| Classification | Examples | At Rest | In Transit | Access |
|---------------|----------|---------|------------|--------|
| Public | Product names, public profiles | Standard | TLS | No auth needed |
| Internal | Org settings, feature flags | AES-256 | TLS | Authenticated |
| Confidential | PII, financial data | AES-256 + field-level | TLS + field masking | Least privilege |
| Restricted | Password hashes, MFA secrets, API keys | AES-256 + HSM-backed | mTLS | Engine only |

---

# 7. Secrets Management

## Secret Types

| Secret | Storage | Rotation | Access |
|--------|---------|----------|--------|
| Database passwords | Vault | 90 days | Engine service accounts |
| API keys (external) | Vault | On compromise | Integration Hub |
| JWT signing keys | Vault | 30 days | Identity Engine |
| Encryption keys | Vault + HSM | Annual | Key management service |
| AI provider keys | Vault | On compromise | AI Gateway |

## Secret Injection Flow

```
Deploy → Kubernetes → Vault Agent Sidecar
                              ↓
                     Inject secrets as volume mount
                              ↓
                     Application reads from file
                              ↓
                     Never in environment variables
```

---

# 8. Audit & Compliance

## Audit Log Requirements

| Category | Events Logged | Retention | Access |
|----------|--------------|-----------|--------|
| Authentication | Login, logout, MFA, password changes, SSO | 1 year | Security team |
| Authorization | Role changes, permission changes, API key creation | 3 years | Security team |
| Data Access | Read access to sensitive data | 1 year | Compliance |
| Data Mutations | Create, update, delete on any entity | 3 years | Audit |
| Tenant Admin | Tenant creation, deletion, setting changes | 3 years | Operations |
| AI Usage | Requests, models, tokens, cost | 30 days | Billing |
| Security Events | Guardrail triggers, rate limit violations, anomalies | 1 year | Security team |

## Audit Store Architecture

```
Engine → Structured Audit Event → Kafka → Immutable Log Store
                                                ↓
                                         (append-only)
                                                ↓
                                         Query API (read-only)
                                                ↓
                                    Compliance export / SIEM integration
```

---

# 9. Privacy Model

## Privacy Principles

1. **Data Minimization** — Only collect what's needed
2. **Purpose Limitation** — Use data only for its stated purpose
3. **Consent Management** — Explicit opt-in for communications
4. **Right to Access** — Users can see all their data
5. **Right to Deletion** — Users can delete their data
6. **Right to Portability** — Users can export their data
7. **Privacy as Default** — Relationship visibility defaults to private

## Privacy Controls by Data Type

| Data Type | Visibility Default | User Configurable | Deletion |
|-----------|-------------------|-------------------|----------|
| Profile name | Public | Yes | On account delete |
| Email | Private | No (required) | On account delete |
| Phone | Private | Yes | On account delete |
| Relationship list | Private | Yes | Per-relationship |
| Trust score | Private | No (computed) | On account delete |
| Opportunity history | Private | No (org-based) | Per org setting |
| Communications | Private | No | Per tenant policy |
| Activity history | Private | Yes | Per tenant policy |

## Compliance by Region

| Regulation | Requirements | Implementation |
|------------|-------------|----------------|
| GDPR (EU) | Consent, access, deletion, portability | Privacy Engine settings, data export API, delete API |
| DPDP (India) | Consent, data localization, grievance | Consent records, data residency config |
| CCPA (California) | Right to know, delete, opt-out | Privacy dashboard, do-not-sell flag |

---

# 10. Incident Response

## Security Incident Response Plan

| Phase | Actions | Timeline |
|-------|---------|----------|
| Detection | Automated alerts + manual review | Real-time |
| Triage | Determine severity, containment strategy | < 15 min |
| Containment | Isolate affected systems, revoke credentials | < 1 hour |
| Eradication | Remove threat, patch vulnerability | < 4 hours |
| Recovery | Restore from clean backup, verify integrity | < 24 hours |
| Post-Mortem | Root cause analysis, prevent recurrence | < 1 week |

## Incident Severity Levels

| Severity | Example | Response Time | Escalation |
|----------|---------|---------------|------------|
| Critical | Data breach, service outage | < 15 min | CEO, CTO |
| High | Unauthorized access, data corruption | < 1 hour | CTO, Security Lead |
| Medium | Suspicious activity, policy violation | < 4 hours | Security Team |
| Low | Minor misconfiguration, false positive | < 24 hours | Engineering |

---

# 11. Security Checklist

## Pre-Launch Checklist

- [ ] Authentication: All methods tested (email, OAuth, magic link, SSO)
- [ ] MFA: TOTP setup, verification, recovery codes
- [ ] Authorization: RBAC matrix implemented and tested
- [ ] Tenant Isolation: Verified at API, application, and database layers
- [ ] Encryption: TLS 1.3 verified, at-rest encryption confirmed
- [ ] Secrets: No hardcoded secrets in repository, vault integration tested
- [ ] Audit: All required events captured, immutable store operational
- [ ] Rate Limiting: Per-tenant limits active on all public endpoints
- [ ] CORS: Restricted to known origins
- [ ] Headers: Helmet.js active (CSP, HSTS, X-Frame-Options)
- [ ] Input Validation: All endpoints validate and sanitize input
- [ ] SQL Injection: Parameterized queries confirmed (Prisma)
- [ ] XSS: Output encoding, CSP headers verified
- [ ] Penetration Test: Third-party pen test completed

## Per-Release Checklist

- [ ] OWASP Top 10 review completed
- [ ] New API endpoints reviewed for auth/authz
- [ ] New data fields classified for privacy
- [ ] Rate limiting applied to new endpoints
- [ ] Audit events added for new mutations
- [ ] Dependency scan (no known vulnerabilities)
- [ ] Secrets scan (no credentials in code)

---

> **This security model is a living document. All security-related changes require review by the Security Architect and must be recorded as ADRs.**
