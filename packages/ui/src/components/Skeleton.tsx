// ─── Skeleton Loading States ────────────────────────────────────────

import React from 'react';

interface SkeletonProps {
  width?: string;
  height?: string;
  rounded?: 'sm' | 'md' | 'lg' | 'full';
  className?: string;
  count?: number;
}

const roundedStyles = {
  sm: 'rounded-sm',
  md: 'rounded-md',
  lg: 'rounded-lg',
  full: 'rounded-full',
};

export function Skeleton({
  width = '100%',
  height = '1rem',
  rounded = 'md',
  className = '',
  count = 1,
}: SkeletonProps) {
  const items = Array.from({ length: count }, (_, i) => i);

  return (
    <>
      {items.map((i) => (
        <div
          key={i}
          className={`animate-pulse bg-[var(--y-border)] ${roundedStyles[rounded]} ${className}`}
          style={{ width, height, marginBottom: count > 1 ? '0.5rem' : undefined }}
        />
      ))}
    </>
  );
}

export function CardSkeleton() {
  return (
    <div className="rounded-xl border border-[var(--y-border)] bg-[var(--y-surface)] p-4 space-y-3">
      <Skeleton width="40%" height="1.25rem" />
      <Skeleton width="100%" height="0.75rem" count={3} />
      <Skeleton width="60%" height="2rem" rounded="lg" />
    </div>
  );
}
