// â”€â”€â”€ LocationPickerMap â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// A full-screen map for dropping a pin to set a venue's coordinates.
// Uses OpenStreetMap (flutter_map) â€” no API key required.
// Google Maps can replace this later without changing the calling code.
//
// Usage:
//   final location = await Navigator.push<Location>(
//     context,
//     MaterialPageRoute(
//       builder: (_) => LocationPickerMap(
//         initialLocation: existingLocation,  // optional
//       ),
//     ),
//   );

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../models/venue.dart';
import '../services/geocoding_service.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import 'package:yugrow_mobile/core/theme/app_typography.dart';

class LocationPickerMap extends StatefulWidget {
  /// Pre-populate with an existing location (for editing).
  final Location? initialLocation;

  /// A suggested address to display
  final String? addressHint;

  const LocationPickerMap({
    super.key,
    this.initialLocation,
    this.addressHint,
  });

  @override
  State<LocationPickerMap> createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  late MapController _mapController;
  late LatLng _center;
  late double _radius;
  bool _locating = false;
  bool _resolving = false;
  String? _resolvedAddress;

  final _geocodingService = GeocodingService();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    if (widget.initialLocation != null) {
      _center = LatLng(
        widget.initialLocation!.latitude,
        widget.initialLocation!.longitude,
      );
      _radius = widget.initialLocation!.validationRadius;
      _resolveAddress();
    } else {
      // Default: center on Chennai
      _center = const LatLng(13.0827, 80.2707);
      _radius = 100;
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _locateMe() async {
    setState(() => _locating = true);
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      setState(() {
        _center = LatLng(pos.latitude, pos.longitude);
        _mapController.move(_center, 16);
        _locating = false;
      });
      _resolveAddress();
    } catch (_) {
      setState(() => _locating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get current location')),
        );
      }
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    setState(() => _center = point);
    _resolveAddress();
  }

  /// Reverse geocode the current center point to get a readable address.
  Future<void> _resolveAddress() async {
    setState(() => _resolving = true);
    final address = await _geocodingService.reverseGeocode(
      _center.latitude,
      _center.longitude,
    );
    if (mounted) {
      setState(() {
        _resolvedAddress = address;
        _resolving = false;
      });
    }
  }

  void _confirm() {
    final location = Location(
      latitude: _center.latitude,
      longitude: _center.longitude,
      validationRadius: _radius,
    );
    Navigator.of(context).pop(<String, dynamic>{
      'location': location,
      'address': _resolvedAddress ??
          widget.addressHint ??
          '${_center.latitude.toStringAsFixed(4)}, ${_center.longitude.toStringAsFixed(4)}',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Location'),
        actions: [
          TextButton(
            onPressed: _locateMe,
            child: _locating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('My Location'),
          ),
        ],
      ),
      body: Column(
        children: [
          // â”€â”€ Map â”€â”€
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _center,
                    initialZoom: 15,
                    onTap: _onMapTap,
                    onMapReady: () {
                      if (widget.initialLocation != null) {
                        _mapController.move(_center, 16);
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.yugrow.app',
                    ),
                    // Validation radius circle
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: _center,
                          radius: _radius,
                          color: Colors.blue.withValues(alpha: 0.15),
                          borderColor: Colors.blue.withValues(alpha: 0.4),
                          borderStrokeWidth: 2,
                        ),
                      ],
                    ),
                    // Draggable pin is simulated by tap + marker
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _center,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Tap hint overlay
                Positioned(
                  bottom: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: AppRadius.xxlCircular,
                    ),
                    child: const Text(
                      'Tap on the map to move the pin',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // â”€â”€ Bottom controls â”€â”€
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Coordinates display
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_center.latitude.toStringAsFixed(6)}, ${_center.longitude.toStringAsFixed(6)}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Resolved address (auto-reverse geocoded)
                  if (_resolving)
                    Row(
                      children: [
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Resolving address...',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    )
                  else if (_resolvedAddress != null)
                    Text(
                      _resolvedAddress!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  else if (widget.addressHint != null)
                    Text(
                      widget.addressHint!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: AppSpacing.md),

                  // Validation radius slider
                  Row(
                    children: [
                      const Text('Radius:', style: TextStyle(fontSize: 13)),
                      Expanded(
                        child: Slider(
                          value: _radius,
                          min: 20,
                          max: 500,
                          divisions: 24,
                          label: '${_radius.toInt()}m',
                          onChanged: (v) => setState(() => _radius = v),
                        ),
                      ),
                      Text(
                        '${_radius.toInt()}m',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _confirm,
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Confirm Location'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
}
