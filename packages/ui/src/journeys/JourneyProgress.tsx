'use client';

import React from 'react';
import type { Journey, JourneyProgress as JourneyProgressType } from './types';
import { PLATFORMS } from './types';

interface JourneyProgressProps {
  journey: Journey;
  progress: JourneyProgressType;
  onStepClick: (stepId: string) => void;
  onCompleteStep: (stepId: string) => void;
  onSkipStep: (stepId: string) => void;
}

export function JourneyProgress({
  journey,
  progress,
  onStepClick,
  onCompleteStep,
  onSkipStep,
}: JourneyProgressProps) {
  const totalSteps = journey.steps.length;
  const completedCount = progress.completedSteps.length;
  const progressPercent = totalSteps > 0 ? Math.round((completedCount / totalSteps) * 100) : 0;

  return (
    <div className="space-y-4">
      {/* Header */}
      <div className="flex items-center gap-3">
        <span className="text-2xl">{journey.icon}</span>
        <div className="flex-1">
          <h2 className="text-lg font-semibold text-[var(--y-text-primary)]">{journey.title}</h2>
          <p className="text-sm text-[var(--y-text-secondary)]">{journey.description}</p>
        </div>
        <div className="text-right">
          <div className="text-2xl font-bold text-[var(--y-brand-primary)]">{progressPercent}%</div>
          <div className="text-xs text-[var(--y-text-secondary)]">
            {completedCount} of {totalSteps} steps
          </div>
        </div>
      </div>

      {/* Progress bar */}
      <div className="h-2 bg-[var(--y-border)] rounded-full overflow-hidden">
        <div
          className="h-full bg-[var(--y-brand-primary)] rounded-full transition-all duration-700 ease-out"
          style={{ width: `${progressPercent}%` }}
        />
      </div>

      {/* Steps */}
      <div className="space-y-2">
        {journey.steps.map((step, index) => {
          const isCompleted = progress.completedSteps.includes(step.id);
          const isSkipped = progress.skippedSteps.includes(step.id);
          const isActive = progress.currentStepId === step.id;
          const isLocked =
            !isCompleted &&
            !isSkipped &&
            (step.dependencies ?? []).some((dep) => !progress.completedSteps.includes(dep));

          const platform = PLATFORMS[step.platform];

          let statusIcon: string;
          let statusColor: string;
          if (isCompleted) {
            statusIcon = '✓';
            statusColor = 'text-[var(--y-state-success)]';
          } else if (isSkipped) {
            statusIcon = '—';
            statusColor = 'text-[var(--y-text-secondary)]';
          } else if (isActive) {
            statusIcon = '●';
            statusColor = 'text-[var(--y-brand-primary)]';
          } else if (isLocked) {
            statusIcon = '🔒';
            statusColor = 'text-[var(--y-text-disabled)]';
          } else {
            statusIcon = '○';
            statusColor = 'text-[var(--y-text-secondary)]';
          }

          return (
            <div
              key={step.id}
              className={`flex items-start gap-3 p-3 rounded-lg cursor-pointer transition-colors
                ${isActive ? 'bg-[var(--y-surface-elevated)] ring-1 ring-[var(--y-brand-primary)]' : 'hover:bg-[var(--y-surface-elevated)]'}
                ${isCompleted ? 'opacity-70' : ''}`}
              onClick={() => onStepClick(step.id)}
              role="button"
              tabIndex={0}
              onKeyDown={(e) => e.key === 'Enter' && onStepClick(step.id)}
            >
              {/* Status indicator */}
              <div className={`w-6 h-6 flex items-center justify-center text-sm font-bold mt-0.5 ${statusColor}`}>
                {statusIcon}
              </div>

              {/* Step content */}
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2">
                  <span className="text-xs text-[var(--y-text-secondary)]">Step {index + 1}</span>
                  {platform && (
                    <span className="text-xs px-1.5 py-0.5 rounded bg-[var(--y-surface-elevated)] text-[var(--y-text-secondary)]">
                      {platform.icon} {platform.name}
                    </span>
                  )}
                  {step.estimatedMinutes > 0 && (
                    <span className="text-xs text-[var(--y-text-secondary)]">
                      ~{step.estimatedMinutes} min
                    </span>
                  )}
                </div>
                <h3 className={`text-sm font-medium mt-0.5 ${isCompleted ? 'line-through text-[var(--y-text-secondary)]' : 'text-[var(--y-text-primary)]'}`}>
                  {step.title}
                </h3>
                <p className="text-xs text-[var(--y-text-secondary)] mt-0.5 line-clamp-1">
                  {step.description}
                </p>
                {step.aiPrompt && (
                  <div className="flex items-center gap-1 mt-1 text-xs text-[var(--y-state-info)]">
                    <span>🤖</span>
                    <span>AI can help</span>
                  </div>
                )}
              </div>

              {/* Actions */}
              <div className="flex flex-col gap-1 shrink-0">
                {!isCompleted && !isSkipped && !isLocked && (
                  <button
                    className="text-xs px-2 py-1 rounded bg-[var(--y-brand-primary)] text-white hover:opacity-90 transition-opacity"
                    onClick={(e) => {
                      e.stopPropagation();
                      onCompleteStep(step.id);
                    }}
                  >
                    Done
                  </button>
                )}
                {!isCompleted && !isSkipped && !isLocked && (
                  <button
                    className="text-xs px-2 py-1 rounded text-[var(--y-text-secondary)] hover:bg-[var(--y-surface-elevated)] transition-colors"
                    onClick={(e) => {
                      e.stopPropagation();
                      onSkipStep(step.id);
                    }}
                  >
                    Skip
                  </button>
                )}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
