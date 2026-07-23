'use client';

// ─── Yugrow Dashboard — Platform Home ──────────────────────────────
// Widget-based dashboard with Journey Engine onboarding.

import {
  Card, CardSkeleton, EmptyState, DashboardGrid,
  registerWidget, getAllWidgets,
  JourneyLauncher, JourneyCard, useJourneys,
} from '@ui';
import { useEffect, useState } from 'react';

// Demo widgets
registerWidget({
  id: 'recent-activity',
  title: 'Recent Activity',
  component: () => (
    <div className="space-y-3">
      {[
        { action: 'New lead created', product: 'CRM', time: '5m ago' },
        { action: 'Invoice paid', product: 'Finance', time: '1h ago' },
        { action: 'Blog published', product: 'Content', time: '3h ago' },
        { action: 'Broadcast sent', product: 'Broadcast', time: '5h ago' },
      ].map((item, i) => (
        <div key={i} className="flex items-center justify-between py-1">
          <div>
            <p className="text-sm text-[var(--y-text-primary)]">{item.action}</p>
            <span className="text-[10px] text-[var(--y-brand-primary)]">{item.product}</span>
          </div>
          <span className="text-xs text-[var(--y-text-secondary)]">{item.time}</span>
        </div>
      ))}
    </div>
  ),
  defaultWidth: 'half',
});

registerWidget({
  id: 'quick-stats',
  title: 'Quick Stats',
  component: () => (
    <div className="grid grid-cols-2 gap-3">
      {[
        { label: 'Open Deals', value: '12', change: '+2' },
        { label: 'Pending Invoices', value: '$8,450', change: '-$1,200' },
        { label: 'Active Broadcasts', value: '3', change: '+1' },
        { label: 'Unread Messages', value: '7', change: '-3' },
      ].map((stat, i) => (
        <div key={i} className="p-3 rounded-lg bg-[var(--y-bg)] border border-[var(--y-border)]">
          <p className="text-xs text-[var(--y-text-secondary)]">{stat.label}</p>
          <p className="text-lg font-bold text-[var(--y-text-primary)] mt-1">{stat.value}</p>
          <p className="text-xs text-green-600 mt-0.5">{stat.change}</p>
        </div>
      ))}
    </div>
  ),
  defaultWidth: 'half',
});

registerWidget({
  id: 'upcoming-events',
  title: 'Upcoming Events',
  component: () => (
    <div className="space-y-2">
      <EmptyState
        title="No upcoming events"
        description="Create your first event in CheckIN"
        action={{ label: 'Create Event', onClick: () => {} }}
      />
    </div>
  ),
  defaultWidth: 'third',
});

export default function Dashboard() {
  const [loading, setLoading] = useState(true);
  const widgets = getAllWidgets();

  const {
    state,
    journeys,
    activeJourney,
    activeProgress,
    startJourney,
    completeStep,
    skipStep,
    setCurrentStep,
    resetJourney,
    dismissWelcome,
    getAvailableJourneys,
    getCoachMessage,
    getAchievements,
  } = useJourneys();

  const availableJourneys = getAvailableJourneys();
  const coachMessage = getCoachMessage();
  const achievements = getAchievements();

  useEffect(() => {
    const t = setTimeout(() => setLoading(false), 500);
    return () => clearTimeout(t);
  }, []);

  if (loading) {
    return (
      <div className="space-y-4">
        <h1 className="text-xl font-bold text-[var(--y-text-primary)]">Dashboard</h1>
        <div className="grid grid-cols-3 gap-4">
          <div className="col-span-2"><CardSkeleton /></div>
          <div className="col-span-1"><CardSkeleton /></div>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Welcome Launcher — shown on first visit */}
      {state.showWelcome && (
        <JourneyLauncher
          journeys={journeys}
          completedJourneys={state.completedJourneys}
          onStartJourney={startJourney}
          onDismiss={dismissWelcome}
        />
      )}

      {/* Active Journey Progress */}
      {activeJourney && activeProgress && (
        <div className="bg-[var(--y-surface-elevated)] rounded-xl p-6 border border-[var(--y-border)]">
          {/* Quick progress component */}
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-3">
              <span className="text-2xl">{activeJourney.icon}</span>
              <div>
                <h2 className="text-lg font-semibold text-[var(--y-text-primary)]">
                  {activeJourney.title}
                </h2>
                <p className="text-sm text-[var(--y-text-secondary)]">
                  {activeProgress.completedSteps.length} of {activeJourney.steps.length} steps completed
                </p>
              </div>
            </div>
            <button
              className="text-sm text-[var(--y-text-secondary)] hover:text-[var(--y-text-primary)] transition-colors"
              onClick={() => resetJourney(activeJourney.id)}
            >
              Reset journey
            </button>
          </div>

          {/* Step list */}
          <div className="space-y-2">
            {activeJourney.steps.map((step) => {
              const isCompleted = activeProgress.completedSteps.includes(step.id);
              const isSkipped = activeProgress.skippedSteps.includes(step.id);
              const isActive = activeProgress.currentStepId === step.id;
              const isLocked =
                !isCompleted && !isSkipped &&
                (step.dependencies ?? []).some((dep) => !activeProgress.completedSteps.includes(dep));

              let statusIcon: string;
              let statusClass: string;
              if (isCompleted) { statusIcon = '✓'; statusClass = 'bg-green-500/10 text-green-500'; }
              else if (isSkipped) { statusIcon = '—'; statusClass = 'bg-gray-500/10 text-gray-400'; }
              else if (isActive) { statusIcon = '●'; statusClass = 'bg-blue-500/10 text-blue-500'; }
              else if (isLocked) { statusIcon = '🔒'; statusClass = 'bg-gray-500/5 text-gray-300'; }
              else { statusIcon = '○'; statusClass = 'bg-gray-500/10 text-gray-400'; }

              return (
                <div
                  key={step.id}
                  className={`flex items-center gap-3 p-3 rounded-lg cursor-pointer transition-colors
                    ${isActive ? 'ring-1 ring-[var(--y-brand-primary)]' : 'hover:bg-[var(--y-bg)]'}`}
                  onClick={() => setCurrentStep(activeJourney.id, step.id)}
                >
                  <div className={`w-7 h-7 rounded-full flex items-center justify-center text-sm ${statusClass}`}>
                    {statusIcon}
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className={`text-sm ${isCompleted ? 'line-through text-[var(--y-text-secondary)]' : 'text-[var(--y-text-primary)]'}`}>
                      {step.title}
                    </p>
                    <p className="text-xs text-[var(--y-text-secondary)] truncate">{step.description}</p>
                  </div>
                  {!isCompleted && !isSkipped && !isLocked && (
                    <div className="flex gap-1 shrink-0">
                      <button
                        className="text-xs px-2 py-1 rounded bg-[var(--y-brand-primary)] text-white hover:opacity-90"
                        onClick={(e) => { e.stopPropagation(); completeStep(activeJourney.id, step.id); }}
                      >
                        Done
                      </button>
                      <button
                        className="text-xs px-2 py-1 rounded text-[var(--y-text-secondary)] hover:bg-[var(--y-bg)]"
                        onClick={(e) => { e.stopPropagation(); skipStep(activeJourney.id, step.id); }}
                      >
                        Skip
                      </button>
                    </div>
                  )}
                </div>
              );
            })}
          </div>

          {/* Progress bar */}
          <div className="mt-4 h-1.5 bg-[var(--y-border)] rounded-full overflow-hidden">
            <div
              className="h-full bg-[var(--y-brand-primary)] rounded-full transition-all duration-700"
              style={{
                width: `${activeJourney.steps.length > 0
                  ? Math.round((activeProgress.completedSteps.length / activeJourney.steps.length) * 100)
                  : 0}%`
              }}
            />
          </div>
        </div>
      )}

      {/* Available Journeys */}
      {!activeJourney && availableJourneys.length > 0 && (
        <div>
          <h2 className="text-lg font-semibold text-[var(--y-text-primary)] mb-3">
            Get started with a journey
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {availableJourneys.map((journey) => (
              <JourneyCard
                key={journey.id}
                journey={journey}
                progress={state.journeyProgress[journey.id]}
                onStart={startJourney}
                onResume={startJourney}
                onReset={resetJourney}
              />
            ))}
          </div>
        </div>
      )}

      {/* AI Coach — contextual coaching on active journey */}
      {coachMessage && (
        <div className="bg-gradient-to-r from-blue-500/5 to-purple-500/5 rounded-xl p-5 border border-blue-500/20">
          <div className="flex items-start gap-4">
            <div className="w-10 h-10 rounded-full bg-blue-500/10 flex items-center justify-center text-lg shrink-0">
              🤖
            </div>
            <div className="flex-1 min-w-0">
              <h3 className="text-sm font-semibold text-[var(--y-text-primary)]">{coachMessage.title}</h3>
              <p className="text-sm text-[var(--y-text-secondary)] mt-1">{coachMessage.message}</p>
              <div className="flex items-center gap-4 mt-2 text-xs text-[var(--y-text-secondary)]">
                <span>🎯 {coachMessage.impact}</span>
                <span>⏱ ~{coachMessage.estimatedMinutes} min</span>
              </div>
            </div>
            <button
              className="shrink-0 text-sm px-4 py-2 rounded-lg bg-[var(--y-brand-primary)] text-white hover:opacity-90 transition-opacity"
              onClick={() => setCurrentStep(coachMessage.journeyId, coachMessage.stepId)}
            >
              Start next step
            </button>
          </div>
        </div>
      )}

      {/* Achievements */}
      {achievements.length > 0 && (
        <div>
          <h2 className="text-sm font-semibold text-[var(--y-text-secondary)] uppercase tracking-wider mb-3">
            Achievements
          </h2>
          <div className="flex gap-3 overflow-x-auto pb-2">
            {achievements.map((a) => (
              <div
                key={a.id}
                className="flex items-center gap-3 px-4 py-3 rounded-xl bg-[var(--y-surface-elevated)] border border-[var(--y-border)] shrink-0"
              >
                <span className="text-2xl">{a.icon}</span>
                <div className="min-w-0">
                  <p className="text-sm font-medium text-[var(--y-text-primary)] whitespace-nowrap">
                    {a.title}
                  </p>
                  <p className="text-xs text-[var(--y-text-secondary)] max-w-[200px] truncate">
                    {a.description}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Main dashboard widgets */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-bold text-[var(--y-text-primary)]">Dashboard</h1>
          <p className="text-sm text-[var(--y-text-secondary)] mt-1">Welcome back, Jay</p>
        </div>
      </div>
      <DashboardGrid
        widgets={widgets.map((w) => ({ id: w.id }))}
      />
    </div>
  );
}
