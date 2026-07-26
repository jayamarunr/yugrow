// ─── GeocodingService ────────────────────────────────────────────
// Resolves coordinates to human-readable addresses.
// Falls back through providers to always return a result.
//
// FD-031: Mapbox is primary geocoding provider when configured.
// Nominatim is the free fallback for Alpha.
//
// Usage:
//   final address = await GeocodingService().reverseGeocode(13.08, 80.27);

import 'package:http/http.dart' as http;
import 'providers/mapbox_provider.dart';
import 'providers/nominatim_provider.dart';

class GeocodingService {
  final MapboxProvider _mapbox;
  final NominatimProvider _nominatim;

  GeocodingService({http.Client? client})
      : _mapbox = MapboxProvider(client: client),
        _nominatim = NominatimProvider();

  /// Convert coordinates to a human-readable address string.
  /// Tries Mapbox first (if configured), then falls back to Nominatim.
  /// Returns null only if both providers fail.
  Future<String?> reverseGeocode(double latitude, double longitude) async {
    // Try Mapbox first (better quality, if configured)
    if (_mapbox.isAvailable) {
      try {
        final address = await _mapbox.reverseGeocode(latitude, longitude);
        if (address != null && address.isNotEmpty) return address;
      } catch (_) {
        // Fall through to Nominatim
      }
    }

    // Fall back to Nominatim (free, good enough for Alpha)
    try {
      final address = await _nominatim.reverseGeocode(latitude, longitude);
      if (address != null && address.isNotEmpty) return address;
    } catch (_) {
      // Both failed
    }

    return null;
  }
}
