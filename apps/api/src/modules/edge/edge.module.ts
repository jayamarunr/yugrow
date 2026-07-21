// ─── Yugrow Edge Platform Module ────────────────────────────────────
// Domains, SSL, CDN, routing, preview URLs, redirects.

import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DatabaseModule } from '@database/index';
import { EdgeService } from './edge.service';
import { EdgeController } from './edge.controller';

@Module({
  imports: [ConfigModule, DatabaseModule],
  controllers: [EdgeController],
  providers: [EdgeService],
  exports: [EdgeService],
})
export class EdgeModule {}
