// â”€â”€â”€ Create Venue Dialog â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// âš ï¸  DEPRECATED â€” replaced by CreateVenuePage (full-page flow with
//     address autocomplete, reverse geocoding, and radius adjustment).
//     Kept for reference. New code should use CreateVenuePage instead.

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yugrow_mobile/core/api/api_client.dart';
import 'package:yugrow_mobile/features/venue/models/venue.dart';
import 'location_picker_map.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import 'package:yugrow_mobile/core/theme/app_typography.dart';

class CreateVenueDialog extends StatefulWidget {
  final ApiClient api;

  const CreateVenueDialog({super.key, required this.api});

  @override
  State<CreateVenueDialog> createState() => _CreateVenueDialogState();
}

class _CreateVenueDialogState extends State<CreateVenueDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();

  bool _saving = false;
  Location? _pickedLocation;
  String? _resolvedAddress;
  Venue? _created;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _openMapPicker() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerMap(
          addressHint: _nameCtrl.text.trim(),
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _pickedLocation = result['location'] as Location;
        _resolvedAddress = result['address'] as String?;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final data = <String, dynamic>{
        'name': _nameCtrl.text.trim(),
        if (_pickedLocation != null) ..._pickedLocation!.toJson(),
        if (_resolvedAddress != null) 'address': _resolvedAddress,
        'status': _pickedLocation != null ? 'verified' : 'pending',
      };

      final result = await widget.api.createVenue(data);
      setState(() {
        _created = Venue.fromJson(result);
        _saving = false;
      });
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create venue: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_created != null) {
      return AlertDialog(
        title: const Text('Venue Created'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text(_created!.name,
                style: Theme.of(context).textTheme.titleMedium),
            if (_created!.hasCoordinates)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  'ðŸ“ ${_created!.latitude!.toStringAsFixed(4)}, ${_created!.longitude!.toStringAsFixed(4)}',
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
              ),
            Text(_created!.displayName,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(_created),
            child: const Text('Use This Venue'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: const Text('Create New Venue'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // â”€â”€ Name (only manual field) â”€â”€
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Venue Name *',
                hintText: 'e.g. Startup Garage',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                filled: true,
                fillColor: AppColors.surface,
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: AppSpacing.lg),

            // â”€â”€ Map location picker (primary action) â”€â”€
            SizedBox(
              width: double.infinity,
              height: 120,
              child: OutlinedButton(
                onPressed: _openMapPicker,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: _pickedLocation != null
                        ? AppColors.success
                        : AppColors.border,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mdCircular),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                ),
                child: _pickedLocation != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle,
                              color: AppColors.success, size: 28),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '${_pickedLocation!.latitude.toStringAsFixed(4)}, ${_pickedLocation!.longitude.toStringAsFixed(4)}',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.success),
                          ),
                          if (_resolvedAddress != null)
                            Text(
                              _resolvedAddress!,
                              style:
                                  TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          Text(
                            'Radius: ${_pickedLocation!.validationRadius.toInt()}m',
                            style: TextStyle(
                                fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.map_pin,
                              size: 32, color: AppColors.primary),
                          const SizedBox(height: AppSpacing.sm),
                          const Text('Set Location on Map',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary)),
                          Text('Required for check-in verification',
                              style: TextStyle(
                                  fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  _pickedLocation != null
                      ? 'Create Venue'
                      : 'Skip Map (check-in disabled)',
                ),
        ),
      ],
    );

  }
}
