// ─── Yugrow Debug Screen ──────────────────────────────────────────
// Hidden debug screen for alpha testing. Only available in debug builds.
// Accessible by long-pressing the Yugrow logo on the Arrival screen.
// Shows internal state for troubleshooting at live events.

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  final _api = ApiClient();
  String _lastApiCall = 'None';
  String _apiUrl = 'http://localhost:4000/api/v1';
  String _appVersion = '0.1.1-alpha';
  String _buildNumber = '1';

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    try {
      final response = await _api.getActiveEvents();
      setState(() => _lastApiCall = 'GET /checkin/events — ${response.length} events');
    } catch (e) {
      setState(() => _lastApiCall = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF8F9FB);
    final cardColor = isDark ? const Color(0xFF16213E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final mutedColor = isDark ? Colors.grey[400]! : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Debug'),
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('App', [
            _row('Version', _appVersion, textColor, mutedColor),
            _row('Build', _buildNumber, textColor, mutedColor),
            _row('Flutter', '3.x', textColor, mutedColor),
          ], cardColor),
          const SizedBox(height: 12),
          _section('Network', [
            _row('API URL', _apiUrl, textColor, mutedColor),
            _row('Last Call', _lastApiCall, textColor, mutedColor),
          ], cardColor),
          const SizedBox(height: 12),
          _section('Actions', [
            _actionButton('Refresh API Status', _loadInfo, textColor, cardColor),
            _actionButton('Test Check-in Flow', () {}, textColor, cardColor),
            _actionButton('View Session Log', () {}, textColor, cardColor),
          ], cardColor),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFE58F)),
            ),
            child: const Text(
              'This screen is only available in debug builds. '
              'It will be removed before production release.',
              style: TextStyle(fontSize: 12, color: Color(0xFF856404)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children, Color cardColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F766E),
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...children,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _row(String label, String value, Color textColor, Color mutedColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: mutedColor)),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: textColor),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String label, VoidCallback onTap, Color textColor, Color cardColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: TextButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.play_arrow, size: 16),
        label: Text(label),
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF0F766E),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
