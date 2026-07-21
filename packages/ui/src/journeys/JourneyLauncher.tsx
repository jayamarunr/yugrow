'use client';

import React from 'react';
import type { Journey } from './types';
import { Card } from '../components/Card';
import { Button } from '../components/Button';

interface JourneyLauncherProps {
  journeys: Journey[];
  completedJourneys: string[];
  onStartJourney: (id: string) => void;
  onDismiss: () => void;
}

export function JourneyLauncher({
  journeys,
  completedJourneys,
  onStartJourney,
  onDismiss,
}: JourneyLauncherProps) {
  const [selectedCategory, setSelectedCategory] = React.useState<string | null>(null);

  const categories = [
    { id: 'onboarding', label: 'Get Started', icon: '🚀' },
    { id: 'growth', label: 'Find Customers', icon: '🎯' },
    { id: 'networking', label: 'Network', icon: '🔗' },
    { id: 'content', label: 'Create Content', icon: '✍️' },
  ];

  const filteredJourneys = selectedCategory
    ? journeys.filter((j) => j.category === selectedCategory)
    : journeys;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm">
      <div className="bg-[var(--y-bg)] rounded-2xl shadow-2xl w-full max-w-2xl mx-4 max-h-[85vh] overflow-y-auto">
        {/* Header */}
        <div className="p-8 pb-4">
          <div className="flex items-center justify-between mb-2">
            <h1 className="text-2xl font-bold text-[var(--y-text-primary)]">
              Welcome to Yugrow
            </h1>
            <button
              className="text-[var(--y-text-secondary)] hover:text-[var(--y-text-primary)] transition-colors text-sm"
              onClick={onDismiss}
            >
              Skip for now →
            </button>
          </div>
          <p className="text-[var(--y-text-secondary)]">
            What do you want to accomplish today?
          </p>
        </div>

        {/* Category pills */}
        <div className="px-8 pb-4 flex gap-2 flex-wrap">
          {categories.map((cat) => (
            <button
              key={cat.id}
              className={`px-3 py-1.5 rounded-full text-sm transition-colors
                ${
                  selectedCategory === cat.id
                    ? 'bg-[var(--y-brand-primary)] text-white'
                    : 'bg-[var(--y-surface-elevated)] text-[var(--y-text-secondary)] hover:bg-[var(--y-border)]'
                }`}
              onClick={() =>
                setSelectedCategory(selectedCategory === cat.id ? null : cat.id)
              }
            >
              {cat.icon} {cat.label}
            </button>
          ))}
        </div>

        {/* Journey cards */}
        <div className="px-8 pb-8 space-y-3">
          {filteredJourneys.map((journey) => {
            const isCompleted = completedJourneys.includes(journey.id);
            return (
              <button
                key={journey.id}
                className={`w-full text-left p-4 rounded-xl border transition-all
                  ${
                    isCompleted
                      ? 'border-[var(--y-state-success)] bg-[var(--y-state-success)]/5'
                      : 'border-[var(--y-border)] hover:border-[var(--y-brand-primary)] hover:bg-[var(--y-surface-elevated)]'
                  }`}
                onClick={() => onStartJourney(journey.id)}
              >
                <div className="flex items-center gap-4">
                  <span className="text-2xl">{journey.icon}</span>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2">
                      <span className="font-medium text-[var(--y-text-primary)]">
                        {journey.title}
                      </span>
                      {isCompleted && (
                        <span className="text-xs px-1.5 py-0.5 rounded bg-[var(--y-state-success)]/10 text-[var(--y-state-success)]">
                          ✓ Done
                        </span>
                      )}
                    </div>
                    <p className="text-sm text-[var(--y-text-secondary)] mt-0.5">
                      {journey.description}
                    </p>
                    <span className="text-xs text-[var(--y-text-secondary)] mt-1 block">
                      ~{journey.estimatedMinutes} minutes • {journey.steps.length} steps
                    </span>
                  </div>
                  <span className="text-[var(--y-text-secondary)] text-lg">→</span>
                </div>
              </button>
            );
          })}
        </div>

        {/* Footer */}
        <div className="px-8 pb-8 pt-2 border-t border-[var(--y-border)]">
          <div className="flex justify-between items-center">
            <span className="text-xs text-[var(--y-text-secondary)]">
              Pick a journey above, or explore on your own
            </span>
            <Button variant="ghost" size="sm" onClick={onDismiss}>
              Go to dashboard
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
