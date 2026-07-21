// ─── Workspace Engine — Capability Registry ─────────────────────────

export const WorkspaceCapabilities = {
  'CreateWorkspace': 'workspace.create',
  'SwitchContext': 'workspace.switch',
  'ManageMembers': 'workspace.members.manage',
  'UpdateWorkspace': 'workspace.update',
  'ManageHierarchy': 'workspace.hierarchy.manage',
} as const;
