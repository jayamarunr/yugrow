// ─── Yugrow Permission Engine — HTTP Controller ─────────────────────

import { Controller, Post, Get, Delete, Body, Param } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { PermissionService } from './permission.service';

@ApiTags('Permission Engine')
@Controller('api/v1/permissions')
export class PermissionController {
  constructor(private readonly perm: PermissionService) {}

  @Post('check')
  async check(
    @Body() dto: { personId: string; workspaceId: string; capability: string },
  ) {
    const allowed = await this.perm.can(dto.personId, dto.workspaceId, dto.capability);
    return { allowed, capability: dto.capability };
  }

  @Post('check-batch')
  async checkBatch(
    @Body() dto: { personId: string; workspaceId: string; capabilities: string[] },
  ) {
    return this.perm.canBatch(dto.personId, dto.workspaceId, dto.capabilities);
  }

  @Get('capabilities/:personId/:workspaceId')
  async getCapabilities(
    @Param('personId') personId: string,
    @Param('workspaceId') workspaceId: string,
  ) {
    return this.perm.getCapabilities(personId, workspaceId);
  }

  @Post('capabilities')
  async defineCapability(
    @Body() dto: { product: string; resource: string; action: string },
  ) {
    return this.perm.defineCapability(dto.product, dto.resource, dto.action);
  }

  @Post('grants')
  async grantTemporary(
    @Body() dto: {
      personId: string;
      workspaceId: string;
      capability: string;
      grantedBy: string;
      expiresAt: string;
      reason?: string;
    },
  ) {
    return this.perm.grantTemporary(
      dto.personId,
      dto.workspaceId,
      dto.capability,
      dto.grantedBy,
      new Date(dto.expiresAt),
      dto.reason,
    );
  }

  @Delete('grants/:id')
  async revokeGrant(@Param('id') id: string) {
    return this.perm.revokeGrant(id);
  }
}
