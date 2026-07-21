// ─── Permission Engine — Capability Registry ────────────────────────

export const PermissionCapabilities = {
  'CheckPermission': 'permission.check',
  'BatchCheck': 'permission.check.batch',
  'GetCapabilities': 'permission.capabilities.list',
  'DefineCapability': 'permission.capabilities.define',
  'GrantTemporary': 'permission.grants.create',
} as const;
