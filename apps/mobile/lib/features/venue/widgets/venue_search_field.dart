// ─── VenueSearchField ─────────────────────────────────────────────
// Shows suggested venues when focused (empty state), search results
// as the user types, and a "Create New Venue" fallback.
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
import '../services/venue_search_service.dart';
import 'create_venue_dialog.dart';
import 'location_picker_map.dart';

/// Suggested venues shown when the search field is focused/empty.
/// In production, these come from a "popular near you" API.
const _suggestedVenues = [
  'Tidel Park',
  'IIT Madras Research Park',
  'Chennai Trade Centre',
  'DLF IT Park',
  'WeWork OMR',
  'The Leela Palace',
  'Hotel Savera',
  'Phoenix Mall',
];

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
  late final VenueSearchService _searchService;
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();
  List<Venue> _results = [];
  Venue? _selected;
  bool _searching = false;
  bool _showResults = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _searchService = VenueSearchService(widget.api);
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _onSearchChanged(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _showResults = false;
      });
      return;
    }

    setState(() => _searching = true);
    final results = await _searchService.search(query);
    if (mounted) {
      setState(() {
        _results = results.venues;
        _showResults = true;
        _searching = false;
      });
    }
  }

  void _selectVenue(Venue venue) {
    setState(() {
      _selected = venue;
      _searchCtrl.text = venue.displayName;
      _showResults = false;
      _results = [];
    });
    widget.onVenueSelected(venue);
  }

  void _clearSelection() {
    setState(() {
      _selected = null;
      _searchCtrl.clear();
      _showResults = false;
      _results = [];
    });
    widget.onVenueSelected(null);
  }

  Future<void> _openCreateDialog() async {
    final venue = await showDialog<Venue>(
      context: context,
      builder: (ctx) => CreateVenueDialog(api: widget.api),
    );
    if (venue != null) {
      _selectVenue(venue);
    }
  }

  Future<void> _openMapPicker() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const LocationPickerMap()),
    );
    if (result != null && mounted) {
      final location = result['location'] as Location;
      final venue = Venue(
        id: 'new_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Pinned Location',
        address: result['address'] as String? ?? '',
        city: '',
        location: location,
        status: 'verified',
        createdAt: DateTime.now(),
      );
      _selectVenue(venue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Helper text ──
        Text('Search an existing venue or create a new one.',
          style: TextStyle(fontSize: 12, color: Colors.grey[600])),

        const SizedBox(height: 8),

        // ── If venue is selected, show confirmation ──
        if (_selected != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selected!.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF166534),
                        ),
                      ),
                      if (_selected!.city.isNotEmpty)
                        Text(
                          _selected!.city,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green[700],
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 28,
                  child: TextButton(
                    onPressed: _clearSelection,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                    ),
                    child: const Text('Change', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          )

        // ── Search field ──
        else
          TextField(
            controller: _searchCtrl,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Search for a venue...',
              prefixIcon: const Icon(LucideIcons.map_pin, size: 18),
              suffixIcon: _searching
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(LucideIcons.x, size: 16),
                          onPressed: () {
                            _searchCtrl.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              filled: true,
              fillColor: Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
            onChanged: _onSearchChanged,
          ),

        // ── Search results dropdown (when typing) ──
        if (_showResults && _results.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _results.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[200]),
              itemBuilder: (context, i) {
                final venue = _results[i];
                return ListTile(
                  dense: true,
                  leading: const Icon(LucideIcons.map_pin, size: 18, color: Colors.grey),
                  title: Text(venue.name, style: const TextStyle(fontSize: 14)),
                  subtitle: venue.city.isNotEmpty
                      ? Text(venue.city, style: TextStyle(fontSize: 12, color: Colors.grey[600]))
                      : null,
                  trailing: venue.eventCount > 0
                      ? Text(
                          '${venue.eventCount} events',
                          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                        )
                      : null,
                  onTap: () => _selectVenue(venue),
                );
              },
            ),
          ),

        // ── Suggested venues (when focused, empty, no search results) ──
        if (_isFocused && _selected == null && _searchCtrl.text.trim().isEmpty && !_showResults)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                  child: Text('Popular venues',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[500])),
                ),
                ...List.generate(_suggestedVenues.length, (i) {
                  return InkWell(
                    onTap: () {
                      _searchCtrl.text = _suggestedVenues[i];
                      _onSearchChanged(_suggestedVenues[i]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          Icon(LucideIcons.map_pin, size: 16, color: Colors.grey[400]),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(_suggestedVenues[i],
                              style: const TextStyle(fontSize: 14)),
                          ),
                          Icon(Icons.chevron_right, size: 16, color: Colors.grey[400]),
                        ],
                      ),
                    ),
                  );
                }),
                const Divider(height: 1),
                InkWell(
                  onTap: _openMapPicker,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.map, size: 16, color: Color(0xFF0F766E)),
                        SizedBox(width: 10),
                        Text('Select from Map',
                          style: TextStyle(fontSize: 14, color: Color(0xFF0F766E), fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
                InkWell(
                  onTap: _openCreateDialog,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      children: [
                        Icon(LucideIcons.plus, size: 16, color: Color(0xFF0F766E)),
                        SizedBox(width: 10),
                        Text('Create New Venue',
                          style: TextStyle(fontSize: 14, color: Color(0xFF0F766E), fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

        // ── No search results: show create / map options ──
        if (_showResults && _results.isEmpty && _searchCtrl.text.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _openMapPicker,
                    icon: const Icon(Icons.map, size: 16),
                    label: const Text('Select from Map'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _openCreateDialog,
                    icon: const Icon(LucideIcons.plus, size: 16),
                    label: Text('Create "${_searchCtrl.text.trim()}" as new venue'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
