// ─── MapboxProvider ──────────────────────────────────────────────
// Venue search via Mapbox Geocoding API.
// Requires MAPBOX_ACCESS_TOKEN set via --dart-define.
//
// FD-031: Mapbox is the primary external venue search/autocomplete
// provider. Evaluate before any Google spend.
//
// API: https://docs.mapbox.com/api/search/geocoding/

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/environment.dart';
import '../../models/venue.dart';
import 'venue_provider.dart';

class MapboxProvider implements VenueProvider {
  final String _accessToken;
  final http.Client _client;

  MapboxProvider({http.Client? client, String? accessToken})
      : _accessToken = accessToken ?? Environment.mapboxAccessToken,
        _client = client ?? http.Client();

  @override
  String get name => 'Mapbox';

  @override
  bool get isAvailable => _accessToken.isNotEmpty;

  @override
  Future<List<Venue>> search(String query) async {
    if (query.trim().isEmpty || !isAvailable) return [];

    try {
      final uri = Uri.parse(
          'https://api.mapbox.com/search/geocoding/v6/forward')
          .replace(queryParameters: {
        'q': query,
        'access_token': _accessToken,
        'types': 'poi,address,place,locality,neighborhood',
        'limit': '5',
        'language': 'en',
      });

      final response = await _client.get(uri);

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final features = data['features'] as List<dynamic>? ?? [];

      return features
          .map((f) => _parseMapboxFeature(f as Map<String, dynamic>))
          .where((v) => v != null)
          .cast<Venue>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Reverse geocode: convert coordinates to address via Mapbox.
  Future<String?> reverseGeocode(double lat, double lng) async {
    if (!isAvailable) return null;

    try {
      final uri = Uri.parse(
          'https://api.mapbox.com/search/geocoding/v6/reverse')
          .replace(queryParameters: {
        'longitude': lng.toString(),
        'latitude': lat.toString(),
        'access_token': _accessToken,
        'types': 'poi,address,place,locality,neighborhood',
        'language': 'en',
      });

      final response = await _client.get(uri);
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final features = data['features'] as List<dynamic>? ?? [];
      if (features.isEmpty) return null;

      final feature = features[0] as Map<String, dynamic>;
      return feature['properties']?['full_address'] as String? ??
          feature['properties']?['place_formatted'] as String? ??
          feature['properties']?['name'] as String?;
    } catch (_) {
      return null;
    }
  }

  Venue? _parseMapboxFeature(Map<String, dynamic> feature) {
    try {
      final props = feature['properties'] as Map<String, dynamic>? ?? {};
      final geometry = feature['geometry'] as Map<String, dynamic>?;
      final coords = geometry?['coordinates'] as List<dynamic>?;

      if (coords == null || coords.length < 2) return null;

      final name = props['name'] as String? ??
          props['place_formatted'] as String? ??
          'Unknown';
      final address = props['full_address'] as String? ??
          props['place_formatted'] as String? ??
          '';
      final context = props['context'] as Map<String, dynamic>?;

      String city = '';
      String? state;
      String? country;

      // Parse context for place hierarchy
      if (context != null) {
        final place = context['place'] as Map<String, dynamic>?;
        final region = context['region'] as Map<String, dynamic>?;
        final countryData = context['country'] as Map<String, dynamic>?;

        city = place?['name'] as String? ?? '';
        state = region?['name'] as String?;
        country = countryData?['name'] as String?;
      }

      return Venue(
        id: 'mapbox_${props['mapbox_id'] ?? DateTime.now().millisecondsSinceEpoch}',
        name: name,
        address: address,
        city: city,
        state: state,
        country: country,
        location: Location(
          latitude: coords[1] as double,
          longitude: coords[0] as double,
          validationRadius: 100,
        ),
        status: 'pending',
        createdAt: DateTime.now(),
      );
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    _client.close();
  }
}
