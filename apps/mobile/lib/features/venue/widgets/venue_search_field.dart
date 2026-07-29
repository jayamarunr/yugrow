// ─── VenueSearchField ─────────────────────────────────────────────
// Tappable field that opens the VenueSearchSheet bottom sheet.
// Shows the selected venue as a confirmation badge.
//
// Usage:
//   VenueSearchField(
//     api: apiClient,
//     onVenueSelected: (venue) => setState(() => selectedVenue = venue),
//   )

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../core/api/api_client.dart';
import '../models/venue.dart';
import 'venue_search_sheet.dart';

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
        // ── Helper text ──
        const Text(
          'Where is your event?',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),

        if (_selected != null)
          // ── Selected venue confirmation ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(LucideIcons.map_pin,
                      size: 18, color: Color(0xFF166534)),
                ),
                const SizedBox(width: 12),
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
                          color: Color(0xFF166534),
                        ),
                      ),
                      if (_selected!.city.isNotEmpty)
                        Text(
                          _selected!.city,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
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
                    foregroundColor: const Color(0xFF166534),
                  ),
                  child: const Text('Change', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          )
        else
          // ── Tappable field to open bottom sheet ──
          InkWell(
            onTap: _openSearchSheet,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Row(
                children: [
                  Icon(LucideIcons.map_pin,
                      size: 18, color: Color(0xFF0F766E)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Search or create a venue...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_up,
                      size: 18, color: Colors.grey),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
