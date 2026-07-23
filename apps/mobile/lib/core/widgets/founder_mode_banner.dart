// ─── Founder Mode Banner ──────────────────────────────────────────
// Persistent banner shown when seeded test attendees are active.
// Prevents accidentally running a real meetup with fake data visible.
// Auto-dismisses after 8 seconds. Can be manually dismissed.

import 'package:flutter/material.dart';
import '../api/api_client.dart';

class FounderModeBanner extends StatefulWidget {
  const FounderModeBanner({super.key});

  @override
  State<FounderModeBanner> createState() => _FounderModeBannerState();
}

class _FounderModeBannerState extends State<FounderModeBanner> {
  final _api = ApiClient();
  Map<String, dynamic>? _status;
  bool _loading = true;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final status = await _api.getTestStatus();
      if (mounted) {
        setState(() {
          _status = status;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _dismissed) return const SizedBox.shrink();

    final hasSeeded = _status?['hasSeededAttendees'] == true;
    if (!hasSeeded) return const SizedBox.shrink();

    final totalSeeded = _status?['totalSeededActive'] as int? ?? 0;
    final events = (_status?['events'] as List<dynamic>?) ?? [];

    // Build a summary: "20 seeded in AI Meetup + 1 more"
    String summary;
    if (events.isEmpty) {
      summary = '$totalSeeded seeded attendees active';
    } else {
      final first = events.first as Map<String, dynamic>;
      final firstName = first['eventName'] as String? ?? 'Unknown';
      final firstSeeded = first['seededAttendees'] as int? ?? 0;
      final remaining = totalSeeded - firstSeeded;
      summary = remaining > 0
          ? '$firstSeeded seeded in "$firstName" + $remaining more'
          : '$firstSeeded seeded in "$firstName"';
    }

    return MaterialBanner(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      backgroundColor: const Color(0xFFFFF3CD),
      content: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, size: 18, color: Color(0xFFD97706)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Founder Mode · $summary',
              style: const TextStyle(fontSize: 13, color: Color(0xFF92400E)),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => _fetch(),
          child: const Text('Refresh', style: TextStyle(fontSize: 12, color: Color(0xFF92400E))),
        ),
        TextButton(
          onPressed: () => setState(() => _dismissed = true),
          child: const Text('Dismiss', style: TextStyle(fontSize: 12, color: Color(0xFF92400E))),
        ),
      ],
    );
  }
}
