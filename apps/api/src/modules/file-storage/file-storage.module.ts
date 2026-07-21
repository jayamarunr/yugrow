// ─── Yugrow File Storage Engine Module ──────────────────────────────
// S3-compatible file storage. Images, documents, videos, AI assets.

import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DatabaseModule } from '@database/index';
import { FileStorageService } from './file-storage.service';
import { FileStorageController } from './file-storage.controller';

@Module({
  imports: [ConfigModule, DatabaseModule],
  controllers: [FileStorageController],
  providers: [FileStorageService],
  exports: [FileStorageService],
})
export class FileStorageModule {}
