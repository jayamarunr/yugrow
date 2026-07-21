// ─── Yugrow Workspace Engine — Service Layer ───────────────────────
// Manages identity context: Person can switch between multiple workspaces.

import {
  Injectable,
  Inject,
  ConflictException,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaClient, WorkspaceType } from '@prisma/client';
import { PRISMA } from '@database/index';
import { EventBus as EventBusInstance } from '@core/event-bus';

@Injectable()
export class WorkspaceService {
  private readonly eventBus = EventBusInstance;

  constructor(
    @Inject(PRISMA) private readonly prisma: PrismaClient,
  ) {}

  // ─── CRUD ──────────────────────────────────────────────────────

  async create(name: string, slug: string, type: WorkspaceType, ownerId: string) {
    const existing = await this.prisma.workspace.findUnique({ where: { slug } });
    if (existing) throw new ConflictException('Workspace slug already exists');

    const workspace = await this.prisma.workspace.create({
      data: { name, slug, type, status: 'ACTIVE' },
    });

    // Create owner membership
    await this.prisma.membership.create({
      data: {
        personId: ownerId,
        workspaceId: workspace.id,
        membershipType: 'OWNER',
      },
    });

    await this.eventBus.publish('Workspace.Created', {
      workspaceId: workspace.id,
      name,
      type,
      ownerId,
    });

    return workspace;
  }

  async getById(workspaceId: string) {
    const ws = await this.prisma.workspace.findUnique({
      where: { id: workspaceId },
      include: { memberships: { include: { person: true, roles: true } } },
    });
    if (!ws) throw new NotFoundException('Workspace not found');
    return ws;
  }

  async getByPerson(personId: string) {
    const memberships = await this.prisma.membership.findMany({
      where: { personId },
      include: { workspace: true },
    });
    return memberships.map((m) => ({ workspace: m.workspace, membershipType: m.membershipType }));
  }

  async update(workspaceId: string, data: any) {
    const ws = await this.prisma.workspace.update({
      where: { id: workspaceId },
      data,
    });
    await this.eventBus.publish('Workspace.Updated', {
      workspaceId,
      changes: Object.keys(data),
    });
    return ws;
  }

  // ─── Members ───────────────────────────────────────────────────

  async addMember(workspaceId: string, personId: string, membershipType: string) {
    const membership = await this.prisma.membership.create({
      data: {
        personId,
        workspaceId,
        membershipType: membershipType as any,
      },
    });
    await this.eventBus.publish('Workspace.Member.Added', {
      workspaceId,
      personId,
      membershipType,
    });
    return membership;
  }

  async removeMember(workspaceId: string, personId: string) {
    await this.prisma.membership.deleteMany({
      where: { workspaceId, personId },
    });
    await this.eventBus.publish('Workspace.Member.Removed', {
      workspaceId,
      personId,
    });
  }

  // ─── Context Switching ─────────────────────────────────────────

  async switchContext(personId: string, targetWorkspaceId: string) {
    // Verify they're a member
    const membership = await this.prisma.membership.findUnique({
      where: {
        personId_workspaceId: {
          personId,
          workspaceId: targetWorkspaceId,
        },
      },
    });
    if (!membership) throw new BadRequestException('Not a member of this workspace');

    await this.eventBus.publish('Workspace.Switched', {
      personId,
      workspaceId: targetWorkspaceId,
    });

    return { activeWorkspaceId: targetWorkspaceId };
  }

  // ─── Hierarchy ─────────────────────────────────────────────────

  async setParent(childId: string, parentId: string) {
    // TODO: Implement workspace hierarchy (holding company structure)
    throw new Error('Workspace hierarchy coming in Phase 2');
  }
}
