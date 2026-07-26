// ─── NominatimProvider ────────────────────────────────────────────
// Free geocoding + search via OpenStreetMap's Nominatim API.
// No API key required.
//
// Usage limits (public service):
//   - Max 1 request per second
//   - Provide a custom User-Agent
//   - For production scale, host your own instance or switch to Mapbox
//
// FD-031: Nominatim is the fallback geocoding provider for Alpha.
// Plan migration to managed provider as usage grows.

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/venue.dart';
import 'venue_provider.dart';

class NominatimProvider implements VenueProvider {
  /// Custom User-Agent per Nominatim's fair use policy.
  final String _userAgent;

  NominatimProvider({String? userAgent})
      : _userAgent = userAgent ?? 'YugrowApp/1.0 (venue-search)';

  @override
  String get name => 'OpenStreetMap';

  @override
  bool get isAvailable => true;

  @override
  Future<List<Venue>> search(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final uri = Uri.parse(
          'https://nominatim.openstreetmap.org/search')
          .replace(queryParameters: {
        'q': query,
        'format': 'json',
        'limit': '5',
        'addressdetails': '1',
        'featuretype': 'amenity,commercial,leisure,office,public_building',
      });

      final response = await http.get(
        uri,
        headers: {'User-Agent': _userAgent},
      );

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((item) => _parseNominatimResult(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Reverse geocode: convert coordinates to a human-readable address.
  Future<String?> reverseGeocode(double lat, double lng) async {
    try {
      final uri = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse')
          .replace(queryParameters: {
        'lat': lat.toString(),
        'lon': lng.toString(),
        'format': 'json',
        'addressdetails': '1',
      });

      final response = await http.get(
        uri,
        headers: {'User-Agent': _userAgent},
      );

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['display_name'] as String?;
    } catch (_) {
      return null;
    }
  }

  Venue _parseNominatimResult(Map<String, dynamic> item) {
    final address = item['address'] as Map<String, dynamic>?;
    final name = item['name'] as String? ??
        (item['display_name'] as String? ?? 'Unknown');
    final displayName = item['display_name'] as String? ?? name;

    return Venue(
      id: 'osm_${item['osm_id'] ?? DateTime.now().millisecondsSinceEpoch}',
      name: name,
      address: displayName,
      city: address?['city'] ??
          address?['town'] ??
          address?['village'] ??
          address?['county'] ??
          '',
      state: address?['state'],
      country: address?['country'],
      location: Location(
        latitude: double.parse((item['lat'] as String)),
        longitude: double.parse((item['lon'] as String)),
        validationRadius: 100,
      ),
      status: 'pending',
      createdAt: DateTime.now(),
    );
  }
}
