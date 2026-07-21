// ─── Yugrow Design System — Public API ──────────────────────────────
// Import everything from a single entry point.

export { colorTokens, typography, spacing, borderRadius, shadows } from './tokens';
export type { ColorScheme, ColorToken } from './tokens';

export { ThemeProvider, useTheme } from './theme';
export type { WorkspaceBranding } from './theme';

export {
  Button, Input, Card, Dialog,
  ToastProvider, useToast,
  Skeleton, CardSkeleton, EmptyState,
} from './components';

export {
  Shell, Sidebar, Topbar, WorkspaceSwitcher, AssistantPanel, NotificationCenter,
} from './shell';

export {
  registerWidget, getWidget, getAllWidgets, DashboardGrid,
} from './widgets';
export type { WidgetDefinition } from './widgets';

export {
  registerProduct, getProduct, getAllProducts,
  getProductsWithCapability, getProductsForWorkspace, loadProductsForWorkspace,
  ProductLauncher,
  registerNavItems, getNavTree, getWorkspaceNavTree,
} from './registry';
export type { ProductRegistration, NavItem } from './registry';

export {
  JourneyProvider, useJourneys,
  JourneyCard, JourneyProgress, JourneyLauncher, JourneySidebar,
  PLATFORMS, defaultJourneys,
} from './journeys';
export type {
  Journey, JourneyStep, JourneyProgress as JourneyProgressType,
  PlatformId, PlatformDefinition, NavMode,
} from './journeys';


