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
    @Body() body: { senderPersonId: string; content: string; type?: string },
  ) {
    return this.communicationService.sendMessage(id, body.senderPersonId, body.content, body.type);
  }

  // ── Get messages in a conversation ───────────────────────────────

  @Get(':id/messages')
  async getMessages(
    @Param('id') id: string,
    @Query('personId') personId: string,
  ) {
    return this.communicationService.getMessages(id, personId);
  }

  // ═════════════════════════════════════════════════════════════════
  // SYSTEM CONVERSATIONS (Yugrow chat)
  // ═════════════════════════════════════════════════════════════════

  /// Initialize the Yugrow system conversation for a person.
  /// Creates the Yugrow persona + relationship + conversation if needed.
  /// Sends the welcome message on first creation.
  @Post('system/init')
  async initSystemConversation(@Body('personId') personId: string) {
    return this.communicationService.initSystemConversation(personId);
  }

  /// Get the Yugrow system conversation for a person.
  @Get('system/:personId')
  async getSystemConversation(@Param('personId') personId: string) {
    return this.communicationService.getSystemConversation(personId);
  }

  /// Ensure the Yugrow system persona exists (call at startup).
  @Post('system/ensure')
  async ensureSystemPersona() {
    return this.communicationService.ensureSystemPersona();
  }

  // ═════════════════════════════════════════════════════════════════
  // FOUNDER TOOLS — Send structured messages as Yugrow
  // ═════════════════════════════════════════════════════════════════

  /// Send a release note to a professional.
  @Post('system/release-note')
  async sendReleaseNote(@Body() body: {
    personId: string;
    version: string;
    title: string;
    changes: string[];
    actionLabel?: string;
  }) {
    await this.communicationService.sendReleaseNote(body.personId, {
      version: body.version,
      title: body.title,
      changes: body.changes,
      actionLabel: body.actionLabel,
    });
    return { message: 'Release note sent.' };
  }

  /// Send an announcement to a professional.
  @Post('system/announcement')
  async sendAnnouncement(@Body() body: {
    personId: string;
    title: string;
    date?: string;
    location?: string;
    description?: string;
    actionLabel?: string;
  }) {
    await this.communicationService.sendAnnouncement(body.personId, {
      title: body.title,
      date: body.date,
      location: body.location,
      description: body.description,
      actionLabel: body.actionLabel,
    });
    return { message: 'Announcement sent.' };
  }

  /// Send a feedback status update to a professional.
  @Post('system/feedback-status')
  async sendFeedbackStatus(@Body() body: {
    personId: string;
    title: string;
    status: string;
    statusColor?: string;
    sprint?: string;
    note?: string;
  }) {
    await this.communicationService.sendFeedbackStatus(body.personId, {
      title: body.title,
      status: body.status,
      statusColor: body.statusColor,
      sprint: body.sprint,
      note: body.note,
    });
    return { message: 'Feedback status sent.' };
  }

  /// Broadcast a message to all professionals with system conversations.
  @Post('system/broadcast')
  async broadcastSystemMessage(@Body() body: {
    content: string;
    type?: string;
  }) {
    return this.communicationService.broadcastSystemMessage(body.content, body.type);
  }
}
