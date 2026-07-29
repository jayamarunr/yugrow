// ─── Yugrow Founder Console v2 ──────────────────────────────────
// Enhanced founder console for testing, validation, and demos.
// Accessible from Profile screen. NOT exposed to end users.
//
// Sprint 6.7 — Founder Mode only. No public hosting, no navigation changes.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/api/api_client.dart';
import 'feedback_inbox_screen.dart';

class FounderConsole extends StatefulWidget {
  const FounderConsole({super.key});

  @override
  State<FounderConsole> createState() => _FounderConsoleState();
}

class _FounderConsoleState extends State<FounderConsole> {
  final _api = ApiClient();

  // ── App Info ──────────────────────────────────────────────────
  final String _apiUrl = 'http://localhost:4000/api/v1';
  final String _appVersion = '0.1.1-alpha';
  final String _buildNumber = '1';
  String _lastApiCall = 'None';
  bool _apiHealthy = false;

  // ── Event List ────────────────────────────────────────────────
  List<Map<String, dynamic>> _events = [];
  bool _eventsLoading = false;

  // ── Create Event Form ─────────────────────────────────────────
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

  // ── Result feedback ───────────────────────────────────────────
  String _resultText = '';
  bool _resultIsError = false;
  bool _isLoading = false;

  // ── Test Status Dashboard ─────────────────────────────────────
  Map<String, dynamic>? _testStatus;

  // ── Send Message Forms ───────────────────────────────────────
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

  // ── Helpers ───────────────────────────────────────────────────

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
        _lastApiCall = 'GET /checkin/events — ${response.length} events';
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

  // ── Create Event ──────────────────────────────────────────────

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

  // ── Edit Event ────────────────────────────────────────────────

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

  // ── End Event ─────────────────────────────────────────────────

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

  // ── Duplicate Event ───────────────────────────────────────────

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

  // ── Seed Attendees ────────────────────────────────────────────

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

  // ── Clear Presence ────────────────────────────────────────────

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

  // ── Reset Demo Data ───────────────────────────────────────────

  Future<void> _resetDemoData() async {
    final confirm = await _confirmDialog(
      '⚠️ Reset Demo Data',
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

  // ── Founder Login ────────────────────────────────────────────

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

  // ── Dialog ────────────────────────────────────────────────────

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
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ═══════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF8F9FB);
    final cardColor = isDark ? const Color(0xFF16213E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final mutedColor = isDark ? Colors.grey[400]! : const Color(0xFF6B7280);
    const dangerColor = Color(0xFFDC2626);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Founder Mode'),
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              // ── Result Banner ────────────────────────────────
              if (_resultText.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _resultIsError
                        ? const Color(0xFFFEF2F2)
                        : const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(8),
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
                        color: _resultIsError ? dangerColor : const Color(0xFF16A34A),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _resultText,
                          style: TextStyle(
                            fontSize: 13,
                            color: _resultIsError ? dangerColor : const Color(0xFF16A34A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // ── App Info ─────────────────────────────────────
              _section('App', cardColor, [
                _row('Version', _appVersion, textColor, mutedColor),
                _row('Build', _buildNumber, textColor, mutedColor),
              ]),
              const SizedBox(height: 12),

              // ── API Health ───────────────────────────────────
              _section('API Health', cardColor, [
                _row('URL', _apiUrl, textColor, mutedColor),
                _row('Status', _apiHealthy ? 'Connected ✓' : 'Disconnected ✗',
                    _apiHealthy ? const Color(0xFF16A34A) : dangerColor, mutedColor),
                _row('Last Call', _lastApiCall, textColor, mutedColor),
                _founderButton('Refresh API Status', Icons.refresh, _checkApiHealth),
              ]),
              const SizedBox(height: 12),

              // ── Current Event Dashboard ──────────────────────
              if (_testStatus != null && (_testStatus!['hasSeededAttendees'] == true || (_testStatus!['events'] as List?)?.isNotEmpty == true))
                _section('Current Event', cardColor, [
                  ...(_testStatus!['events'] as List).map((e) {
                    final event = e as Map<String, dynamic>;
                    return _buildEventDashboard(event, textColor, mutedColor);
                  }),
                  const SizedBox(height: 4),
                ]),
              if (_testStatus != null && (_testStatus!['hasSeededAttendees'] == true || (_testStatus!['events'] as List?)?.isNotEmpty == true))
                const SizedBox(height: 12),

              // ── Event Management ─────────────────────────────
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
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                else if (_events.isEmpty && !_showCreateForm)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No active events. Create one to get started.',
                      style: TextStyle(fontSize: 13, color: mutedColor),
                    ),
                  )
                else
                  ..._events.map((event) => _buildEventTile(event, textColor, mutedColor, cardColor)),
              ]),
              const SizedBox(height: 12),

              // ── Auth ─────────────────────────────────────────
              _section('Auth', cardColor, [
                _founderButton(
                  'Sign in as Founder',
                  Icons.person_outline,
                  _founderLogin,
                ),
              ]),
              const SizedBox(height: 12),

              // ── Test Data Tools ──────────────────────────────
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
              const SizedBox(height: 12),

              // ── Founder Inbox ────────────────────────────────
              _section('Founder Inbox 💬', cardColor, [
                _founderButton(
                  'View Feedback Inbox',
                  Icons.inbox_outlined,
                  _openFeedbackInbox,
                ),
              ]),
              const SizedBox(height: 12),

              // ── Send Messages ────────────────────────────────
              _section('Send Messages 📨', cardColor, [
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
              const SizedBox(height: 12),

              // ── Warning ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFFE58F)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🔒 Founder Mode Only',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF856404),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'These tools are for founder testing only. '
                      'They will be removed or redesigned before '
                      'the public Host experience is built.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF856404)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),

          // ── Loading Overlay ──────────────────────────────────
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // ── Create Event Form ─────────────────────────────────────────

  Widget _buildCreateForm(Color mutedColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('New Test Event',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 12),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Event Name',
              hintText: 'e.g. AI Meetup Chennai',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _venueCtrl,
            decoration: const InputDecoration(
              labelText: 'Venue',
              hintText: 'e.g. Tidel Park',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _cityCtrl,
            decoration: const InputDecoration(
              labelText: 'City',
              hintText: 'Chennai',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 6),
          Text(
            'Starts today at 6 PM · Ends at 9 PM',
            style: TextStyle(fontSize: 12, color: mutedColor),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _creating ? null : _createEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    foregroundColor: Colors.white,
                  ),
                  child: _creating
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Create Event'),
                ),
              ),
              const SizedBox(width: 8),
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

  // ── Edit Event Form ───────────────────────────────────────────

  Widget _buildEditForm(Color mutedColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Edit Event',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 12),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Event Name',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _editing ? null : _saveEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    foregroundColor: Colors.white,
                  ),
                  child: _editing
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Save'),
                ),
              ),
              const SizedBox(width: 8),
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

  // ── Event Dashboard ──────────────────────────────────────────

  Widget _buildEventDashboard(Map<String, dynamic> event, Color textColor, Color mutedColor) {
    final eventName = event['eventName'] as String? ?? 'Unknown';
    final total = event['totalAttendees'] as int? ?? 0;
    final real = event['realAttendees'] as int? ?? 0;
    final seeded = event['seededAttendees'] as int? ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(eventName,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor)),
          const SizedBox(height: 8),
          Row(
            children: [
              _statBox('Total', '$total', const Color(0xFF0F766E)),
              const SizedBox(width: 8),
              _statBox('Real', '$real', const Color(0xFF16A34A)),
              const SizedBox(width: 8),
              _statBox('Seeded', '$seeded', const Color(0xFFD97706)),
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
          borderRadius: BorderRadius.circular(8),
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

  // ── Event Tile ────────────────────────────────────────────────

  Widget _buildEventTile(Map<String, dynamic> event, Color textColor, Color mutedColor, Color cardColor) {
    final name = event['name'] as String? ?? 'Untitled';
    final id = event['id'] as String? ?? '';
    final venueData = event['venue'] as Map<String, dynamic>?;
    final venue = venueData?['name'] as String? ?? '';
    final status = event['status'] as String? ?? 'ACTIVE';
    final visibility = event['visibility'] as String? ?? 'PUBLIC';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: status == 'ACTIVE'
                      ? const Color(0xFFBBF7D0)
                      : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(status,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
                    color: status == 'ACTIVE' ? const Color(0xFF16A34A) : const Color(0xFFD97706))),
              ),
            ],
          ),
          if (venue.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('$venue · $visibility',
                style: TextStyle(fontSize: 12, color: mutedColor)),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              _smallButton('Edit', () => _openEditForm(event)),
              const SizedBox(width: 6),
              _smallButton('End', () => _endEvent(id, name)),
              const SizedBox(width: 6),
              _smallButton('Duplicate', () => _duplicateEvent(id, name)),
              const SizedBox(width: 6),
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
          side: const BorderSide(color: Color(0xFFD1D5DB)),
          foregroundColor: const Color(0xFF374151),
        ),
        child: Text(label),
      ),
    );
  }

  // ── Event Picker Dialog ───────────────────────────────────────

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

  // ── Reusable Widgets ──────────────────────────────────────────

  Widget _section(String title, Color cardColor, List<Widget> children) {
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
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F766E),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
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

  Widget _founderButton(String label, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF0F766E),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }

  // ── Release Note Form ──────────────────────────────────────────

  Widget _buildReleaseForm(Color mutedColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Release Note', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 12),
          TextField(controller: _releasePersonCtrl, decoration: const InputDecoration(labelText: 'Person ID', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: 8),
          TextField(controller: _releaseVersionCtrl, decoration: const InputDecoration(labelText: 'Version', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: 8),
          TextField(controller: _releaseTitleCtrl, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: 8),
          TextField(controller: _releaseChangesCtrl, decoration: const InputDecoration(labelText: 'Changes (one per line)', border: OutlineInputBorder(), isDense: true), maxLines: 3),
          const SizedBox(height: 8),
          TextField(controller: _releaseActionCtrl, decoration: const InputDecoration(labelText: 'Action Label (optional)', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _sendingMessage ? null : _sendReleaseNote,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
                  child: _sendingMessage
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Send Release Note'),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(onPressed: () => setState(() { _showReleaseForm = false; }), child: const Text('Cancel')),
            ],
          ),
        ],
      ),
    );
  }

  // ── Announcement Form ──────────────────────────────────────────

  Widget _buildAnnouncementForm(Color mutedColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Announcement', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 12),
          TextField(controller: _announcePersonCtrl, decoration: const InputDecoration(labelText: 'Person ID', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: 8),
          TextField(controller: _announceTitleCtrl, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: 8),
          TextField(controller: _announceDateCtrl, decoration: const InputDecoration(labelText: 'Date (optional)', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: 8),
          TextField(controller: _announceLocationCtrl, decoration: const InputDecoration(labelText: 'Location (optional)', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: 8),
          TextField(controller: _announceDescCtrl, decoration: const InputDecoration(labelText: 'Description (optional)', border: OutlineInputBorder(), isDense: true), maxLines: 2),
          const SizedBox(height: 8),
          TextField(controller: _announceActionCtrl, decoration: const InputDecoration(labelText: 'Action Label (optional)', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _sendingMessage ? null : _sendAnnouncement,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
                  child: _sendingMessage
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Send Announcement'),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(onPressed: () => setState(() { _showAnnouncementForm = false; }), child: const Text('Cancel')),
            ],
          ),
        ],
      ),
    );
  }

  // ── Feedback Status Form ───────────────────────────────────────

  Widget _buildFeedbackStatusForm(Color mutedColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFE5B4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Feedback Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 12),
          TextField(controller: _feedbackPersonCtrl, decoration: const InputDecoration(labelText: 'Person ID', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: 8),
          TextField(controller: _feedbackTitleCtrl, decoration: const InputDecoration(labelText: 'Feedback Title', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: 8),
          TextField(controller: _feedbackStatusCtrl, decoration: const InputDecoration(labelText: 'Status (e.g. Accepted, Planned, Fixed)', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: 8),
          TextField(controller: _feedbackSprintCtrl, decoration: const InputDecoration(labelText: 'Sprint (optional)', border: OutlineInputBorder(), isDense: true)),
          const SizedBox(height: 8),
          TextField(controller: _feedbackNoteCtrl, decoration: const InputDecoration(labelText: 'Note (optional)', border: OutlineInputBorder(), isDense: true), maxLines: 2),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _sendingMessage ? null : _sendFeedbackStatus,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
                  child: _sendingMessage
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Send Feedback Status'),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(onPressed: () => setState(() { _showFeedbackStatusForm = false; }), child: const Text('Cancel')),
            ],
          ),
        ],
      ),
    );
  }

  // ── Send Actions ───────────────────────────────────────────────

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
