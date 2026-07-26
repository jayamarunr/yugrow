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
import { JwtService } from '@nestjs/jwt';
import { PrismaClient } from '@prisma/client';
import { PRISMA } from '@database/index';
import { EventBus as EventBusInstance } from '@core/event-bus';

@Injectable()
export class IdentityService {
  private readonly eventBus = EventBusInstance;

  constructor(
    @Inject(PRISMA) private readonly prisma: PrismaClient,
    private readonly config: ConfigService,
    private readonly jwtService: JwtService,
  ) {}

  // ─── JWT Token Generation ─────────────────────────────────────

  async generateToken(personId: string, email: string, workspaceId: string): Promise<string> {
    return this.jwtService.signAsync({
      sub: personId,
      email,
      workspaceId,
    });
  }

  // ─── Authentication ─────────────────────────────────────────────

  async login(email: string, password: string) {
    // Find person by email
    const person = await this.prisma.person.findUnique({ where: { email } });
    if (!person || person.status !== 'ACTIVE') {
      throw new UnauthorizedException('Invalid credentials');
    }

    // TODO: Implement password verification via Authentik/OIDC
    // For now, accept any password for existing accounts in development
    if (this.config.get<string>('NODE_ENV') !== 'development') {
      throw new UnauthorizedException('Password verification not yet implemented');
    }

    // Find the person's primary workspace
    const membership = await this.prisma.membership.findFirst({
      where: { personId: person.id },
      include: { workspace: true },
    });
    const workspaceId = membership?.workspaceId ?? 'personal';

    const token = await this.generateToken(person.id, person.email, workspaceId);

    return {
      token,
      person: {
        id: person.id,
        email: person.email,
        name: person.firstName ?? person.email,
      },
      workspace: {
        id: workspaceId,
        name: membership?.workspace?.name ?? 'Personal',
      },
    };
  }

  async register(email: string, password: string, name: string) {
    const existing = await this.prisma.person.findUnique({
      where: { email },
    });
    if (existing) {
      throw new ConflictException({
        code: 'EMAIL_ALREADY_EXISTS',
        message: 'An account already exists with this email. Please sign in instead.',
      });
    }

    // Use a transaction to ensure all-or-nothing creation
    const result = await this.prisma.$transaction(async (tx) => {
      const person = await tx.person.create({
        data: { email, firstName: name, status: 'ACTIVE' },
      });

      // Auto-create personal workspace
      const workspace = await tx.workspace.create({
        data: {
          name: `${name}'s Workspace`,
          slug: `p-${person.id.slice(0, 8)}`,
          type: 'PERSONAL',
        },
      });

      // Create owner membership
      await tx.membership.create({
        data: {
          personId: person.id,
          workspaceId: workspace.id,
          membershipType: 'OWNER',
        },
      });

      return { person, workspace };
    });

    const token = await this.generateToken(
      result.person.id,
      email,
      result.workspace.id,
    );

    await this.eventBus.publish('Identity.Person.Registered', {
      personId: result.person.id,
      email,
      displayName: name,
      authMethod: 'email',
    });

    return {
      token,
      person: {
        id: result.person.id,
        email: result.person.email,
        name: result.person.firstName ?? result.person.email,
      },
      workspace: {
        id: result.workspace.id,
        name: result.workspace.name,
      },
    };
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
