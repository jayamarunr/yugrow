// ─── Yugrow Organization Engine — HTTP Controller ──────────────────
// Thin controller — delegates all logic to OrganizationService.

import { Controller, Post, Get, Body, Param } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { OrganizationService } from './organization.service';

@ApiTags('Organization Engine')
@Controller('api/v1/organization')
export class OrganizationController {
  constructor(private readonly org: OrganizationService) {}

  @Post('hierarchy/groups')
  async createBusinessGroup(@Body() dto: { workspaceId: string; name: string }) {
    return this.org.createBusinessGroup(dto.workspaceId, dto.name);
  }

  @Get('hierarchy/:workspaceId')
  async getHierarchy(@Param('workspaceId') workspaceId: string) {
    return this.org.getHierarchy(workspaceId);
  }
}
