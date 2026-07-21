// ─── Yugrow Organization Engine Module ──────────────────────────────
// Multi-tenant hierarchy, business groups, legal entities, teams.

import { Module } from '@nestjs/common';
import { DatabaseModule } from '@database/index';
import { OrganizationController } from './organization.controller';
import { OrganizationService } from './organization.service';

@Module({
  imports: [DatabaseModule],
  controllers: [OrganizationController],
  providers: [OrganizationService],
  exports: [OrganizationService],
})
export class OrganizationModule {}
