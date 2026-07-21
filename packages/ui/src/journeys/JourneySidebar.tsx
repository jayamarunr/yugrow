'use client';

import React from 'react';
import type { NavMode } from './types';

interface JourneySidebarProps {
  navMode: NavMode;
  onToggleMode: () => void;
  activeJourneyId: string | null;
  availableJourneys: { id: string; title: string; icon: string; category: string }[];
  completedJourneys: string[];
  onStartJourney: (id: string) => void;
  onOpenWelcome: () => void;
}

export function JourneySidebar({
  navMode,
  onToggleMode,
  activeJourneyId,
  availableJourneys,
  completedJourneys,
  onStartJourney,
  onOpenWelcome,
}: JourneySidebarProps) {
  return (
    <div className="space-y-4">
      {/* Nav Mode Toggle */}
      <button
        className="w-full flex items-center gap-2 px-3 py-2 text-xs font-medium rounded-lg
          bg-[var(--y-surface-elevated)] text-[var(--y-text-secondary)]
          hover:text-[var(--y-text-primary)] transition-colors"
        onClick={onToggleMode}
        title="Toggle between goals and products view"
      >
        <span className="text-sm">
          {navMode === 'goals' ? '🎯' : '📦'}
        </span>
        <span className="flex-1 text-left">
          {navMode === 'goals' ? 'What do you want to do?' : 'Products'}
        </span>
        <span className="text-xs opacity-60">↻</span>
      </button>

      {/* Quick start */}
      {navMode === 'goals' && (
        <>
          <div className="px-3">
            <h3 className="text-xs font-semibold text-[var(--y-text-secondary)] uppercase tracking-wider">
              Quick Start
            </h3>
          </div>

          <div className="space-y-0.5">
            {availableJourneys.map((journey) => {
              const isActive = activeJourneyId === journey.id;
              const isCompleted = completedJourneys.includes(journey.id);
              return (
                <button
                  key={journey.id}
                  className={`w-full flex items-center gap-2 px-3 py-2 text-sm rounded-lg transition-colors
                    ${isActive
                      ? 'bg-[var(--y-brand-primary)]/10 text-[var(--y-brand-primary)] font-medium'
                      : isCompleted
                        ? 'text-[var(--y-state-success)]'
                        : 'text-[var(--y-text-secondary)] hover:text-[var(--y-text-primary)] hover:bg-[var(--y-surface-elevated)]'
                    }`}
                  onClick={() => onStartJourney(journey.id)}
                >
                  <span className="text-base">{journey.icon}</span>
                  <span className="flex-1 text-left truncate">{journey.title}</span>
                  {isCompleted && <span className="text-xs">✓</span>}
                </button>
              );
            })}
          </div>
        </>
      )}

      {/* Bottom: Welcome trigger */}
      <div className="pt-2 border-t border-[var(--y-border)]">
        <button
          className="w-full flex items-center gap-2 px-3 py-2 text-xs text-[var(--y-text-secondary)]
            hover:text-[var(--y-text-primary)] transition-colors rounded-lg"
          onClick={onOpenWelcome}
        >
          <span>🏁</span>
          <span>Show welcome guide</span>
        </button>
      </div>
    </div>
  );
}
