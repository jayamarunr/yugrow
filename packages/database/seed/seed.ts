// ─── Yugrow Platform — Base Capabilities Seed ───────────────────────
// Run: pnpm --filter @database exec prisma db seed

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const baseCapabilities = [
  // Identity
  { product: 'identity', resource: 'profile', action: 'read' },
  { product: 'identity', resource: 'profile', action: 'update' },
  { product: 'identity', resource: 'people', action: 'deactivate' },
  { product: 'identity', resource: 'sessions', action: 'manage' },

  // Storage
  { product: 'storage', resource: 'files', action: 'upload' },
  { product: 'storage', resource: 'files', action: 'read' },
  { product: 'storage', resource: 'files', action: 'delete' },

  // Workspace
  { product: 'workspace', resource: 'workspace', action: 'create' },
  { product: 'workspace', resource: 'workspace', action: 'update' },
  { product: 'workspace', resource: 'members', action: 'manage' },
  { product: 'workspace', resource: 'workspace', action: 'switch' },

  // Audit
  { product: 'audit', resource: 'logs', action: 'read' },
  { product: 'audit', resource: 'logs', action: 'export' },

  // Edge
  { product: 'edge', resource: 'domains', action: 'manage' },
  { product: 'edge', resource: 'routes', action: 'manage' },
  { product: 'edge', resource: 'ssl', action: 'manage' },

  // CRM (future)
  { product: 'crm', resource: 'contacts', action: 'create' },
  { product: 'crm', resource: 'contacts', action: 'read' },
  { product: 'crm', resource: 'contacts', action: 'update' },
  { product: 'crm', resource: 'contacts', action: 'delete' },
  { product: 'crm', resource: 'pipeline', action: 'manage' },
  { product: 'crm', resource: 'deals', action: 'create' },
  { product: 'crm', resource: 'deals', action: 'read' },
  { product: 'crm', resource: 'deals', action: 'update' },
  { product: 'crm', resource: 'forecast', action: 'read' },

  // Content (future)
  { product: 'content', resource: 'articles', action: 'create' },
  { product: 'content', resource: 'articles', action: 'read' },
  { product: 'content', resource: 'articles', action: 'update' },
  { product: 'content', resource: 'articles', action: 'publish' },
  { product: 'content', resource: 'articles', action: 'delete' },

  // Broadcast (future)
  { product: 'broadcast', resource: 'campaigns', action: 'create' },
  { product: 'broadcast', resource: 'campaigns', action: 'send' },
  { product: 'broadcast', resource: 'campaigns', action: 'send_global' },

  // Finance (future)
  { product: 'finance', resource: 'invoices', action: 'create' },
  { product: 'finance', resource: 'invoices', action: 'read' },
  { product: 'finance', resource: 'invoices', action: 'approve' },
  { product: 'finance', resource: 'payments', action: 'release' },

  // HR (future)
  { product: 'hr', resource: 'employees', action: 'read' },
  { product: 'hr', resource: 'payroll', action: 'run' },

  // Relationship Engine
  { product: 'relationship', resource: 'graph', action: 'create' },
  { product: 'relationship', resource: 'graph', action: 'read' },
  { product: 'relationship', resource: 'graph', action: 'update' },
  { product: 'relationship', resource: 'graph', action: 'delete' },
  { product: 'relationship', resource: 'graph', action: 'merge' },
  { product: 'relationship', resource: 'connections', action: 'request' },
  { product: 'relationship', resource: 'connections', action: 'respond' },
  { product: 'relationship', resource: 'cards', action: 'create' },
  { product: 'relationship', resource: 'cards', action: 'read' },
  { product: 'relationship', resource: 'cards', action: 'share' },
  { product: 'relationship', resource: 'contacts', action: 'import' },
  { product: 'relationship', resource: 'contacts', action: 'export' },

  // Admin
  { product: 'admin', resource: 'settings', action: 'manage' },
  { product: 'admin', resource: 'users', action: 'manage' },
];

const relationshipTypes = [
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

async function seed() {
  console.log('Seeding base capabilities...');

  for (const cap of baseCapabilities) {
    await prisma.capability.upsert({
      where: {
        product_resource_action: {
          product: cap.product,
          resource: cap.resource,
          action: cap.action,
        },
      },
      update: {},
      create: cap,
    });
  }

  console.log(`Seeded ${baseCapabilities.length} base capabilities.`);

  console.log('Seeding relationship types...');
  for (const t of relationshipTypes) {
    const existing = await prisma.relationshipType.findFirst({
      where: { workspaceId: null, name: t.name },
    });
    if (!existing) {
      await prisma.relationshipType.create({ data: { ...t, workspaceId: null } });
    }
  }
  console.log(`Seeded ${relationshipTypes.length} relationship types.`);

  for (const cap of baseCapabilities) {
    await prisma.capability.upsert({
      where: {
        product_resource_action: {
          product: cap.product,
          resource: cap.resource,
          action: cap.action,
        },
      },
      update: {},
      create: cap,
    });
  }

  console.log(`Seeded ${baseCapabilities.length} base capabilities.`);
}

seed()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
