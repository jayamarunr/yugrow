// ─── VenueAnalytics ───────────────────────────────────────────────
// Instruments the venue discovery flow to validate FD-031.
//
// Metrics:
//   - venue_search_started
//   - existing_venue_selected
//   - provider_used (Yugrow / Mapbox / Nominatim)
//   - create_venue_opened
//   - create_venue_completed
//   - create_venue_abandoned
//   - avg_search_time_ms
//   - avg_venue_selection_time_ms
//
// These metrics determine whether FD-031 was the right decision.
// If Venue Creation Success Rate is high, the OSM-first approach is validated.
// If abandonment is high, premium search may be needed.

/// Provider name constants for analytics.
class VenueProviderName {
  static const yugrow = 'Yugrow';
  static const mapbox = 'Mapbox';
  static const nominatim = 'OpenStreetMap';
  static const manual = 'Manual';
}

/// Records a venue search analytics event.
/// Replace the body with your preferred analytics SDK (PostHog, etc.).
class VenueAnalytics {
  /// Called when user focuses the venue search field.
  static void searchStarted() {
    // TODO: Track event 'venue_search_started'
  }

  /// Called when user selects an existing venue from results.
  static void existingVenueSelected(String providerName) {
    // TODO: Track event 'existing_venue_selected' with property provider: providerName
  }

  /// Called with the provider that returned the selected result.
  static void providerUsed(String providerName) {
    // TODO: Track event 'provider_used' with property provider: providerName
  }

  /// Called when user opens the create venue flow.
  static void createVenueOpened() {
    // TODO: Track event 'create_venue_opened'
  }

  /// Called when a new venue is successfully created.
  static void createVenueCompleted() {
    // TODO: Track event 'create_venue_completed'
  }

  /// Called when user abandons the create venue flow.
  static void createVenueAbandoned() {
    // TODO: Track event 'create_venue_abandoned'
  }

  /// Track how long a search took.
  static void searchTime(double durationMs) {
    // TODO: Track 'avg_search_time_ms'
  }

  /// Track total time from opening search to selecting a venue.
  static void selectionTime(double durationMs) {
    // TODO: Track 'avg_venue_selection_time_ms'
  }

  /// Set user properties after onboarding.
  static void setPersonProperties(String headline, String company) {
    // TODO: Set person properties in analytics: headline, company
  }
}
