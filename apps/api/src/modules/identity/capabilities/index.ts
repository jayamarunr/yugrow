// ─── Identity Engine — Capability Registry ─────────────────────────
// Maps engine capabilities to their implementations.

export const IdentityCapabilities = {
  'Authenticate': 'identity.auth.login',
  'Register': 'identity.auth.register',
  'RefreshToken': 'identity.auth.refresh',
  'ManageProfile': 'identity.users.profile',
  'DeactivateUser': 'identity.users.deactivate',
  'CreateRole': 'identity.roles.create',
  'AssignRole': 'identity.roles.assign',
} as const;

export type IdentityCapability = keyof typeof IdentityCapabilities;
