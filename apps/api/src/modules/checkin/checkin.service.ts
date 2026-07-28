// ─── CheckIN MVP Service ──────────────────────────────────────────
// Venue, Event, Presence, Live Discovery, Connection Flow.
// The first Yugrow customer-facing product.

// Product analytics events — tracked for the Meaningful Connections funnel
const ANALYTICS_EVENTS = {
  LIVE_VIEWED: 'checkin.live_viewed',
  PROFILE_VIEWED: 'connection.profile_viewed',
  REQUEST_SENT: 'connection.request_sent',
  REQUEST_ACCEPTED: 'connection.accepted',
  CONVERSATION_STARTED: 'conversation.started',
};

function track(event: string, data: Record<string, any>): void {
  // TODO: Integrate with analytics service / Event Bus
  // For MVP, log to console. Replace with proper event emission.
  if (process.env.NODE_ENV === 'development') {
    console.log(`[Analytics] ${event}`, JSON.stringify(data));
  }
}

import { Injectable, Inject, ConflictException, NotFoundException } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { PRISMA } from '@database/index';
import { CommunicationService } from '../communication/communication.service';
import { IdentityService } from '../identity/identity.service';

@Injectable()
export class CheckinService {
  constructor(
    @Inject(PRISMA) private readonly prisma: PrismaClient,
    private readonly communicationService: CommunicationService,
    private readonly identityService: IdentityService,
  ) {}

  // ═════════════════════════════════════════════════════════════════
  // VENUE
  // ═════════════════════════════════════════════════════════════════

  async searchVenues(query: string) {
    return this.prisma.venue.findMany({
      where: {
        OR: [
          { name: { contains: query, mode: 'insensitive' } },
          { city: { contains: query, mode: 'insensitive' } },
          { address: { contains: query, mode: 'insensitive' } },
        ],
      },
      take: 20,
      orderBy: { name: 'asc' },
    });
  }

  async createVenue(data: {
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
    // Prevent duplicates: check by name + city
    const existing = await this.prisma.venue.findFirst({
      where: {
        name: { equals: data.name, mode: 'insensitive' },
        city: data.city ?? undefined,
      },
    });
    if (existing) {
      throw new ConflictException(`Venue '${data.name}' already exists. Use the existing venue or choose a different name.`);
    }

    return this.prisma.venue.create({ data });
  }

  async getVenue(id: string) {
    const venue = await this.prisma.venue.findUnique({
      where: { id },
      include: { events: { where: { status: 'ACTIVE' }, take: 10 } },
    });
    if (!venue) throw new NotFoundException('Venue not found.');
    return venue;
  }

  // ═════════════════════════════════════════════════════════════════
  // EVENT
  // ═════════════════════════════════════════════════════════════════

  async createEvent(data: {
    name: string;
    venueId: string;
    organizerWorkspaceId: string;
    startDate: string;
    endDate: string;
  }) {
    const venue = await this.prisma.venue.findUnique({ where: { id: data.venueId } });
    if (!venue) throw new NotFoundException('Venue not found.');

    return this.prisma.event.create({
      data: {
        name: data.name,
        venueId: data.venueId,
        organizerWorkspaceId: data.organizerWorkspaceId,
        startDate: new Date(data.startDate),
        endDate: new Date(data.endDate),
        status: 'ACTIVE',
      },
      include: { venue: true },
    });
  }

  async getEvent(id: string) {
    const event = await this.prisma.event.findUnique({
      where: { id },
      include: { venue: true },
    });
    if (!event) throw new NotFoundException('Event not found.');
    return event;
  }

  async listActiveEvents(workspaceId?: string) {
    const now = new Date();
    return this.prisma.event.findMany({
      where: {
        status: 'ACTIVE',
        endDate: { gte: now },
        ...(workspaceId ? { organizerWorkspaceId: workspaceId } : {}),
      },
      include: { venue: true },
      orderBy: { startDate: 'asc' },
      take: 50,
    });
  }

  async expirePastEvents() {
    const now = new Date();
    return this.prisma.event.updateMany({
      where: { endDate: { lt: now }, status: 'ACTIVE' },
      data: { status: 'EXPIRED' },
    });
  }

  // ── Active Presence Check ────────────────────────────────────

  async getActivePresence(personId: string) {
    return this.prisma.presence.findFirst({
      where: {
        personId,
        status: 'ACTIVE',
        expiresAt: { gte: new Date() },
      },
      include: {
        event: { include: { venue: true } },
      },
      orderBy: { startedAt: 'desc' },
    });
  }

  // ── Founder Mode: Update Event ────────────────────────────────

  async updateEvent(
    id: string,
    data: {
      name?: string;
      startDate?: string;
      endDate?: string;
      status?: 'DRAFT' | 'ACTIVE' | 'COMPLETED' | 'EXPIRED';
      visibility?: 'PUBLIC' | 'PRIVATE' | 'HIDDEN';
      discoverable?: boolean;
    },
  ) {
    const event = await this.prisma.event.findUnique({ where: { id } });
    if (!event) throw new NotFoundException('Event not found.');

    const updateData: any = {};
    if (data.name !== undefined) updateData.name = data.name;
    if (data.startDate !== undefined) updateData.startDate = new Date(data.startDate);
    if (data.endDate !== undefined) updateData.endDate = new Date(data.endDate);
    if (data.status !== undefined) updateData.status = data.status;
    if (data.visibility !== undefined) updateData.visibility = data.visibility;
    if (data.discoverable !== undefined) updateData.discoverable = data.discoverable;

    return this.prisma.event.update({
      where: { id },
      data: updateData,
      include: { venue: true },
    });
  }

  // ── Founder Mode: Expire Event (ends event + all active presence) ──

  async expireEvent(id: string) {
    const event = await this.prisma.event.findUnique({ where: { id } });
    if (!event) throw new NotFoundException('Event not found.');

    // Expire all active presence for this event
    await this.prisma.presence.updateMany({
      where: { eventId: id, status: 'ACTIVE' },
      data: { status: 'EXPIRED' },
    });

    // Expire the event itself
    return this.prisma.event.update({
      where: { id },
      data: { status: 'EXPIRED' },
      include: { venue: true },
    });
  }

  // ── Founder Mode: Duplicate Event ─────────────────────────────

  async duplicateEvent(id: string, newName?: string) {
    const source = await this.prisma.event.findUnique({
      where: { id },
      include: { venue: true },
    });
    if (!source) throw new NotFoundException('Event not found.');

    const now = new Date();
    const duration = source.endDate.getTime() - source.startDate.getTime();
    const newStart = new Date(now.getTime() + 60 * 60 * 1000); // start 1h from now
    const newEnd = new Date(newStart.getTime() + duration);

    return this.prisma.event.create({
      data: {
        name: newName ?? `${source.name} (${now.toLocaleDateString('en-IN')})`,
        venueId: source.venueId,
        organizerWorkspaceId: source.organizerWorkspaceId,
        startDate: newStart,
        endDate: newEnd,
        status: 'ACTIVE',
        visibility: source.visibility,
        discoverable: source.discoverable,
      },
      include: { venue: true },
    });
  }

  // ── Founder Mode: Seed Test Attendees ─────────────────────────

  async seedTestAttendees(eventId: string, count: number = 20) {
    const event = await this.prisma.event.findUnique({ where: { id: eventId } });
    if (!event) throw new NotFoundException('Event not found.');

    const testNames = [
      'Rajesh Kumar', 'Ananya Sharma', 'Priya Patel', 'Arun Venkatesh',
      'Deepika Singh', 'Vikram Reddy', 'Kavita Nair', 'Suresh Iyer',
      'Meera Joshi', 'Rahul Kapoor', 'Neha Gupta', 'Aditya Deshmukh',
      'Shruti Menon', 'Karthik Rajan', 'Pooja Mehta', 'Ravi Chandra',
      'Anjali Krishnan', 'Manish Agarwal', 'Divya Saxena', 'Sanjay Pillai',
      'Ishita Basu', 'Rohit Saxena', 'Lakshmi Narayan', 'Akash Jain',
      'Sneha Bhatt', 'Varun Malhotra', 'Nandini Rao', 'Arjun Nair',
      'Tanya George', 'Pranav Kapoor',
    ];

    const testTitles = [
      'Founder & CEO', 'Product Manager', 'Software Engineer',
      'Marketing Lead', 'Design Director', 'Data Scientist',
      'Business Analyst', 'Engineering Manager', 'Growth Hacker',
      'Sales Director', 'CTO', 'COO', 'VP Engineering', 'Tech Lead',
      'Consultant', 'Angel Investor', 'Venture Partner', 'Advisor',
      'Community Manager', 'Event Organizer',
    ];

    const testCompanies = [
      'TechVentures', 'GrowthLabs', 'InnovateAI', 'CloudBase',
      'DataDriven Inc', 'ProductForge', 'DesignStudio', 'ScaleUp',
      'NextGen Corp', 'MarketPulse',
    ];

    const testIndustries = [
      'Technology', 'SaaS', 'AI/ML', 'Fintech', 'Healthcare',
      'E-commerce', 'EdTech', 'Enterprise Software', 'CleanTech',
      'Professional Services',
    ];

    const created = [];

    for (let i = 0; i < Math.min(count, testNames.length); i++) {
      const name = testNames[i];
      const [firstName, ...lastParts] = name.split(' ');
      const lastName = lastParts.join(' ');
      const email = `test.${firstName.toLowerCase()}.${i}@yugrow.test`;

      // Create or find person
      let person = await this.prisma.person.findUnique({ where: { email } });
      if (!person) {
        person = await this.prisma.person.create({
          data: { email, firstName, lastName: lastName || '', status: 'ACTIVE' },
        });
      }

      // Create or find workspace
      const slug = `test-ws-${firstName.toLowerCase()}-${i}`;
      let workspace = await this.prisma.workspace.findUnique({ where: { slug } });
      if (!workspace) {
        workspace = await this.prisma.workspace.create({
          data: { name: `${name}'s Workspace`, slug, type: 'PERSONAL' },
        });
      }

      // Ensure membership
      const existingMember = await this.prisma.membership.findFirst({
        where: { personId: person.id, workspaceId: workspace.id },
      });
      if (!existingMember) {
        await this.prisma.membership.create({
          data: {
            personId: person.id,
            workspaceId: workspace.id,
            membershipType: 'EMPLOYEE',
          },
        });
      }

      // Create or update ProfessionalIdentity
      const existingProf = await this.prisma.professionalIdentity.findUnique({
        where: { personId: person.id },
      });
      const profData = {
        workspaceId: workspace.id,
        name,
        title: testTitles[i % testTitles.length],
        company: testCompanies[i % testCompanies.length],
        industries: [testIndustries[i % testIndustries.length]],
        skills: [testIndustries[i % testIndustries.length], 'Networking', 'Leadership'],
        verified: true,
      };

      if (!existingProf) {
        await this.prisma.professionalIdentity.create({
          data: { personId: person.id, ...profData },
        });
      } else {
        await this.prisma.professionalIdentity.update({
          where: { id: existingProf.id },
          data: profData,
        });
      }

      // Create presence (staggered over the last 30 minutes)
      const minutesAgo = Math.floor(Math.random() * 30);
      const startedAt = new Date(Date.now() - minutesAgo * 60 * 1000);
      const expiresAt = new Date(startedAt.getTime() + 4 * 60 * 60 * 1000);

      const presence = await this.prisma.presence.create({
        data: {
          personId: person.id,
          workspaceId: workspace.id,
          eventId,
          venueId: event.venueId,
          startedAt,
          expiresAt,
          status: 'ACTIVE',
        },
      });

      created.push({ personId: person.id, name, presenceId: presence.id });
    }

    return {
      message: `Seeded ${created.length} test attendees for event '${event.name}'.`,
      count: created.length,
      attendees: created,
    };
  }

  // ── Founder Mode: Clear Presence ──────────────────────────────

  async clearPresence(eventId?: string) {
    const where: any = { status: 'ACTIVE' };
    if (eventId) where.eventId = eventId;

    const result = await this.prisma.presence.updateMany({
      where,
      data: { status: 'EXPIRED' },
    });

    return {
      message: `Expired ${result.count} active presence${eventId ? ` for event ${eventId}` : ''}.`,
      count: result.count,
    };
  }

  // ── Founder Mode: Reset Demo Data ─────────────────────────────

  async resetDemoData() {
    // Delete test data in reverse dependency order
    // Only removes data created by test/seed operations (identified by @yugrow.test email)
    const testPersonEmails = await this.prisma.person.findMany({
      where: { email: { endsWith: '@yugrow.test' } },
      select: { id: true, email: true },
    });
    const testPersonIds = testPersonEmails.map(p => p.id);

    // Delete presences for test persons
    if (testPersonIds.length > 0) {
      await this.prisma.presence.deleteMany({
        where: { personId: { in: testPersonIds } },
      });
    }

    // Delete connection requests involving test persons
    await this.prisma.connectionRequest.deleteMany({
      where: {
        OR: [
          { senderPersonId: { in: testPersonIds } },
          { recipientPersonId: { in: testPersonIds } },
        ],
      },
    });

    // Delete ProfessionalIdentities for test persons
    await this.prisma.professionalIdentity.deleteMany({
      where: { personId: { in: testPersonIds } },
    });

    // Delete memberships for test persons
    await this.prisma.membership.deleteMany({
      where: { personId: { in: testPersonIds } },
    });

    // Delete test workspaces
    await this.prisma.workspace.deleteMany({
      where: { slug: { startsWith: 'test-ws-' } },
    });

    // Delete test persons
    await this.prisma.person.deleteMany({
      where: { id: { in: testPersonIds } },
    });

    return {
      message: `Reset complete. Removed ${testPersonIds.length} test attendees and related data.`,
      removedAttendees: testPersonIds.length,
    };
  }

  // ── Founder Mode: Test Status (for banner) ────────────────────

  async getTestStatus() {
    // Find persons with test email suffix
    const testPersonEmails = await this.prisma.person.findMany({
      where: { email: { endsWith: '@yugrow.test' } },
      select: { id: true },
    });
    const testPersonIds = testPersonEmails.map(p => p.id);

    // Count active test presence
    const activeTestPresence = testPersonIds.length > 0
      ? await this.prisma.presence.findMany({
          where: {
            personId: { in: testPersonIds },
            status: 'ACTIVE',
            expiresAt: { gte: new Date() },
          },
          include: {
            event: { select: { id: true, name: true } },
          },
        })
      : [];

    // Count total active presence per event affected by test data
    const eventIds = [...new Set(activeTestPresence.map(p => p.eventId))];
    const events = await Promise.all(
      eventIds.map(async (eventId) => {
        const event = activeTestPresence.find(p => p.eventId === eventId)?.event;
        const totalActive = await this.prisma.presence.count({
          where: { eventId, status: 'ACTIVE', expiresAt: { gte: new Date() } },
        });
        const seededActive = activeTestPresence.filter(p => p.eventId === eventId).length;
        return {
          eventId,
          eventName: event?.name ?? 'Unknown',
          totalAttendees: totalActive,
          realAttendees: totalActive - seededActive,
          seededAttendees: seededActive,
        };
      }),
    );

    return {
      hasSeededAttendees: activeTestPresence.length > 0,
      totalSeededActive: activeTestPresence.length,
      events,
    };
  }

  // ── Founder Demo Login ───────────────────────────────────────

  async founderLogin() {
    const email = 'founder@yugrow.test';
    const name = 'Jayam (Founder)';

    // Find or create founder person
    let person = await this.prisma.person.findUnique({ where: { email } });
    if (!person) {
      person = await this.prisma.person.create({
        data: { email, firstName: 'Jayam', lastName: '(Founder)', status: 'ACTIVE' },
      });
    }

    // Find or create personal workspace
    const slug = 'founder-yugrow';
    let workspace = await this.prisma.workspace.findUnique({ where: { slug } });
    if (!workspace) {
      workspace = await this.prisma.workspace.create({
        data: { name: "Jayam's Workspace", slug, type: 'PERSONAL' },
      });
    }

    // Ensure membership
    const existingMember = await this.prisma.membership.findFirst({
      where: { personId: person.id, workspaceId: workspace.id },
    });
    if (!existingMember) {
      await this.prisma.membership.create({
        data: {
          personId: person.id,
          workspaceId: workspace.id,
          membershipType: 'OWNER',
        },
      });
    }

    // Ensure professional identity
    const existingProf = await this.prisma.professionalIdentity.findUnique({
      where: { personId: person.id },
    });
    if (!existingProf) {
      await this.prisma.professionalIdentity.create({
        data: {
          personId: person.id,
          workspaceId: workspace.id,
          name,
          title: 'Founder',
          company: 'Yugrow',
          industries: ['Technology', 'SaaS'],
          skills: ['AI', 'CRM', 'Product Strategy'],
          lookingFor: 'Co-founders, investors, and strategic partners',
          verified: true,
        },
      });
    }

    // Generate a real JWT via IdentityService
    const token = await this.identityService.generateToken(person.id, person.email, workspace.id);

    return {
      token,
      person: {
        id: person.id,
        email: person.email,
        name,
      },
      workspace: {
        id: workspace.id,
        name: workspace.name,
      },
    };
  }

  // ═════════════════════════════════════════════════════════════════
  // PRESENCE
  // ═════════════════════════════════════════════════════════════════

  async checkIn(data: {
    personId: string;
    workspaceId: string;
    eventId: string;
    venueId: string;
    expiresAt?: string;
  }) {
    // Verify event exists and is active
    const event = await this.prisma.event.findUnique({ where: { id: data.eventId } });
    if (!event) throw new NotFoundException('Event not found.');
    if (event.status !== 'ACTIVE') throw new ConflictException('Event is not active.');

    // Verify event time window — cannot check in before event starts or after it ends
    const now = new Date();
    if (now < event.startDate) {
      const diff = event.startDate.getTime() - now.getTime();
      const hours = Math.floor(diff / 3600000);
      const minutes = Math.floor((diff % 3600000) / 60000);
      throw new ConflictException(
        `Event starts in ${hours > 0 ? `${hours}h ` : ''}${minutes}m. Check-in opens when the event begins.`
      );
    }
    if (now > event.endDate) {
      throw new ConflictException('This event has already ended.');
    }

    // End any existing active presence for this person
    await this.prisma.presence.updateMany({
      where: { personId: data.personId, status: 'ACTIVE' },
      data: { status: 'EXPIRED' },
    });

    const expiresAt = data.expiresAt
      ? new Date(data.expiresAt)
      : new Date(Date.now() + 4 * 60 * 60 * 1000); // default: 4 hours

    const presence = await this.prisma.presence.create({
      data: {
        personId: data.personId,
        workspaceId: data.workspaceId,
        eventId: data.eventId,
        venueId: data.venueId,
        expiresAt,
        status: 'ACTIVE',
      },
      include: {
        event: { include: { venue: true } },
      },
    });

    return presence;
  }

  async expirePresence(presenceId: string) {
    const presence = await this.prisma.presence.findUnique({ where: { id: presenceId } });
    if (!presence) throw new NotFoundException('Presence not found.');

    return this.prisma.presence.update({
      where: { id: presenceId },
      data: { status: 'EXPIRED' },
    });
  }

  async expireStalePresences() {
    const now = new Date();
    return this.prisma.presence.updateMany({
      where: { expiresAt: { lt: now }, status: 'ACTIVE' },
      data: { status: 'EXPIRED' },
    });
  }

  // ═════════════════════════════════════════════════════════════════
  // LIVE DISCOVERY
  // ═════════════════════════════════════════════════════════════════

  async getLiveAttendees(eventId: string, viewerPersonId?: string) {
    track(ANALYTICS_EVENTS.LIVE_VIEWED, { eventId, viewerPersonId, timestamp: new Date().toISOString() });
    const activePresences = await this.prisma.presence.findMany({
      where: {
        eventId,
        status: 'ACTIVE',
        expiresAt: { gte: new Date() },
      },
      include: {
        event: { include: { venue: true } },
      },
      orderBy: { startedAt: 'desc' },
    });

    // For each presence, gather person info, professional identity, and mutual connections
    const attendees = await Promise.all(
      activePresences.map(async (presence) => {
        const person = await this.prisma.person.findUnique({
          where: { id: presence.personId },
          select: { id: true, firstName: true, lastName: true, email: true },
        });

        const professional = await this.prisma.professionalIdentity.findFirst({
          where: { personId: presence.personId, workspaceId: presence.workspaceId },
        });

        // Count mutual connections if viewer is present
        let mutualCount = 0;
        if (viewerPersonId && presence.personId !== viewerPersonId) {
          mutualCount = await this.countMutualConnections(viewerPersonId, presence.personId);
        }

        return {
          personId: presence.personId,
          name: professional?.name ?? (person ? `${person.firstName ?? ''} ${person.lastName ?? ''}`.trim() : 'Unknown'),
          title: professional?.title ?? null,
          company: professional?.company ?? null,
          industry: professional && professional.industries && professional.industries.length > 0 ? professional.industries[0] : null,
          skills: professional?.skills ?? [],
          lookingFor: professional?.lookingFor ?? null,
          bio: professional?.bio ?? null,
          avatarUrl: professional?.avatarUrl ?? null,
          verified: professional?.verified ?? false,
          workspaceId: presence.workspaceId,
          checkedInAt: presence.startedAt,
          expiresAt: presence.expiresAt,
          mutualConnections: mutualCount,
          eventName: presence.event.name,
          venueName: presence.event.venue.name,
        };
      }),
    );

    // Sort: mutual connections first, then by check-in time
    attendees.sort((a, b) => {
      if (b.mutualConnections !== a.mutualConnections) {
        return b.mutualConnections - a.mutualConnections;
      }
      return b.checkedInAt.getTime() - a.checkedInAt.getTime();
    });

    return attendees;
  }

  private async countMutualConnections(personA: string, personB: string): Promise<number> {
    // Count relationships where both people are connected to the same third person
    const relationships = await this.prisma.relationship.findMany({
      where: {
        OR: [
          { sourceEntityType: 'person', sourceEntityId: personA },
          { targetEntityType: 'person', targetEntityId: personA },
        ],
        status: 'CONNECTED',
      },
      select: {
        sourceEntityId: true,
        targetEntityId: true,
      },
    });

    const aConnections = new Set<string>();
    for (const rel of relationships) {
      if (rel.sourceEntityId === personA) aConnections.add(rel.targetEntityId);
      if (rel.targetEntityId === personA) aConnections.add(rel.sourceEntityId);
    }

    const bRelationships = await this.prisma.relationship.findMany({
      where: {
        OR: [
          { sourceEntityType: 'person', sourceEntityId: personB },
          { targetEntityType: 'person', targetEntityId: personB },
        ],
        status: 'CONNECTED',
      },
      select: {
        sourceEntityId: true,
        targetEntityId: true,
      },
    });

    let mutual = 0;
    for (const rel of bRelationships) {
      const bConn = rel.sourceEntityId === personB ? rel.targetEntityId : rel.sourceEntityId;
      if (aConnections.has(bConn)) mutual++;
    }

    return mutual;
  }

  // ═════════════════════════════════════════════════════════════════
  // CONNECTION FLOW
  // ═════════════════════════════════════════════════════════════════

  async sendConnectionRequest(data: {
    fromPersonId: string;
    toPersonId: string;
    workspaceId: string;
    eventId: string;
    venueId: string;
    presenceId?: string;
  }) {
    // Check for existing pending request
    const existing = await this.prisma.connectionRequest.findFirst({
      where: {
        senderPersonId: data.fromPersonId,
        recipientPersonId: data.toPersonId,
        status: 'PENDING',
      },
    });
    if (existing) throw new ConflictException('Connection request already sent.');

    // Store event context in message field as JSON
    const eventContext = JSON.stringify({
      eventId: data.eventId,
      venueId: data.venueId,
      timestamp: new Date().toISOString(),
      presenceId: data.presenceId,
    });

    track(ANALYTICS_EVENTS.REQUEST_SENT, { fromPersonId: data.fromPersonId, toPersonId: data.toPersonId, eventId: data.eventId, timestamp: new Date().toISOString() });

    // Look up a default relationship type for networking
    const defaultType = await this.prisma.relationshipType.findFirst({
      where: { isSystem: true, name: 'Network' },
    });

    const request = await this.prisma.connectionRequest.create({
      data: {
        workspaceId: data.workspaceId,
        senderPersonId: data.fromPersonId,
        recipientPersonId: data.toPersonId,
        message: eventContext,
        status: 'PENDING',
        relationshipTypeId: defaultType?.id ?? null,
        expiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000), // 24-hour window
      },
    });

    return request;
  }

  async acceptConnectionRequest(requestId: string, accepterPersonId: string) {
    const request = await this.prisma.connectionRequest.findUnique({
      where: { id: requestId },
    });
    if (!request) throw new NotFoundException('Connection request not found.');
    if (request.recipientPersonId !== accepterPersonId) {
      throw new ConflictException('You can only accept requests sent to you.');
    }
    if (request.status !== 'PENDING') {
      throw new ConflictException('Request is no longer pending.');
    }

    // Parse event context from message
    let eventContext: Record<string, any> = {};
    try {
      eventContext = JSON.parse(request.message ?? '{}');
    } catch {}

    // Look up a default relationship type
    const defaultType = await this.prisma.relationshipType.findFirst({
      where: { isSystem: true, name: 'Network' },
    });
    const typeId = defaultType?.id ?? request.relationshipTypeId;

    track(ANALYTICS_EVENTS.REQUEST_ACCEPTED, { requestId, accepterPersonId, senderPersonId: request.senderPersonId, timestamp: new Date().toISOString() });

    // Create the relationship with origin preserved
    const relationship = await this.prisma.relationship.create({
      data: {
        workspaceId: request.workspaceId,
        typeId: typeId!,
        sourceEntityType: 'person',
        sourceEntityId: request.senderPersonId,
        targetEntityType: 'person',
        targetEntityId: request.recipientPersonId,
        status: 'CONNECTED',
        strength: 0.5,
        contexts: {
          create: {
            source: 'checkin',
            sourceDetail: `Event: ${eventContext.eventId ?? 'unknown'}, Venue: ${eventContext.venueId ?? 'unknown'}`,
            firstMetAt: eventContext.timestamp ? new Date(eventContext.timestamp) : new Date(),
            tags: ['checkin', 'event-networking'],
            notes: `Connected via CheckIN at event ${eventContext.eventId}`,
          },
        },
      },
    });

    // Update request status
    await this.prisma.connectionRequest.update({
      where: { id: requestId },
      data: { status: 'ACCEPTED' },
    });

    // Auto-create conversation for the new relationship
    const conversation = await this.communicationService.createConversation(
      relationship.id,
      {
        contextType: 'event',
        contextId: eventContext.eventId,
      },
    );

    track(ANALYTICS_EVENTS.CONVERSATION_STARTED, {
      relationshipId: relationship.id,
      conversationId: conversation.id,
      eventId: eventContext.eventId,
    });

    return { relationship, conversation, requestId };
  }

  async declineConnectionRequest(requestId: string, declinerPersonId: string) {
    const request = await this.prisma.connectionRequest.findUnique({
      where: { id: requestId },
    });
    if (!request) throw new NotFoundException('Connection request not found.');
    if (request.recipientPersonId !== declinerPersonId) {
      throw new ConflictException('You can only decline requests sent to you.');
    }

    return this.prisma.connectionRequest.update({
      where: { id: requestId },
      data: { status: 'DECLINED' },
    });
  }

  async getIncomingRequests(personId: string) {
    return this.prisma.connectionRequest.findMany({
      where: { recipientPersonId: personId, status: 'PENDING' },
      orderBy: { createdAt: 'desc' },
    });
  }

  async getOutgoingRequests(personId: string) {
    return this.prisma.connectionRequest.findMany({
      where: { senderPersonId: personId },
      orderBy: { createdAt: 'desc' },
    });
  }

  // ═════════════════════════════════════════════════════════════════
  // FOUNDER MODE — Conversation & Message Seeding
  // ═════════════════════════════════════════════════════════════════

  async generateTestConversations(eventId: string) {
    const event = await this.prisma.event.findUnique({ where: { id: eventId } });
    if (!event) throw new NotFoundException('Event not found.');

    // Find test attendees currently checked in
    const activePresences = await this.prisma.presence.findMany({
      where: { eventId, status: 'ACTIVE', expiresAt: { gte: new Date() } },
      orderBy: { startedAt: 'asc' },
    });

    // Get person records for each presence
    const personIds = activePresences.map(p => p.personId);
    const persons = await this.prisma.person.findMany({
      where: { id: { in: personIds } },
    });
    const personMap = new Map(persons.map(p => [p.id, p]));

    const testPresences = activePresences.filter(p => {
      const person = personMap.get(p.personId);
      return person?.email.endsWith('@yugrow.test');
    });

    if (testPresences.length < 2) {
      return {
        message: 'Need at least 2 test attendees to generate conversations.',
        conversationsCreated: 0,
      };
    }

    const sampleMessages = [
      'Hey! Great connecting at the event. Would love to catch up over coffee sometime.',
      'Thanks for the chat earlier. Your work on AI is really impressive!',
      'Loved discussing the industry trends with you. Let\'s stay in touch.',
      'Hey, I was thinking about what you said regarding the partnership opportunity. Let\'s explore it.',
      'Great meeting you! I\'d love to introduce you to my co-founder.',
      'Thanks for the insights on the market. Really valuable perspective.',
    ];

    let conversationsCreated = 0;

    // Create connections between adjacent test attendees
    for (let i = 0; i < testPresences.length - 1; i++) {
      const personA = testPresences[i];
      const personB = testPresences[i + 1];

      // Check if connection already exists
      const existingRel = await this.prisma.relationship.findFirst({
        where: {
          OR: [
            { sourceEntityId: personA.personId, targetEntityId: personB.personId },
            { sourceEntityId: personB.personId, targetEntityId: personA.personId },
          ],
        },
      });

      if (existingRel) continue;

      // Create relationship
      const defaultType = await this.prisma.relationshipType.findFirst({
        where: { isSystem: true, name: 'Network' },
      });

      const relationship = await this.prisma.relationship.create({
        data: {
          workspaceId: 'personal',
          typeId: defaultType?.id ?? '',
          sourceEntityType: 'person',
          sourceEntityId: personA.personId,
          targetEntityType: 'person',
          targetEntityId: personB.personId,
          status: 'CONNECTED' as any,
        },
      });

      // Create conversation
      const conversation = await this.prisma.conversation.create({
        data: {
          relationshipId: relationship.id,
          contextType: 'EVENT',
          contextId: eventId,
        },
      });

      // Create a couple of messages
      const msg1 = sampleMessages[i % sampleMessages.length];
      const msg2 = sampleMessages[(i + 3) % sampleMessages.length];

      await this.prisma.message.create({
        data: {
          conversationId: conversation.id,
          senderPersonId: personA.personId,
          content: msg1,
        },
      });

      await this.prisma.message.create({
        data: {
          conversationId: conversation.id,
          senderPersonId: personB.personId,
          content: msg2,
        },
      });

      conversationsCreated++;
    }

    return {
      message: `Generated ${conversationsCreated} conversations with sample messages.`,
      conversationsCreated,
      totalAttendees: activePresences.length,
      testAttendeesUsed: testPresences.length,
    };
  }
}
