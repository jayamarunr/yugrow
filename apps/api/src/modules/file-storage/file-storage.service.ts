// ─── Yugrow File Storage Engine — Service Layer ─────────────────────
// S3-compatible storage. Supports MinIO (local), AWS S3, GCS, Azure Blob.

import { Injectable, Inject, NotFoundException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaClient } from '@prisma/client';
import { PRISMA } from '@database/index';
import * as path from 'path';
import * as crypto from 'crypto';

// Minimal S3-like interface. Swap implementation based on config.
interface S3Client {
  upload(bucket: string, key: string, body: Buffer, mimeType: string): Promise<string>;
  getUrl(bucket: string, key: string): Promise<string>;
  delete(bucket: string, key: string): Promise<void>;
}

@Injectable()
export class FileStorageService {
  private s3: S3Client;
  private bucket: string;

  constructor(
    @Inject(PRISMA) private readonly prisma: PrismaClient,
    private readonly config: ConfigService,
  ) {
    this.bucket = this.config.get('S3_BUCKET', 'yugrow-uploads');
    this.s3 = this.createS3Client();
  }

  private createS3Client(): S3Client {
    const endpoint = this.config.get('S3_ENDPOINT', 'http://localhost:9000');
    const region = this.config.get('S3_REGION', 'us-east-1');
    const accessKey = this.config.get('S3_ACCESS_KEY', 'minioadmin');
    const secretKey = this.config.get('S3_SECRET_KEY', 'minioadmin');

    // TODO: Replace with @aws-sdk/client-s3 or minio SDK
    // For now, return a stub that logs operations
    return {
      upload: async (bucket, key, body, mimeType) => {
        console.log(`[S3] Upload: ${bucket}/${key} (${mimeType}, ${body.length} bytes)`);
        return `https://${bucket}.s3.amazonaws.com/${key}`;
      },
      getUrl: async (bucket, key) => {
        return `https://${bucket}.s3.amazonaws.com/${key}`;
      },
      delete: async (bucket, key) => {
        console.log(`[S3] Delete: ${bucket}/${key}`);
      },
    };
  }

  async upload(
    workspaceId: string,
    file: { originalname: string; buffer: Buffer; mimetype: string; size: number },
    uploadedBy: string,
    options?: { alt?: string; metadata?: Record<string, any> },
  ) {
    const ext = path.extname(file.originalname);
    const key = `${workspaceId}/${crypto.randomUUID()}${ext}`;

    const url = await this.s3.upload(this.bucket, key, file.buffer, file.mimetype);

    const record = await this.prisma.file.create({
      data: {
        workspaceId,
        name: file.originalname,
        mimeType: file.mimetype,
        size: file.size,
        storageKey: key,
        url,
        alt: options?.alt,
        uploadedBy,
        metadata: options?.metadata ?? {},
      },
    });

    return record;
  }

  async getFile(fileId: string) {
    const file = await this.prisma.file.findUnique({ where: { id: fileId } });
    if (!file || file.deletedAt) throw new NotFoundException('File not found');
    return file;
  }

  async listFiles(workspaceId: string, options?: { mimeType?: string; limit?: number }) {
    const where: any = { workspaceId, deletedAt: null };
    if (options?.mimeType) where.mimeType = { startsWith: options.mimeType };

    return this.prisma.file.findMany({
      where,
      orderBy: { createdAt: 'desc' },
      take: options?.limit ?? 50,
    });
  }

  async deleteFile(fileId: string) {
    const file = await this.prisma.file.findUnique({ where: { id: fileId } });
    if (!file) throw new NotFoundException('File not found');

    await this.s3.delete(this.bucket, file.storageKey);

    await this.prisma.file.update({
      where: { id: fileId },
      data: { deletedAt: new Date() },
    });
  }
}
