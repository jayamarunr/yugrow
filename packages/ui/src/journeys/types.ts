// ─── Platform Grouping ───────────────────────────────────────
// Products are grouped into Platforms. Users think in goals,
// not products. Platforms are how we organize internally.

export type PlatformId =
  | 'platform-core'
  | 'relationship-platform'
  | 'business-platform'
  | 'content-platform'
  | 'commerce-platform'
  | 'people-platform';

export interface PlatformDefinition {
  id: PlatformId;
  name: string;
  description: string;
  icon: string; // emoji or icon name
  color: string; // theme color token
}

export const PLATFORMS: Record<PlatformId, PlatformDefinition> = {
  'platform-core': {
    id: 'platform-core',
    name: 'Platform Core',
    description: 'Identity, workspace, permissions, and AI',
    icon: '⚙️',
    color: 'var(--y-brand-primary)',
  },
  'relationship-platform': {
    id: 'relationship-platform',
    name: 'Relationship Platform',
    description: 'Connections, trust, discovery, and networking',
    icon: '🔗',
    color: 'var(--y-state-success)',
  },
  'business-platform': {
    id: 'business-platform',
    name: 'Business Platform',
    description: 'CRM, workflow, communication, and documents',
    icon: '💼',
    color: 'var(--y-state-info)',
  },
  'content-platform': {
    id: 'content-platform',
    name: 'Content Platform',
    description: 'Content creation, websites, publishing, and media',
    icon: '✍️',
    color: 'var(--y-state-warning)',
  },
  'commerce-platform': {
    id: 'commerce-platform',
    name: 'Commerce Platform',
    description: 'Finance, payments, marketplace, and billing',
    icon: '💰',
    color: 'var(--y-state-success)',
  },
  'people-platform': {
    id: 'people-platform',
    name: 'People Platform',
    description: 'HR, hiring, attendance, and performance',
    icon: '👥',
    color: 'var(--y-brand-secondary)',
  },
};

// ─── Journey Types ──────────────────────────────────────────

export type JourneyCategory = 'onboarding' | 'growth' | 'networking' | 'content' | 'manage';

export type StepStatus = 'pending' | 'in-progress' | 'completed' | 'skipped' | 'locked';

export interface JourneyAction {
  label: string;
  href?: string;
  onClick?: () => void;
}

export interface JourneyStep {
  id: string;
  title: string;
  description: string;
  platform: PlatformId;
  status: StepStatus;
  action: JourneyAction;
  dependencies?: string[];
  aiPrompt?: string;
  coachTip?: string; // AI Coach tip shown when this step is active
  estimatedMinutes: number;
}

export interface JourneyAchievement {
  id: string;
  title: string;
  description: string;
  icon: string;
}

export interface Journey {
  id: string;
  title: string;
  description: string;
  icon: string;
  category: JourneyCategory;
  steps: JourneyStep[];
  estimatedMinutes: number;
  achievement: JourneyAchievement; // awarded on completion
  /** Optional: return steps dynamically based on user context */
  contextualize?: (context: UserContext) => JourneyStep[];
}

export interface UserContext {
  isNewUser: boolean;
  hasIdentity: boolean;
  hasWebsite: boolean;
  hasWorkspace: boolean;
  hasConnections: boolean;
  completedJourneyIds: string[];
  role?: 'individual' | 'agency' | 'enterprise';
}

// ─── Journey State ──────────────────────────────────────────

export interface JourneyProgress {
  journeyId: string;
  completedSteps: string[];
  skippedSteps: string[];
  startedAt: number;
  completedAt?: number;
  currentStepId?: string;
}

export interface JourneyState {
  activeJourneyId: string | null;
  journeyProgress: Record<string, JourneyProgress>;
  completedJourneys: string[];
  showWelcome: boolean;
}

// ─── Navigation ─────────────────────────────────────────────

export type NavMode = 'products' | 'goals';

export interface NavGroup {
  id: string;
  label: string;
  icon: string;
  href?: string;
  items?: NavGroup[];
  journeyId?: string;
  platform?: PlatformId;
}

// ─── Context ────────────────────────────────────────────────

export interface CoachMessage {
  journeyId: string;
  stepId: string;
  title: string;
  message: string;
  impact: string;
  estimatedMinutes: number;
}

export interface JourneyContextValue {
  state: JourneyState;
  journeys: Journey[];
  activeJourney: Journey | null;
  activeProgress: JourneyProgress | null;
  navMode: NavMode;
  userContext: UserContext;
  startJourney: (journeyId: string) => void;
  completeStep: (journeyId: string, stepId: string) => void;
  skipStep: (journeyId: string, stepId: string) => void;
  setCurrentStep: (journeyId: string, stepId: string) => void;
  resetJourney: (journeyId: string) => void;
  dismissWelcome: () => void;
  toggleNavMode: () => void;
  getStepsByPlatform: (platformId: PlatformId) => JourneyStep[];
  getPendingSteps: () => JourneyStep[];
  getAvailableJourneys: () => Journey[];
  getActiveSteps: () => JourneyStep[];
  getCoachMessage: () => CoachMessage | null;
  getAchievements: () => JourneyAchievement[];
  setUserContext: (ctx: Partial<UserContext>) => void;
}
