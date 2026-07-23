// ─── Yugrow Identity Engine Module ──────────────────────────────────
// Handles authentication, authorization, user profiles, sessions.

import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { DatabaseModule } from '@database/index';
import { IdentityController } from './identity.controller';
import { IdentityService } from './identity.service';
import { JwtStrategy } from './strategies/jwt.strategy';

@Module({
  imports: [
    ConfigModule,
    DatabaseModule,
    PassportModule.register({ defaultStrategy: 'jwt' }),
    JwtModule.registerAsync({
      global: true,
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        secret: config.get<string>('JWT_SECRET', 'yugrow-dev-secret-change-in-production'),
        signOptions: { expiresIn: '24h' },
      }),
    }),
  ],
  controllers: [IdentityController],
  providers: [IdentityService, JwtStrategy],
  exports: [IdentityService, JwtModule],
})
export class IdentityModule {}
