// ─── Platform SDK: Storage ──────────────────────────────────────────
// File and object storage interface.

export interface UploadOptions {
  workspaceId: string;
  buffer: Buffer;
  filename: string;
  mimeType: string;
  metadata?: Record<string, any>;
}

export interface StorageResult {
  id: string;
  url: string;
  name: string;
  mimeType: string;
  size: number;
}

class StorageSDK {
  private baseUrl: string;

  constructor() {
    this.baseUrl = process.env.API_URL || 'http://localhost:4000';
  }

  async upload(options: UploadOptions): Promise<StorageResult> {
    const form = new FormData();
    const blob = new Blob([options.buffer as unknown as BlobPart], { type: options.mimeType });
    form.append('file', blob, options.filename);

    const res = await fetch(
      `${this.baseUrl}/api/v1/files/upload/${options.workspaceId}`,
      { method: 'POST', body: form },
    );

    if (!res.ok) throw new Error(`Upload failed: ${res.statusText}`);
    return res.json();
  }

  async getUrl(fileId: string): Promise<string> {
    const res = await fetch(`${this.baseUrl}/api/v1/files/${fileId}`);
    if (!res.ok) throw new Error('File not found');
    const file = await res.json();
    return file.url;
  }

  async delete(fileId: string): Promise<void> {
    await fetch(`${this.baseUrl}/api/v1/files/${fileId}`, { method: 'DELETE' });
  }
}

export const storage = new StorageSDK();
