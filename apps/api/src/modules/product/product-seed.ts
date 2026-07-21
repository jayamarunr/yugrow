// ─── Product Registration Seed ──────────────────────────────────────
// Example: Register the Presence Platform as a product.
// Run this once during platform setup or via an admin API call.
//
// Usage:
//   curl -X POST http://localhost:3000/api/v1/admin/products \
//     -H "Content-Type: application/json" \
//     -d '{ ... }'

export const PRESENCE_PLATFORM_PRODUCT = {
  id: 'checkin',
  name: 'Presence Platform',
  description: 'Professional Presence Network — check in, see people, connect, chat.',
  version: '1.0.0',
  icon: '📍',
  owningEngine: 'Presence Platform',
  visibility: 'PUBLIC',
  discoverable: true,
  promotable: false,
  capabilities: [
    { capability: 'presence.declare', description: 'Check in to an event' },
    { capability: 'presence.read', description: 'View present people' },
    { capability: 'presence.request.create', description: 'Send connection request' },
    { capability: 'presence.request.respond', description: 'Accept or decline request' },
    { capability: 'presence.hide', description: 'Hide presence from others' },
    { capability: 'event.create', description: 'Create an event' },
    { capability: 'venue.create', description: 'Create a venue' },
  ],
  routes: [
    { path: '/api/v1/presence/declare', method: 'POST', description: 'Declare presence' },
    { path: '/api/v1/presence/nearby', method: 'GET', description: 'List present people' },
    { path: '/api/v1/presence/requests', method: 'POST', description: 'Send connection request' },
    { path: '/api/v1/presence/requests/incoming', method: 'GET', description: 'List incoming requests' },
    { path: '/api/v1/presence/requests/:id/accept', method: 'POST', description: 'Accept request' },
    { path: '/api/v1/presence/events', method: 'GET', description: 'List active events' },
    { path: '/api/v1/presence/events', method: 'POST', description: 'Create event' },
    { path: '/api/v1/presence/venues', method: 'POST', description: 'Create venue' },
  ],
  navItems: [
    { label: 'Events', href: '/checkin/events', icon: '📍', order: 1 },
    { label: 'Live', href: '/checkin/live', icon: '👥', order: 2 },
    { label: 'Connections', href: '/checkin/connections', icon: '🔗', order: 3 },
    { label: 'Messages', href: '/checkin/messages', icon: '💬', order: 4 },
  ],
  featureFlags: [
    { key: 'checkin-enabled', description: 'Master toggle for CheckIN', defaultValue: true },
    { key: 'checkin-temporary-communities', description: '24h temporary communities', defaultValue: false },
    { key: 'checkin-event-pulse', description: 'Live event dashboard', defaultValue: false },
  ],
  planAssignments: [
    { plan: 'free', enabled: true },
    { plan: 'pro', enabled: true },
    { plan: 'business', enabled: true },
    { plan: 'enterprise', enabled: true },
  ],
};

export const SITES_PRODUCT = {
  id: 'sites',
  name: 'Sites',
  description: 'AI-powered website builder — create and publish professional websites.',
  version: '1.0.0',
  icon: '🌐',
  owningEngine: 'Content Platform',
  capabilities: [
    { capability: 'sites.create', description: 'Create a website' },
    { capability: 'sites.publish', description: 'Publish a website' },
    { capability: 'sites.domain', description: 'Connect custom domain' },
  ],
  navItems: [
    { label: 'My Sites', href: '/sites', icon: '🌐', order: 1 },
    { label: 'Create Site', href: '/sites/create', icon: '➕', order: 2 },
  ],
  planAssignments: [
    { plan: 'free', enabled: true },
    { plan: 'pro', enabled: true },
    { plan: 'business', enabled: true },
    { plan: 'enterprise', enabled: true },
  ],
};
