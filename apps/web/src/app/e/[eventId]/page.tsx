'use client';

import { useEffect, useState } from 'react';
import { useParams } from 'next/navigation';
import { Button, Card, Skeleton } from '@ui';
import Link from 'next/link';

interface EventData {
  id: string;
  name?: string;
  title?: string;
  description?: string;
  date?: string;
  startTime?: string;
  endTime?: string;
  startDate?: string;
  endDate?: string;
  venue?: {
    name?: string;
    address?: string;
    city?: string;
  } | string;
  topics?: { name: string }[];
  eventType?: string;
  hostName?: string;
  attendeeCount?: number;
  imageUrl?: string;
}

function EventContent({ eventId }: { eventId: string }) {
  const [event, setEvent] = useState<EventData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [interested, setInterested] = useState(false);

  useEffect(() => {
    async function loadEvent() {
      try {
        const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL || ''}/api/v1/checkin/events/${eventId}/public`);
        if (!res.ok) throw new Error('Event not found');
        const data = await res.json();
        setEvent(data);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Failed to load event');
      } finally {
        setLoading(false);
      }
    }
    loadEvent();
  }, [eventId]);

  if (loading) {
    return (
      <div className="max-w-3xl mx-auto px-4 py-12">
        <Skeleton height="2rem" width="60%" className="mb-4" />
        <Skeleton height="1rem" width="40%" className="mb-8" />
        <Skeleton height="12rem" className="mb-6" />
        <Skeleton height="1rem" count={3} />
      </div>
    );
  }

  if (error || !event) {
    return (
      <div className="max-w-3xl mx-auto px-4 py-20 text-center">
        <div className="text-4xl mb-4">📅</div>
        <h1 className="text-2xl font-bold text-[var(--y-text-primary)] mb-2">Event Not Found</h1>
        <p className="text-[var(--y-text-secondary)] mb-6">{error || 'This event does not exist or has been removed.'}</p>
        <Button onClick={() => window.location.href = '/'}>Back to Home</Button>
      </div>
    );
  }

  const startDateObj = new Date(event.startDate || event.startTime || event.date || Date.now());
  const endDateObj = event.endDate ? new Date(event.endDate) : null;
  const formattedDate = startDateObj.toLocaleDateString('en-US', {
    weekday: 'long', month: 'long', day: 'numeric', year: 'numeric',
  });
  const formattedTime = `${startDateObj.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' })}${endDateObj ? ` – ${endDateObj.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' })}` : ''}`;

  return (
    <div className="min-h-screen bg-[var(--y-bg)]">
      {/* Nav */}
      <nav className="flex items-center justify-between px-4 py-3 max-w-5xl mx-auto">
        <Link href="/" className="flex items-center gap-2 text-[var(--y-text-primary)] font-semibold">
          <div className="w-7 h-7 rounded-lg bg-[var(--y-brand-primary)] flex items-center justify-center text-white font-bold text-xs">
            Y
          </div>
          Yugrow
        </Link>
        <Button size="sm" onClick={() => window.location.href = '/login?signup=1'}>
          Download App
        </Button>
      </nav>

      {/* Event Hero */}
      <div className="max-w-3xl mx-auto px-4 pt-8 pb-12">
        {/* Badge */}
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[var(--y-surface)] border border-[var(--y-border)] text-sm text-[var(--y-text-secondary)] mb-6">
          {(event.eventType || 'Event').replace('_', ' ')}
        </div>

        <h1 className="text-3xl md:text-4xl font-bold text-[var(--y-text-primary)] mb-4">
          {event.name || event.title}
        </h1>

        <p className="text-[var(--y-text-secondary)] mb-8 leading-relaxed">
          {event.description || ''}
        </p>

        {/* Event Details */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8">
          <Card padding="md">
            <div className="flex items-start gap-3">
              <span className="text-lg mt-0.5">📅</span>
              <div>
                <div className="font-semibold text-[var(--y-text-primary)] text-sm">Date & Time</div>
                <div className="text-sm text-[var(--y-text-secondary)]">{formattedDate}</div>
                {formattedTime && <div className="text-sm text-[var(--y-text-secondary)]">{formattedTime}</div>}
              </div>
            </div>
          </Card>

          <Card padding="md">
            <div className="flex items-start gap-3">
              <span className="text-lg mt-0.5">📍</span>
              <div>
                <div className="font-semibold text-[var(--y-text-primary)] text-sm">Venue</div>
                <div className="text-sm text-[var(--y-text-secondary)]">{typeof event.venue === 'object' ? event.venue?.name || '' : event.venue || ''}</div>
                <div className="text-sm text-[var(--y-text-secondary)]">{typeof event.venue === 'object' && event.venue ? `${event.venue.address ? event.venue.address + ', ' : ''}${event.venue.city || ''}` : ''}</div>
              </div>
            </div>
          </Card>

          <Card padding="md">
            <div className="flex items-start gap-3">
              <span className="text-lg mt-0.5">👥</span>
              <div>
                <div className="font-semibold text-[var(--y-text-primary)] text-sm">Attendees</div>
                <div className="text-sm text-[var(--y-text-secondary)]">{event.attendeeCount || 0} professionals</div>
              </div>
            </div>
          </Card>

          <Card padding="md">
            <div className="flex items-start gap-3">
              <span className="text-lg mt-0.5">🏢</span>
              <div>
                <div className="font-semibold text-[var(--y-text-primary)] text-sm">Hosted by</div>
                <div className="text-sm text-[var(--y-text-secondary)]">{event.hostName || 'Event Organizer'}</div>
              </div>
            </div>
          </Card>
        </div>

        {/* Topics */}
        {event.topics && event.topics.length > 0 && (
          <div className="mb-8">
            <div className="font-semibold text-[var(--y-text-primary)] text-sm mb-3">Topics</div>
            <div className="flex flex-wrap gap-2">
              {event.topics.map((topic) => (
                <span key={topic.name} className="px-3 py-1 rounded-full bg-[var(--y-surface)] border border-[var(--y-border)] text-sm text-[var(--y-text-secondary)]">
                  {topic.name}
                </span>
              ))}
            </div>
          </div>
        )}

        {/* Actions */}
        <div className="flex flex-col sm:flex-row gap-3">
          <Button size="lg" onClick={() => window.location.href = '/login?signup=1'} className="flex-1">
            Install Yugrow to Network
          </Button>
          <Button
            variant={interested ? 'primary' : 'outline'}
            size="lg"
            onClick={() => setInterested(!interested)}
          >
            {interested ? '⭐ Interested' : '☆ Interested'}
          </Button>
        </div>
        <p className="text-xs text-[var(--y-text-disabled)] mt-3 text-center">
          Networking only begins after you check in at the venue. No app required to browse.
        </p>
      </div>
    </div>
  );
}

export default function EventPage() {
  const params = useParams();
  const eventId = params?.eventId as string;

  if (!eventId) {
    return (
      <div className="max-w-3xl mx-auto px-4 py-20 text-center">
        <h1 className="text-2xl font-bold text-[var(--y-text-primary)]">Event not found</h1>
      </div>
    );
  }

  return <EventContent eventId={eventId} />;
}
