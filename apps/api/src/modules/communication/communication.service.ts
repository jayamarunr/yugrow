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

    // Attach contextType to each conversation for frontend type detection
    return conversations.map((c) => ({
      ...c,
      contextType: c.contextType,
    }));
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

  async sendMessage(
    conversationId: string,
    senderPersonId: string,
    content: string,
    type?: string,
  ) {
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
        type: (type?.toUpperCase() as any) ?? 'TEXT',
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
      type: type ?? 'TEXT',
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

  // ═════════════════════════════════════════════════════════════════
  // SYSTEM CONVERSATIONS (Yugrow chat)
  // ═════════════════════════════════════════════════════════════════

  // Well-known Yugrow system persona UUID — seeded in the database
  static readonly YUGROW_SYSTEM_PERSON_ID = '00000000-0000-0000-0000-000000000001';
  static readonly YUGROW_SYSTEM_WORKSPACE_ID = '00000000-0000-0000-0000-000000000001';
  static readonly YUGROW_SYSTEM_PERSON_EMAIL = 'system@yugrow.app';
  static readonly YUGROW_RELATIONSHIP_TYPE = 'system-yugrow';

  /// Ensure the Yugrow system persona exists in the database.
  /// Called at app startup and on demand.
  async ensureSystemPersona(): Promise<{ personId: string; workspaceId: string }> {
    const personId = CommunicationService.YUGROW_SYSTEM_PERSON_ID;
    const workspaceId = CommunicationService.YUGROW_SYSTEM_WORKSPACE_ID;

    // Create or find system person
    const existingPerson = await this.prisma.person.findUnique({ where: { id: personId } });
    if (!existingPerson) {
      await this.prisma.person.create({
        data: {
          id: personId,
          email: CommunicationService.YUGROW_SYSTEM_PERSON_EMAIL,
          firstName: 'Yugrow',
          lastName: '',
          status: 'ACTIVE',
        },
      });
    }

    // Create or find system workspace
    const existingWs = await this.prisma.workspace.findUnique({ where: { id: workspaceId } });
    if (!existingWs) {
      await this.prisma.workspace.create({
        data: {
          id: workspaceId,
          name: 'Yugrow',
          slug: 'yugrow-system',
          type: 'PERSONAL',
        },
      });
    }

    // Ensure membership
    const existingMember = await this.prisma.membership.findFirst({
      where: { personId, workspaceId },
    });
    if (!existingMember) {
      await this.prisma.membership.create({
        data: { personId, workspaceId, membershipType: 'OWNER' },
      });
    }

    // Create relationship type if needed
    const existingType = await this.prisma.relationshipType.findFirst({
      where: { name: CommunicationService.YUGROW_RELATIONSHIP_TYPE },
    });
    if (!existingType) {
      await this.prisma.relationshipType.create({
        data: {
          name: CommunicationService.YUGROW_RELATIONSHIP_TYPE,
          description: 'System',
          isSystem: true,
        },
      });
    }

    return { personId, workspaceId };
  }

  /// Initialize the Yugrow system conversation for a person.
  /// Creates a relationship + conversation if one doesn't already exist.
  async initSystemConversation(personId: string): Promise<{ conversationId: string; isNew: boolean }> {
    await this.ensureSystemPersona();
    const yugrowId = CommunicationService.YUGROW_SYSTEM_PERSON_ID;
    const workspaceId = CommunicationService.YUGROW_SYSTEM_WORKSPACE_ID;

    // Find the system relationship type
    const sysType = await this.prisma.relationshipType.findFirst({
      where: { name: CommunicationService.YUGROW_RELATIONSHIP_TYPE },
    });

    // Check if relationship already exists (in either direction)
    const existingRel = await this.prisma.relationship.findFirst({
      where: {
        OR: [
          { sourceEntityId: personId, targetEntityId: yugrowId },
          { sourceEntityId: yugrowId, targetEntityId: personId },
        ],
      },
    });

    let relationshipId: string;
    let isNew = false;

    if (!existingRel) {
      isNew = true;
      const rel = await this.prisma.relationship.create({
        data: {
          workspaceId: 'personal',
          typeId: sysType?.id ?? '',
          sourceEntityType: 'person',
          sourceEntityId: personId,
          targetEntityType: 'person',
          targetEntityId: yugrowId,
          status: 'CONNECTED',
        },
      });
      relationshipId = rel.id;
    } else {
      relationshipId = existingRel.id;
    }

    // Check if conversation already exists
    const existingConv = await this.prisma.conversation.findFirst({
      where: { relationshipId },
    });
    if (existingConv) {
      return { conversationId: existingConv.id, isNew: false };
    }

    // Create the system conversation
    const conversation = await this.prisma.conversation.create({
      data: {
        relationshipId,
        contextType: 'system',
        contextId: 'yugrow-chat',
      },
    });

    // Send the welcome message
    const welcomeMessage =
      '💚 Welcome to Yugrow\n\n' +
      'This is your private conversation with the Yugrow team.\n\n' +
      'Use this space anytime to:\n\n' +
      '• Report a bug\n' +
      '• Suggest a feature\n' +
      '• Ask a question\n' +
      '• Share screenshots\n' +
      '• Tell us about your experience\n\n' +
      'Every message here is reviewed by our team.\n' +
      'When your feedback leads to an improvement, we\'ll let you know right here.\n\n' +
      'We\'re building Yugrow together.\n\n' +
      '— Team Yugrow';

    await this.prisma.message.create({
      data: {
        conversationId: conversation.id,
        senderPersonId: yugrowId,
        content: welcomeMessage,
      },
    });

    return { conversationId: conversation.id, isNew: true };
  }

  /// Send a proactive message from Yugrow to a professional.
  async sendSystemMessage(
    personId: string,
    content: string,
    type?: string,
  ): Promise<void> {
    const { conversationId } = await this.initSystemConversation(personId);
    await this.prisma.message.create({
      data: {
        conversationId,
        senderPersonId: CommunicationService.YUGROW_SYSTEM_PERSON_ID,
        type: (type?.toUpperCase() as any) ?? 'TEXT',
        content,
      },
    });
  }

  /// Send a release note to a professional.
  async sendReleaseNote(
    personId: string,
    data: { version: string; title: string; changes: string[]; actionLabel?: string },
  ): Promise<void> {
    await this.sendSystemMessage(personId, JSON.stringify(data), 'RELEASE_NOTE');
  }

  /// Send an announcement to a professional.
  async sendAnnouncement(
    personId: string,
    data: { title: string; date?: string; location?: string; description?: string; actionLabel?: string },
  ): Promise<void> {
    await this.sendSystemMessage(personId, JSON.stringify(data), 'ANNOUNCEMENT');
  }

  /// Send a feedback status update to a professional.
  async sendFeedbackStatus(
    personId: string,
    data: { title: string; status: string; statusColor?: string; sprint?: string; note?: string },
  ): Promise<void> {
    await this.sendSystemMessage(personId, JSON.stringify(data), 'FEEDBACK_STATUS');
  }

  /// Send a proactive message from Yugrow to all professionals with system conversations.
  async broadcastSystemMessage(
    content: string,
    type?: string,
  ): Promise<{ sent: number }> {
    // Find all system conversations
    const convs = await this.prisma.conversation.findMany({
      where: { contextType: 'system', contextId: 'yugrow-chat' },
      select: { id: true, relationshipId: true },
    });

    const yugrowId = CommunicationService.YUGROW_SYSTEM_PERSON_ID;

    for (const conv of convs) {
      await this.prisma.message.create({
        data: {
          conversationId: conv.id,
          senderPersonId: yugrowId,
          type: (type?.toUpperCase() as any) ?? 'TEXT',
          content,
        },
      });
    }

    return { sent: convs.length };
  }

  /// Get the Yugrow system conversation for a person (with messages).
  async getSystemConversation(personId: string) {
    const { conversationId } = await this.initSystemConversation(personId);
    const conversation = await this.prisma.conversation.findUnique({
      where: { id: conversationId },
      include: {
        messages: { orderBy: { createdAt: 'asc' } },
      },
    });
    return conversation;
  }
}
