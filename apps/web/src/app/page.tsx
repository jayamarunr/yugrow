'use client';

import { Button } from '@ui';
import { useRouter } from 'next/navigation';

export default function Home() {
  const router = useRouter();

  return (
    <main className="min-h-screen flex flex-col items-center justify-center bg-[var(--y-bg)] p-4">
      <div className="flex flex-col items-center text-center max-w-md">
        {/* Logo */}
        <div className="w-14 h-14 rounded-2xl bg-[var(--y-brand-primary)] flex items-center justify-center text-white font-bold text-2xl mb-6 shadow-lg">
          Y
        </div>

        <h1 className="text-3xl font-bold text-[var(--y-text-primary)] mb-2">
          Yugrow
        </h1>
        <p className="text-[var(--y-text-secondary)] mb-8 text-lg">
          One Platform. Endless Growth.
        </p>

        <div className="flex gap-3">
          <Button size="lg" onClick={() => router.push('/login')}>
            Sign In
          </Button>
          <Button variant="outline" size="lg" onClick={() => router.push('/login?signup=1')}>
            Create Account
          </Button>
        </div>

        <div className="mt-12 text-xs text-[var(--y-text-secondary)]">
          {new Date().getFullYear()} Yugrow Technologies
        </div>
      </div>
    </main>
  );
}
