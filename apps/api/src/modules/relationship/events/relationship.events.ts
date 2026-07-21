// ─── Yugrow Relationship Engine — Event Definitions ────────────────

export const RelationshipEvents = {
  Connected: 'Relationship.Connected',
  Disconnected: 'Relationship.Disconnected',
  Updated: 'Relationship.Updated',
  RequestSent: 'Relationship.Request.Sent',
  RequestAccepted: 'Relationship.Request.Accepted',
  RequestDeclined: 'Relationship.Request.Declined',
  BusinessCardShared: 'Relationship.BusinessCard.Shared',
  DiscoverySuggested: 'Relationship.Discovery.Suggested',
} as const;
