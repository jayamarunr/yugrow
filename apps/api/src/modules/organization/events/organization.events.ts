// ─── Yugrow Organization Engine — Event Definitions ────────────────

export const OrganizationEvents = {
  TenantProvisioned: 'Organization.Tenant.Provisioned',
  TenantUpdated: 'Organization.Tenant.Updated',
  TenantDeactivated: 'Organization.Tenant.Deactivated',
  MemberInvited: 'Organization.Member.Invited',
  MemberJoined: 'Organization.Member.Joined',
  MemberRemoved: 'Organization.Member.Removed',
  TeamCreated: 'Organization.Team.Created',
} as const;

export interface TenantProvisionedEvent {
  tenantId: string;
  tenantName: string;
  ownerId: string;
  timestamp: string;
}
