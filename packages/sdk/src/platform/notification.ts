// ─── Platform SDK: Notification ─────────────────────────────────────
// Multi-channel notification delivery.

export type NotificationChannel = 'in_app' | 'email' | 'sms' | 'push' | 'whatsapp';

export interface NotificationPayload {
  workspaceId: string;
  recipientId: string;
  channel: NotificationChannel | NotificationChannel[];
  title: string;
  body: string;
  data?: Record<string, any>;
  templateId?: string;
}

class NotificationSDK {
  private baseUrl: string;

  constructor() {
    this.baseUrl = process.env.API_URL || 'http://localhost:4000';
  }

  async send(payload: NotificationPayload): Promise<void> {
    // TODO: Route through Communication Engine
    console.log(`[Notification] ${payload.channel} → ${payload.recipientId}: ${payload.title}`);
  }

  async sendBatch(payloads: NotificationPayload[]): Promise<void> {
    await Promise.allSettled(payloads.map((p) => this.send(p)));
  }
}

export const notification = new NotificationSDK();
