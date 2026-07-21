// ─── Platform SDK: Audit ────────────────────────────────────────────
// Immutable audit logging.

export interface AuditPayload {
  workspaceId: string;
  personId?: string;
  action: string;
  resource: string;
  resourceId?: string;
  details?: Record<string, any>;
  ipAddress?: string;
  userAgent?: string;
}

class AuditSDK {
  private baseUrl: string;

  constructor() {
    this.baseUrl = process.env.API_URL || 'http://localhost:4000';
  }

  async record(payload: AuditPayload): Promise<void> {
    // TODO: Call Audit Engine API
    console.log(`[Audit] ${payload.action} on ${payload.resource} in ${payload.workspaceId}`);
  }
}

export const audit = new AuditSDK();
