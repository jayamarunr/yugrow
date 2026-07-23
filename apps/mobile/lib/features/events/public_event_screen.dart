// ─── Public Event Page ──────────────────────────────────────────
// Shareable event page that works without authentication.
// Accessed via /e/:eventId. Anyone with the link can view this page.
// No shell, no nav, no auth required.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../core/api/api_client.dart';

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
      backgroundColor: const Color(0xFFF8F9FB),
      body: _loading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF0F766E)))
          : _error != null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.calendar_x, size: 64, color: Color(0xFFD1D5DB)),
            const SizedBox(height: 20),
            const Text('Event not found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
            const SizedBox(height: 8),
            Text('This event may have ended or the link is invalid.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 24),
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
    final dateStr = startDate != null ? DateFormat('EEEE, MMMM d · h:mm a').format(startDate) : '';
    final status = event['status'] as String? ?? 'ACTIVE';
    final isLive = status == 'ACTIVE';

    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          backgroundColor: const Color(0xFF0F766E),
          foregroundColor: Colors.white,
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isLive ? const Color(0xFFBBF7D0) : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isLive ? '● Live now' : 'Ended',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isLive ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Event name
                Text(name,
                  style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: const Color(0xFF111827))),
                const SizedBox(height: 8),

                // Date/time
                if (dateStr.isNotEmpty) ...[
                  Row(children: [
                    const Icon(LucideIcons.calendar, size: 18, color: Color(0xFF6B7280)),
                    const SizedBox(width: 8),
                    Text(dateStr, style: TextStyle(fontSize: 15, color: Colors.grey[700])),
                  ]),
                  const SizedBox(height: 6),
                ],

                // Venue
                if (venueName.isNotEmpty) ...[
                  Row(children: [
                    const Icon(LucideIcons.map_pin, size: 18, color: Color(0xFF6B7280)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(venueName, style: TextStyle(fontSize: 15, color: Colors.grey[700]))),
                  ]),
                ],

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),

                // Join button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/'),
                    icon: const Icon(LucideIcons.log_in, size: 20),
                    label: const Text('Open in Yugrow', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text('Install Yugrow to check in and network.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                ),

                const SizedBox(height: 32),
                Center(
                  child: Text('Powered by Yugrow',
                    style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
