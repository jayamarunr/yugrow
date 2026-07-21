# Identity Engine

## Purpose
Authentication, authorization, user profiles, sessions, roles, and permissions.

## Capabilities
- Authenticate (email/password, OAuth, magic link, SSO)
- Authorize (RBAC, permission checks)
- Manage MFA (Phase 2)
- Manage Sessions (create, refresh, revoke)
- Manage API Keys
- Manage Roles & Permissions
- User Profile CRUD

## Dependencies
- None (foundational engine)

## Consumers
- All engines
- All products

## Events Emitted
- `Identity.User.Registered`
- `Identity.User.LoggedIn`
- `Identity.User.LoggedOut`
- `Identity.User.Updated`
- `Identity.User.Deactivated`
- `Identity.Role.Created`
- `Identity.Login.Failed`

## Status
- [x] Module structure created
- [x] Service stub with all methods
- [x] Controller with endpoints
- [x] Auth guard scaffold
- [x] Event definitions
- [x] Capability Registry
- [ ] Authentik/OIDC integration
- [ ] JWT implementation
- [ ] MFA support
- [ ] Full test coverage
- [ ] OpenAPI docs verified
