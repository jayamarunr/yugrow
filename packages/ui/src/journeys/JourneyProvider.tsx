'use client';

import React, { createContext, useContext, useState, useCallback, useMemo } from 'react';
import type {
  Journey,
  JourneyContextValue,
  JourneyState,
  JourneyProgress,
  PlatformId,
  JourneyStep,
  NavMode,
  UserContext,
  CoachMessage,
  JourneyAchievement,
} from './types';
import { defaultJourneys } from './data';

const INITIAL_STATE: JourneyState = {
  activeJourneyId: null,
  journeyProgress: {},
  completedJourneys: [],
  showWelcome: true,
};

const DEFAULT_USER_CONTEXT: UserContext = {
  isNewUser: true,
  hasIdentity: false,
  hasWebsite: false,
  hasWorkspace: false,
  hasConnections: false,
  completedJourneyIds: [],
};

const JourneyContext = createContext<JourneyContextValue | null>(null);

export function JourneyProvider({
  children,
  journeys = defaultJourneys,
}: {
  children: React.ReactNode;
  journeys?: Journey[];
}) {
  const [state, setState] = useState<JourneyState>(INITIAL_STATE);
  const [navMode, setNavMode] = useState<NavMode>('goals');
  const [userContext, setUserContextState] = useState<UserContext>(DEFAULT_USER_CONTEXT);

  const setUserContext = useCallback((ctx: Partial<UserContext>) => {
    setUserContextState((prev) => ({ ...prev, ...ctx }));
  }, []);

  // ── Derived State ──────────────────────────────────────────

  const activeJourney = useMemo(
    () => journeys.find((j) => j.id === state.activeJourneyId) ?? null,
    [journeys, state.activeJourneyId]
  );

  const activeProgress = useMemo(
    () => (state.activeJourneyId ? state.journeyProgress[state.activeJourneyId] : null),
    [state.activeJourneyId, state.journeyProgress]
  );

  // ── Actions ────────────────────────────────────────────────

  const startJourney = useCallback((journeyId: string) => {
    setState((prev) => ({
      ...prev,
      activeJourneyId: journeyId,
      journeyProgress: {
        ...prev.journeyProgress,
        [journeyId]: {
          journeyId,
          completedSteps: [],
          skippedSteps: [],
          startedAt: Date.now(),
          currentStepId: undefined,
        },
      },
    }));
  }, []);

  const completeStep = useCallback((journeyId: string, stepId: string) => {
    setState((prev) => {
      const progress = prev.journeyProgress[journeyId];
      if (!progress) return prev;
      if (progress.completedSteps.includes(stepId)) return prev;

      const newCompleted = [...progress.completedSteps, stepId];
      const journey = [...defaultJourneys, ...journeys].find((j) => j.id === journeyId);
      const totalSteps = journey?.steps.length ?? 0;
      const isComplete = newCompleted.length >= totalSteps;

      return {
        ...prev,
        journeyProgress: {
          ...prev.journeyProgress,
          [journeyId]: {
            ...progress,
            completedSteps: newCompleted,
            currentStepId: undefined,
            completedAt: isComplete ? Date.now() : progress.completedAt,
          },
        },
        completedJourneys: isComplete
          ? [...new Set([...prev.completedJourneys, journeyId])]
          : prev.completedJourneys,
        // Auto-advance to next pending step
        currentStepId: undefined,
      };
    });
  }, [journeys]);

  const skipStep = useCallback((journeyId: string, stepId: string) => {
    setState((prev) => {
      const progress = prev.journeyProgress[journeyId];
      if (!progress) return prev;
      if (progress.skippedSteps.includes(stepId)) return prev;

      return {
        ...prev,
        journeyProgress: {
          ...prev.journeyProgress,
          [journeyId]: {
            ...progress,
            skippedSteps: [...progress.skippedSteps, stepId],
          },
        },
      };
    });
  }, []);

  const setCurrentStep = useCallback((journeyId: string, stepId: string) => {
    setState((prev) => {
      const progress = prev.journeyProgress[journeyId];
      if (!progress) return prev;
      return {
        ...prev,
        journeyProgress: {
          ...prev.journeyProgress,
          [journeyId]: { ...progress, currentStepId: stepId },
        },
      };
    });
  }, []);

  const resetJourney = useCallback((journeyId: string) => {
    setState((prev) => ({
      ...prev,
      journeyProgress: {
        ...prev.journeyProgress,
        [journeyId]: {
          journeyId,
          completedSteps: [],
          skippedSteps: [],
          startedAt: Date.now(),
          currentStepId: undefined,
        },
      },
      completedJourneys: prev.completedJourneys.filter((id) => id !== journeyId),
    }));
  }, []);

  const dismissWelcome = useCallback(() => {
    setState((prev) => ({ ...prev, showWelcome: false }));
  }, []);

  const toggleNavMode = useCallback(() => {
    setNavMode((prev) => (prev === 'goals' ? 'products' : 'goals'));
  }, []);

  // ── Query Helpers ──────────────────────────────────────────

  const getStepsByPlatform = useCallback(
    (platformId: PlatformId): JourneyStep[] => {
      const steps: JourneyStep[] = [];
      for (const journey of journeys) {
        const progress = state.journeyProgress[journey.id];
        for (const step of journey.steps) {
          if (step.platform === platformId) {
            const isCompleted = progress?.completedSteps.includes(step.id);
            const isSkipped = progress?.skippedSteps.includes(step.id);
            steps.push({
              ...step,
              status: isCompleted ? 'completed' : isSkipped ? 'skipped' : 'pending',
            });
          }
        }
      }
      return steps;
    },
    [journeys, state.journeyProgress]
  );

  const getPendingSteps = useCallback((): JourneyStep[] => {
    const pending: JourneyStep[] = [];
    for (const journey of journeys) {
      const progress = state.journeyProgress[journey.id];
      if (!progress) {
        // Journey not started — first step is pending
        if (journey.steps.length > 0) {
          pending.push({ ...journey.steps[0], status: 'pending' });
        }
        continue;
      }
      for (const step of journey.steps) {
        if (
          !progress.completedSteps.includes(step.id) &&
          !progress.skippedSteps.includes(step.id)
        ) {
          const depsMet = (step.dependencies ?? []).every((dep) =>
            progress.completedSteps.includes(dep)
          );
          pending.push({
            ...step,
            status: depsMet ? 'pending' : 'locked',
          });
        }
      }
    }
    return pending;
  }, [journeys, state.journeyProgress]);

  const getAvailableJourneys = useCallback((): Journey[] => {
    return journeys.filter(
      (j) => !state.completedJourneys.includes(j.id)
    );
  }, [journeys, state.completedJourneys]);

  // ── Contextual Steps ───────────────────────────────────────

  const getActiveSteps = useCallback((): JourneyStep[] => {
    if (!activeJourney) return [];
    if (activeJourney.contextualize) {
      return activeJourney.contextualize(userContext);
    }
    return activeJourney.steps;
  }, [activeJourney, userContext]);

  // ── AI Coach ───────────────────────────────────────────────

  const getCoachMessage = useCallback((): CoachMessage | null => {
    if (!activeJourney || !activeProgress) return null;

    const steps = activeJourney.contextualize
      ? activeJourney.contextualize(userContext)
      : activeJourney.steps;

    // Find the first pending (non-completed, non-skipped) step
    const nextStep = steps.find(
      (s) =>
        !activeProgress.completedSteps.includes(s.id) &&
        !activeProgress.skippedSteps.includes(s.id)
    );

    if (!nextStep) return null;

    const completedCount = activeProgress.completedSteps.length;
    const totalCount = steps.length;
    const percent = Math.round((completedCount / totalCount) * 100);

    return {
      journeyId: activeJourney.id,
      stepId: nextStep.id,
      title: `You're ${percent}% through "${activeJourney.title}"`,
      message: nextStep.coachTip ?? `The next step is "${nextStep.title}". Let's go.`,
      impact: nextStep.description,
      estimatedMinutes: nextStep.estimatedMinutes,
    };
  }, [activeJourney, activeProgress, userContext]);

  // ── Achievements ───────────────────────────────────────────

  const getAchievements = useCallback((): JourneyAchievement[] => {
    return journeys
      .filter((j) => state.completedJourneys.includes(j.id))
      .map((j) => j.achievement)
      .filter(Boolean);
  }, [journeys, state.completedJourneys]);

  // ── Context Value ──────────────────────────────────────────

  const value = useMemo<JourneyContextValue>(
    () => ({
      state,
      journeys,
      activeJourney,
      activeProgress,
      navMode,
      userContext,
      startJourney,
      completeStep,
      skipStep,
      setCurrentStep,
      resetJourney,
      dismissWelcome,
      toggleNavMode,
      getStepsByPlatform,
      getPendingSteps,
      getAvailableJourneys,
      getActiveSteps,
      getCoachMessage,
      getAchievements,
      setUserContext,
    }),
    [
      state,
      journeys,
      activeJourney,
      activeProgress,
      navMode,
      userContext,
      startJourney,
      completeStep,
      skipStep,
      setCurrentStep,
      resetJourney,
      dismissWelcome,
      toggleNavMode,
      getStepsByPlatform,
      getPendingSteps,
      getAvailableJourneys,
      getActiveSteps,
      getCoachMessage,
      getAchievements,
      setUserContext,
    ]
  );

  return (
    <JourneyContext.Provider value={value}>
      {children}
    </JourneyContext.Provider>
  );
}

export function useJourneys(): JourneyContextValue {
  const ctx = useContext(JourneyContext);
  if (!ctx) {
    throw new Error('useJourneys must be used within a JourneyProvider');
  }
  return ctx;
}
