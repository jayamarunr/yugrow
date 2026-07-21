// ─── Product Registration Service ───────────────────────────────────
// Manages the lifecycle of all Yugrow products. Products register
// themselves with capabilities, routes, navigation items, and feature
// flags. The Permission Engine and Workspace Engine reference this
// service to determine what's available in the current context.

import { Injectable, Inject, ConflictException, NotFoundException } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { PRISMA } from '@database/index';

@Injectable()
export class ProductService {
  constructor(@Inject(PRISMA) private readonly prisma: PrismaClient) {}

  // ── Registration ──────────────────────────────────────────────────

  async register(data: {
    id: string;
    name: string;
    description?: string;
    version?: string;
    icon?: string;
    owningEngine?: string;
    capabilities?: { capability: string; description?: string }[];
    routes?: { path: string; method?: string; description?: string; authRequired?: boolean }[];
    navItems?: { label: string; href: string; icon?: string; parentId?: string; order?: number }[];
    featureFlags?: { key: string; description?: string; defaultValue?: boolean }[];
    planAssignments?: { plan: string; enabled?: boolean }[];
  }) {
    const existing = await this.prisma.product.findUnique({ where: { id: data.id } });
    if (existing) {
      throw new ConflictException(`Product '${data.id}' is already registered.`);
    }

    return this.prisma.product.create({
      data: {
        id: data.id,
        name: data.name,
        description: data.description,
        version: data.version ?? '1.0.0',
        icon: data.icon,
        owningEngine: data.owningEngine,
        status: 'DEVELOPMENT',
        ownerWorkspaceId: (data as any).ownerWorkspaceId ?? null,
        visibility: (data as any).visibility ?? 'PUBLIC',
        discoverable: (data as any).discoverable ?? true,
        promotable: (data as any).promotable ?? false,
        capabilities: data.capabilities?.length
          ? { create: data.capabilities }
          : undefined,
        routes: data.routes?.length
          ? { create: data.routes.map((r) => ({ ...r, method: r.method ?? 'GET' })) }
          : undefined,
        navItems: data.navItems?.length
          ? { create: data.navItems.map((n) => ({ ...n, order: n.order ?? 0 })) }
          : undefined,
        featureFlags: data.featureFlags?.length
          ? { create: data.featureFlags }
          : undefined,
        assignments: data.planAssignments?.length
          ? { create: data.planAssignments.map((a) => ({ plan: a.plan, enabled: a.enabled ?? true })) }
          : undefined,
      },
      include: {
        capabilities: true,
        routes: true,
        navItems: true,
        featureFlags: true,
        assignments: true,
      },
    });
  }

  // ── Lookup ────────────────────────────────────────────────────────

  async getProduct(id: string) {
    const product = await this.prisma.product.findUnique({
      where: { id },
      include: {
        capabilities: true,
        routes: true,
        navItems: { orderBy: { order: 'asc' } },
        featureFlags: true,
        assignments: true,
      },
    });
    if (!product) throw new NotFoundException(`Product '${id}' not found.`);
    return product;
  }

  async listProducts(status?: string) {
    const where = status ? { status: status as any } : {};
    return this.prisma.product.findMany({
      where,
      include: {
        capabilities: true,
        navItems: { orderBy: { order: 'asc' } },
        assignments: true,
      },
      orderBy: { createdAt: 'asc' },
    });
  }

  // ── Status Management ─────────────────────────────────────────────

  async setStatus(id: string, status: 'DEVELOPMENT' | 'BETA' | 'ACTIVE' | 'DEPRECATED') {
    const product = await this.prisma.product.findUnique({ where: { id } });
    if (!product) throw new NotFoundException(`Product '${id}' not found.`);

    return this.prisma.product.update({
      where: { id },
      data: { status },
      include: { capabilities: true, navItems: true, featureFlags: true, assignments: true },
    });
  }

  // ── Feature Flags ─────────────────────────────────────────────────

  async getFeatureFlags(productId: string): Promise<{ key: string; defaultValue: boolean }[]> {
    const flags = await this.prisma.productFeatureFlag.findMany({
      where: { productId },
    });
    return flags.map((f) => ({ key: f.key, defaultValue: f.defaultValue }));
  }

  async addFeatureFlag(productId: string, key: string, description?: string, defaultValue = false) {
    const product = await this.prisma.product.findUnique({ where: { id: productId } });
    if (!product) throw new NotFoundException(`Product '${productId}' not found.`);

    return this.prisma.productFeatureFlag.create({
      data: { productId, key, description, defaultValue },
    });
  }

  // ── Plan Assignments ──────────────────────────────────────────────

  async assignToPlan(productId: string, plan: string, enabled = true) {
    return this.prisma.productPlanAssignment.upsert({
      where: { productId_plan: { productId, plan } },
      create: { productId, plan, enabled },
      update: { enabled },
    });
  }

  async getProductsForPlan(plan: string): Promise<string[]> {
    const assignments = await this.prisma.productPlanAssignment.findMany({
      where: { plan, enabled: true },
      include: { product: true },
    });
    return assignments.map((a) => a.product.id);
  }

  // ── Workspace-Aware Queries ───────────────────────────────────────

  async getEnabledProductsForWorkspace(workspaceId: string) {
    // 1. Get the workspace's plan tier
    const workspace = await this.prisma.workspace.findUnique({
      where: { id: workspaceId },
      select: { tier: true },
    });
    const plan = workspace?.tier ?? 'free';

    // 2. Get products assigned to this plan
    const assignments = await this.prisma.productPlanAssignment.findMany({
      where: { plan, enabled: true },
      include: {
        product: {
          include: {
            capabilities: true,
            navItems: { orderBy: { order: 'asc' } },
            routes: true,
            featureFlags: true,
          },
        },
      },
    });

    // 3. Check per-workspace feature flag overrides
    const workspaceFlags = await this.prisma.featureFlag.findMany({
      where: { workspaceId },
    });
    const flagMap = new Map(workspaceFlags.map((f) => [f.key, f.enabled]));

    return assignments
      .map((a) => ({
        id: a.product.id,
        name: a.product.name,
        description: a.product.description,
        version: a.product.version,
        icon: a.product.icon,
        status: a.product.status,
        owningEngine: a.product.owningEngine,
        capabilities: a.product.capabilities.map((c) => c.capability),
        navItems: a.product.navItems,
        routes: a.product.routes,
        featureFlags: a.product.featureFlags.reduce(
          (acc, f) => {
            acc[f.key] = flagMap.has(f.key) ? flagMap.get(f.key)! : f.defaultValue;
            return acc;
          },
          {} as Record<string, boolean>,
        ),
      }))
      .filter((p) => p.status === 'ACTIVE' || p.status === 'BETA');
  }

  // ── Unregistration ────────────────────────────────────────────────

  async unregister(id: string) {
    const product = await this.prisma.product.findUnique({ where: { id } });
    if (!product) throw new NotFoundException(`Product '${id}' not found.`);

    await this.prisma.product.delete({ where: { id } });
    return { removed: id };
  }
}
