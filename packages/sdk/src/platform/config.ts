// ─── Platform SDK: Configuration ────────────────────────────────────
// Tenant-scoped configuration and feature flags.

class ConfigSDK {
  private cache: Map<string, any> = new Map();
  private baseUrl: string;

  constructor() {
    this.baseUrl = process.env.API_URL || 'http://localhost:4000';
  }

  async getFeatureFlag(workspaceId: string, key: string): Promise<boolean> {
    const cacheKey = `ff:${workspaceId}:${key}`;
    if (this.cache.has(cacheKey)) return this.cache.get(cacheKey);

    // TODO: Call Organization Engine to check feature flag
    // For now, return true for all flags
    this.cache.set(cacheKey, true);
    return true;
  }

  async getSetting(workspaceId: string, key: string): Promise<any> {
    const cacheKey = `setting:${workspaceId}:${key}`;
    if (this.cache.has(cacheKey)) return this.cache.get(cacheKey);
    return null;
  }

  clearCache(workspaceId?: string): void {
    if (workspaceId) {
      for (const key of this.cache.keys()) {
        if (key.includes(workspaceId)) this.cache.delete(key);
      }
    } else {
      this.cache.clear();
    }
  }
}

export const config = new ConfigSDK();
