// ─── Yugrow Permission Engine — Event Definitions ───────────────────

export const PermissionEvents = {
  CapabilityDefined: 'Permission.Capability.Defined',
  CapabilityGranted: 'Permission.Capability.Granted',
  CapabilityRevoked: 'Permission.Capability.Revoked',
  PermissionChecked: 'Permission.Checked',
} as const;
