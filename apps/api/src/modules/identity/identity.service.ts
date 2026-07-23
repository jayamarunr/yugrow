// ─── Yugrow Identity Engine — Service Layer ─────────────────────────
// Person identity, authentication, profiles. Does NOT manage workspaces
// or permissions (those belong to Workspace Engine and Permission Engine).

import {
  Injectable,
  Inject,
  UnauthorizedException,
  ConflictException,
  NotFoundException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaClient } from '@prisma/client';
import { PRISMA } from '@database/index';
import { EventBus as EventBusInstance } from '@core/event-bus';

@Injectable()
export class IdentityService {
  private readonly eventBus = EventBusInstance;

  constructor(
    @Inject(PRISMA) private readonly prisma: PrismaClient,
    private readonly config: ConfigService,
  ) {}

  // ─── Authentication ─────────────────────────────────────────────

  async login(email: string, password: string) {
    // TODO: Implement Authentik/OIDC integration
    throw new UnauthorizedException('Not yet implemented');
  }

  async register(email: string, password: string, name: string) {
    const existing = await this.prisma.person.findUnique({
      where: { email },
    });
    if (existing) throw new ConflictException('Email already registered');

    const person = await this.prisma.person.create({
      data: { email, firstName: name, status: 'ACTIVE' },
    });

    // Auto-create personal workspace
    const workspace = await this.prisma.workspace.create({
      data: {
        name: `${name}'s Workspace`,
        slug: `p-${person.id.slice(0, 8)}`,
        type: 'PERSONAL',
      },
    });

    // Create owner membership
    await this.prisma.membership.create({
      data: {
        personId: person.id,
        workspaceId: workspace.id,
        membershipType: 'OWNER',
      },
    });

    await this.eventBus.publish('Identity.Person.Registered', {
      personId: person.id,
      email,
      displayName: name,
      authMethod: 'email',
    });

    return { person, workspace };
  }

  async refreshToken(refreshToken: string) {
    throw new UnauthorizedException('Not yet implemented');
  }

  // ─── Person Management ──────────────────────────────────────────

  async getPerson(personId: string) {
    const person = await this.prisma.person.findUnique({
      where: { id: personId },
      include: {
        memberships: {
          include: { workspace: true, roles: true },
        },
      },
    });
    if (!person) throw new NotFoundException('Person not found');
    return person;
  }

  async updateProfile(personId: string, data: any) {
    const person = await this.prisma.person.update({
      where: { id: personId },
      data,
    });
    await this.eventBus.publish('Identity.Person.Updated', {
      personId,
      changes: Object.keys(data),
    });
    return person;
  }

  async deactivatePerson(personId: string) {
    await this.prisma.person.update({
      where: { id: personId },
      data: { status: 'DISABLED', deletedAt: new Date() },
    });
    await this.eventBus.publish('Identity.Person.Deactivated', { personId });
  }

  // ─── Professional Identity ──────────────────────────────────────

  async getProfessionalIdentity(personId: string, workspaceId: string) {
    let identity = await this.prisma.professionalIdentity.findFirst({
      where: { personId, workspaceId },
    });

    // Auto-create if it doesn't exist
    if (!identity) {
      const person = await this.prisma.person.findUnique({ where: { id: personId } });
      identity = await this.prisma.professionalIdentity.create({
        data: {
          personId,
          workspaceId,
          name: person ? `${person.firstName ?? ''} ${person.lastName ?? ''}`.trim() : 'Unknown',
        },
      });
    }

    return identity;
  }

  async updateProfessionalIdentity(personId: string, workspaceId: string, data: any) {
    const existing = await this.prisma.professionalIdentity.findFirst({
      where: { personId, workspaceId },
    });

    if (!existing) {
      throw new NotFoundException('Professional identity not found. Create it first by calling GET.');
    }

    const updated = await this.prisma.professionalIdentity.update({
      where: { id: existing.id },
      data,
    });

    await this.eventBus.publish('Identity.Professional.Updated', {
      personId,
      workspaceId,
      changes: Object.keys(data),
    });

    return updated;
  }
}
