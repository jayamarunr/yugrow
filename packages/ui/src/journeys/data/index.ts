import type { Journey } from '../types';
import { startBusinessJourney } from './start-business';
import { findCustomersJourney } from './find-customers';
import { attendEventJourney } from './attend-event';
import { buildAuthorityJourney } from './build-authority';

export const defaultJourneys: Journey[] = [
  startBusinessJourney,
  findCustomersJourney,
  attendEventJourney,
  buildAuthorityJourney,
];

export { startBusinessJourney } from './start-business';
export { findCustomersJourney } from './find-customers';
export { attendEventJourney } from './attend-event';
export { buildAuthorityJourney } from './build-authority';
