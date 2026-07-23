// ─── YugrowVenueProvider ──────────────────────────────────────────
// Searches venues already stored in Yugrow's database.
// Always available — no external API key required.

import 'package:yugrow_mobile/core/api/api_client.dart';
import '../../models/venue.dart';
import 'venue_provider.dart';

class YugrowVenueProvider implements VenueProvider {
  final ApiClient _api;

  YugrowVenueProvider(this._api);

  @override
  String get name => 'Yugrow';

  @override
  bool get isAvailable => true;

  @override
  Future<List<Venue>> search(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final results = await _api.searchVenues(query);
      return results
          .map((json) => Venue.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
