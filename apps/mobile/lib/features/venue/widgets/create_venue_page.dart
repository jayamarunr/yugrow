// â”€â”€â”€ CreateVenuePage â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Full-page venue creation flow (replaces the old dialog).
//
// Flow:
//   Venue Name
//     â†“
//   Search Address (autocomplete via Mapbox / Nominatim)
//     â†“
//   Autocomplete results
//     â†“
//   Drop Pin on Map (with reverse geocoding to fill address fields)
//     â†“
//   Adjust Validation Radius
//     â†“
//   Save
//
// Manual address editing is possible at every step.
// Returns the created Venue via Navigator.pop().

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../core/api/api_client.dart';
import '../models/venue.dart';

import '../services/providers/mapbox_provider.dart';
import '../services/providers/nominatim_provider.dart';

import 'location_picker_map.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import 'package:yugrow_mobile/core/theme/app_typography.dart';

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
      // â”€â”€ Offline fallback â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            // â”€â”€ Venue Name â”€â”€
            Text(
              'Venue Name',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                hintText: 'e.g. Startup Garage',
                prefixIcon: const Icon(LucideIcons.building_2, size: 18),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.mdCircular,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Venue name is required' : null,
            ),
            const SizedBox(height: AppSpacing.xl),

            // â”€â”€ Address Search â”€â”€
            Text(
              'Search Address',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _addressCtrl,
              decoration: InputDecoration(
                hintText: 'Start typing an address...',
                prefixIcon: const Icon(LucideIcons.search, size: 18),
                suffixIcon: _searchingAddress
                    ? const Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.mdCircular,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
              ),
              onChanged: _onAddressChanged,
            ),

            // â”€â”€ Address autocomplete suggestions â”€â”€
            if (_addressSuggestions.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 180),
                margin: const EdgeInsets.only(top: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: AppRadius.mdCircular,
                  border: Border.all(color: AppColors.border),
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
                      Divider(height: 1, color: AppColors.surfaceHover),
                  itemBuilder: (context, i) {
                    final s = _addressSuggestions[i];
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        LucideIcons.map_pin,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      title: Text(
                        s['name'] as String? ?? '',
                        style: const TextStyle(fontSize: 13),
                      ),
                      subtitle: s['address'] != s['name']
                          ? Text(
                              s['address'] as String? ?? '',
                              style: TextStyle(
                                  fontSize: 11, color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      trailing: Text(
                        s['provider'] as String? ?? '',
                        style: TextStyle(
                            fontSize: 10, color: AppColors.textDisabled),
                      ),
                      onTap: () => _selectAddressSuggestion(s),
                    );
                  },
                ),
              ),
            const SizedBox(height: AppSpacing.md),

            // â”€â”€ City (auto-filled from map or address search) â”€â”€
            TextFormField(
              controller: _cityCtrl,
              decoration: InputDecoration(
                labelText: 'City',
                prefixIcon: const Icon(Icons.location_city, size: 18),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.mdCircular,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // â”€â”€ Map picker â”€â”€
            InkWell(
              onTap: _openMapPicker,
              borderRadius: AppRadius.mdCircular,
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.mdCircular,
                  border: Border.all(
                    color: _pickedLocation != null
                        ? AppColors.primary
                        : AppColors.border,
                    width: 1.5,
                  ),
                  color: AppColors.background,
                ),
                child: Center(
                  child: _pickedLocation != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle,
                                color: AppColors.primary, size: 32),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              '${_pickedLocation!.latitude.toStringAsFixed(4)}, ${_pickedLocation!.longitude.toStringAsFixed(4)}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Radius: ${_radius.toInt()}m',
                              style: TextStyle(
                                  fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LucideIcons.map,
                                size: 32, color: AppColors.textDisabled),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Drop a Pin on Map',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              'Required for check-in verification',
                              style: TextStyle(
                                  fontSize: 11, color: AppColors.textDisabled),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // â”€â”€ Validation Radius Slider (if location picked) â”€â”€
            if (_pickedLocation != null) ...[
              Row(
                children: [
                  Text('Validation Radius: ',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
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
              const SizedBox(height: AppSpacing.sm),
            ],

            // â”€â”€ Info text â”€â”€
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.info,
                borderRadius: AppRadius.mdCircular,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(LucideIcons.info, size: 16, color: AppColors.info),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Setting a location enables check-in verification. '
                      'Users must be within the validation radius to check in.',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.info),
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
          padding: const EdgeInsets.all(AppSpacing.xxxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isOffline ? Colors.amber[50] : AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isOffline ? Icons.cloud_off : Icons.check_circle,
                  color: isOffline ? Colors.amber[700] : AppColors.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                _createdVenue!.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              if (_createdVenue!.hasCoordinates)
                Text(
                  'ðŸ“ ${_createdVenue!.latitude!.toStringAsFixed(4)}, ${_createdVenue!.longitude!.toStringAsFixed(4)}',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              if (_createdVenue!.city.isNotEmpty)
                Text(
                  _createdVenue!.city,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Status: ${_createdVenue!.status}',
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
              if (isOffline) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: AppRadius.smCircular,
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cloud_off,
                          size: 16, color: Colors.amber[700]),
                      const SizedBox(width: AppSpacing.sm),
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
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(_createdVenue),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Use This Venue'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mdCircular,
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
