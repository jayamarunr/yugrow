// ─── Yugrow Edge Platform — HTTP Controller ─────────────────────────

import { Controller, Post, Get, Delete, Param, Body } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { EdgeService } from './edge.service';

@ApiTags('Edge Platform')
@Controller('api/v1/edge')
export class EdgeController {
  constructor(private readonly edge: EdgeService) {}

  @Post('subdomains')
  async provisionSubdomain(@Body() dto: { workspaceId: string; slug: string }) {
    return this.edge.provisionSubdomain(dto.workspaceId, dto.slug);
  }

  @Post('domains')
  async registerDomain(@Body() dto: { workspaceId: string; domain: string }) {
    return this.edge.registerCustomDomain(dto.workspaceId, dto.domain);
  }

  @Post('domains/:id/verify')
  async verifyDomain(@Param('id') id: string) {
    return this.edge.verifyDomain(id);
  }

  @Post('domains/:id/ssl')
  async provisionSSL(@Param('id') id: string) {
    return this.edge.provisionSSL(id);
  }

  @Post('routes')
  async setRoute(@Body() dto: { domainId: string; path: string; targetType: string; targetId: string }) {
    return this.edge.setRoute(dto.domainId, dto.path, dto.targetType, dto.targetId);
  }

  @Get('domains/:workspaceId')
  async getDomains(@Param('workspaceId') workspaceId: string) {
    return this.edge.getDomains(workspaceId);
  }

  @Get('domains/detail/:id')
  async getDomain(@Param('id') id: string) {
    return this.edge.getDomain(id);
  }

  @Delete('domains/:id')
  async removeDomain(@Param('id') id: string) {
    return this.edge.removeDomain(id);
  }

  @Post('preview')
  async createPreview(@Body() dto: { workspaceId: string; resourceType: string; resourceId: string }) {
    return this.edge.createPreviewUrl(dto.workspaceId, dto.resourceType, dto.resourceId);
  }
}
