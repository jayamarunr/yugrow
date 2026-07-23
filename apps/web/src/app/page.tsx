'use client';

import { Button, Card } from '@ui';
import { useRouter } from 'next/navigation';

const FEATURES = [
  {
    icon: '📍',
    title: 'Discover Events',
    description: 'Find professional events, conferences, and meetups happening near you.',
  },
  {
    icon: '✅',
    title: 'Check In',
    description: 'Arrive at the venue and declare your presence with one tap.',
  },
  {
    icon: '👥',
    title: 'Meet Professionals',
    description: 'See who else is here and discover people worth connecting with.',
  },
  {
    icon: '🔗',
    title: 'Connect Instantly',
    description: 'Send connection requests with context — no awkward intros needed.',
  },
  {
    icon: '💬',
    title: 'Continue Conversations',
    description: 'Chat after the event. Relationships outlive the event itself.',
  },
  {
    icon: '⏰',
    title: 'Missed Connections',
    description: 'Discover professionals you missed while they were at the same event.',
  },
];

const STEPS = [
  { number: '1', title: 'Find an Event', description: 'Browse professional events near you or search by topic, city, or date.' },
  { number: '2', title: 'Check In', description: 'Arrive at the venue, tap "I\'m Here," and become discoverable to other attendees.' },
  { number: '3', title: 'Meet People', description: 'See a live feed of professionals around you. Tap to view profiles and connect.' },
  { number: '4', title: 'Stay Connected', description: 'Conversations continue after the event. Your relationships outlive the venue.' },
];

export default function Home() {
  const router = useRouter();

  return (
    <main className="min-h-screen bg-[var(--y-bg)]">
      {/* ─── Navigation ─── */}
      <nav className="flex items-center justify-between px-6 py-4 max-w-6xl mx-auto">
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 rounded-lg bg-[var(--y-brand-primary)] flex items-center justify-center text-white font-bold text-sm">
            Y
          </div>
          <span className="font-semibold text-[var(--y-text-primary)]">Yugrow</span>
        </div>
        <div className="flex items-center gap-3">
          <Button variant="ghost" size="sm" onClick={() => router.push('/login')}>
            Sign In
          </Button>
          <Button size="sm" onClick={() => router.push('/login?signup=1')}>
            Get Started
          </Button>
        </div>
      </nav>

      {/* ─── Hero ─── */}
      <section className="px-6 pt-20 pb-16 max-w-4xl mx-auto text-center">
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[var(--y-surface)] border border-[var(--y-border)] text-sm text-[var(--y-text-secondary)] mb-8">
          <span className="w-2 h-2 rounded-full bg-[var(--y-success)]" />
          Professional Presence Platform
        </div>
        <h1 className="text-4xl md:text-5xl font-bold text-[var(--y-text-primary)] leading-tight mb-4">
          Professional Presence,
          <br />
          for the Real World
        </h1>
        <p className="text-lg text-[var(--y-text-secondary)] max-w-2xl mx-auto mb-10">
          Yugrow helps professionals discover business events, connect with verified attendees,
          and build meaningful relationships that started in person.
        </p>
        <div className="flex items-center justify-center gap-3">
          <Button size="lg" onClick={() => router.push('/login?signup=1')}>
            Download the App
          </Button>
          <Button variant="outline" size="lg" onClick={() => router.push('/login')}>
            Sign In
          </Button>
        </div>
      </section>

      {/* ─── How It Works ─── */}
      <section className="px-6 py-20 max-w-5xl mx-auto">
        <h2 className="text-2xl font-bold text-[var(--y-text-primary)] text-center mb-12">
          How It Works
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          {STEPS.map((step) => (
            <div key={step.number} className="text-center">
              <div className="w-10 h-10 rounded-full bg-[var(--y-brand-primary)] text-white font-bold flex items-center justify-center mx-auto mb-4">
                {step.number}
              </div>
              <h3 className="font-semibold text-[var(--y-text-primary)] mb-2">{step.title}</h3>
              <p className="text-sm text-[var(--y-text-secondary)]">{step.description}</p>
            </div>
          ))}
        </div>
      </section>

      {/* ─── Features ─── */}
      <section className="px-6 py-20 bg-[var(--y-surface)]">
        <div className="max-w-5xl mx-auto">
          <h2 className="text-2xl font-bold text-[var(--y-text-primary)] text-center mb-12">
            Everything You Need
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {FEATURES.map((feature) => (
              <Card key={feature.title} padding="lg" className="text-left">
                <div className="text-2xl mb-3">{feature.icon}</div>
                <h3 className="font-semibold text-[var(--y-text-primary)] mb-1">{feature.title}</h3>
                <p className="text-sm text-[var(--y-text-secondary)]">{feature.description}</p>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* ─── Why Yugrow ─── */}
      <section className="px-6 py-20 max-w-4xl mx-auto">
        <h2 className="text-2xl font-bold text-[var(--y-text-primary)] text-center mb-12">
          Built for Professionals
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {[
            { icon: '✓', text: 'Verified physical presence — not just "interested"' },
            { icon: '✓', text: 'Professional identity tied to your workspace' },
            { icon: '✓', text: 'Networking with context — event, venue, date preserved' },
            { icon: '✓', text: 'Relationships, not followers or friends' },
            { icon: '✓', text: 'Missed connections — discover who you almost met' },
            { icon: '✓', text: '24-hour networking window after every event' },
            { icon: '✓', text: 'Trust evidence built from real interactions' },
            { icon: '✓', text: 'AI never invents relationships — only reveals them' },
          ].map((item) => (
            <div key={item.text} className="flex items-start gap-3">
              <span className="text-[var(--y-success)] font-bold mt-0.5">{item.icon}</span>
              <span className="text-[var(--y-text-primary)]">{item.text}</span>
            </div>
          ))}
        </div>
      </section>

      {/* ─── CTA ─── */}
      <section className="px-6 py-20 bg-[var(--y-surface)] border-t border-[var(--y-border)]">
        <div className="max-w-2xl mx-auto text-center">
          <h2 className="text-2xl font-bold text-[var(--y-text-primary)] mb-4">
            Ready to Build Better Professional Relationships?
          </h2>
          <p className="text-[var(--y-text-secondary)] mb-8">
            Yugrow is currently in validation. Join an upcoming event and experience professional networking that actually works.
          </p>
          <Button size="lg" onClick={() => router.push('/login?signup=1')}>
            Get Started
          </Button>
        </div>
      </section>

      {/* ─── Footer ─── */}
      <footer className="px-6 py-8 border-t border-[var(--y-border)]">
        <div className="max-w-6xl mx-auto flex flex-col md:flex-row items-center justify-between gap-4 text-sm text-[var(--y-text-secondary)]">
          <div className="flex items-center gap-4">
            <a href="/privacy" className="hover:text-[var(--y-text-primary)]">Privacy</a>
            <a href="/terms" className="hover:text-[var(--y-text-primary)]">Terms</a>
            <a href="mailto:hello@yugrow.app" className="hover:text-[var(--y-text-primary)]">Contact</a>
          </div>
          <span>&copy; {new Date().getFullYear()} Yugrow Technologies</span>
        </div>
      </footer>
    </main>
  );
}
