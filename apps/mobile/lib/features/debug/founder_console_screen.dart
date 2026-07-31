// â”€â”€â”€ Yugrow Founder Console v2 â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Enhanced founder console for testing, validation, and demos.
// Accessible from Profile screen. NOT exposed to end users.
//
// Sprint 6.7 â€” Founder Mode only. No public hosting, no navigation changes.

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import '../../core/api/api_client.dart';
import 'feedback_inbox_screen.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import 'package:yugrow_mobile/core/theme/app_typography.dart';

class FounderConsole extends StatefulWidget {
  const FounderConsole({super.key});

  @override
  State<FounderConsole> createState() => _FounderConsoleState();
}

class _FounderConsoleState extends State<FounderConsole> {
  final _api = ApiClient();

  // â”€â”€ App Info â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  final String _apiUrl = 'http://localhost:4000/api/v1';
  final String _appVersion = '0.1.1-alpha';
  final String _buildNumber = '1';
  String _lastApiCall = 'None';
  bool _apiHealthy = false;

  // â”€â”€ Event List â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  List<Map<String, dynamic>> _events = [];
  bool _eventsLoading = false;

  // â”€â”€ Create Event Form â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  bool _showCreateForm = false;
  bool _showEditForm = false;
  Map<String, dynamic>? _editingEvent;
  final _nameCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _radiusCtrl = TextEditingController(text: '100');
  String _visibility = 'PUBLIC';
  bool _creating = false;
  bool _editing = false;

  // â”€â”€ Result feedback â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  String _resultText = '';
  bool _resultIsError = false;
  bool _isLoading = false;

  // â”€â”€ Test Status Dashboard â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Map<String, dynamic>? _testStatus;

  // â”€â”€ Send Message Forms â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  bool _showReleaseForm = false;
  bool _showAnnouncementForm = false;
  bool _showFeedbackStatusForm = false;
  bool _sendingMessage = false;

  // Release Note form
  final _releasePersonCtrl = TextEditingController(text: 'person-001');
  final _releaseVersionCtrl = TextEditingController(text: '0.9.8');
  final _releaseTitleCtrl = TextEditingController(text: "What's New");
  final _releaseChangesCtrl = TextEditingController(text: 'Venue search improved\nProfile cards\nFaster check-in');
  final _releaseActionCtrl = TextEditingController(text: 'Read More');

  // Announcement form
  final _announcePersonCtrl = TextEditingController(text: 'person-001');
  final _announceTitleCtrl = TextEditingController(text: 'Professional Meetup');
  final _announceDateCtrl = TextEditingController(text: 'Saturday');
  final _announceLocationCtrl = TextEditingController(text: 'Chennai');
  final _announceDescCtrl = TextEditingController(text: '');
  final _announceActionCtrl = TextEditingController(text: 'Register');

  // Feedback Status form
  final _feedbackPersonCtrl = TextEditingController(text: 'person-001');
  final _feedbackTitleCtrl = TextEditingController(text: 'Duplicate Events');
  final _feedbackStatusCtrl = TextEditingController(text: 'Accepted');
  final _feedbackSprintCtrl = TextEditingController(text: 'Sprint 12');
  final _feedbackNoteCtrl = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _venueCtrl.dispose();
    _cityCtrl.dispose();
    _radiusCtrl.dispose();
    _releasePersonCtrl.dispose();
    _releaseVersionCtrl.dispose();
    _releaseTitleCtrl.dispose();
    _releaseChangesCtrl.dispose();
    _releaseActionCtrl.dispose();
    _announcePersonCtrl.dispose();
    _announceTitleCtrl.dispose();
    _announceDateCtrl.dispose();
    _announceLocationCtrl.dispose();
    _announceDescCtrl.dispose();
    _announceActionCtrl.dispose();
    _feedbackPersonCtrl.dispose();
    _feedbackTitleCtrl.dispose();
    _feedbackStatusCtrl.dispose();
    _feedbackSprintCtrl.dispose();
    _feedbackNoteCtrl.dispose();
    super.dispose();
  }

  // â”€â”€ Helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _refresh() async {
    await Future.wait([_checkApiHealth(), _loadEvents(), _loadTestStatus()]);
  }

  Future<void> _loadTestStatus() async {
    try {
      final status = await _api.getTestStatus();
      if (mounted) setState(() => _testStatus = status);
    } catch (_) {}
  }

  Future<void> _checkApiHealth() async {
    try {
      final response = await _api.getActiveEvents();
      setState(() {
        _apiHealthy = true;
        _lastApiCall = 'GET /checkin/events â€” ${response.length} events';
      });
    } catch (e) {
      setState(() {
        _apiHealthy = false;
        _lastApiCall = 'Error: $e';
      });
    }
  }

  Future<void> _loadEvents() async {
    setState(() => _eventsLoading = true);
    try {
      final data = await _api.getActiveEvents();
      setState(() {
        _events = data.cast<Map<String, dynamic>>();
        _eventsLoading = false;
      });
    } catch (e) {
      setState(() {
        _events = [];
        _eventsLoading = false;
      });
    }
  }

  void _showResult(String message, {bool isError = false}) {
    setState(() {
      _resultText = message;
      _resultIsError = isError;
    });
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _resultText = '');
    });
  }

  Future<void> _withLoading(Future<void> Function() fn) async {
    setState(() => _isLoading = true);
    try {
      await fn();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // â”€â”€ Create Event â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _createEvent() async {
    final name = _nameCtrl.text.trim();
    final venue = _venueCtrl.text.trim();
    final city = _cityCtrl.text.trim();

    if (name.isEmpty || venue.isEmpty) {
      _showResult('Name and venue are required.', isError: true);
      return;
    }

    setState(() => _creating = true);
    try {
      // 1. Find or create venue
      List<dynamic> searchResults;
      try {
        searchResults = await _api.searchVenues(venue);
      } catch (_) {
        searchResults = [];
      }

      String venueId;
      final matched = searchResults.cast<Map<String, dynamic>>().where(
        (v) => (v['name'] as String?)?.toLowerCase() == venue.toLowerCase(),
      ).toList();

      if (matched.isNotEmpty) {
        venueId = matched.first['id'] as String;
      } else {
        final newVenue = await _api.createVenue({
          'name': venue,
          'city': city.isNotEmpty ? city : 'Chennai',
          'createdByPersonId': 'person-self',
          'ownerWorkspaceId': 'personal',
        });
        venueId = newVenue['id'] as String;
      }

      // 2. Create event
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day, 18, 0); // Today 6 PM
      final endDate = DateTime(now.year, now.month, now.day, 21, 0);  // Today 9 PM

      final event = await _api.createEvent({
        'name': name,
        'venueId': venueId,
        'organizerWorkspaceId': 'personal',
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      });

      _nameCtrl.clear();
      _venueCtrl.clear();
      _cityCtrl.clear();
      setState(() => _showCreateForm = false);
      _showResult('Event "${event['name']}" created!');
      await _loadEvents();
    } catch (e) {
      _showResult('Failed to create event: $e', isError: true);
    } finally {
      setState(() => _creating = false);
    }
  }

  // â”€â”€ Edit Event â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  void _openEditForm(Map<String, dynamic> event) {
    setState(() {
      _editingEvent = event;
      _nameCtrl.text = event['name'] as String? ?? '';
      _venueCtrl.text = (event['venue'] as Map<String, dynamic>?)?['name'] as String? ?? '';
      _radiusCtrl.text = '100';
      _visibility = event['visibility'] as String? ?? 'PUBLIC';
      _showEditForm = true;
    });
  }

  Future<void> _saveEdit() async {
    final event = _editingEvent;
    if (event == null) return;
    final id = event['id'] as String;
    final name = _nameCtrl.text.trim();

    if (name.isEmpty) {
      _showResult('Name is required.', isError: true);
      return;
    }

    setState(() => _editing = true);
    try {
      await _api.updateEvent(id, {
        'name': name,
        'visibility': _visibility,
      });
      setState(() => _showEditForm = false);
      _editingEvent = null;
      _showResult('Event updated!');
      await _loadEvents();
    } catch (e) {
      _showResult('Failed to update: $e', isError: true);
    } finally {
      setState(() => _editing = false);
    }
  }

  // â”€â”€ End Event â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _endEvent(String id, String name) async {
    final confirm = await _confirmDialog(
      'End Event',
      'Expire "$name"? All active presence will be cleared.',
    );
    if (!confirm) return;

    await _withLoading(() async {
      try {
        await _api.expireEvent(id);
        _showResult('Event "$name" ended.');
        await _loadEvents();
      } catch (e) {
        _showResult('Failed to end event: $e', isError: true);
      }
    });
  }

  // â”€â”€ Duplicate Event â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _duplicateEvent(String id, String name) async {
    await _withLoading(() async {
      try {
        final result = await _api.duplicateEvent(id);
        final newName = result['name'] as String? ?? 'Duplicated event';
        _showResult('Duplicated as "$newName"');
        await _loadEvents();
      } catch (e) {
        _showResult('Failed to duplicate: $e', isError: true);
      }
    });
  }

  // â”€â”€ Seed Attendees â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _seedAttendees(String eventId, String eventName) async {
    await _withLoading(() async {
      try {
        final result = await _api.seedTestAttendees(eventId, count: 20);
        final count = result['count'] as int? ?? 20;
        _showResult('$count test attendees seeded for "$eventName"');
      } catch (e) {
        _showResult('Failed to seed: $e', isError: true);
      }
    });
  }

  // â”€â”€ Clear Presence â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _clearPresence() async {
    final confirm = await _confirmDialog(
      'Clear Presence',
      'Expire ALL active presence across all events?',
    );
    if (!confirm) return;

    await _withLoading(() async {
      try {
        final result = await _api.clearPresence();
        final count = result['count'] as int? ?? 0;
        _showResult('Cleared $count active presence records.');
      } catch (e) {
        _showResult('Failed to clear presence: $e', isError: true);
      }
    });
  }

  // â”€â”€ Reset Demo Data â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _resetDemoData() async {
    final confirm = await _confirmDialog(
      'âš ï¸ Reset Demo Data',
      'This will delete ALL test attendees, their workspaces, '
      'and related data. Events and venues will be preserved.\n\n'
      'This cannot be undone.',
    );
    if (!confirm) return;

    await _withLoading(() async {
      try {
        final result = await _api.resetDemoData();
        final removed = result['removedAttendees'] as int? ?? 0;
        _showResult('Reset complete. Removed $removed test attendees.');
        await _loadEvents();
      } catch (e) {
        _showResult('Failed to reset: $e', isError: true);
      }
    });
  }

  // â”€â”€ Founder Login â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _founderLogin() async {
    await _withLoading(() async {
      try {
        final result = await _api.founderLogin();
        final token = result['token'] as String?;
        final person = result['person'] as Map<String, dynamic>?;
        if (token != null) {
          await _api.setAuthToken(token);
          final name = person?['name'] as String? ?? 'Founder';
          _showResult('Signed in as $name. Refresh the app to authenticate.');
        }
      } catch (e) {
        _showResult('Login failed: $e', isError: true);
      }
    });
  }

  // â”€â”€ Dialog â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<bool> _confirmDialog(String title, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // BUILD
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A2E) : AppColors.background;
    final cardColor = isDark ? const Color(0xFF16213E) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.textPrimary;
    final mutedColor = isDark ? AppColors.textDisabled : AppColors.textSecondary;
    const dangerColor = AppColors.error;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Founder Mode'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textInverse,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: _refresh,
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 100),
            children: [
              // â”€â”€ Result Banner â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              if (_resultText.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: _resultIsError
                        ? const Color(0xFFFEF2F2)
                        : const Color(0xFFF0FDF4),
                    borderRadius: AppRadius.smCircular,
                    border: Border.all(
                      color: _resultIsError
                          ? const Color(0xFFFECACA)
                          : const Color(0xFFBBF7D0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _resultIsError ? Icons.error_outline : Icons.check_circle_outline,
                        size: 18,
                        color: _resultIsError ? dangerColor : AppColors.success,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          _resultText,
                          style: TextStyle(
                            fontSize: 13,
                            color: _resultIsError ? dangerColor : AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // â”€â”€ App Info â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              _section('App', cardColor, [
                _row('Version', _appVersion, textColor, mutedColor),
                _row('Build', _buildNumber, textColor, mutedColor),
              ]),
              const SizedBox(height: AppSpacing.md),

              // â”€â”€ API Health â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              _section('API Health', cardColor, [
                _row('URL', _apiUrl, textColor, mutedColor),
                _row('Status', _apiHealthy ? 'Connected âœ“' : 'Disconnected âœ—',
                    _apiHealthy ? AppColors.success : dangerColor, mutedColor),
                _row('Last Call', _lastApiCall, textColor, mutedColor),
                _founderButton('Refresh API Status', Icons.refresh, _checkApiHealth),
              ]),
              const SizedBox(height: AppSpacing.md),

              // â”€â”€ Current Event Dashboard â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              if (_testStatus != null && (_testStatus!['hasSeededAttendees'] == true || (_testStatus!['events'] as List?)?.isNotEmpty == true))
                _section('Current Event', cardColor, [
                  ...(_testStatus!['events'] as List).map((e) {
                    final event = e as Map<String, dynamic>;
                    return _buildEventDashboard(event, textColor, mutedColor);
                  }),
                  const SizedBox(height: AppSpacing.xs),
                ]),
              if (_testStatus != null && (_testStatus!['hasSeededAttendees'] == true || (_testStatus!['events'] as List?)?.isNotEmpty == true))
                const SizedBox(height: AppSpacing.md),

              // â”€â”€ Event Management â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              _section('Event Management', cardColor, [
                // Create button
                _founderButton(
                  'Create Test Event',
                  Icons.add_circle_outline,
                  () => setState(() => _showCreateForm = !_showCreateForm),
                ),

                // Create form
                if (_showCreateForm) _buildCreateForm(mutedColor),

                // Edit form
                if (_showEditForm) _buildEditForm(mutedColor),

                // Divider if there are events
                if (_events.isNotEmpty) const Divider(height: 1),

                // Event list
                if (_eventsLoading)
                  const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                else if (_events.isEmpty && !_showCreateForm)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      'No active events. Create one to get started.',
                      style: TextStyle(fontSize: 13, color: mutedColor),
                    ),
                  )
                else
                  ..._events.map((event) => _buildEventTile(event, textColor, mutedColor, cardColor)),
              ]),
              const SizedBox(height: AppSpacing.md),

              // â”€â”€ Auth â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              _section('Auth', cardColor, [
                _founderButton(
                  'Sign in as Founder',
                  Icons.person_outline,
                  _founderLogin,
                ),
              ]),
              const SizedBox(height: AppSpacing.md),

              // â”€â”€ Test Data Tools â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              _section('Test Data', cardColor, [
                _founderButton(
                  'Seed 20 Test Attendees',
                  Icons.people_outline,
                  () => _showEventPicker('Select event to seed attendees', _seedAttendees),
                ),
                _founderButton(
                  'Clear All Presence',
                  Icons.logout,
                  _clearPresence,
                ),
                _founderButton(
                  'Reset Demo Data',
                  Icons.delete_sweep_outlined,
                  _resetDemoData,
                ),
              ]),
              const SizedBox(height: AppSpacing.md),

              // â”€â”€ Founder Inbox â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              _section('Founder Inbox ðŸ’¬', cardColor, [
                _founderButton(
                  'View Feedback Inbox',
                  Icons.inbox_outlined,
                  _openFeedbackInbox,
                ),
              ]),
              const SizedBox(height: AppSpacing.md),

              // â”€â”€ Send Messages â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              _section('Send Messages ðŸ“¨', cardColor, [
                _founderButton(
                  'Send Release Note',
                  Icons.newspaper,
                  () => setState(() => _showReleaseForm = !_showReleaseForm),
                ),
                if (_showReleaseForm) _buildReleaseForm(mutedColor),

                _founderButton(
                  'Send Announcement',
                  Icons.campaign,
                  () => setState(() => _showAnnouncementForm = !_showAnnouncementForm),
                ),
                if (_showAnnouncementForm) _buildAnnouncementForm(mutedColor),

                _founderButton(
                  'Send Feedback Status',
                  Icons.feedback,
                  () => setState(() => _showFeedbackStatusForm = !_showFeedbackStatusForm),
                ),
                if (_showFeedbackStatusForm) _buildFeedbackStatusForm(mutedColor),
              ]),
              const SizedBox(height: AppSpacing.md),

              // â”€â”€ Warning â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: AppRadius.smCircular,
                  border: Border.all(color: const Color(0xFFFFE58F)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ðŸ”’ Founder Mode Only',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'These tools are for founder testing only. '
                      'They will be removed or redesigned before '
                      'the public Host experience is built.',
                      style: AppTypography.caption.copyWith(color: AppColors.warning),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),

          // â”€â”€ Loading Overlay â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          if (_isLoading)
            Container(
              color: AppColors.textDisabled,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // â”€â”€ Create Event Form â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildCreateForm(Color mutedColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: AppRadius.mdCircular,
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('New Test Event',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Event Name',
              hintText: 'e.g. AI Meetup Chennai',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _venueCtrl,
            decoration: const InputDecoration(
              labelText: 'Venue',
              hintText: 'e.g. Tidel Park',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _cityCtrl,
            decoration: const InputDecoration(
              labelText: 'City',
              hintText: 'Chennai',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _visibility,
            decoration: const InputDecoration(
              labelText: 'Visibility',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: 'PUBLIC', child: Text('Public')),
              DropdownMenuItem(value: 'PRIVATE', child: Text('Private')),
              DropdownMenuItem(value: 'HIDDEN', child: Text('Hidden')),
            ],
            onChanged: (v) => setState(() => _visibility = v ?? 'PUBLIC'),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Starts today at 6 PM Â· Ends at 9 PM',
            style: AppTypography.caption.copyWith(color: mutedColor),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _creating ? null : _createEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textInverse,
                  ),
                  child: _creating
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Create Event'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TextButton(
                onPressed: () => setState(() => _showCreateForm = false),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // â”€â”€ Edit Event Form â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildEditForm(Color mutedColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: AppRadius.mdCircular,
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Edit Event',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Event Name',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _visibility,
            decoration: const InputDecoration(
              labelText: 'Visibility',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: 'PUBLIC', child: Text('Public')),
              DropdownMenuItem(value: 'PRIVATE', child: Text('Private')),
              DropdownMenuItem(value: 'HIDDEN', child: Text('Hidden')),
            ],
            onChanged: (v) => setState(() => _visibility = v ?? 'PUBLIC'),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _editing ? null : _saveEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textInverse,
                  ),
                  child: _editing
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Save'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showEditForm = false;
                    _editingEvent = null;
                  });
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // â”€â”€ Event Dashboard â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildEventDashboard(Map<String, dynamic> event, Color textColor, Color mutedColor) {
    final eventName = event['eventName'] as String? ?? 'Unknown';
    final total = event['totalAttendees'] as int? ?? 0;
    final real = event['realAttendees'] as int? ?? 0;
    final seeded = event['seededAttendees'] as int? ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(eventName,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor)),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _statBox('Total', '$total', AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              _statBox('Real', '$real', AppColors.success),
              const SizedBox(width: AppSpacing.sm),
              _statBox('Seeded', '$seeded', AppColors.warning),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: AppRadius.smCircular,
        ),
        child: Column(
          children: [
            Text(value,
              style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: color)),
            Text(label,
              style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // â”€â”€ Event Tile â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildEventTile(Map<String, dynamic> event, Color textColor, Color mutedColor, Color cardColor) {
    final name = event['name'] as String? ?? 'Untitled';
    final id = event['id'] as String? ?? '';
    final venueData = event['venue'] as Map<String, dynamic>?;
    final venue = venueData?['name'] as String? ?? '';
    final status = event['status'] as String? ?? 'ACTIVE';
    final visibility = event['visibility'] as String? ?? 'PUBLIC';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.smCircular,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(name,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: status == 'ACTIVE'
                      ? const Color(0xFFBBF7D0)
                      : const Color(0xFFFEF3C7),
                  borderRadius: AppRadius.xsCircular,
                ),
                child: Text(status,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
                    color: status == 'ACTIVE' ? AppColors.success : AppColors.warning)),
              ),
            ],
          ),
          if (venue.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text('$venue Â· $visibility',
                style: AppTypography.caption.copyWith(color: mutedColor)),
            ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _smallButton('Edit', () => _openEditForm(event)),
              const SizedBox(width: AppSpacing.sm),
              _smallButton('End', () => _endEvent(id, name)),
              const SizedBox(width: AppSpacing.sm),
              _smallButton('Duplicate', () => _duplicateEvent(id, name)),
              const SizedBox(width: AppSpacing.sm),
              _smallButton('Seed', () => _seedAttendees(id, name)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallButton(String label, VoidCallback onTap) {
    return SizedBox(
      height: 28,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          textStyle: const TextStyle(fontSize: 11),
          side: const BorderSide(color: AppColors.border),
          foregroundColor: AppColors.textPrimary,
        ),
        child: Text(label),
      ),
    );
  }

  // â”€â”€ Event Picker Dialog â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _showEventPicker(
    String title,
    Future<void> Function(String eventId, String eventName) action,
  ) async {
    await _loadEvents();
    if (!mounted) return;
    if (_events.isEmpty) {
      _showResult('No active events to use.', isError: true);
      return;
    }

    final selected = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(title),
        children: _events.map((event) {
          final name = event['name'] as String? ?? 'Untitled';
          return SimpleDialogOption(
            onPressed: () => Navigator.of(ctx).pop(event),
            child: Text(name),
          );
        }).toList(),
      ),
    );

    if (selected != null) {
      final eventId = selected['id'] as String;
      final eventName = selected['name'] as String? ?? 'Event';
      await action(eventId, eventName);
    }
  }

  // â”€â”€ Reusable Widgets â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _section(String title, Color cardColor, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: AppRadius.mdCircular,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xs),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          ...children,
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }

  Widget _row(String label, String value, Color textColor, Color mutedColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall.copyWith(color: mutedColor)),
          Flexible(
            child: Text(
              value,
              style: AppTypography.bodySmall.copyWith(color: textColor),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _founderButton(String label, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }

  // â”€â”€ Release Note Form â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildReleaseForm(Color mutedColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: AppRadius.mdCircular,
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Release Note', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: AppSpacing.md),
          TextField(controller: _releasePersonCtrl, decoration: const InputDecoration(labelText: 'Person ID', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: AppSpacing.sm),
          TextField(controller: _releaseVersionCtrl, decoration: const InputDecoration(labelText: 'Version', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: AppSpacing.sm),
          TextField(controller: _releaseTitleCtrl, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: AppSpacing.sm),
          TextField(controller: _releaseChangesCtrl, decoration: const InputDecoration(labelText: 'Changes (one per line)', border: OutlineInputBorder(), isDense: true), maxLines: 3),
          const SizedBox(height: AppSpacing.sm),
          TextField(controller: _releaseActionCtrl, decoration: const InputDecoration(labelText: 'Action Label (optional)', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _sendingMessage ? null : _sendReleaseNote,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.textInverse),
                  child: _sendingMessage
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Send Release Note'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TextButton(onPressed: () => setState(() { _showReleaseForm = false; }), child: const Text('Cancel')),
            ],
          ),
        ],
      ),
    );
  }

  // â”€â”€ Announcement Form â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildAnnouncementForm(Color mutedColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: AppRadius.mdCircular,
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Announcement', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: AppSpacing.md),
          TextField(controller: _announcePersonCtrl, decoration: const InputDecoration(labelText: 'Person ID', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: AppSpacing.sm),
          TextField(controller: _announceTitleCtrl, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: AppSpacing.sm),
          TextField(controller: _announceDateCtrl, decoration: const InputDecoration(labelText: 'Date (optional)', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: AppSpacing.sm),
          TextField(controller: _announceLocationCtrl, decoration: const InputDecoration(labelText: 'Location (optional)', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: AppSpacing.sm),
          TextField(controller: _announceDescCtrl, decoration: const InputDecoration(labelText: 'Description (optional)', border: OutlineInputBorder(), isDense: true), maxLines: 2),
          const SizedBox(height: AppSpacing.sm),
          TextField(controller: _announceActionCtrl, decoration: const InputDecoration(labelText: 'Action Label (optional)', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _sendingMessage ? null : _sendAnnouncement,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.textInverse),
                  child: _sendingMessage
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Send Announcement'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TextButton(onPressed: () => setState(() { _showAnnouncementForm = false; }), child: const Text('Cancel')),
            ],
          ),
        ],
      ),
    );
  }

  // â”€â”€ Feedback Status Form â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Widget _buildFeedbackStatusForm(Color mutedColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: AppRadius.mdCircular,
        border: Border.all(color: const Color(0xFFFFE5B4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Feedback Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: AppSpacing.md),
          TextField(controller: _feedbackPersonCtrl, decoration: const InputDecoration(labelText: 'Person ID', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: AppSpacing.sm),
          TextField(controller: _feedbackTitleCtrl, decoration: const InputDecoration(labelText: 'Feedback Title', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: AppSpacing.sm),
          TextField(controller: _feedbackStatusCtrl, decoration: const InputDecoration(labelText: 'Status (e.g. Accepted, Planned, Fixed)', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: AppSpacing.sm),
          TextField(controller: _feedbackSprintCtrl, decoration: const InputDecoration(labelText: 'Sprint (optional)', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: AppSpacing.sm),
          TextField(controller: _feedbackNoteCtrl, decoration: const InputDecoration(labelText: 'Note (optional)', border: OutlineInputBorder(), isDense: true), maxLines: 2),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _sendingMessage ? null : _sendFeedbackStatus,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.textInverse),
                  child: _sendingMessage
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Send Feedback Status'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TextButton(onPressed: () => setState(() { _showFeedbackStatusForm = false; }), child: const Text('Cancel')),
            ],
          ),
        ],
      ),
    );
  }

  // â”€â”€ Send Actions â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _sendReleaseNote() async {
    final personId = _releasePersonCtrl.text.trim();
    if (personId.isEmpty) { _showResult('Person ID required', isError: true); return; }
    setState(() => _sendingMessage = true);
    try {
      final changes = _releaseChangesCtrl.text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
      await _api.sendReleaseNote(
        personId: personId,
        version: _releaseVersionCtrl.text.trim(),
        title: _releaseTitleCtrl.text.trim(),
        changes: changes,
        actionLabel: _releaseActionCtrl.text.trim().isEmpty ? null : _releaseActionCtrl.text.trim(),
      );
      _showResult('Release note sent to $personId');
      setState(() => _showReleaseForm = false);
    } catch (e) {
      _showResult('Failed: $e', isError: true);
    }
    setState(() => _sendingMessage = false);
  }

  Future<void> _sendAnnouncement() async {
    final personId = _announcePersonCtrl.text.trim();
    if (personId.isEmpty) { _showResult('Person ID required', isError: true); return; }
    setState(() => _sendingMessage = true);
    try {
      await _api.sendAnnouncement(
        personId: personId,
        title: _announceTitleCtrl.text.trim(),
        date: _announceDateCtrl.text.trim().isEmpty ? null : _announceDateCtrl.text.trim(),
        location: _announceLocationCtrl.text.trim().isEmpty ? null : _announceLocationCtrl.text.trim(),
        description: _announceDescCtrl.text.trim().isEmpty ? null : _announceDescCtrl.text.trim(),
        actionLabel: _announceActionCtrl.text.trim().isEmpty ? null : _announceActionCtrl.text.trim(),
      );
      _showResult('Announcement sent to $personId');
      setState(() => _showAnnouncementForm = false);
    } catch (e) {
      _showResult('Failed: $e', isError: true);
    }
    setState(() => _sendingMessage = false);
  }

  Future<void> _sendFeedbackStatus() async {
    final personId = _feedbackPersonCtrl.text.trim();
    if (personId.isEmpty) { _showResult('Person ID required', isError: true); return; }
    setState(() => _sendingMessage = true);
    try {
      await _api.sendFeedbackStatus(
        personId: personId,
        title: _feedbackTitleCtrl.text.trim(),
        status: _feedbackStatusCtrl.text.trim(),
        sprint: _feedbackSprintCtrl.text.trim().isEmpty ? null : _feedbackSprintCtrl.text.trim(),
        note: _feedbackNoteCtrl.text.trim().isEmpty ? null : _feedbackNoteCtrl.text.trim(),
      );
      _showResult('Feedback status sent to $personId');
      setState(() => _showFeedbackStatusForm = false);
    } catch (e) {
      _showResult('Failed: $e', isError: true);
    }
    setState(() => _sendingMessage = false);
  }

  void _openFeedbackInbox() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const FeedbackInboxScreen()),
    );

  }
}
