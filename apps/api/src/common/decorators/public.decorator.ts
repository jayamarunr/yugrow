// ─── @Public() Decorator ───────────────────────────────────────────
// Marks a route handler as publicly accessible (skips AuthGuard).
// Usage: @Public()
//
// IMPORTANT: Only use for login, registration, health, and test endpoints.
// Never attach to production data routes.

import { SetMetadata } from '@nestjs/common';

export const IS_PUBLIC_KEY = 'isPublic';
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);
