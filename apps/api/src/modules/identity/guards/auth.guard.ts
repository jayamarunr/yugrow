// ─── Yugrow Authorization Guard ─────────────────────────────────────
// Global guard: validates JWT via Passport, extracts identity, checks capabilities.
// Controllers declare requirements via @RequireCapability() decorator.

import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
  ForbiddenException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ConfigService } from '@nestjs/config';
import { PermissionService } from '../../permission/permission.service';
import { CAPABILITIES_KEY } from '../../../common/decorators/capabilities.decorator';
import { IS_PUBLIC_KEY } from '../../../common/decorators/public.decorator';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private readonly config: ConfigService,
    private readonly reflector: Reflector,
    private readonly permission: PermissionService,
    private readonly jwtService: JwtService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    // Skip auth for @Public() decorated routes
    const isPublic = this.reflector.getAllAndOverride<boolean>(
      IS_PUBLIC_KEY,
      [context.getHandler(), context.getClass()],
    );
    if (isPublic) return true;

    const request = context.switchToHttp().getRequest();
    const token = this.extractToken(request);

    if (!token) {
      throw new UnauthorizedException('No authentication token provided');
    }

    try {
      // Validate the JWT
      const secret = this.config.get<string>('JWT_SECRET', 'yugrow-dev-secret-change-in-production');
      const payload = await this.jwtService.verifyAsync(token, { secret });

      // Set user from verified JWT payload
      request.user = {
        personId: payload.sub,
        workspaceId: payload.workspaceId,
      };

      // Check required capabilities from @RequireCapability() decorator
      const requiredCapabilities = this.reflector.getAllAndOverride<string[]>(
        CAPABILITIES_KEY,
        [context.getHandler(), context.getClass()],
      );

      if (!requiredCapabilities || requiredCapabilities.length === 0) {
        return true; // No specific capability required — auth alone is enough
      }

      // Verify all required capabilities
      const results = await this.permission.canBatch(
        payload.sub,
        payload.workspaceId,
        requiredCapabilities,
      );

      const denied = requiredCapabilities.filter((cap) => !results[cap]);
      if (denied.length > 0) {
        throw new ForbiddenException(
          `Missing required capabilities: ${denied.join(', ')}`,
        );
      }

      return true;
    } catch (err) {
      if (err instanceof ForbiddenException) throw err;
      throw new UnauthorizedException('Invalid or expired token');
    }
  }

  private extractToken(request: any): string | null {
    const auth = request.headers?.authorization;
    if (!auth) return null;
    const [type, token] = auth.split(' ');
    return type === 'Bearer' ? token : null;
  }
}
