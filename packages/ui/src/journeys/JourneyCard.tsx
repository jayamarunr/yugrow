'use client';

import React from 'react';
import type { Journey, JourneyProgress } from './types';
import { PLATFORMS } from './types';
import { Card } from '../components/Card';
import { Button } from '../components/Button';

interface JourneyCardProps {
  journey: Journey;
  progress?: JourneyProgress;
  onStart: (id: string) => void;
  onResume: (id: string) => void;
  onReset: (id: string) => void;
}

export function JourneyCard({ journey, progress, onStart, onResume, onReset }: JourneyCardProps) {
  const isStarted = !!progress;
  const isCompleted = progress && journey.steps.length > 0
    ? progress.completedSteps.length >= journey.steps.length
    : false;
  const completedCount = progress?.completedSteps.length ?? 0;
  const totalCount = journey.steps.length;
  const progressPercent = totalCount > 0 ? Math.round((completedCount / totalCount) * 100) : 0;

  // Group steps by platform for visual display
  const platformSteps = new Map<string, typeof journey.steps>();
  for (const step of journey.steps) {
    const existing = platformSteps.get(step.platform) ?? [];
    existing.push(step);
    platformSteps.set(step.platform, existing);
  }

  return (
    <Card
      title={
        <span className="flex items-center gap-2">
          <span className="text-xl">{journey.icon}</span>
          <span>{journey.title}</span>
        </span>
      }
      subtitle={
        <span className="text-sm text-[var(--y-text-secondary)]">
          {journey.description}
        </span>
      }
      actions={
        <div className="flex gap-2">
          {isCompleted ? (
            <>
              <span className="text-sm text-[var(--y-state-success)] flex items-center gap-1">
                ✓ Completed
              </span>
              <Button variant="ghost" size="sm" onClick={() => onReset(journey.id)}>
                Redo
              </Button>
            </>
          ) : isStarted ? (
            <Button variant="primary" size="sm" onClick={() => onResume(journey.id)}>
              Resume ({completedCount}/{totalCount})
            </Button>
          ) : (
            <Button variant="primary" size="sm" onClick={() => onStart(journey.id)}>
              Start ({journey.estimatedMinutes} min)
            </Button>
          )}
        </div>
      }
    >
      {/* Progress bar */}
      {isStarted && (
        <div className="mb-4">
          <div className="flex justify-between text-xs text-[var(--y-text-secondary)] mb-1">
            <span>Progress</span>
            <span>{progressPercent}%</span>
          </div>
          <div className="h-1.5 bg-[var(--y-border)] rounded-full overflow-hidden">
            <div
              className="h-full bg-[var(--y-brand-primary)] rounded-full transition-all duration-500"
              style={{ width: `${progressPercent}%` }}
            />
          </div>
        </div>
      )}

      {/* Steps by platform */}
      <div className="space-y-2">
        {Array.from(platformSteps.entries()).map(([platformId, steps]) => {
          const platform = PLATFORMS[platformId as keyof typeof PLATFORMS];
          const stepsCompleted = steps.filter((s) =>
            progress?.completedSteps.includes(s.id)
          ).length;
          return (
            <div key={platformId} className="flex items-center gap-2 text-sm">
              <span className="w-5 text-center">{platform?.icon ?? '📋'}</span>
              <span className="text-[var(--y-text-secondary)] flex-1">
                {platform?.name ?? platformId}
              </span>
              <span className="text-xs text-[var(--y-text-secondary)]">
                {stepsCompleted}/{steps.length}
              </span>
            </div>
          );
        })}
      </div>
    </Card>
  );
}
