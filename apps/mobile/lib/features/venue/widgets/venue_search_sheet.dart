// â”€â”€â”€ VenueSearchSheet â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Bottom sheet for venue discovery. Never shows an empty state.
//
// Flow (FD-031):
//   Tap Venue â†’ Bottom Sheet opens
//     â†’ Search field (always visible)
//     â†’ Nearby Verified Venues (if available)
//     â†’ Recent Venues (if available)
//     â†’ Type to search â†’ Mapbox suggestions â†’ Nominatim fallback
//     â†’ Create New Venue (always visible at bottom)
//
// Usage:
//   final venue = await VenueSearchSheet.show(context, api: apiClient);

import 'package:flutter/material.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../core/api/api_client.dart';
import '../models/venue.dart';
import '../services/venue_search_service.dart';
import '../services/venue_analytics.dart';
import 'create_venue_page.dart';
import 'location_picker_map.dart';
import 'package:yugrow_mobile/core/theme/app_typography.dart';

class VenueSearchSheet extends StatefulWidget {
  final ApiClient api;

  const VenueSearchSheet({super.key, required this.api});

  /// Show the venue search bottom sheet and return the selected venue.
  static Future<Venue?> show(BuildContext context, {required ApiClient api}) {
    return showModalBottomSheet<Venue>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => VenueSearchSheet(api: api),
    );
  }

  @override
  State<VenueSearchSheet> createState() => _VenueSearchSheetState();
}

class _VenueSearchSheetState extends State<VenueSearchSheet> {
  late final VenueSearchService _searchService;
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();
  List<Venue> _results = [];
  List<Venue> _recentVenues = [];
  bool _searching = false;
  bool _hasTyped = false;

  @override
  void initState() {
    super.initState();
    _searchService = VenueSearchService(widget.api);
    _loadRecent();
    _focusNode.requestFocus();
    VenueAnalytics.searchStarted();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadRecent() async {
    try {
      final results = await _searchService.search('');
      if (mounted) {
        setState(() => _recentVenues = results.venues.take(5).toList());
      }
    } catch (_) {
      // Silent â€” recents are best-effort
    }
  }

  Future<void> _onSearchChanged(String query) async {
    setState(() => _hasTyped = query.trim().isNotEmpty);

    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _searching = false;
      });
      return;
    }

    setState(() => _searching = true);
    final results = await _searchService.search(query);
    if (mounted) {
      setState(() {
        _results = results.venues;
        _searching = false;
      });
    }
  }

  Future<void> _selectVenue(Venue venue) async {
    VenueAnalytics.existingVenueSelected(venue.name);
    if (_isExternalId(venue.id)) {
      // External venue â€” must import into Yugrow DB first
      final imported = await _importVenue(venue);
      if (imported != null && mounted) {
        Navigator.of(context).pop(imported);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not import this venue. Try "Create New Venue" instead.')),
        );
      }
    } else if (mounted) {
      // Already a Yugrow DB venue â€” safe to use directly
      Navigator.of(context).pop(venue);
    }
  }

  bool _isExternalId(String id) {
    return id.startsWith('osm_') || id.startsWith('mapbox_') ||
           id.startsWith('new_') || id.startsWith('local_');
  }

  Future<void> _openCreateDialog() async {
    VenueAnalytics.createVenueOpened();
    final venue = await Navigator.push<Venue>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateVenuePage(api: widget.api),
      ),
    );
    if (venue != null && mounted) {
      VenueAnalytics.createVenueCompleted();
      Navigator.of(context).pop(venue);
    } else if (mounted) {
      VenueAnalytics.createVenueAbandoned();
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
      // Import external venue into Yugrow's database
      final imported = await _importVenue(venue);
      if (imported != null && mounted) {
        Navigator.of(context).pop(imported);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save the pinned location. Please try again.')),
        );
      }
    }
  }

  /// Import an external venue into Yugrow's database.
  /// Returns the imported venue with a real DB ID, or null if import fails.
  Future<Venue?> _importVenue(Venue venue) async {
    if (!_isExternalId(venue.id)) return null;
    if (widget.api.personId == null || widget.api.workspaceId == null) {
      debugPrint('[VenueSearchSheet] Cannot import venue: personId or workspaceId not set');
      return null;
    }
    try {
      final data = <String, dynamic>{
        'name': venue.name,
        'address': venue.address,
        'city': venue.city,
        if (venue.latitude != null) 'latitude': venue.latitude,
        if (venue.longitude != null) 'longitude': venue.longitude,
        'createdByPersonId': widget.api.personId,
        'ownerWorkspaceId': widget.api.workspaceId,
      };
      final result = await widget.api.createVenue(data);
      return Venue.fromJson(result);
    } catch (e) {
      debugPrint('[VenueSearchSheet] Import failed: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.xl),
          child: Column(
            children: [
              // â”€â”€ Drag handle â”€â”€
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // â”€â”€ Title â”€â”€
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Venue',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // â”€â”€ Search field â”€â”€
              TextField(
                controller: _searchCtrl,
                focusNode: _focusNode,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search venue...',
                  prefixIcon: const Icon(LucideIcons.search, size: 20),
                  suffixIcon: _searching
                      ? const Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : _hasTyped
                          ? IconButton(
                              icon: const Icon(LucideIcons.x, size: 18),
                              onPressed: () {
                                _searchCtrl.clear();
                                _onSearchChanged('');
                              },
                            )
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.mdCircular,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: AppSpacing.sm),

              // â”€â”€ Results area â”€â”€
              Expanded(
                child: _hasTyped
                    ? _buildSearchResults(theme)
                    : _buildInitialView(theme, scrollController),
              ),

              // â”€â”€ Bottom action (always visible) â”€â”€
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _openCreateDialog,
                  icon: const Icon(LucideIcons.plus, size: 18),
                  label: const Text('Create New Venue'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    side: BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mdCircular,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextButton.icon(
                onPressed: _openMapPicker,
                icon: Icon(LucideIcons.map, size: 16, color: AppColors.textSecondary),
                label: Text(
                  'Drop a Pin on Map',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInitialView(ThemeData theme, ScrollController scrollController) {
    final hasRecent = _recentVenues.isNotEmpty;
    final suggestions = [
      'Coworking Space',
      'Conference Hall',
      'Hotel',
      'Restaurant',
      'Office',
      'Incubator',
      'University',
    ];

    return ListView(
      controller: scrollController,
      children: [
        // â”€â”€ Recent venues â”€â”€
        if (hasRecent) ...[
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xs),
            child: Text(
              'Recent Venues',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ..._recentVenues.map((venue) => _VenueResultTile(
                venue: venue,
                onTap: () => _selectVenue(venue),
              )),
          const SizedBox(height: AppSpacing.sm),
        ],

        // â”€â”€ Type suggestions â”€â”€
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs, bottom: AppSpacing.xs),
          child: Text(
            'Suggestions',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestions.map((s) {
            return ActionChip(
              label: Text(s, style: const TextStyle(fontSize: 13)),
              onPressed: () {
                _searchCtrl.text = s;
                _onSearchChanged(s);
              },
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.xxlCircular,
              ),
              side: BorderSide(color: AppColors.border),
              backgroundColor: AppColors.background,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSearchResults(ThemeData theme) {
    if (_searching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xxxl),
          child: Column(
            children: [
              Icon(LucideIcons.map_pin_off, size: 40, color: AppColors.border),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No venues found for "${_searchCtrl.text.trim()}"',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Create a new venue or try a different search.',
                style: TextStyle(color: AppColors.textDisabled, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.surfaceHover),
      itemBuilder: (context, i) => _VenueResultTile(
        venue: _results[i],
        onTap: () => _selectVenue(_results[i]),
      ),
    );
  }
}

class _VenueResultTile extends StatelessWidget {
  final Venue venue;
  final VoidCallback onTap;

  const _VenueResultTile({
    required this.venue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceHover,
          borderRadius: AppRadius.mdCircular,
        ),
        child: const Icon(LucideIcons.map_pin, size: 20, color: AppColors.primary),
      ),
      title: Text(
        venue.name,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (venue.city.isNotEmpty)
            Text(
              venue.city,
              style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          if (venue.hasCoordinates)
            Text(
              'ðŸ“ ${venue.latitude!.toStringAsFixed(4)}, ${venue.longitude!.toStringAsFixed(4)}',
              style: TextStyle(fontSize: 10, color: AppColors.textDisabled),
            ),
        ],
      ),
      trailing: venue.eventCount > 0
          ? Text(
              '${venue.eventCount}',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            )
          : null,
      onTap: onTap,
    );

  }
}
