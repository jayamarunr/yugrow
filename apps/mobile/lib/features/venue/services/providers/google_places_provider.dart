// ─── GooglePlacesProvider ─────────────────────────────────────────
// Searches venues via Google Places API.
// Phase 2 — behind feature flag, requires API key.
//
// To enable:
//   1. Add your Google Places API key to the environment
//   2. Set ENABLE_GOOGLE_PLACES=true
//   3. No UI changes needed — results automatically appear

import 'package:yugrow_mobile/core/config/environment.dart';
import '../../models/venue.dart';
import 'venue_provider.dart';

class GooglePlacesProvider implements VenueProvider {
  GooglePlacesProvider();

  @override
  String get name => 'Google Places';

  @override
  bool get isAvailable =>
      Environment.flavor.name == 'development'
      // In production, check for API key:
      // && Environment.googlePlacesApiKey.isNotEmpty
      ;

  @override
  Future<List<Venue>> search(String query) async {
    // ─── Phase 2 implementation ─────────────────────────────────
    // 1. Call Google Places Autocomplete API:
    //    GET https://maps.googleapis.com/maps/api/place/autocomplete/json
    //      ?input=$query
    //      &key=$apiKey
    //      &types=establishment
    //
    // 2. For the selected place, call Place Details:
    //    GET https://maps.googleapis.com/maps/api/place/details/json
    //      ?place_id=$placeId
    //      &key=$apiKey
    //
    // 3. Convert to Venue:
    //    Venue(
    //      id: 'google_$placeId',
    //      name: result.name,
    //      address: result.formattedAddress,
    //      city: extractCity(result.addressComponents),
    //      latitude: result.geometry.location.lat,
    //      longitude: result.geometry.location.lng,
    //      googlePlaceId: result.placeId,
    //      status: 'pending',  // becomes verified after first event
    //      createdAt: DateTime.now(),
    //    )
    //
    // 4. On event creation, the API imports the Google Place
    //    into Yugrow's Venue database with the googlePlaceId preserved.
    //    From that point, every event references the Yugrow Venue,
    //    not the Google Place ID directly.

    await Future.delayed(Duration.zero); // placeholder
    return [];
  }
}
