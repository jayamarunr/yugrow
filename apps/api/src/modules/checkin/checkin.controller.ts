// ─── CheckIN MVP Controller ────────────────────────────────────────
// REST API for Venue, Event, Presence, Live Discovery, Connection Flow.

import { Controller, Get, Post, Patch, Delete, Param, Body, Query } from '@nestjs/common';
import { CheckinService } from './checkin.service';
import { Public } from '../../common/decorators/public.decorator';

@Controller('checkin')
export class CheckinController {
  constructor(private readonly checkinService: CheckinService) {}

  // ═════════════════════════════════════════════════════════════════
  // VENUE
  // ═════════════════════════════════════════════════════════════════

  @Get('venues/search')
  async searchVenues(@Query('q') query: string) {
    return this.checkinService.searchVenues(query);
  }

  @Post('venues')
  async createVenue(@Body() body: {
    name: string;
    address?: string;
    latitude?: number;
    longitude?: number;
    city?: string;
    state?: string;
    country?: string;
    createdByPersonId: string;
    ownerWorkspaceId: string;
  }) {
    return this.checkinService.createVenue(body);
  }

  @Get('venues/:id')
  async getVenue(@Param('id') id: string) {
    return this.checkinService.getVenue(id);
  }

  // ═════════════════════════════════════════════════════════════════
  // EVENT
  // ═════════════════════════════════════════════════════════════════

  @Post('events')
  async createEvent(@Body() body: {
    name: string;
    venueId: string;
    organizerWorkspaceId: string;
    startDate: string;
    endDate: string;
  }) {
    return this.checkinService.createEvent(body);
  }

  @Get('events')
  async listActiveEvents(@Query('workspaceId') workspaceId?: string) {
    return this.checkinService.listActiveEvents(workspaceId);
  }

  @Get('events/:id')
  async getEvent(@Param('id') id: string) {
    return this.checkinService.getEvent(id);
  }

  @Public()
  @Get('events/:id/public')
  async getPublicEvent(@Param('id') id: string) {
    return this.checkinService.getEvent(id);
  }

  @Patch('events/:id')
  async updateEvent(
    @Param('id') id: string,
    @Body() body: {
      name?: string;
      startDate?: string;
      endDate?: string;
      status?: 'DRAFT' | 'ACTIVE' | 'COMPLETED' | 'EXPIRED';
      visibility?: 'PUBLIC' | 'PRIVATE' | 'HIDDEN';
      discoverable?: boolean;
    },
  ) {
    return this.checkinService.updateEvent(id, body);
  }

  @Post('events/:id/expire')
  async expireEvent(@Param('id') id: string) {
    return this.checkinService.expireEvent(id);
  }

  @Post('events/:id/duplicate')
  async duplicateEvent(
    @Param('id') id: string,
    @Body('name') name?: string,
  ) {
    return this.checkinService.duplicateEvent(id, name);
  }

  // ═════════════════════════════════════════════════════════════════
  // FOUNDER MODE — Test/Tooling Endpoints (hidden from public API docs)
  // ═════════════════════════════════════════════════════════════════

  @Public()
  @Post('test/login')
  async founderLogin() {
    return this.checkinService.founderLogin();
  }

  @Post('test/seed')
  async seedTestAttendees(
    @Body() body: { eventId: string; count?: number },
  ) {
    return this.checkinService.seedTestAttendees(body.eventId, body.count ?? 20);
  }

  @Post('test/clear-presence')
  async clearPresence(@Body('eventId') eventId?: string) {
    return this.checkinService.clearPresence(eventId);
  }

  @Post('test/reset')
  async resetDemoData() {
    return this.checkinService.resetDemoData();
  }

  @Get('test/status')
  async getTestStatus() {
    return this.checkinService.getTestStatus();
  }

  // ═════════════════════════════════════════════════════════════════
  // PRESENCE ("I'm Here")
  // ═════════════════════════════════════════════════════════════════

  @Post('presence')
  async checkIn(@Body() body: {
    personId: string;
    workspaceId: string;
    eventId: string;
    venueId: string;
  }) {
    return this.checkinService.checkIn(body);
  }

  @Get('presence/active')
  async getActivePresence(@Query('personId') personId: string) {
    return this.checkinService.getActivePresence(personId);
  }

  @Get('live/:eventId')
  async getLiveAttendees(
    @Param('eventId') eventId: string,
    @Query('viewerPersonId') viewerPersonId?: string,
  ) {
    return this.checkinService.getLiveAttendees(eventId, viewerPersonId);
  }

  // ═════════════════════════════════════════════════════════════════
  // CONNECTION FLOW
  // ═════════════════════════════════════════════════════════════════

  @Post('connections')
  async sendConnectionRequest(@Body() body: {
    fromPersonId: string;
    toPersonId: string;
    workspaceId: string;
    eventId: string;
    venueId: string;
    presenceId?: string;
  }) {
    return this.checkinService.sendConnectionRequest(body);
  }

  @Post('connections/:id/accept')
  async acceptRequest(
    @Param('id') id: string,
    @Body('personId') personId: string,
  ) {
    return this.checkinService.acceptConnectionRequest(id, personId);
  }

  @Post('connections/:id/decline')
  async declineRequest(
    @Param('id') id: string,
    @Body('personId') personId: string,
  ) {
    return this.checkinService.declineConnectionRequest(id, personId);
  }

  @Get('connections/incoming/:personId')
  async getIncomingRequests(@Param('personId') personId: string) {
    return this.checkinService.getIncomingRequests(personId);
  }

  @Get('connections/outgoing/:personId')
  async getOutgoingRequests(@Param('personId') personId: string) {
    return this.checkinService.getOutgoingRequests(personId);
  }
}
