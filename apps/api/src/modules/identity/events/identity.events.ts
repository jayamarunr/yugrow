// ─── Yugrow Identity Engine — Event Definitions ────────────────────

export const IdentityEvents = {
  PersonRegistered: 'Identity.Person.Registered',
  PersonLoggedIn: 'Identity.Person.LoggedIn',
  PersonLoggedOut: 'Identity.Person.LoggedOut',
  PersonUpdated: 'Identity.Person.Updated',
  PersonDeactivated: 'Identity.Person.Deactivated',
  LoginFailed: 'Identity.Login.Failed',
} as const;

export interface PersonRegisteredEvent {
  personId: string;
  email: string;
  displayName: string;
  authMethod: 'email' | 'google' | 'magic-link';
  timestamp: string;
}

export interface PersonLoggedInEvent {
  personId: string;
  sessionId: string;
  ipAddress: string;
  deviceInfo: Record<string, any>;
  authMethod: string;
  timestamp: string;
}

export interface PersonUpdatedEvent {
  personId: string;
  changes: string[];
}
