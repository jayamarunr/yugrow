# Relationship Engine

## Purpose
Generic entity relationships between Person, Workspace, Company, Event, and any future entity type. Configurable types, lifecycle states, strength scoring, business cards, and connection requests.

## Capabilities
- Create/Read/Update/Delete relationships
- Connection requests (send, accept, decline)
- Business cards (create, list, share)
- Mutual connections
- Network statistics
- Configurable relationship types

## Generic Entity Support
Relationships support any entity type: Person, Workspace, Company, Event, etc.
sourceEntityType and targetEntityType are strings, not enums — future-proof.

## Lifecycle States
PENDING > CONNECTED > TRUSTED > MUTED > BLOCKED > ARCHIVED

## Events
See `events/relationship.events.ts`

## Status
- [x] Prisma models created
- [x] Module, service, controller
- [x] All API endpoints
- [x] Capability registry
- [ ] Seed relationship types
- [ ] Tests
