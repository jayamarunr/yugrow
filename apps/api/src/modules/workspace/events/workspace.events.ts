// ─── Yugrow Workspace Engine — Event Definitions ────────────────────

export const WorkspaceEvents = {
  Created: 'Workspace.Created',
  Updated: 'Workspace.Updated',
  Switched: 'Workspace.Switched',
  MemberAdded: 'Workspace.Member.Added',
  MemberRemoved: 'Workspace.Member.Removed',
  MemberRoleChanged: 'Workspace.Member.RoleChanged',
} as const;

export interface WorkspaceCreatedEvent {
  workspaceId: string;
  name: string;
  type: string;
  ownerId: string;
}

export interface WorkspaceSwitchedEvent {
  personId: string;
  workspaceId: string;
}
