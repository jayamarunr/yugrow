// ─── Communication Lite Controller ─────────────────────────────────
// REST API for conversations and messages.

import { Controller, Get, Post, Param, Body, Query } from '@nestjs/common';
import { CommunicationService } from './communication.service';

@Controller('conversations')
export class CommunicationController {
  constructor(private readonly communicationService: CommunicationService) {}

  // ── Create a conversation from a relationship ────────────────────

  @Post()
  async createConversation(@Body() body: {
    relationshipId: string;
    contextType?: string;
    contextId?: string;
  }) {
    return this.communicationService.createConversation(body.relationshipId, {
      contextType: body.contextType,
      contextId: body.contextId,
    });
  }

  // ── List conversations for a person ───────────────────────────────

  @Get()
  async listConversations(@Query('personId') personId: string) {
    return this.communicationService.getConversations(personId);
  }

  // ── Get a single conversation with context ───────────────────────

  @Get(':id')
  async getConversation(
    @Param('id') id: string,
    @Query('personId') personId: string,
  ) {
    return this.communicationService.getConversation(id, personId);
  }

  // ── Get conversation context (origin) ────────────────────────────

  @Get(':id/context')
  async getContext(@Param('id') id: string) {
    return this.communicationService.getConversationContext(id);
  }

  // ── Send a message ───────────────────────────────────────────────

  @Post(':id/messages')
  async sendMessage(
    @Param('id') id: string,
    @Body() body: { senderPersonId: string; content: string },
  ) {
    return this.communicationService.sendMessage(id, body.senderPersonId, body.content);
  }

  // ── Get messages in a conversation ───────────────────────────────

  @Get(':id/messages')
  async getMessages(
    @Param('id') id: string,
    @Query('personId') personId: string,
  ) {
    return this.communicationService.getMessages(id, personId);
  }
}
