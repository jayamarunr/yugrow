// ─── VenueProvider Interface ──────────────────────────────────────
// All venue search providers implement this interface.
// The VenueSearchService aggregates results from all registered providers.
//
// Current providers:
//   - YugrowVenueProvider  (Phase 1 — always active)
//   - GooglePlacesProvider  (Phase 2 — behind feature flag, requires API key)

import '../../models/venue.dart';

abstract class VenueProvider {
  /// A human-readable name for this provider (e.g. "Yugrow", "Google Places")
  String get name;

  /// Search venues matching [query].
  /// Returns a list of Venue objects, ordered by relevance.
  Future<List<Venue>> search(String query);

  /// Whether this provider is available (e.g. API key configured).
  bool get isAvailable;
}
