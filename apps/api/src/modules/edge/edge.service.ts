// ─── Yugrow Edge Platform — Service Layer ───────────────────────────
// Domains, SSL, CDN, routing, preview URLs, redirects.

import { Injectable, Inject, ConflictException, NotFoundException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaClient } from '@prisma/client';
import { PRISMA } from '@database/index';

@Injectable()
export class EdgeService {
  private platformDomain: string;

  constructor(
    @Inject(PRISMA) private readonly prisma: PrismaClient,
    private readonly config: ConfigService,
  ) {
    this.platformDomain = this.config.get('PLATFORM_DOMAIN', 'yugrow.com');
  }

  // ─── Subdomain Auto-Provisioning ───────────────────────────────

  async provisionSubdomain(workspaceId: string, slug: string) {
    const domain = `${slug}.${this.platformDomain}`;

    const existing = await this.prisma.domain.findUnique({ where: { name: domain } });
    if (existing) throw new ConflictException('Subdomain already exists');

    return this.prisma.domain.create({
      data: {
        workspaceId,
        name: domain,
        type: 'SUBDOMAIN',
        verificationStatus: 'VERIFIED', // Auto-verified for subdomains
        sslStatus: 'PROVISIONING',     // SSL will be provisioned async
        targetProduct: 'sites',
        targetRoute: `/workspace/${workspaceId}`,
      },
    });
  }

  // ─── Custom Domain ─────────────────────────────────────────────

  async registerCustomDomain(workspaceId: string, domain: string) {
    const existing = await this.prisma.domain.findUnique({ where: { name: domain } });
    if (existing) throw new ConflictException('Domain already registered');

    return this.prisma.domain.create({
      data: {
        workspaceId,
        name: domain,
        type: 'CUSTOM',
        verificationStatus: 'PENDING',
        sslStatus: 'PENDING',
      },
    });
  }

  async verifyDomain(domainId: string) {
    // TODO: Implement DNS verification (TXT record check)
    const domain = await this.prisma.domain.update({
      where: { id: domainId },
      data: { verificationStatus: 'VERIFIED' },
    });

    // Auto-provision SSL
    await this.provisionSSL(domainId);

    return domain;
  }

  async provisionSSL(domainId: string) {
    // TODO: Implement Let's Encrypt / ACME certificate provisioning
    await this.prisma.domain.update({
      where: { id: domainId },
      data: { sslStatus: 'ACTIVE' },
    });
  }

  // ─── Routing ───────────────────────────────────────────────────

  async setRoute(domainId: string, path: string, targetType: string, targetId: string) {
    return this.prisma.route.create({
      data: { domainId, path, targetType, targetId },
    });
  }

  async getRoutes(domainId: string) {
    return this.prisma.route.findMany({
      where: { domainId, isActive: true },
      orderBy: { priority: 'desc' },
    });
  }

  // ─── Redirects ─────────────────────────────────────────────────

  async createRedirect(domainId: string, source: string, destination: string, type: number = 301) {
    return this.prisma.redirect.create({
      data: { domainId, source, destination, type },
    });
  }

  // ─── Preview URLs ──────────────────────────────────────────────

  async createPreviewUrl(workspaceId: string, resourceType: string, resourceId: string) {
    const preview = `preview-${resourceId.slice(0, 8)}.${this.platformDomain}`;
    return this.prisma.domain.create({
      data: {
        workspaceId,
        name: preview,
        type: 'SUBDOMAIN',
        verificationStatus: 'VERIFIED',
        sslStatus: 'PROVISIONING',
        targetProduct: resourceType,
        targetRoute: `/preview/${resourceId}`,
        environment: 'staging',
      },
    });
  }

  // ─── Queries ───────────────────────────────────────────────────

  async getDomains(workspaceId: string) {
    return this.prisma.domain.findMany({
      where: { workspaceId, deletedAt: null },
      include: { routes: true, redirects: true },
    });
  }

  async getDomain(domainId: string) {
    const domain = await this.prisma.domain.findUnique({
      where: { id: domainId },
      include: { routes: true, redirects: true },
    });
    if (!domain) throw new NotFoundException('Domain not found');
    return domain;
  }

  async removeDomain(domainId: string) {
    await this.prisma.domain.update({
      where: { id: domainId },
      data: { deletedAt: new Date() },
    });
  }
}
