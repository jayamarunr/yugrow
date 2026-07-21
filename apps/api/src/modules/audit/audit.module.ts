// ─── Yugrow Audit Engine Module ─────────────────────────────────────
// Immutable audit logging. Every important action is recorded.

import { Module } from '@nestjs/common';
import { DatabaseModule } from '@database/index';
import { AuditService } from './audit.service';
import { AuditController } from './audit.controller';

@Module({
  imports: [DatabaseModule],
  controllers: [AuditController],
  providers: [AuditService],
  exports: [AuditService],
})
export class AuditModule {}
