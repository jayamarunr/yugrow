// ─── Yugrow Audit Engine — HTTP Controller ──────────────────────────

import { Controller, Get, Query, Param } from '@nestjs/common';
import { ApiTags, ApiQuery } from '@nestjs/swagger';
import { AuditService } from './audit.service';

@ApiTags('Audit Engine')
@Controller('api/v1/audit')
export class AuditController {
  constructor(private readonly audit: AuditService) {}

  @Get(':workspaceId')
  @ApiQuery({ name: 'action', required: false })
  @ApiQuery({ name: 'resource', required: false })
  @ApiQuery({ name: 'personId', required: false })
  @ApiQuery({ name: 'limit', required: false })
  @ApiQuery({ name: 'offset', required: false })
  async query(
    @Param('workspaceId') workspaceId: string,
    @Query('action') action?: string,
    @Query('resource') resource?: string,
    @Query('personId') personId?: string,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    return this.audit.query(workspaceId, {
      action,
      resource,
      personId,
      limit: limit ? parseInt(limit) : undefined,
      offset: offset ? parseInt(offset) : undefined,
    });
  }

  @Get(':workspaceId/:resource/:resourceId')
  async getByResource(
    @Param('workspaceId') workspaceId: string,
    @Param('resource') resource: string,
    @Param('resourceId') resourceId: string,
  ) {
    return this.audit.getByResource(workspaceId, resource, resourceId);
  }
}
