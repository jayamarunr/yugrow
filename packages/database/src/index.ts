// ─── NestJS Database Module ──────────────────────────────────────────

import { Global, Module } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

export const PRISMA = 'PRISMA';

export const prismaProvider = {
  provide: PRISMA,
  useFactory: () => {
    const client = new PrismaClient({
      log: process.env.NODE_ENV === 'development' ? ['query', 'info', 'warn', 'error'] : ['error'],
    });
    return client;
  },
};

@Global()
@Module({
  providers: [prismaProvider],
  exports: [PRISMA],
})
export class DatabaseModule {}
