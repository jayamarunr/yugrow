// ─── Yugrow Workspace Engine — HTTP Controller ─────────────────────

import { Controller, Post, Get, Patch, Delete, Body, Param } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { WorkspaceService } from './workspace.service';
import { WorkspaceType } from '@prisma/client';

@ApiTags('Workspace Engine')
@Controller('api/v1/workspaces')
export class WorkspaceController {
  constructor(private readonly ws: WorkspaceService) {}

  @Post()
  async create(
    @Body() dto: { name: string; slug: string; type: WorkspaceType; ownerId: string },
  ) {
    return this.ws.create(dto.name, dto.slug, dto.type, dto.ownerId);
  }

  @Get(':id')
  async get(@Param('id') id: string) {
    return this.ws.getById(id);
  }

  @Get('by-person/:personId')
  async getByPerson(@Param('personId') personId: string) {
    return this.ws.getByPerson(personId);
  }

  @Patch(':id')
  async update(@Param('id') id: string, @Body() dto: any) {
    return this.ws.update(id, dto);
  }

  @Post(':workspaceId/members')
  async addMember(
    @Param('workspaceId') wsId: string,
    @Body() dto: { personId: string; membershipType: string },
  ) {
    return this.ws.addMember(wsId, dto.personId, dto.membershipType);
  }

  @Delete(':workspaceId/members/:personId')
  async removeMember(
    @Param('workspaceId') wsId: string,
    @Param('personId') personId: string,
  ) {
    return this.ws.removeMember(wsId, personId);
  }

  @Post('switch')
  async switchContext(@Body() dto: { personId: string; workspaceId: string }) {
    return this.ws.switchContext(dto.personId, dto.workspaceId);
  }
}
