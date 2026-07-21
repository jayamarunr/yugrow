// ─── Communication Lite Service ────────────────────────────────────
// Conversations and messages tied to relationships.
// Not a WhatsApp replacement — no groups, no media, no voice/video.

import { Injectable, Inject, ConflictException, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { PRISMA } from '@database/index';

const ANALYTICS = {
  CONVERSATION_CREATED: 'conversation.created',
  MESSAGE_SENT: 'message.sent',
  CONVERSATION_ACTIVE: 'conversation.active',
};

function track(event: string, data: Record<string, any>): void {
  if (process.env.NODE_ENV === 'development') {
    console.log(`[Analytics] ${event}`, JSON.stringify(data));
  }
}

@Injectable()
export class CommunicationService {
  constructor(@Inject(PRISMA) private readonly prisma: PrismaClient) {}

  // ── Create conversation from relationship ────────────────────────

  async createConversation(relationshipId: string, context?: { contextType?: string; contextId?: string }) {
    // Verify relationship exists
    const relationship = await this.prisma.relationship.findUnique({
      where: { id: relationshipId },
    });
    if (!relationship) throw new NotFoundException('Relationship not found.');

    // Check if conversation already exists
    const existing = await this.prisma.conversation.findFirst({
      where: { relationshipId },
    });
    if (existing) return existing;

    const conversation = await this.prisma.conversation.create({
      data: {
        relationshipId,
        contextType: context?.contextType ?? null,
        contextId: context?.contextId ?? null,
      },
    });

    track(ANALYTICS.CONVERSATION_CREATED, {
      relationshipId,
      contextType: context?.contextType,
      contextId: context?.contextId,
    });

    return conversation;
  }

  // ── Get conversations for a person ────────────────────────────────

  async getConversations(personId: string) {
    // Find all relationships where this person participates
    const relationships = await this.prisma.relationship.findMany({
      where: {
        OR: [
          { sourceEntityType: 'person', sourceEntityId: personId },
          { targetEntityType: 'person', targetEntityId: personId },
        ],
        status: 'CONNECTED',
      },
      select: { id: true },
    });

    const relationshipIds = relationships.map((r) => r.id);

    const conversations = await this.prisma.conversation.findMany({
      where: { relationshipId: { in: relationshipIds } },
      include: {
        messages: {
          take: 1,
          orderBy: { createdAt: 'desc' },
          select: { content: true, createdAt: true, senderPersonId: true },
        },
      },
      orderBy: { updatedAt: 'desc' },
    });

    return conversations;
  }

  async getConversation(conversationId: string, personId: string) {
    const conversation = await this.prisma.conversation.findUnique({
      where: { id: conversationId },
      include: {
        messages: {
          orderBy: { createdAt: 'asc' },
        },
      },
    });
    if (!conversation) throw new NotFoundException('Conversation not found.');

    // Verify person is a participant via relationship
    await this.assertParticipant(conversation.relationshipId, personId);

    return conversation;
  }

  // ── Send message ─────────────────────────────────────────────────

  async sendMessage(conversationId: string, senderPersonId: string, content: string) {
    const conversation = await this.prisma.conversation.findUnique({
      where: { id: conversationId },
    });
    if (!conversation) throw new NotFoundException('Conversation not found.');

    // Verify sender is a participant
    await this.assertParticipant(conversation.relationshipId, senderPersonId);

    if (!content || content.trim().length === 0) {
      throw new ConflictException('Message content cannot be empty.');
    }

    const message = await this.prisma.message.create({
      data: {
        conversationId,
        senderPersonId,
        content: content.trim(),
      },
    });

    // Update conversation timestamp
    await this.prisma.conversation.update({
      where: { id: conversationId },
      data: { updatedAt: new Date() },
    });

    track(ANALYTICS.MESSAGE_SENT, {
      conversationId,
      senderPersonId,
      messageLength: content.length,
    });

    return message;
  }

  async getMessages(conversationId: string, personId: string) {
    const conversation = await this.prisma.conversation.findUnique({
      where: { id: conversationId },
    });
    if (!conversation) throw new NotFoundException('Conversation not found.');

    await this.assertParticipant(conversation.relationshipId, personId);

    const messages = await this.prisma.message.findMany({
      where: { conversationId },
      orderBy: { createdAt: 'asc' },
    });

    // Track active read
    track(ANALYTICS.CONVERSATION_ACTIVE, {
      conversationId,
      personId,
      messageCount: messages.length,
    });

    return messages;
  }

  // ── Get conversation context for display ─────────────────────────

  async getConversationContext(conversationId: string) {
    const conversation = await this.prisma.conversation.findUnique({
      where: { id: conversationId },
    });
    if (!conversation) throw new NotFoundException('Conversation not found.');

    const relationship = await this.prisma.relationship.findUnique({
      where: { id: conversation.relationshipId },
      include: {
        contexts: {
          take: 1,
          orderBy: { createdAt: 'desc' },
        },
      },
    });

    return {
      contextType: conversation.contextType,
      contextId: conversation.contextId,
      relationship: {
        sourceEntityId: relationship?.sourceEntityId,
        targetEntityId: relationship?.targetEntityId,
        status: relationship?.status,
      },
      origin: relationship?.contexts[0]
        ? {
            source: relationship.contexts[0].source,
            detail: relationship.contexts[0].sourceDetail,
            firstMetAt: relationship.contexts[0].firstMetAt,
            tags: relationship.contexts[0].tags,
          }
        : null,
    };
  }

  // ── Participant assertion ────────────────────────────────────────

  private async assertParticipant(relationshipId: string, personId: string): Promise<void> {
    const relationship = await this.prisma.relationship.findUnique({
      where: { id: relationshipId },
    });
    if (!relationship) throw new NotFoundException('Relationship not found.');

    const isParticipant =
      (relationship.sourceEntityType === 'person' && relationship.sourceEntityId === personId) ||
      (relationship.targetEntityType === 'person' && relationship.targetEntityId === personId);

    if (!isParticipant) {
      throw new ForbiddenException('You are not a participant in this conversation.');
    }
  }
}
