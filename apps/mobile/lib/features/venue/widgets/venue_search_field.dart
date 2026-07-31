// â”€â”€â”€ VenueSearchField â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Tappable field that opens the VenueSearchSheet bottom sheet.
// Shows the selected venue as a confirmation badge.
//
// Usage:
//   VenueSearchField(
//     api: apiClient,
//     onVenueSelected: (venue) => setState(() => selectedVenue = venue),
//   )

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../core/api/api_client.dart';
import '../models/venue.dart';
import 'venue_search_sheet.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import 'package:yugrow_mobile/core/theme/app_typography.dart';

class VenueSearchField extends StatefulWidget {
  final ApiClient api;
  final void Function(Venue? venue) onVenueSelected;

  const VenueSearchField({
    super.key,
    required this.api,
    required this.onVenueSelected,
  });

  @override
  State<VenueSearchField> createState() => _VenueSearchFieldState();
}

class _VenueSearchFieldState extends State<VenueSearchField> {
  Venue? _selected;

  Future<void> _openSearchSheet() async {
    final venue = await VenueSearchSheet.show(context, api: widget.api);
    if (venue != null) {
      setState(() => _selected = venue);
      widget.onVenueSelected(venue);
    }
  }

  void _clearSelection() {
    setState(() => _selected = null);
    widget.onVenueSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // â”€â”€ Helper text â”€â”€
        Text(
          'Where is your event?',
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),

        if (_selected != null)
          // â”€â”€ Selected venue confirmation â”€â”€
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: AppRadius.mdCircular,
              border: Border.all(color: AppColors.success),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: AppRadius.smCircular,
                  ),
                  child: const Icon(LucideIcons.map_pin,
                      size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selected!.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      if (_selected!.city.isNotEmpty)
                        Text(
                          _selected!.city,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.success,
                          ),
                        ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _clearSelection,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('Change', style: AppTypography.caption),
                ),
              ],
            ),
          )
        else
          // â”€â”€ Tappable field to open bottom sheet â”€â”€
          InkWell(
            onTap: _openSearchSheet,
            borderRadius: AppRadius.mdCircular,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.mdCircular,
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  Icon(LucideIcons.map_pin,
                      size: 18, color: AppColors.primary),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Search or create a venue...',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_up,
                      size: 18, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
      ],
    );

  }
}
