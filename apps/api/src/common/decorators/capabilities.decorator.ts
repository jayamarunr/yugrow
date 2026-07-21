// ─── @RequireCapability() Decorator ─────────────────────────────────
// Attach required capabilities to route handlers.
// Usage: @RequireCapability('crm.contacts.create')

import { SetMetadata } from '@nestjs/common';

export const CAPABILITIES_KEY = 'required_capabilities';
export const RequireCapability = (...capabilities: string[]) =>
  SetMetadata(CAPABILITIES_KEY, capabilities);
