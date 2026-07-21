// ─── Product Registration System ────────────────────────────────────
// Products register themselves with the shell: routes, menus, widgets, capabilities.
// Supports both static registration (for development) and backend-driven registration.

import React from 'react';

export interface ProductRegistration {
  id: string;
  name: string;
  icon: React.ReactNode;
  description?: string;
  version?: string;
  status?: 'DEVELOPMENT' | 'BETA' | 'ACTIVE' | 'DEPRECATED';
  owningEngine?: string;
  href: string;
  menuItems?: Array<{
    label: string;
    href: string;
    icon?: React.ReactNode;
    badge?: number;
  }>;
  capabilities?: string[];
  widget?: React.ComponentType<any>;
  featureFlags?: Record<string, boolean>;
}

// ── Static Registry (frontend-only, for development) ───────────────

const registry = new Map<string, ProductRegistration>();

export function registerProduct(product: ProductRegistration) {
  if (registry.has(product.id)) {
    console.warn(`Product ${product.id} is already registered. Overwriting.`);
  }
  registry.set(product.id, product);
}

export function getProduct(id: string): ProductRegistration | undefined {
  return registry.get(id);
}

export function getAllProducts(): ProductRegistration[] {
  return Array.from(registry.values());
}

export function getProductsWithCapability(capability: string): ProductRegistration[] {
  return Array.from(registry.values()).filter(
    (p) => p.capabilities?.includes(capability),
  );
}

// ── Backend-Driven Registry (for production) ───────────────────────
// Call loadProductsForWorkspace() on workspace switch to sync
// enabled products from the backend Product Registration module.

let backendProducts: ProductRegistration[] = [];
let lastLoadedWorkspace: string | null = null;

export async function loadProductsForWorkspace(workspaceId: string): Promise<ProductRegistration[]> {
  try {
    const res = await fetch(`/api/v1/admin/products/workspace/${workspaceId}`);
    if (!res.ok) throw new Error(`Failed to load products: ${res.statusText}`);
    const data = await res.json();
    backendProducts = data.map((p: any) => ({
      id: p.id,
      name: p.name,
      icon: getIconForProduct(p.id),
      description: p.description,
      version: p.version,
      status: p.status,
      owningEngine: p.owningEngine,
      href: p.navItems?.[0]?.href ?? `/${p.id}`,
      menuItems: p.navItems?.map((n: any) => ({
        label: n.label,
        href: n.href,
        icon: n.icon,
      })),
      capabilities: p.capabilities,
      featureFlags: p.featureFlags,
    }));
    lastLoadedWorkspace = workspaceId;
    return backendProducts;
  } catch {
    // Fall back to static registry
    return getAllProducts();
  }
}

export function getProductsForWorkspace(): ProductRegistration[] {
  return backendProducts.length > 0 ? backendProducts : getAllProducts();
}

export function getLastLoadedWorkspace(): string | null {
  return lastLoadedWorkspace;
}

// Map product IDs to icons (can be extended)
function getIconForProduct(id: string): string {
  const icons: Record<string, string> = {
    'checkin': '📍',
    'sites': '🌐',
    'content': '✍️',
    'broadcast': '📢',
    'crm': '💼',
    'identity': '👤',
    'relationship': '🔗',
  };
  return icons[id] ?? '📦';
}

// ─── Product Launcher Component ────────────────────────────────────

interface ProductLauncherProps {
  open: boolean;
  onClose: () => void;
}

export function ProductLauncher({ open, onClose }: ProductLauncherProps) {
  if (!open) return null;
  const products = getAllProducts();

  return (
    <div className="fixed inset-0 z-50 flex items-start justify-center pt-20" onClick={onClose}>
      <div className="absolute inset-0 bg-black/30 backdrop-blur-sm" />
      <div
        className="relative grid grid-cols-3 gap-4 p-6 bg-[var(--y-bg)] border border-[var(--y-border)] rounded-xl shadow-xl max-w-lg w-full mx-4"
        onClick={(e) => e.stopPropagation()}
      >
        {products.map((product) => (
          <a
            key={product.id}
            href={product.href}
            className="flex flex-col items-center gap-2 p-4 rounded-lg hover:bg-[var(--y-surface)] transition-colors"
          >
            <span className="text-[var(--y-brand-primary)]">{product.icon}</span>
            <span className="text-xs font-medium text-[var(--y-text-primary)]">{product.name}</span>
          </a>
        ))}
        {products.length === 0 && (
          <p className="col-span-3 text-sm text-[var(--y-text-secondary)] text-center py-8">
            No products registered yet.
          </p>
        )}
      </div>
    </div>
  );
}
