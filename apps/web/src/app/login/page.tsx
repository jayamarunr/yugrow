'use client';
import { Suspense, useState } from 'react';
import Link from 'next/link';
import { useRouter, useSearchParams } from 'next/navigation';
import { Button, Input, Card } from '@ui';

function LoginForm() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const router = useRouter();
  const searchParams = useSearchParams();
  const isSignup = searchParams?.get('signup') === '1';

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const res = await fetch('/api/v1/identity/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password }),
      });

      if (!res.ok) {
        const data = await res.json();
        setError(data.error?.message || 'Login failed');
        setLoading(false);
        return;
      }

      router.push('/dashboard');
    } catch {
      setError('Network error. Is the API running?');
    }
  };

  return (
    <main className="min-h-screen flex items-center justify-center bg-[var(--y-bg)] p-4">
      <div className="w-full max-w-sm">
        <div className="flex flex-col items-center mb-8">
          <div className="w-10 h-10 rounded-xl bg-[var(--y-brand-primary)] flex items-center justify-center text-white font-bold mb-4">Y</div>
          <h1 className="text-xl font-bold text-[var(--y-text-primary)]">{isSignup ? 'Create Account' : 'Welcome back'}</h1>
          <p className="text-sm text-[var(--y-text-secondary)] mt-1">
            {isSignup ? 'Start your Yugrow journey' : 'Sign in to Yugrow'}
          </p>
        </div>

        <Card padding="lg">
          <form onSubmit={handleSubmit} className="space-y-4">
            {error && (
              <div className="p-3 rounded-lg bg-red-50 border border-red-200 text-sm text-red-700">
                {error}
              </div>
            )}

            <Input
              label="Email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="you@company.com"
              required
            />
            <Input
              label="Password"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Enter your password"
              required
            />
            <Button type="submit" loading={loading} className="w-full">
              {isSignup ? 'Create Account' : 'Sign In'}
            </Button>
          </form>
        </Card>

        <p className="mt-6 text-center text-sm text-[var(--y-text-secondary)]">
          {isSignup ? 'Already have an account?' : "Don't have an account?"}{' '}
          <Link href="/register" className="text-[var(--y-brand-primary)] hover:underline font-medium">Create one</Link>
        </p>
      </div>
    </main>
  );
}

export default function LoginPage() {
  return (
    <Suspense fallback={<div className="min-h-screen flex items-center justify-center">Loading...</div>}>
      <LoginForm />
    </Suspense>
  );
}
