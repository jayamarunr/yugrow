// ─── Yugrow API — Root Application Module ────────────────────────────

import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { APP_GUARD } from '@nestjs/core';
import { DatabaseModule } from '@database/index';
import { loggerConfig } from '@logger/index';
import { HealthModule } from './health/health.module';
import { IdentityModule } from './modules/identity/identity.module';
import { OrganizationModule } from './modules/organization/organization.module';
import { WorkspaceModule } from './modules/workspace/workspace.module';
import { PermissionModule } from './modules/permission/permission.module';
import { AuditModule } from './modules/audit/audit.module';
import { FileStorageModule } from './modules/file-storage/file-storage.module';
import { EdgeModule } from './modules/edge/edge.module';
import { RelationshipModule } from './modules/relationship/relationship.module';
import { ProductModule } from './modules/product/product.module';
import { CheckinModule } from './modules/checkin/checkin.module';
import { CommunicationModule } from './modules/communication/communication.module';
import { AuthGuard } from './modules/identity/guards/auth.guard';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    loggerConfig,
    DatabaseModule,
    ThrottlerModule.forRoot([{ ttl: 60000, limit: 100 }]),
    HealthModule,

    // ─── Platform Engines (Phase 1 — Sprint 1) ──────────────────
    IdentityModule,       // Person identity, auth
    WorkspaceModule,      // Identity context, workspace switching
    PermissionModule,     // 5-layer authorization
    OrganizationModule,   // Enterprise hierarchy inside workspaces
    AuditModule,          // Immutable audit logging
    FileStorageModule,    // S3-compatible file storage
    EdgeModule,           // Domains, SSL, CDN, routing
    RelationshipModule,   // Generic entity relationships, business cards
    ProductModule,        // Product registration, lifecycle, plan assignments
    CheckinModule,        // CheckIN MVP — venue, event, presence, live, connections
    CommunicationModule,  // Communication Lite — conversations, messages
  ],
  controllers: [],
  providers: [
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
    {
      provide: APP_GUARD,
      useClass: AuthGuard,
    },
  ],
})
export class AppModule {}
