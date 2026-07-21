// ─── Yugrow Permission Engine — Service Layer ───────────────────────
// 5-layer authorization: Identity > Workspace > Membership > Role > Capability
// Every product asks: "Can this person perform this action in this workspace?"

import { Injectable, Inject, ForbiddenException } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { PRISMA } from '@database/index';

@Injectable()
export class PermissionService {
  constructor(@Inject(PRISMA) private readonly prisma: PrismaClient) {}

  // ─── Check Permission ──────────────────────────────────────────
  // Returns true/false. Does NOT throw — caller decides how to handle denial.

  async can(personId: string, workspaceId: string, capability: string): Promise<boolean> {
    const [product, resource, action] = capability.split('.');
    if (!product || !resource || !action) return false;

    // 1. Verify person is a member of this workspace
    const membership = await this.prisma.membership.findUnique({
      where: {
        personId_workspaceId: { personId, workspaceId },
      },
      include: {
        roles: {
          include: { capabilities: true },
        },
      },
    });
    if (!membership) return false;

    // 2. Check if any of the person's roles grant this capability
    const hasCapability = membership.roles.some((role) =>
      role.capabilities.some(
        (cap) => cap.product === product && cap.resource === resource && cap.action === action,
      ),
    );
    if (hasCapability) return true;

    // 3. Check temporary grants
    const grant = await this.prisma.capabilityGrant.findFirst({
      where: {
        personId,
        workspaceId,
        capabilityId: capability,
        expiresAt: { gte: new Date() },
      },
    });

    return !!grant;
  }

  // ─── Check with Throw ──────────────────────────────────────────
  // Throws ForbiddenException if denied. Convenient for API guards.

  async require(personId: string, workspaceId: string, capability: string): Promise<void> {
    const allowed = await this.can(personId, workspaceId, capability);
    if (!allowed) {
      throw new ForbiddenException(
        `Missing required capability: ${capability}`,
      );
    }
  }

  // ─── Batch Check ───────────────────────────────────────────────
  // Check multiple capabilities at once. Returns a map.

  async canBatch(
    personId: string,
    workspaceId: string,
    capabilities: string[],
  ): Promise<Record<string, boolean>> {
    const results: Record<string, boolean> = {};
    for (const cap of capabilities) {
      results[cap] = await this.can(personId, workspaceId, cap);
    }
    return results;
  }

  // ─── Get All Capabilities for a Person in a Workspace ──────────
  // Used by the frontend to render menus, buttons, and tabs.

  async getCapabilities(personId: string, workspaceId: string): Promise<string[]> {
    const membership = await this.prisma.membership.findUnique({
      where: {
        personId_workspaceId: { personId, workspaceId },
      },
      include: {
        roles: {
          include: { capabilities: true },
        },
      },
    });
    if (!membership) return [];

    const caps = new Set<string>();
    for (const role of membership.roles) {
      for (const cap of role.capabilities) {
        caps.add(`${cap.product}.${cap.resource}.${cap.action}`);
      }
    }
    return Array.from(caps);
  }

  // ─── Manage Capabilities ───────────────────────────────────────

  async defineCapability(product: string, resource: string, action: string) {
    return this.prisma.capability.upsert({
      where: {
        product_resource_action: { product, resource, action },
      },
      update: {},
      create: { product, resource, action },
    });
  }

  // ─── Temporary Grants ──────────────────────────────────────────

  async grantTemporary(
    personId: string,
    workspaceId: string,
    capability: string,
    grantedBy: string,
    expiresAt: Date,
    reason?: string,
  ) {
    return this.prisma.capabilityGrant.create({
      data: {
        personId,
        workspaceId,
        capabilityId: capability,
        grantedBy,
        expiresAt,
        reason,
      },
    });
  }

  async revokeGrant(grantId: string) {
    return this.prisma.capabilityGrant.delete({
      where: { id: grantId },
    });
  }
}
