// ─── VenueSearchService ───────────────────────────────────────────
// Aggregates venue search results from all registered providers.
// The UI never knows which provider returned which result.
//
// Provider chain (FD-031):
//   1. YugrowVenueProvider  — always active, Yugrow's own DB
//   2. MapboxProvider        — primary external search (if configured)
//   3. NominatimProvider     — free fallback (OSM / OpenStreetMap)
//
// To add a new provider:
//   1. Implement VenueProvider
//   2. Add it to the providers list below
//   3. Done — no UI changes needed

import '../models/venue.dart';
import 'providers/venue_provider.dart';
import 'providers/yugrow_venue_provider.dart';
import 'providers/mapbox_provider.dart';
import 'providers/nominatim_provider.dart';
import 'venue_analytics.dart';
import 'venue_cache_service.dart';
import '../../../core/api/api_client.dart';

class VenueSearchService {
  final List<VenueProvider> _providers;
  final VenueCacheService _cache;

  VenueSearchService(ApiClient api)
      : _providers = [
          YugrowVenueProvider(api),      // Always active — own DB
          MapboxProvider(),               // If MAPBOX_ACCESS_TOKEN set
          NominatimProvider(),            // Free fallback
        ],
        _cache = VenueCacheService();

  /// Search all available providers and return merged results.
  /// Results are deduplicated by name (case-insensitive).
  /// Cached for 24h to reduce external API calls.
  Future<VenueSearchResults> search(String query) async {
    if (query.trim().isEmpty) {
      return const VenueSearchResults(venues: [], totalCount: 0);
    }

    // Check cache first
    final cached = _cache.get(query);
    if (cached != null) {
      VenueAnalytics.providerUsed('cache');
      return VenueSearchResults(venues: cached, totalCount: cached.length);
    }

    final stopwatch = Stopwatch()..start();
    final results = <Venue>[];
    final seenNames = <String>{};
    String? firstProviderUsed;

    for (final provider in _providers) {
      if (!provider.isAvailable) continue;

      try {
        final venues = await provider.search(query);
        if (venues.isNotEmpty && firstProviderUsed == null) {
          firstProviderUsed = provider.name;
        }
        for (final venue in venues) {
          final key = venue.name.toLowerCase().trim();
          if (seenNames.add(key)) {
            results.add(venue);
          }
        }
        // If Yugrow returned results, skip external providers
        if (provider is YugrowVenueProvider && venues.isNotEmpty) break;
      } catch (_) {
        // Provider failed — skip and continue with others
      }
    }

    stopwatch.stop();
    VenueAnalytics.searchTime(stopwatch.elapsedMilliseconds.toDouble());
    if (firstProviderUsed != null) {
      VenueAnalytics.providerUsed(firstProviderUsed);
    }

    // Cache results (even empty — prevents repeated failed lookups)
    _cache.set(query, results);

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
