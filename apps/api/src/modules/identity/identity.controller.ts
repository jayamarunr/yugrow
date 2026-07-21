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
} from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { IdentityService } from './identity.service';
import { RequireCapability } from '../../common/decorators/capabilities.decorator';

@ApiTags('Identity Engine')
@Controller('api/v1/identity')
export class IdentityController {
  constructor(private readonly identity: IdentityService) {}

  // ─── Auth ─────────────────────────────────────────────────────

  @Post('auth/login')
  async login(@Body() dto: { email: string; password: string }) {
    return this.identity.login(dto.email, dto.password);
  }

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

  // ─── Roles (delegated to Permission Engine) ─────────────────
  // Role management is handled by the Permission Engine.
  // See PermissionController for role/capability management.
}
