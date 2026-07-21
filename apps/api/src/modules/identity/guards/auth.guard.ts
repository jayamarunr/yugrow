// ─── Yugrow Authorization Guard ─────────────────────────────────────
// Global guard: validates JWT, extracts identity, checks required capabilities.
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

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private readonly config: ConfigService,
    private readonly reflector: Reflector,
    private readonly permission: PermissionService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const token = this.extractToken(request);

    if (!token) {
      throw new UnauthorizedException('No authentication token provided');
    }

    try {
      // TODO: Real JWT validation via Authentik/OIDC
      // For now, use demo identity for development
      const personId = request.headers['x-person-id'] || 'demo-person-id';
      const workspaceId = request.headers['x-workspace-id'] || 'demo-workspace-id';

      request.user = { personId, workspaceId };

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
        personId,
        workspaceId,
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
