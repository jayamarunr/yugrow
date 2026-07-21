// ─── Yugrow Relationship Engine Module ──────────────────────────────
// Generic entity relationships with configurable types, lifecycle states,
// strength scoring, business cards, and connection requests.

import { Module } from '@nestjs/common';
import { DatabaseModule } from '@database/index';
import { RelationshipController } from './relationship.controller';
import { RelationshipService } from './relationship.service';

@Module({
  imports: [DatabaseModule],
  controllers: [RelationshipController],
  providers: [RelationshipService],
  exports: [RelationshipService],
})
export class RelationshipModule {}
