// ─── Yugrow JWT Strategy ───────────────────────────────────────────
// Passport strategy that validates JWT tokens from Authorization headers.
// Extracts personId and workspaceId from the token payload.

import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { PrismaClient } from '@prisma/client';
import { PRISMA } from '@database/index';
import { Inject } from '@nestjs/common';

export interface JwtPayload {
  sub: string;    // personId
  email: string;
  workspaceId: string;
  iat?: number;
  exp?: number;
}

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    config: ConfigService,
    @Inject(PRISMA) private readonly prisma: PrismaClient,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.get<string>('JWT_SECRET', 'yugrow-dev-secret-change-in-production'),
    });
  }

  async validate(payload: JwtPayload) {
    const person = await this.prisma.person.findUnique({
      where: { id: payload.sub },
      select: { id: true, email: true, status: true },
    });

    if (!person || person.status !== 'ACTIVE') {
      throw new UnauthorizedException('Person not found or inactive');
    }

    return {
      personId: payload.sub,
      email: payload.email,
      workspaceId: payload.workspaceId,
    };
  }
}
