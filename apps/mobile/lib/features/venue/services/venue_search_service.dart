// ─── VenueSearchService ───────────────────────────────────────────
// Aggregates venue search results from all registered providers.
// The UI never knows which provider returned which result.
//
// To add a new provider:
//   1. Implement VenueProvider
//   2. Add it to the providers list below
//   3. Done — no UI changes needed

import '../models/venue.dart';
import 'providers/venue_provider.dart';
import 'providers/yugrow_venue_provider.dart';
import 'providers/google_places_provider.dart';
import '../../../core/api/api_client.dart';

class VenueSearchService {
  final List<VenueProvider> _providers;

  VenueSearchService(ApiClient api)
      : _providers = [
          YugrowVenueProvider(api),         // Phase 1 — always active
          GooglePlacesProvider(),            // Phase 2 — feature flagged
        ];

  /// Search all available providers and return merged results.
  /// Results are deduplicated by name (case-insensitive).
  /// Google Place results are marked so the UI can show "via Google Places".
  Future<VenueSearchResults> search(String query) async {
    if (query.trim().isEmpty) {
      return const VenueSearchResults(venues: [], totalCount: 0);
    }

    final results = <Venue>[];
    final seenNames = <String>{};

    for (final provider in _providers) {
      if (!provider.isAvailable) continue;

      try {
        final venues = await provider.search(query);
        for (final venue in venues) {
          final key = venue.name.toLowerCase().trim();
          if (seenNames.add(key)) {
            results.add(venue);
          }
        }
      } catch (_) {
        // Provider failed — skip and continue with others
      }
    }

    return VenueSearchResults(
      venues: results,
      totalCount: results.length,
    );
  }
}

class VenueSearchResults {
  final List<Venue> venues;
  final int totalCount;

  const VenueSearchResults({
    required this.venues,
    required this.totalCount,
  });

  bool get isEmpty => venues.isEmpty;
  bool get isNotEmpty => venues.isNotEmpty;
}
