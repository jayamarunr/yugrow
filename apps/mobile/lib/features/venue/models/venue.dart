// ─── Venue Model ──────────────────────────────────────────────────
// A Venue is a first-class domain object in Yugrow. It represents a
// physical location where professional gatherings occur.
//
// A Venue has a Location (coordinates + validation radius) that serves
// as the trust boundary for Presence verification. When a user taps
// "I'm Here," their GPS is compared against the Venue's Location.
//
// External systems (Google Places, etc.) are providers — they help
// discover venues, but the Venue object itself belongs to Yugrow.

/// Geographic location for a Venue. Owned separately so venues can
/// be updated without rewriting historical event data.
class Location {
  final double latitude;
  final double longitude;

  /// How close a user must be (in meters) for check-in to succeed.
  /// Default 100m — configurable per venue.
  final double validationRadius;

  const Location({
    required this.latitude,
    required this.longitude,
    this.validationRadius = 100,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      validationRadius: (json['validationRadius'] as num?)?.toDouble() ?? 100,
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'validationRadius': validationRadius,
      };
}

class Venue {
  final String id;
  final String name;
  final String address;
  final String city;
  final String? state;
  final String? country;
  final Location? location;
  final String? googlePlaceId;
  final String status; // 'pending' | 'verified' | 'archived'
  final int eventCount;
  final DateTime createdAt;

  const Venue({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    this.state,
    this.country,
    this.location,
    this.googlePlaceId,
    this.status = 'pending',
    this.eventCount = 0,
    required this.createdAt,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    Location? location;
    if (json['latitude'] != null && json['longitude'] != null) {
      location = Location(
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        validationRadius:
            (json['validationRadius'] as num?)?.toDouble() ?? 100,
      );
    } else if (json['location'] != null) {
      location = Location.fromJson(json['location'] as Map<String, dynamic>);
    }

    return Venue(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String? ?? json['name'] as String,
      city: json['city'] as String? ?? '',
      state: json['state'] as String?,
      country: json['country'] as String?,
      location: location,
      googlePlaceId: json['googlePlaceId'] as String?,
      status: json['status'] as String? ?? 'pending',
      eventCount: json['eventCount'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'city': city,
        if (state != null) 'state': state,
        if (country != null) 'country': country,
        if (location != null) ...location!.toJson(),
        if (googlePlaceId != null) 'googlePlaceId': googlePlaceId,
        'status': status,
      };

  // ── Convenience getters ──

  double? get latitude => location?.latitude;
  double? get longitude => location?.longitude;
  double? get validationRadius => location?.validationRadius;

  /// A compact display string: "Venue Name, City"
  String get displayName => city.isNotEmpty ? '$name, $city' : name;

  /// Whether this venue has geographic coordinates (for presence verification)
  bool get hasCoordinates => location != null;
}
