export { JourneyProvider, useJourneys } from './JourneyProvider';
export { JourneyCard } from './JourneyCard';
export { JourneyProgress } from './JourneyProgress';
export { JourneyLauncher } from './JourneyLauncher';
export { JourneySidebar } from './JourneySidebar';

export { PLATFORMS } from './types';

export {
  defaultJourneys,
  startBusinessJourney,
  findCustomersJourney,
  attendEventJourney,
  buildAuthorityJourney,
} from './data';

export type {
  Journey,
  JourneyStep,
  JourneyState,
  JourneyAction,
  JourneyCategory,
  StepStatus,
  PlatformId,
  PlatformDefinition,
  NavMode,
  NavGroup,
  JourneyContextValue,
} from './types';
