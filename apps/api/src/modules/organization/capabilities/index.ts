// ─── Organization Engine — Capability Registry ─────────────────────

export const OrganizationCapabilities = {
  'CreateTenant': 'organization.tenants.create',
  'GetTenant': 'organization.tenants.get',
  'InviteMember': 'organization.members.invite',
  'RemoveMember': 'organization.members.remove',
  'CreateTeam': 'organization.teams.create',
} as const;

export type OrganizationCapability = keyof typeof OrganizationCapabilities;
