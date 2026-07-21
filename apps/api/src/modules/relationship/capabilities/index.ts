// ─── Relationship Engine — Capability Registry ──────────────────────

export const RelationshipCapabilities = {
  CreateConnection: 'relationship.graph.create',
  ReadConnections: 'relationship.graph.read',
  UpdateConnection: 'relationship.graph.update',
  DeleteConnection: 'relationship.graph.delete',
  SendRequest: 'relationship.connections.request',
  RespondToRequest: 'relationship.connections.respond',
  CreateCard: 'relationship.cards.create',
  ReadCards: 'relationship.cards.read',
  ShareCard: 'relationship.cards.share',
  ImportContacts: 'relationship.contacts.import',
  ExportContacts: 'relationship.contacts.export',
  MergeDuplicates: 'relationship.graph.merge',
} as const;
