# Engine Module Template

Every engine in `apps/api/src/modules/{engine-name}/` follows this structure:

```
{engine-name}/
│
├── {engine-name}.module.ts        — NestJS module definition
├── {engine-name}.controller.ts    — HTTP endpoints (thin — no business logic)
├── {engine-name}.service.ts       — Business logic
│
├── dto/                           — Request/response validation schemas
│   ├── create-{entity}.dto.ts
│   ├── update-{entity}.dto.ts
│   └── query-{entity}.dto.ts
│
├── entities/                      — Prisma entity types / TypeScript interfaces
│   └── {entity}.types.ts
│
├── interfaces/                    — Service interfaces & contracts
│   ├── {engine-name}-service.interface.ts
│   └── repository.interface.ts
│
├── guards/                        — Auth/permission guards (engine-specific)
│   └── {engine-name}-access.guard.ts
│
├── decorators/                    — Custom decorators
│   └── current-user.decorator.ts
│
├── events/                        — Event definitions & handlers
│   ├── {engine-name}.events.ts
│   └── handlers/
│
├── test/                          — Tests
│   ├── unit/
│   └── integration/
│
├── docs/                          — Engine-specific documentation
│   └── README.md
│
└── capabilities/                  — Capability Registry implementations
    └── {capability-name}.ts
```

## Conventions

| Artifact | Convention | Example |
|----------|-----------|---------|
| Module class | PascalCase + Module | `IdentityModule` |
| Controller | PascalCase + Controller | `IdentityController` |
| Service | PascalCase + Service | `IdentityService` |
| DTOs | PascalCase | `CreateUserDto` |
| Files | kebab-case | `identity.service.ts` |
| Routes | kebab-case plural | `api/v1/identity/users` |
| Events | PascalCase | `UserCreatedEvent` |

## Adding to AppModule

```typescript
// app.module.ts
import { IdentityModule } from './modules/identity/identity.module';

@Module({
  imports: [
    IdentityModule,
    // ...
  ],
})
```

## DoD Checklist

Before merging, verify against `engineering/DEFINITION-OF-DONE.md`.
