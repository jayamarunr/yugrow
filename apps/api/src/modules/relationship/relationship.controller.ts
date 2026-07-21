// ─── Yugrow Relationship Engine — HTTP Controller ──────────────────

import { Controller, Get, Post, Patch, Delete, Body, Param, Query } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { RelationshipService } from './relationship.service';
import { RequireCapability } from '../../common/decorators/capabilities.decorator';
import { RelationshipStatus } from '@prisma/client';

@ApiTags('Relationship Engine')
@ApiBearerAuth()
@Controller('api/v1/relationships')
export class RelationshipController {
  constructor(private readonly rel: RelationshipService) {}

  // ─── Types ────────────────────────────────────────────────────

  @Get('types')
  async listTypes(@Query('workspaceId') workspaceId?: string) {
    return this.rel.listTypes(workspaceId);
  }

  // ─── Core CRUD ────────────────────────────────────────────────

  @Post()
  @RequireCapability('relationship.graph.create')
  async create(@Body() dto: any) {
    return this.rel.create(dto);
  }

  @Get()
  @RequireCapability('relationship.graph.read')
  async list(
    @Query('workspaceId') workspaceId: string,
    @Query('entityType') entityType?: string,
    @Query('entityId') entityId?: string,
    @Query('status') status?: RelationshipStatus,
    @Query('typeId') typeId?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.rel.list({
      workspaceId,
      entityType,
      entityId,
      status,
      typeId,
      page: page ? parseInt(page) : undefined,
      limit: limit ? parseInt(limit) : undefined,
    });
  }

  @Get(':id')
  @RequireCapability('relationship.graph.read')
  async getById(@Param('id') id: string) {
    return this.rel.getById(id);
  }

  @Patch(':id')
  @RequireCapability('relationship.graph.update')
  async update(@Param('id') id: string, @Body() dto: any) {
    return this.rel.update(id, dto);
  }

  @Delete(':id')
  @RequireCapability('relationship.graph.delete')
  async delete(@Param('id') id: string) {
    return this.rel.delete(id);
  }

  // ─── Connection Requests ──────────────────────────────────────

  @Post('requests')
  @RequireCapability('relationship.connections.request')
  async sendRequest(@Body() dto: any) {
    return this.rel.sendRequest(dto);
  }

  @Patch('requests/:id')
  @RequireCapability('relationship.connections.respond')
  async respondToRequest(
    @Param('id') id: string,
    @Body() dto: { accept: boolean },
  ) {
    return this.rel.respondToRequest(id, dto.accept);
  }

  // ─── Business Cards ───────────────────────────────────────────

  @Post('cards')
  @RequireCapability('relationship.cards.create')
  async createCard(@Body() dto: any) {
    return this.rel.createCard(dto);
  }

  @Get('cards/:personId')
  @RequireCapability('relationship.cards.read')
  async listCards(@Param('personId') personId: string) {
    return this.rel.listCards(personId);
  }

  @Post('cards/share')
  @RequireCapability('relationship.cards.share')
  async shareCard(@Body() dto: { cardId: string; recipientId: string }) {
    return this.rel.shareCard(dto.cardId, dto.recipientId);
  }

  // ─── Network ──────────────────────────────────────────────────

  @Get('mutual/:personId/:targetPersonId')
  @RequireCapability('relationship.graph.read')
  async getMutual(
    @Param('personId') personId: string,
    @Param('targetPersonId') targetPersonId: string,
  ) {
    return this.rel.getMutualConnections(personId, targetPersonId);
  }

  @Get('stats/:personId')
  @RequireCapability('relationship.graph.read')
  async getStats(@Param('personId') personId: string) {
    return this.rel.getStats(personId);
  }
}
