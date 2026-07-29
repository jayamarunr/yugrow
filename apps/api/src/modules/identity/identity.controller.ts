// ─── Yugrow Identity Engine — HTTP Controller ──────────────────────
// Thin controller — delegates all logic to IdentityService.

import {
  Controller,
  Post,
  Get,
  Patch,
  Delete,
  Body,
  Param,
  Req,
} from '@nestjs/common';
import { Request } from 'express';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { IdentityService } from './identity.service';
import { RequireCapability } from '../../common/decorators/capabilities.decorator';
import { Public } from '../../common/decorators/public.decorator';
import { UpdateProfessionalDto } from './dto/professional-identity.dto';

@ApiTags('Identity Engine')
@Controller('identity')
export class IdentityController {
  constructor(private readonly identity: IdentityService) {}

  // ─── Auth ─────────────────────────────────────────────────────

  @Public()
  @Post('auth/login')
  async login(@Body() dto: { email: string; password: string }) {
    return this.identity.login(dto.email, dto.password);
  }

  @Public()
  @Post('auth/register')
  async register(
    @Body() dto: { email: string; password: string; name: string },
  ) {
    return this.identity.register(dto.email, dto.password, dto.name);
  }

  @Post('auth/refresh')
  async refresh(@Body() dto: { refreshToken: string }) {
    return this.identity.refreshToken(dto.refreshToken);
  }

  // ─── Users ────────────────────────────────────────────────────

  @Get('people/me')
  @ApiBearerAuth()
  @RequireCapability('identity.profile.read')
  async getProfile() {
    return this.identity.getPerson('current-person-id');
  }

  @Patch('people/me')
  @ApiBearerAuth()
  @RequireCapability('identity.profile.update')
  async updateProfile(@Body() dto: any) {
    return this.identity.updateProfile('current-person-id', dto);
  }

  @Delete('people/:id')
  @ApiBearerAuth()
  @RequireCapability('identity.people.deactivate')
  async deactivatePerson(@Param('id') id: string) {
    return this.identity.deactivatePerson(id);
  }

  // ─── Professional Identity ─────────────────────────────────────
  // Canonical profile — single source of truth for Discovery,
  // Recommendations, and Opportunity Engine signals.

  @Get('professional/:workspaceId')
  @ApiBearerAuth()
  async getProfessionalIdentity(
    @Param('workspaceId') workspaceId: string,
    @Req() req: Request,
  ) {
    const personId = (req as any).user?.personId;
    return this.identity.getProfessionalIdentity(personId, workspaceId);
  }

  @Patch('professional/:workspaceId')
  @ApiBearerAuth()
  async updateProfessionalIdentity(
    @Param('workspaceId') workspaceId: string,
    @Body() dto: UpdateProfessionalDto,
    @Req() req: Request,
  ) {
    const personId = (req as any).user?.personId;
    return this.identity.updateProfessionalIdentity(personId, workspaceId, dto);
  }

  // ─── Roles (delegated to Permission Engine) ─────────────────
  // Role management is handled by the Permission Engine.
  // See PermissionController for role/capability management.
}
