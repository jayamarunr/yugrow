# Organization Engine

## Purpose
Multi-tenant hierarchy, business groups, legal entities, brands, branches, departments, teams, and memberships.

## Capabilities
- Create Tenant
- Get/Update Tenant
- Invite/Remove Members
- Manage Hierarchy (Phase 2)
- Create Teams (Phase 2)

## Dependencies
- Identity Engine (for user membership)

## Consumers
- All engines and products

## Events Emitted
- `Organization.Tenant.Provisioned`
- `Organization.Tenant.Updated`
- `Organization.Member.Invited`
- `Organization.Member.Removed`

## Status
- [x] Module structure created
- [x] Service with tenant CRUD
- [x] Controller with endpoints
- [x] Event definitions
- [x] Capability Registry
- [ ] Full tenant hierarchy (BusinessGroup, LegalEntity, Brand, Branch, Dept, Team)
- [ ] Subscription management
- [ ] Feature flag integration
- [ ] Full test coverage
