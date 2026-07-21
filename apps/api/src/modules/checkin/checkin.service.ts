// ─── CheckIN MVP Service ──────────────────────────────────────────
// Venue, Event, Presence, Live Discovery, Connection Flow.
// The first Yugrow customer-facing product.

// Product analytics events — tracked for the Meaningful Connections funnel
const ANALYTICS_EVENTS = {
  LIVE_VIEWED: 'checkin.live_viewed',
  PROFILE_VIEWED: 'connection.profile_viewed',
  REQUEST_SENT: 'connection.request_sent',
  REQUEST_ACCEPTED: 'connection.accepted',
  CONVERSATION_STARTED: 'conversation.started',
};

function track(event: string, data: Record<string, any>): void {
  // TODO: Integrate with analytics service / Event Bus
  // For MVP, log to console. Replace with proper event emission.
  if (process.env.NODE_ENV === 'development') {
    console.log(`[Analytics] ${event}`, JSON.stringify(data));
  }
}

import { Injectable, Inject, ConflictException, NotFoundException } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { PRISMA } from '@database/index';
import { CommunicationService } from '../communication/communication.service';

@Injectable()
export class CheckinService {
  constructor(
    @Inject(PRISMA) private readonly prisma: PrismaClient,
    private readonly communicationService: CommunicationService,
  ) {}

  // ═════════════════════════════════════════════════════════════════
  // VENUE
  // ═════════════════════════════════════════════════════════════════

  async searchVenues(query: string) {
    return this.prisma.venue.findMany({
      where: {
        OR: [
          { name: { contains: query, mode: 'insensitive' } },
          { city: { contains: query, mode: 'insensitive' } },
          { address: { contains: query, mode: 'insensitive' } },
        ],
      },
      take: 20,
      orderBy: { name: 'asc' },
    });
  }

  async createVenue(data: {
    name: string;
    address?: string;
    latitude?: number;
    longitude?: number;
    city?: string;
    state?: string;
    country?: string;
    createdByPersonId: string;
    ownerWorkspaceId: string;
  }) {
    // Prevent duplicates: check by name + city
    const existing = await this.prisma.venue.findFirst({
      where: {
        name: { equals: data.name, mode: 'insensitive' },
        city: data.city ?? undefined,
      },
    });
    if (existing) {
      throw new ConflictException(`Venue '${data.name}' already exists. Use the existing venue or choose a different name.`);
    }

    return this.prisma.venue.create({ data });
  }

  async getVenue(id: string) {
    const venue = await this.prisma.venue.findUnique({
      where: { id },
      include: { events: { where: { status: 'ACTIVE' }, take: 10 } },
    });
    if (!venue) throw new NotFoundException('Venue not found.');
    return venue;
  }

  // ═════════════════════════════════════════════════════════════════
  // EVENT
  // ═════════════════════════════════════════════════════════════════

  async createEvent(data: {
    name: string;
    venueId: string;
    organizerWorkspaceId: string;
    startDate: string;
    endDate: string;
  }) {
    const venue = await this.prisma.venue.findUnique({ where: { id: data.venueId } });
    if (!venue) throw new NotFoundException('Venue not found.');

    return this.prisma.event.create({
      data: {
        name: data.name,
        venueId: data.venueId,
        organizerWorkspaceId: data.organizerWorkspaceId,
        startDate: new Date(data.startDate),
        endDate: new Date(data.endDate),
        status: 'ACTIVE',
      },
      include: { venue: true },
    });
  }

  async getEvent(id: string) {
    const event = await this.prisma.event.findUnique({
      where: { id },
      include: { venue: true },
    });
    if (!event) throw new NotFoundException('Event not found.');
    return event;
  }

  async listActiveEvents(workspaceId?: string) {
    const now = new Date();
    return this.prisma.event.findMany({
      where: {
        status: 'ACTIVE',
        endDate: { gte: now },
        ...(workspaceId ? { organizerWorkspaceId: workspaceId } : {}),
      },
      include: { venue: true },
      orderBy: { startDate: 'asc' },
      take: 50,
    });
  }

  async expirePastEvents() {
    const now = new Date();
    return this.prisma.event.updateMany({
      where: { endDate: { lt: now }, status: 'ACTIVE' },
      data: { status: 'EXPIRED' },
    });
  }

  // ═════════════════════════════════════════════════════════════════
  // PRESENCE
  // ═════════════════════════════════════════════════════════════════

  async checkIn(data: {
    personId: string;
    workspaceId: string;
    eventId: string;
    venueId: string;
    expiresAt?: string;
  }) {
    // Verify event exists and is active
    const event = await this.prisma.event.findUnique({ where: { id: data.eventId } });
    if (!event) throw new NotFoundException('Event not found.');
    if (event.status !== 'ACTIVE') throw new ConflictException('Event is not active.');

    // End any existing active presence for this person
    await this.prisma.presence.updateMany({
      where: { personId: data.personId, status: 'ACTIVE' },
      data: { status: 'EXPIRED' },
    });

    const expiresAt = data.expiresAt
      ? new Date(data.expiresAt)
      : new Date(Date.now() + 4 * 60 * 60 * 1000); // default: 4 hours

    const presence = await this.prisma.presence.create({
      data: {
        personId: data.personId,
        workspaceId: data.workspaceId,
        eventId: data.eventId,
        venueId: data.venueId,
        expiresAt,
        status: 'ACTIVE',
      },
      include: {
        event: { include: { venue: true } },
      },
    });

    return presence;
  }

  async expirePresence(presenceId: string) {
    const presence = await this.prisma.presence.findUnique({ where: { id: presenceId } });
    if (!presence) throw new NotFoundException('Presence not found.');

    return this.prisma.presence.update({
      where: { id: presenceId },
      data: { status: 'EXPIRED' },
    });
  }

  async expireStalePresences() {
    const now = new Date();
    return this.prisma.presence.updateMany({
      where: { expiresAt: { lt: now }, status: 'ACTIVE' },
      data: { status: 'EXPIRED' },
    });
  }

  // ═════════════════════════════════════════════════════════════════
  // LIVE DISCOVERY
  // ═════════════════════════════════════════════════════════════════

  async getLiveAttendees(eventId: string, viewerPersonId?: string) {
    track(ANALYTICS_EVENTS.LIVE_VIEWED, { eventId, viewerPersonId, timestamp: new Date().toISOString() });
    const activePresences = await this.prisma.presence.findMany({
      where: {
        eventId,
        status: 'ACTIVE',
        expiresAt: { gte: new Date() },
      },
      include: {
        event: { include: { venue: true } },
      },
      orderBy: { startedAt: 'desc' },
    });

    // For each presence, gather person info and mutual connections
    const attendees = await Promise.all(
      activePresences.map(async (presence) => {
        const person = await this.prisma.person.findUnique({
          where: { id: presence.personId },
          select: { id: true, firstName: true, lastName: true, email: true },
        });

        // Count mutual connections if viewer is present
        let mutualCount = 0;
        if (viewerPersonId && presence.personId !== viewerPersonId) {
          mutualCount = await this.countMutualConnections(viewerPersonId, presence.personId);
        }

        return {
          personId: presence.personId,
          name: person ? `${person.firstName ?? ''} ${person.lastName ?? ''}`.trim() : 'Unknown',
          workspaceId: presence.workspaceId,
          checkedInAt: presence.startedAt,
          expiresAt: presence.expiresAt,
          mutualConnections: mutualCount,
          eventName: presence.event.name,
          venueName: presence.event.venue.name,
        };
      }),
    );

    // Sort: mutual connections first, then by check-in time
    attendees.sort((a, b) => {
      if (b.mutualConnections !== a.mutualConnections) {
        return b.mutualConnections - a.mutualConnections;
      }
      return b.checkedInAt.getTime() - a.checkedInAt.getTime();
    });

    return attendees;
  }

  private async countMutualConnections(personA: string, personB: string): Promise<number> {
    // Count relationships where both people are connected to the same third person
    const relationships = await this.prisma.relationship.findMany({
      where: {
        OR: [
          { sourceEntityType: 'person', sourceEntityId: personA },
          { targetEntityType: 'person', targetEntityId: personA },
        ],
        status: 'CONNECTED',
      },
      select: {
        sourceEntityId: true,
        targetEntityId: true,
      },
    });

    const aConnections = new Set<string>();
    for (const rel of relationships) {
      if (rel.sourceEntityId === personA) aConnections.add(rel.targetEntityId);
      if (rel.targetEntityId === personA) aConnections.add(rel.sourceEntityId);
    }

    const bRelationships = await this.prisma.relationship.findMany({
      where: {
        OR: [
          { sourceEntityType: 'person', sourceEntityId: personB },
          { targetEntityType: 'person', targetEntityId: personB },
        ],
        status: 'CONNECTED',
      },
      select: {
        sourceEntityId: true,
        targetEntityId: true,
      },
    });

    let mutual = 0;
    for (const rel of bRelationships) {
      const bConn = rel.sourceEntityId === personB ? rel.targetEntityId : rel.sourceEntityId;
      if (aConnections.has(bConn)) mutual++;
    }

    return mutual;
  }

  // ═════════════════════════════════════════════════════════════════
  // CONNECTION FLOW
  // ═════════════════════════════════════════════════════════════════

  async sendConnectionRequest(data: {
    fromPersonId: string;
    toPersonId: string;
    workspaceId: string;
    eventId: string;
    venueId: string;
    presenceId?: string;
  }) {
    // Check for existing pending request
    const existing = await this.prisma.connectionRequest.findFirst({
      where: {
        senderPersonId: data.fromPersonId,
        recipientPersonId: data.toPersonId,
        status: 'PENDING',
      },
    });
    if (existing) throw new ConflictException('Connection request already sent.');

    // Store event context in message field as JSON
    const eventContext = JSON.stringify({
      eventId: data.eventId,
      venueId: data.venueId,
      timestamp: new Date().toISOString(),
      presenceId: data.presenceId,
    });

    track(ANALYTICS_EVENTS.REQUEST_SENT, { fromPersonId: data.fromPersonId, toPersonId: data.toPersonId, eventId: data.eventId, timestamp: new Date().toISOString() });

    // Look up a default relationship type for networking
    const defaultType = await this.prisma.relationshipType.findFirst({
      where: { isSystem: true, name: 'Network' },
    });

    const request = await this.prisma.connectionRequest.create({
      data: {
        workspaceId: data.workspaceId,
        senderPersonId: data.fromPersonId,
        recipientPersonId: data.toPersonId,
        message: eventContext,
        status: 'PENDING',
        relationshipTypeId: defaultType?.id ?? null,
        expiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000), // 24-hour window
      },
    });

    return request;
  }

  async acceptConnectionRequest(requestId: string, accepterPersonId: string) {
    const request = await this.prisma.connectionRequest.findUnique({
      where: { id: requestId },
    });
    if (!request) throw new NotFoundException('Connection request not found.');
    if (request.recipientPersonId !== accepterPersonId) {
      throw new ConflictException('You can only accept requests sent to you.');
    }
    if (request.status !== 'PENDING') {
      throw new ConflictException('Request is no longer pending.');
    }

    // Parse event context from message
    let eventContext: Record<string, any> = {};
    try {
      eventContext = JSON.parse(request.message ?? '{}');
    } catch {}

    // Look up a default relationship type
    const defaultType = await this.prisma.relationshipType.findFirst({
      where: { isSystem: true, name: 'Network' },
    });
    const typeId = defaultType?.id ?? request.relationshipTypeId;

    track(ANALYTICS_EVENTS.REQUEST_ACCEPTED, { requestId, accepterPersonId, senderPersonId: request.senderPersonId, timestamp: new Date().toISOString() });

    // Create the relationship with origin preserved
    const relationship = await this.prisma.relationship.create({
      data: {
        workspaceId: request.workspaceId,
        typeId: typeId!,
        sourceEntityType: 'person',
        sourceEntityId: request.senderPersonId,
        targetEntityType: 'person',
        targetEntityId: request.recipientPersonId,
        status: 'CONNECTED',
        strength: 0.5,
        contexts: {
          create: {
            source: 'checkin',
            sourceDetail: `Event: ${eventContext.eventId ?? 'unknown'}, Venue: ${eventContext.venueId ?? 'unknown'}`,
            firstMetAt: eventContext.timestamp ? new Date(eventContext.timestamp) : new Date(),
            tags: ['checkin', 'event-networking'],
            notes: `Connected via CheckIN at event ${eventContext.eventId}`,
          },
        },
      },
    });

    // Update request status
    await this.prisma.connectionRequest.update({
      where: { id: requestId },
      data: { status: 'ACCEPTED' },
    });

    // Auto-create conversation for the new relationship
    const conversation = await this.communicationService.createConversation(
      relationship.id,
      {
        contextType: 'event',
        contextId: eventContext.eventId,
      },
    );

    track(ANALYTICS_EVENTS.CONVERSATION_STARTED, {
      relationshipId: relationship.id,
      conversationId: conversation.id,
      eventId: eventContext.eventId,
    });

    return { relationship, conversation, requestId };
  }

  async declineConnectionRequest(requestId: string, declinerPersonId: string) {
    const request = await this.prisma.connectionRequest.findUnique({
      where: { id: requestId },
    });
    if (!request) throw new NotFoundException('Connection request not found.');
    if (request.recipientPersonId !== declinerPersonId) {
      throw new ConflictException('You can only decline requests sent to you.');
    }

    return this.prisma.connectionRequest.update({
      where: { id: requestId },
      data: { status: 'DECLINED' },
    });
  }

  async getIncomingRequests(personId: string) {
    return this.prisma.connectionRequest.findMany({
      where: { recipientPersonId: personId, status: 'PENDING' },
      orderBy: { createdAt: 'desc' },
    });
  }

  async getOutgoingRequests(personId: string) {
    return this.prisma.connectionRequest.findMany({
      where: { senderPersonId: personId },
      orderBy: { createdAt: 'desc' },
    });
  }
}
