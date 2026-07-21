// ─── Navigation Registry ────────────────────────────────────────────
// Every product contributes navigation items. The Shell assembles them.
// Supports both static registration and backend-driven (workspace-aware) nav.

import React from 'react';
import { getProductsForWorkspace, type ProductRegistration } from './ProductRegistry';

export interface NavItem {
  id: string;
  label: string;
  href: string;
  icon: React.ReactNode;
  badge?: number;
  requiredCapability?: string;
  children?: NavItem[];
}

// ── Static Registry (frontend-only) ────────────────────────────────

const navRegistry = new Map<string, NavItem[]>();

export function registerNavItems(productId: string, items: NavItem[]) {
  navRegistry.set(productId, items);
}

export function getNavTree(): NavItem[] {
  const all: NavItem[] = [];
  for (const items of navRegistry.values()) {
    all.push(...items);
  }
  return all;
}

// ── Workspace-Aware Nav Tree ───────────────────────────────────────
// Used by the Shell when a workspace is active. Builds nav from the
// products enabled for this workspace and their registered nav items.

export function getWorkspaceNavTree(userCapabilities?: string[]): NavItem[] {
  const products = getProductsForWorkspace();
  const items: NavItem[] = [];

  for (const product of products) {
    if (product.menuItems) {
      for (const menuItem of product.menuItems) {
        items.push({
          id: `${product.id}-${menuItem.label.toLowerCase().replace(/\s+/g, '-')}`,
          label: menuItem.label,
          href: menuItem.href,
          icon: (menuItem.icon as React.ReactNode) ?? product.icon,
          badge: (menuItem as any).badge,
        });
      }
    } else {
      // Default: one nav item per product linking to its home
      items.push({
        id: product.id,
        label: product.name,
        href: product.href,
        icon: product.icon as React.ReactNode,
      });
    }
  }

  // Filter by capabilities if user capabilities are provided
  if (userCapabilities) {
    return items.filter((item) => {
      if (!item.requiredCapability) return true;
      return userCapabilities.includes(item.requiredCapability);
    });
  }

  return items;
}
