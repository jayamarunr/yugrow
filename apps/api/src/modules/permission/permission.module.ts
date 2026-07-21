// ─── Yugrow Permission Engine Module ────────────────────────────────
// 5-layer authorization: Identity > Workspace > Membership > Role > Capability

import { Module } from '@nestjs/common';
import { DatabaseModule } from '@database/index';
import { PermissionController } from './permission.controller';
import { PermissionService } from './permission.service';

@Module({
  imports: [DatabaseModule],
  controllers: [PermissionController],
  providers: [PermissionService],
  exports: [PermissionService],
})
export class PermissionModule {}
