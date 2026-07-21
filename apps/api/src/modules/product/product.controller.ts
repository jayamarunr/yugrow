// ─── Product Registration Controller ────────────────────────────────
// Admin APIs for product lifecycle management.
// Products register themselves; admins promote them through lifecycle.

import { Controller, Get, Post, Patch, Delete, Param, Body, Query } from '@nestjs/common';
import { ProductService } from './product.service';

@Controller('api/v1/admin/products')
export class ProductController {
  constructor(private readonly productService: ProductService) {}

  // ── Register a new product ────────────────────────────────────────

  @Post()
  async register(@Body() body: {
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
    return this.productService.register(body);
  }

  // ── List all products ─────────────────────────────────────────────

  @Get()
  async list(@Query('status') status?: string) {
    return this.productService.listProducts(status);
  }

  // ── Get a single product ──────────────────────────────────────────

  @Get(':id')
  async get(@Param('id') id: string) {
    return this.productService.getProduct(id);
  }

  // ── Update product status ─────────────────────────────────────────

  @Patch(':id/status')
  async setStatus(
    @Param('id') id: string,
    @Body('status') status: 'DEVELOPMENT' | 'BETA' | 'ACTIVE' | 'DEPRECATED',
  ) {
    return this.productService.setStatus(id, status);
  }

  // ── Add a feature flag ────────────────────────────────────────────

  @Post(':id/feature-flags')
  async addFeatureFlag(
    @Param('id') id: string,
    @Body() body: { key: string; description?: string; defaultValue?: boolean },
  ) {
    return this.productService.addFeatureFlag(id, body.key, body.description, body.defaultValue);
  }

  // ── Assign product to a plan ──────────────────────────────────────

  @Post(':id/plans')
  async assignToPlan(
    @Param('id') id: string,
    @Body() body: { plan: string; enabled?: boolean },
  ) {
    return this.productService.assignToPlan(id, body.plan, body.enabled);
  }

  // ── Unregister a product ──────────────────────────────────────────

  @Delete(':id')
  async unregister(@Param('id') id: string) {
    return this.productService.unregister(id);
  }

  // ── Get enabled products for a workspace ──────────────────────────

  @Get('workspace/:workspaceId')
  async getForWorkspace(@Param('workspaceId') workspaceId: string) {
    return this.productService.getEnabledProductsForWorkspace(workspaceId);
  }
}
