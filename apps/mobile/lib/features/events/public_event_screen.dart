// â”€â”€â”€ Public Event Page â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Shareable event page that works without authentication.
// Accessed via /e/:eventId. Anyone with the link can view this page.
// No shell, no nav, no auth required.

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../core/api/api_client.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import 'package:yugrow_mobile/core/theme/app_typography.dart';

class PublicEventScreen extends StatefulWidget {
  final String eventId;
  const PublicEventScreen({super.key, required this.eventId});

  @override
  State<PublicEventScreen> createState() => _PublicEventScreenState();
}

class _PublicEventScreenState extends State<PublicEventScreen> {
  final _api = ApiClient();
  Map<String, dynamic>? _event;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.getPublicEvent(widget.eventId);
      if (data == null) throw Exception('Event not found');
      if (mounted) setState(() { _event = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _loading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary))
          : _error != null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.calendar_x, size: 64, color: AppColors.border),
            const SizedBox(height: AppSpacing.xl),
            Text('Event not found',
              style: AppTypography.h3.copyWith(color: AppColors.textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            Text('This event may have ended or the link is invalid.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final event = _event!;
    final name = event['name'] as String? ?? 'Untitled Event';
    final venueData = event['venue'] as Map<String, dynamic>?;
    final venueName = venueData?['name'] as String? ?? '';
    final startDate = event['startDate'] != null ? DateTime.parse(event['startDate'] as String) : null;
    final dateStr = startDate != null ? DateFormat('EEEE, MMMM d Â· h:mm a').format(startDate) : '';
    final status = event['status'] as String? ?? 'ACTIVE';
    final isLive = status == 'ACTIVE';

    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textInverse,
          title: const Text('Event'),
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.share_2, size: 20),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: 'https://yugrow.app/e/${widget.eventId}'));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Link copied!'),
                  behavior: SnackBarBehavior.floating,
                ));
              },
            ),
          ],
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isLive ? const Color(0xFFBBF7D0) : const Color(0xFFFEF3C7),
                    borderRadius: AppRadius.xxlCircular,
                  ),
                  child: Text(
                    isLive ? 'â— Live now' : 'Ended',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isLive ? AppColors.success : AppColors.warning,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Event name
                Text(name,
                  style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: AppSpacing.sm),

                // Date/time
                if (dateStr.isNotEmpty) ...[
                  Row(children: [
                    const Icon(LucideIcons.calendar, size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.sm),
                    Text(dateStr, style: TextStyle(fontSize: 15, color: AppColors.textPrimary)),
                  ]),
                  const SizedBox(height: AppSpacing.sm),
                ],

                // Venue
                if (venueName.isNotEmpty) ...[
                  Row(children: [
                    const Icon(LucideIcons.map_pin, size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: Text(venueName, style: TextStyle(fontSize: 15, color: AppColors.textPrimary))),
                  ]),
                ],

                const SizedBox(height: AppSpacing.xl),
                const Divider(),
                const SizedBox(height: AppSpacing.xl),

                // Join button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/'),
                    icon: const Icon(LucideIcons.log_in, size: 20),
                    label: const Text('Open in Yugrow', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textInverse,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgCircular),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: Text('Install Yugrow to check in and network.',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                ),

                const SizedBox(height: AppSpacing.xxl),
                Center(
                  child: Text('Powered by Yugrow',
                    style: AppTypography.caption.copyWith(color: AppColors.textDisabled)),
                ),
              ],
            ),
          ),
        ),
      ],
    );

  }
}
