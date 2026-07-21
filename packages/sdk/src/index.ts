// ─── Yugrow Platform SDK ────────────────────────────────────────────
// The developer toolkit. Every engine and product imports from here.

export { createLogger } from './platform/logger';
export { eventBus } from './platform/event-bus';
export { ai } from './platform/ai';
export { storage } from './platform/storage';
export { config as platformConfig } from './platform/config';
export { notification } from './platform/notification';
export { audit } from './platform/audit';

export const SDK_VERSION = '0.1.0';

export interface ClientConfig {
  baseUrl: string;
  apiKey?: string;
  accessToken?: string;
}

export class YugrowClient {
  private config: ClientConfig;

  constructor(config: ClientConfig) {
    this.config = config;
  }

  async request<T>(path: string, options?: RequestInit): Promise<T> {
    const res = await fetch(`${this.config.baseUrl}/api/v1${path}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...(this.config.accessToken && { Authorization: `Bearer ${this.config.accessToken}` }),
        ...(this.config.apiKey && { 'X-API-Key': this.config.apiKey }),
        ...options?.headers,
      },
    });

    if (!res.ok) {
      const error = await res.json().catch(() => ({ error: { code: 'UNKNOWN', message: res.statusText } }));
      throw new YugrowError(error.error);
    }

    return res.json();
  }
}

export class YugrowError extends Error {
  public code: string;
  constructor(error: { code: string; message: string }) {
    super(error.message);
    this.name = 'YugrowError';
    this.code = error.code;
  }
}
