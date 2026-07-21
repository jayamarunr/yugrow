// ─── Yugrow Audit Engine — Service Layer ────────────────────────────
// Immutable audit log. Append-only. Every mutation is recorded.

import { Injectable, Inject } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { PRISMA } from '@database/index';

export interface AuditEntry {
  workspaceId: string;
  personId?: string;
  action: string;
  resource: string;
  resourceId?: string;
  details?: Record<string, any>;
  ipAddress?: string;
  userAgent?: string;
  actorContext?: Record<string, any>;
}

@Injectable()
export class AuditService {
  constructor(@Inject(PRISMA) private readonly prisma: PrismaClient) {}

  async record(entry: AuditEntry): Promise<void> {
    await this.prisma.auditLog.create({
      data: {
        workspaceId: entry.workspaceId,
        personId: entry.personId,
        action: entry.action,
        resource: entry.resource,
        resourceId: entry.resourceId,
        details: entry.details ?? {},
        ipAddress: entry.ipAddress,
        userAgent: entry.userAgent,
        actorContext: entry.actorContext ?? {},
      },
    });
  }

  async query(workspaceId: string, options?: {
    action?: string;
    resource?: string;
    personId?: string;
    limit?: number;
    offset?: number;
    from?: Date;
    to?: Date;
  }) {
    const where: any = { workspaceId };

    if (options?.action) where.action = options.action;
    if (options?.resource) where.resource = options.resource;
    if (options?.personId) where.personId = options.personId;
    if (options?.from || options?.to) {
      where.createdAt = {};
      if (options.from) where.createdAt.gte = options.from;
      if (options.to) where.createdAt.lte = options.to;
    }

    const [items, total] = await Promise.all([
      this.prisma.auditLog.findMany({
        where,
        orderBy: { createdAt: 'desc' },
        take: options?.limit ?? 50,
        skip: options?.offset ?? 0,
      }),
      this.prisma.auditLog.count({ where }),
    ]);

    return { items, total, limit: options?.limit ?? 50, offset: options?.offset ?? 0 };
  }

  async getByResource(workspaceId: string, resource: string, resourceId: string) {
    return this.prisma.auditLog.findMany({
      where: { workspaceId, resource, resourceId },
      orderBy: { createdAt: 'desc' },
    });
  }
}
