// ─── Yugrow Workspace Engine Module ─────────────────────────────────
// Identity context — Person acts as a Workspace (Personal, Company, etc.)

import { Module } from '@nestjs/common';
import { DatabaseModule } from '@database/index';
import { WorkspaceController } from './workspace.controller';
import { WorkspaceService } from './workspace.service';

@Module({
  imports: [DatabaseModule],
  controllers: [WorkspaceController],
  providers: [WorkspaceService],
  exports: [WorkspaceService],
})
export class WorkspaceModule {}
