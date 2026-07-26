// ─── GooglePlacesProvider ─────────────────────────────────────────
// ⚠️  DEPRECATED — replaced by MapboxProvider + NominatimProvider.
//     Kept as reference for future if user evidence justifies Google spend.
//
// FD-031: Google Places is excluded until user evidence proves that
// search quality is blocking adoption. Do not implement unless:
//   1. Venue Creation Success Rate drops below target
//   2. User testing confirms search quality is the #1 friction point
//   3. Budget is approved for the $100+/month cost
//
// See FD-031 for full decision history.
// See mapbox_provider.dart for the current primary external provider.
// See nominatim_provider.dart for the free fallback.

import '../../models/venue.dart';
import 'venue_provider.dart';

class GooglePlacesProvider implements VenueProvider {
  GooglePlacesProvider();

  @override
  String get name => 'Google Places';

  /// Disabled by default. Re-enable only when FD-031's evidence
  /// triggers are met.
  @override
  bool get isAvailable => false;

  @override
  Future<List<Venue>> search(String query) async {
    // Not implemented. See FD-031 for activation criteria.
    return [];
  }
}
