// ─── CreateVenuePage ─────────────────────────────────────────────
// Full-page venue creation flow (replaces the old dialog).
//
// Flow:
//   Venue Name
//     ↓
//   Search Address (autocomplete via Mapbox / Nominatim)
//     ↓
//   Autocomplete results
//     ↓
//   Drop Pin on Map (with reverse geocoding to fill address fields)
//     ↓
//   Adjust Validation Radius
//     ↓
//   Save
//
// Manual address editing is possible at every step.
// Returns the created Venue via Navigator.pop().

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../core/api/api_client.dart';
import '../models/venue.dart';

import '../services/providers/mapbox_provider.dart';
import '../services/providers/nominatim_provider.dart';

import 'location_picker_map.dart';

class CreateVenuePage extends StatefulWidget {
  final ApiClient api;

  const CreateVenuePage({super.key, required this.api});

  @override
  State<CreateVenuePage> createState() => _CreateVenuePageState();
}

class _CreateVenuePageState extends State<CreateVenuePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();

  final _mapboxProvider = MapboxProvider();
  final _nominatimProvider = NominatimProvider();

  bool _saving = false;
  bool _searchingAddress = false;
  bool _created = false;
  Location? _pickedLocation;
  double _radius = 100;
  List<Map<String, dynamic>> _addressSuggestions = [];
  Venue? _createdVenue;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _mapboxProvider.dispose();
    super.dispose();
  }

  Future<void> _onAddressChanged(String query) async {
    if (query.trim().length < 3) {
      setState(() => _addressSuggestions = []);
      return;
    }

    setState(() => _searchingAddress = true);

    final results = <Map<String, dynamic>>[];

    // Try Mapbox first
    if (_mapboxProvider.isAvailable) {
      try {
        final venues = await _mapboxProvider.search(query);
        for (final v in venues) {
          results.add({
            'name': v.name,
            'address': v.address,
            'city': v.city,
            'lat': v.latitude,
            'lng': v.longitude,
            'provider': 'Mapbox',
          });
        }
      } catch (_) {}
    }

    // Fall back to Nominatim if Mapbox returned nothing
    if (results.isEmpty) {
      try {
        final venues = await _nominatimProvider.search(query);
        for (final v in venues) {
          results.add({
            'name': v.name,
            'address': v.address,
            'city': v.city,
            'lat': v.latitude,
            'lng': v.longitude,
            'provider': 'OpenStreetMap',
          });
        }
      } catch (_) {}
    }

    if (mounted) {
      setState(() {
        _addressSuggestions = results;
        _searchingAddress = false;
      });
    }
  }

  void _selectAddressSuggestion(Map<String, dynamic> suggestion) {
    setState(() {
      _addressCtrl.text = suggestion['address'] as String? ?? suggestion['name'] as String? ?? '';
      _cityCtrl.text = suggestion['city'] as String? ?? '';
      _pickedLocation = Location(
        latitude: suggestion['lat'] as double,
        longitude: suggestion['lng'] as double,
        validationRadius: _radius,
      );
      _addressSuggestions = [];
    });
  }

  Future<void> _openMapPicker() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerMap(
          initialLocation: _pickedLocation,
          addressHint: _addressCtrl.text.isNotEmpty ? _addressCtrl.text : null,
        ),
      ),
    );
    if (result != null && mounted) {
      final location = result['location'] as Location;
      final address = result['address'] as String?;

      setState(() {
        _pickedLocation = location;
        _radius = location.validationRadius;
        if (address != null && _addressCtrl.text.isEmpty) {
          _addressCtrl.text = address;
        }
        // Also try to extract city from the address
        if (_cityCtrl.text.isEmpty && address != null) {
          final parts = address.split(',');
          if (parts.length >= 2) {
            _cityCtrl.text = parts[parts.length - 2].trim();
          }
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final data = <String, dynamic>{
        'name': _nameCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'city': _cityCtrl.text.trim(),
        if (_pickedLocation != null) ...{
          'latitude': _pickedLocation!.latitude,
          'longitude': _pickedLocation!.longitude,
          'validationRadius': _radius,
        },
        'status': _pickedLocation != null ? 'verified' : 'pending',
      };

      final result = await widget.api.createVenue(data);

      if (mounted) {
        setState(() {
          _createdVenue = Venue.fromJson(result);
          _saving = false;
          _created = true;
        });
      }
    } catch (_) {
      // ── Offline fallback ─────────────────────────────────────
      // If the API is unreachable, create a local venue object so
      // the user can continue creating their event. The venue will
      // be synced when connectivity is restored.
      if (mounted) {
        setState(() {
          _createdVenue = Venue(
            id: 'local_${DateTime.now().millisecondsSinceEpoch}',
            name: _nameCtrl.text.trim(),
            address: _addressCtrl.text.trim(),
            city: _cityCtrl.text.trim(),
            location: _pickedLocation,
            status: 'pending',
            createdAt: DateTime.now(),
          );
          _saving = false;
          _created = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_created && _createdVenue != null) {
      return _buildSuccessView(theme);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Venue'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ── Venue Name ──
            Text(
              'Venue Name',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                hintText: 'e.g. Startup Garage',
                prefixIcon: const Icon(LucideIcons.building_2, size: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Venue name is required' : null,
            ),
            const SizedBox(height: 20),

            // ── Address Search ──
            Text(
              'Search Address',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _addressCtrl,
              decoration: InputDecoration(
                hintText: 'Start typing an address...',
                prefixIcon: const Icon(LucideIcons.search, size: 18),
                suffixIcon: _searchingAddress
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
              ),
              onChanged: _onAddressChanged,
            ),

            // ── Address autocomplete suggestions ──
            if (_addressSuggestions.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 180),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: _addressSuggestions.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey[100]),
                  itemBuilder: (context, i) {
                    final s = _addressSuggestions[i];
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        LucideIcons.map_pin,
                        size: 16,
                        color: Colors.grey[500],
                      ),
                      title: Text(
                        s['name'] as String? ?? '',
                        style: const TextStyle(fontSize: 13),
                      ),
                      subtitle: s['address'] != s['name']
                          ? Text(
                              s['address'] as String? ?? '',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey[500]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      trailing: Text(
                        s['provider'] as String? ?? '',
                        style: TextStyle(
                            fontSize: 10, color: Colors.grey[400]),
                      ),
                      onTap: () => _selectAddressSuggestion(s),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),

            // ── City (auto-filled from map or address search) ──
            TextFormField(
              controller: _cityCtrl,
              decoration: InputDecoration(
                labelText: 'City',
                prefixIcon: const Icon(Icons.location_city, size: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: 20),

            // ── Map picker ──
            InkWell(
              onTap: _openMapPicker,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _pickedLocation != null
                        ? const Color(0xFF0F766E)
                        : Colors.grey[300]!,
                    width: 1.5,
                  ),
                  color: Colors.grey[50],
                ),
                child: Center(
                  child: _pickedLocation != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle,
                                color: Color(0xFF0F766E), size: 32),
                            const SizedBox(height: 6),
                            Text(
                              '${_pickedLocation!.latitude.toStringAsFixed(4)}, ${_pickedLocation!.longitude.toStringAsFixed(4)}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF0F766E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Radius: ${_radius.toInt()}m',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey[500]),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LucideIcons.map,
                                size: 32, color: Colors.grey[400]),
                            const SizedBox(height: 6),
                            Text(
                              'Drop a Pin on Map',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'Required for check-in verification',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Validation Radius Slider (if location picked) ──
            if (_pickedLocation != null) ...[
              Row(
                children: [
                  Text('Validation Radius: ',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  Text(
                    '${_radius.toInt()}m',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Slider(
                value: _radius,
                min: 20,
                max: 500,
                divisions: 24,
                label: '${_radius.toInt()}m',
                onChanged: (v) => setState(() => _radius = v),
              ),
              const SizedBox(height: 8),
            ],

            // ── Info text ──
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(LucideIcons.info, size: 16, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Setting a location enables check-in verification. '
                      'Users must be within the validation radius to check in.',
                      style: TextStyle(
                          fontSize: 12, color: Colors.blue[800]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView(ThemeData theme) {
    final isOffline = _createdVenue!.id.startsWith('local_');

    return Scaffold(
      appBar: AppBar(title: const Text('Venue Created')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isOffline ? Colors.amber[50] : Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isOffline ? Icons.cloud_off : Icons.check_circle,
                  color: isOffline ? Colors.amber[700] : Colors.green,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _createdVenue!.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (_createdVenue!.hasCoordinates)
                Text(
                  '📍 ${_createdVenue!.latitude!.toStringAsFixed(4)}, ${_createdVenue!.longitude!.toStringAsFixed(4)}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              if (_createdVenue!.city.isNotEmpty)
                Text(
                  _createdVenue!.city,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              const SizedBox(height: 8),
              Text(
                'Status: ${_createdVenue!.status}',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
              if (isOffline) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cloud_off,
                          size: 16, color: Colors.amber[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Saved offline. Will sync when connected.',
                          style: TextStyle(
                              fontSize: 12, color: Colors.amber[800]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(_createdVenue),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Use This Venue'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
