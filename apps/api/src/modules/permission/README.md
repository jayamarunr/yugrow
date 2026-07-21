# Permission Engine

## Purpose
5-layer authorization: Identity > Workspace > Membership > Role > Capability.
Every product asks: "Can this person do X in this workspace?"

## Data Model
- Capability: atomic permission (product.resource.action)
- CapabilityScope: ABAC attribute restrictions
- CapabilityGrant: temporary permission with expiry

## Status
- [x] Module, service, controller
- [x] Permission checking (can / require / canBatch)
- [x] Capability management (define, list)
- [x] Temporary grants
- [ ] ABAC scoping (CapabilityScope)
- [ ] UI capability projection endpoint
- [ ] Full test coverage
