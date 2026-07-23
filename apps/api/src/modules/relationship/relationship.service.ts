// ─── Yugrow Relationship Engine — Service Layer ─────────────────────
// Generic relationships between any entity types (Person, Workspace, Company, Event).
// Supports configurable types, lifecycle states, strength scoring, business cards.

import { Injectable, Inject, NotFoundException, ConflictException } from '@nestjs/common';
import { PrismaClient, RelationshipStatus, Prisma } from '@prisma/client';
import { PRISMA } from '@database/index';
import { EventBus as EventBusInstance } from '@core/event-bus';
import { RelationshipEvents } from './events/relationship.events';

@Injectable()
export class RelationshipService {
  private readonly eventBus = EventBusInstance;

  constructor(
    @Inject(PRISMA) private readonly prisma: PrismaClient,
  ) {}

  // ─── Relationship Types ────────────────────────────────────────

  async createType(name: string, category?: string, description?: string, workspaceId?: string) {
    const type = await this.prisma.relationshipType.create({
      data: { workspaceId, name, category, description, isSystem: !workspaceId },
    });
    return type;
  }

  async listTypes(workspaceId?: string) {
    return this.prisma.relationshipType.findMany({
      where: {
        OR: [
          { isSystem: true },
          { workspaceId },
        ].filter(Boolean) as any,
      },
    });
  }

  async seedDefaultTypes() {
    const defaults = [
      { name: 'Connected', category: 'Professional', isSystem: true },
      { name: 'Following', category: 'Professional', isSystem: true },
      { name: 'Customer', category: 'Professional', isSystem: true },
      { name: 'Supplier', category: 'Professional', isSystem: true },
      { name: 'Partner', category: 'Professional', isSystem: true },
      { name: 'Investor', category: 'Professional', isSystem: true },
      { name: 'Mentor', category: 'Professional', isSystem: true },
      { name: 'Employee', category: 'Professional', isSystem: true },
      { name: 'Recruiter', category: 'Professional', isSystem: true },
      { name: 'Agency', category: 'Professional', isSystem: true },
      { name: 'Vendor', category: 'Professional', isSystem: true },
      { name: 'Alumni', category: 'Community', isSystem: true },
      { name: 'Friend', category: 'Personal', isSystem: true },
      { name: 'Met at Event', category: 'Professional', isSystem: true },
    ];

    for (const t of defaults) {
      await this.prisma.relationshipType.upsert({
        where: { workspaceId_name: { workspaceId: null as any, name: t.name } },
        update: {},
        create: { ...t, workspaceId: null },
      });
    }
  }

  // ─── Core CRUD ─────────────────────────────────────────────────

  async create(data: {
    workspaceId: string;
    typeId: string;
    sourceEntityType: string;
    sourceEntityId: string;
    targetEntityType: string;
    targetEntityId: string;
    source?: string;
    sourceDetail?: string;
  }) {
    const rel = await this.prisma.relationship.create({
      data: {
        workspaceId: data.workspaceId,
        typeId: data.typeId,
        sourceEntityType: data.sourceEntityType,
        sourceEntityId: data.sourceEntityId,
        targetEntityType: data.targetEntityType,
        targetEntityId: data.targetEntityId,
        status: 'CONNECTED',
      },
    });

    // Add context if provided
    if (data.source) {
      await this.prisma.relationshipContext.create({
        data: {
          relationshipId: rel.id,
          source: data.source,
          sourceDetail: data.sourceDetail,
          tags: [],
        },
      });
    }

    await this.eventBus.publish(RelationshipEvents.Connected, {
      relationshipId: rel.id,
      sourceEntityType: data.sourceEntityType,
      sourceEntityId: data.sourceEntityId,
      targetEntityType: data.targetEntityType,
      targetEntityId: data.targetEntityId,
    });

    return rel;
  }

  async getById(id: string) {
    const rel = await this.prisma.relationship.findUnique({
      where: { id },
      include: { type: true, contexts: true },
    });
    if (!rel) throw new NotFoundException('Relationship not found');
    return rel;
  }

  async list(filters: {
    workspaceId: string;
    entityType?: string;
    entityId?: string;
    status?: RelationshipStatus;
    typeId?: string;
    page?: number;
    limit?: number;
  }) {
    const where: any = { workspaceId: filters.workspaceId };

    if (filters.entityType && filters.entityId) {
      where.OR = [
        { sourceEntityType: filters.entityType, sourceEntityId: filters.entityId },
        { targetEntityType: filters.entityType, targetEntityId: filters.entityId },
      ];
    }
    if (filters.status) where.status = filters.status;
    if (filters.typeId) where.typeId = filters.typeId;

    const page = filters.page || 1;
    const limit = filters.limit || 20;
    const skip = (page - 1) * limit;

    const [items, total] = await Promise.all([
      this.prisma.relationship.findMany({
        where,
        include: { type: true, contexts: true },
        orderBy: { strength: 'desc' },
        skip,
        take: limit,
      }),
      this.prisma.relationship.count({ where }),
    ]);

    return { items, total, page, limit };
  }

  async update(id: string, data: { status?: RelationshipStatus; strength?: number; sourceNotes?: string }) {
    const rel = await this.prisma.relationship.update({
      where: { id },
      data,
    });
    await this.eventBus.publish(RelationshipEvents.Updated, {
      relationshipId: id,
      changes: Object.keys(data),
    });
    return rel;
  }

  async delete(id: string) {
    await this.prisma.relationship.update({
      where: { id },
      data: { deletedAt: new Date(), status: 'ARCHIVED' },
    });
    await this.eventBus.publish(RelationshipEvents.Disconnected, { relationshipId: id });
  }

  // ─── Connection Requests ───────────────────────────────────────

  async sendRequest(data: {
    workspaceId: string;
    senderPersonId: string;
    recipientPersonId: string;
    message?: string;
    relationshipTypeId?: string;
  }) {
    const req = await this.prisma.connectionRequest.create({
      data: {
        workspaceId: data.workspaceId,
        senderPersonId: data.senderPersonId,
        recipientPersonId: data.recipientPersonId,
        message: data.message,
        relationshipTypeId: data.relationshipTypeId,
        expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days
      },
    });

    await this.eventBus.publish(RelationshipEvents.RequestSent, {
      requestId: req.id,
      senderId: data.senderPersonId,
      recipientId: data.recipientPersonId,
    });

    return req;
  }

  async respondToRequest(requestId: string, accept: boolean) {
    const req = await this.prisma.connectionRequest.findUnique({
      where: { id: requestId },
    });
    if (!req || req.status !== 'PENDING') {
      throw new NotFoundException('Request not found or already processed');
    }

    if (accept) {
      // Create the relationship
      await this.create({
        workspaceId: req.workspaceId,
        typeId: req.relationshipTypeId || (await this.getDefaultTypeId()),
        sourceEntityType: 'Person',
        sourceEntityId: req.senderPersonId,
        targetEntityType: 'Person',
        targetEntityId: req.recipientPersonId,
        source: 'invite',
      });

      await this.prisma.connectionRequest.update({
        where: { id: requestId },
        data: { status: 'ACCEPTED' },
      });

      await this.eventBus.publish(RelationshipEvents.RequestAccepted, {
        requestId,
        senderId: req.senderPersonId,
        recipientId: req.recipientPersonId,
      });
    } else {
      await this.prisma.connectionRequest.update({
        where: { id: requestId },
        data: { status: 'DECLINED' },
      });

      await this.eventBus.publish(RelationshipEvents.RequestDeclined, {
        requestId,
      });
    }
  }

  private async getDefaultTypeId(): Promise<string> {
    const type = await this.prisma.relationshipType.findFirst({
      where: { name: 'Connected', isSystem: true },
    });
    return type!.id;
  }

  // ─── Professional Identity & Business Cards ────────────────────

  async createCard(data: {
    workspaceId: string;
    personId: string;
    name: string;
    title?: string;
    company?: string;
    phone?: string;
    email?: string;
  }) {
    return this.prisma.professionalIdentity.create({ data });
  }

  async listCards(personId: string) {
    return this.prisma.professionalIdentity.findMany({
      where: { personId, deletedAt: null },
    });
  }

  async shareCard(cardId: string, recipientId: string, relationshipId?: string) {
    return this.prisma.businessCardCollection.create({
      data: {
        collectorId: recipientId,
        cardId,
        relationshipId,
      },
    });
  }

  // ─── Network ───────────────────────────────────────────────────

  async getMutualConnections(personId: string, targetPersonId: string) {
    // Find Person IDs that are connected to BOTH personId and targetPersonId
    const myRels = await this.prisma.relationship.findMany({
      where: {
        status: 'CONNECTED',
        OR: [
          { sourceEntityType: 'Person', sourceEntityId: personId },
          { targetEntityType: 'Person', targetEntityId: personId },
        ],
      },
      select: {
        sourceEntityId: true,
        targetEntityId: true,
      },
    });

    const myConnections = new Set<string>();
    for (const r of myRels) {
      if (r.sourceEntityId === personId) myConnections.add(r.targetEntityId);
      if (r.targetEntityId === personId) myConnections.add(r.sourceEntityId);
    }

    const targetRels = await this.prisma.relationship.findMany({
      where: {
        status: 'CONNECTED',
        OR: [
          { sourceEntityType: 'Person', sourceEntityId: targetPersonId },
          { targetEntityType: 'Person', targetEntityId: targetPersonId },
        ],
      },
      select: {
        sourceEntityId: true,
        targetEntityId: true,
      },
    });

    const targetConnections = new Set<string>();
    for (const r of targetRels) {
      if (r.sourceEntityId === targetPersonId) targetConnections.add(r.targetEntityId);
      if (r.targetEntityId === targetPersonId) targetConnections.add(r.sourceEntityId);
    }

    // Intersection
    const mutual = [...myConnections].filter((id) => targetConnections.has(id));
    return { mutual, count: mutual.length };
  }

  async getStats(personId: string) {
    const total = await this.prisma.relationship.count({
      where: {
        status: 'CONNECTED',
        OR: [
          { sourceEntityType: 'Person', sourceEntityId: personId },
          { targetEntityType: 'Person', targetEntityId: personId },
        ],
      },
    });

    const byType = await this.prisma.relationship.groupBy({
      by: ['typeId'],
      where: {
        status: 'CONNECTED',
        OR: [
          { sourceEntityType: 'Person', sourceEntityId: personId },
          { targetEntityType: 'Person', targetEntityId: personId },
        ],
      },
      _count: true,
    });

    return { total, byType };
  }

  // ─── Connection Strength ───────────────────────────────────────
  // Math-based scoring from multiple signals.

  async addStrengthSignal(data: {
    relationshipId: string;
    signalType: string;
    weight: number;
    source: string;
    sourceId?: string;
  }) {
    return this.prisma.relationshipStrengthSignal.create({
      data: {
        relationshipId: data.relationshipId,
        signalType: data.signalType,
        weight: data.weight,
        source: data.source,
        sourceId: data.sourceId,
        timestamp: new Date(),
      },
    });
  }

  async recalculateStrength(relationshipId: string): Promise<number> {
    const signals = await this.prisma.relationshipStrengthSignal.findMany({
      where: { relationshipId },
    });

    if (signals.length === 0) return 0.5; // default neutral

    // Weighted average with recency bonus
    const now = Date.now();
    let totalWeight = 0;
    let weightedSum = 0;

    for (const s of signals) {
      const daysSince = (now - s.timestamp.getTime()) / (1000 * 60 * 60 * 24);
      const recencyFactor = Math.max(0.3, 1 - daysSince * 0.01); // decays over time
      const effectiveWeight = s.weight * recencyFactor;
      totalWeight += effectiveWeight;
      weightedSum += effectiveWeight * s.weight;
    }

    const strength = totalWeight > 0 ? Math.min(1, weightedSum / totalWeight) : 0.5;

    await this.prisma.relationship.update({
      where: { id: relationshipId },
      data: { strength },
    });

    return strength;
  }

  // ─── Timeline ──────────────────────────────────────────────────

  async addTimelineEvent(data: {
    relationshipId: string;
    eventType: string;
    title: string;
    description?: string;
    sourceEngine: string;
    sourceId?: string;
    metadata?: Record<string, any>;
  }) {
    return this.prisma.relationshipTimeline.create({
      data: {
        relationshipId: data.relationshipId,
        eventType: data.eventType,
        title: data.title,
        description: data.description,
        sourceEngine: data.sourceEngine,
        sourceId: data.sourceId,
        metadata: data.metadata ?? {},
        occurredAt: new Date(),
      },
    });
  }

  async getTimeline(relationshipId: string) {
    return this.prisma.relationshipTimeline.findMany({
      where: { relationshipId },
      orderBy: { occurredAt: 'desc' },
    });
  }

  // ─── Professional Identity ─────────────────────────────────────

  async upsertIdentity(data: {
    workspaceId: string;
    personId: string;
    name: string;
    title?: string;
    company?: string;
    phone?: string;
    email?: string;
    skills?: string[];
    services?: string[];
    availability?: string;
  }) {
    return this.prisma.professionalIdentity.upsert({
      where: { personId: data.personId },
      update: data,
      create: data,
    });
  }

  async getIdentity(personId: string) {
    return this.prisma.professionalIdentity.findUnique({
      where: { personId },
    });
  }
}
