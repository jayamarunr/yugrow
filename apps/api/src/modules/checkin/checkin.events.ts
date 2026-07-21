// ─── CheckIN Events ───────────────────────────────────────────────

export const CheckinEvents = {
  VenueCreated: 'venue.created',
  VenueUpdated: 'venue.updated',
  EventCreated: 'event.created',
  EventActivated: 'event.activated',
  EventCompleted: 'event.completed',
  EventExpired: 'event.expired',
  PresenceCreated: 'presence.created',
  PresenceExpired: 'presence.expired',
  ConnectionRequested: 'connection.requested',
  ConnectionAccepted: 'connection.accepted',
} as const;
