// ─── Alpha Host Flow ──────────────────────────────────────────────
// Sprint 6.9 — Create a real event in under 60 seconds.
// NOT a full event management system. No ticketing, payments, Zoom.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../core/api/api_client.dart';


class HostEventScreen extends StatefulWidget {
  const HostEventScreen({super.key});

  @override
  State<HostEventScreen> createState() => _HostEventScreenState();
}

class _HostEventScreenState extends State<HostEventScreen> {
  final _api = ApiClient();
  final _nameCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();

  // ── State ─────────────────────────────────────────────────────
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 18, minute: 0);
  String _eventType = 'NETWORKING_MEETUP';
  String _visibility = 'PUBLIC';
  String _expectedSize = 'under_20';
  final _descriptionCtrl = TextEditingController();
  final Set<String> _industryTags = {};
  String _organizerWorkspace = 'personal'; // 'personal' or workspace name
  bool _creating = false;
  bool _created = false;
  Map<String, dynamic>? _createdEvent;

  static const _industryOptions = [
    'Technology', 'AI/ML', 'SaaS', 'Fintech', 'Healthcare',
    'E-commerce', 'EdTech', 'Manufacturing', 'Startups',
    'Design', 'Marketing', 'Sales', 'HR', 'Legal', 'Finance',
  ];

  // ── Venue search ──────────────────────────────────────────────
  List<Map<String, dynamic>> _venueResults = [];
  Map<String, dynamic>? _selectedVenue;
  bool _searchingVenue = false;
  bool _useCurrentLocation = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _venueCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _searchVenues(String query) async {
    if (query.length < 2) {
      setState(() => _venueResults = []);
      return;
    }
    setState(() => _searchingVenue = true);
    try {
      final results = await _api.searchVenues(query);
      if (mounted) {
        setState(() {
          _venueResults = results.cast<Map<String, dynamic>>();
          _selectedVenue = null;
          _searchingVenue = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _searchingVenue = false);
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  Future<void> _create() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      _showSnack('Please enter an event name');
      return;
    }

    setState(() => _creating = true);
    try {
      String venueId;

      if (_selectedVenue != null) {
        venueId = _selectedVenue!['id'] as String;
      } else if (_useCurrentLocation) {
        // Create a venue with current location placeholder
        final venueName = _venueCtrl.text.trim().isNotEmpty
            ? _venueCtrl.text.trim()
            : 'Current Location';
        final newVenue = await _api.createVenue({
          'name': venueName,
          'city': 'Chennai',
          'createdByPersonId': 'person-self',
          'ownerWorkspaceId': 'personal',
        });
        venueId = newVenue['id'] as String;
      } else {
        // Create a new venue from the text input
        final venueName = _venueCtrl.text.trim();
        if (venueName.isEmpty) {
          _showSnack('Please enter or search for a venue');
          setState(() => _creating = false);
          return;
        }
        final newVenue = await _api.createVenue({
          'name': venueName,
          'city': 'Chennai',
          'createdByPersonId': 'person-self',
          'ownerWorkspaceId': 'personal',
        });
        venueId = newVenue['id'] as String;
      }

      // Build date/time
      final startDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      final endDate = startDate.add(const Duration(hours: 3));

      // Create the event
      final event = await _api.createEvent({
        'name': name,
        'venueId': venueId,
        'organizerWorkspaceId': 'personal',
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      });

      setState(() {
        _createdEvent = event;
        _created = true;
        _creating = false;
      });

      HapticFeedback.heavyImpact();
    } catch (e) {
      _showSnack('Failed to create event: $e');
      setState(() => _creating = false);
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
    ));
  }

  Future<void> _checkInNow() async {
    if (_createdEvent == null) return;
    final eventId = _createdEvent!['id'] as String;
    final venueId = (_createdEvent!['venue'] as Map<String, dynamic>?)?['id'] as String? ?? '';

    try {
      await _api.checkIn({
        'personId': 'person-self',
        'workspaceId': 'personal',
        'eventId': eventId,
        'venueId': venueId,
      });
      if (mounted) {
        context.go('/live');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You're now checked in!"),
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      _showSnack('Check-in failed: $e');
    }
  }

  String get _formattedDate => DateFormat('EEEE, MMMM d').format(_selectedDate);
  String get _formattedTime => _selectedTime.format(context);

  String get _visibilityLabel {
    switch (_visibility) {
      case 'PUBLIC': return 'Public';
      case 'HIDDEN': return 'Invite Link';
      case 'INVITE_ONLY': return 'Invite Only';
      default: return _visibility;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF8F9FB);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final mutedColor = isDark ? Colors.grey[400]! : const Color(0xFF6B7280);
    final cardColor = isDark ? const Color(0xFF16213E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Create Professional Event'),
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
      ),
      body: _created ? _buildSuccess() : _buildForm(textColor, mutedColor, cardColor),
    );
  }

  Widget _buildForm(Color textColor, Color mutedColor, Color cardColor) {
    final venueName = _selectedVenue?['name'] as String? ?? '';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Event Type ────────────────────────────────────────
        _label('What are you hosting?'),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6, runSpacing: 6,
          children: [
            ('🤝 Networking Meetup', 'NETWORKING_MEETUP'),
            ('🎓 Workshop', 'WORKSHOP'),
            ('🎤 Conference', 'CONFERENCE'),
            ('🏢 Expo', 'EXPO'),
            ('📚 Seminar', 'SEMINAR'),
            ('🚀 Pitch Night', 'PITCH_NIGHT'),
            ('👥 Community Meetup', 'COMMUNITY_MEETUP'),
            ('🏢 Company Event', 'COMPANY_EVENT'),
          ].map((e) {
            final label = e.$1;
            final value = e.$2;
            final selected = _eventType == value;
            return ChoiceChip(
              label: Text(label, style: TextStyle(fontSize: 12, color: selected ? Colors.white : null)),
              selected: selected,
              selectedColor: const Color(0xFF0F766E),
              onSelected: (v) {
                if (v) setState(() => _eventType = value);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // ── Event Name ────────────────────────────────────────
        _label('Event Name'),
        const SizedBox(height: 6),
        TextField(
          controller: _nameCtrl,
          decoration: const InputDecoration(
            hintText: 'e.g. AI Meetup Chennai',
            border: OutlineInputBorder(),
            filled: true,
          ),
        ),
        const SizedBox(height: 20),

        // ── Venue ─────────────────────────────────────────────
        _label('Venue'),
        const SizedBox(height: 6),
        TextField(
          controller: _venueCtrl,
          decoration: InputDecoration(
            hintText: 'Search for a venue...',
            border: const OutlineInputBorder(),
            filled: true,
            suffixIcon: _searchingVenue
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : null,
          ),
          onChanged: _searchVenues,
        ),

        // Venue search results
        if (_venueResults.isNotEmpty && _selectedVenue == null)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            constraints: const BoxConstraints(maxHeight: 160),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _venueResults.length,
              itemBuilder: (_, i) {
                final v = _venueResults[i];
                return ListTile(
                  dense: true,
                  title: Text(v['name'] as String? ?? ''),
                  subtitle: v['city'] != null ? Text(v['city'] as String) : null,
                  trailing: const Icon(Icons.check, size: 16),
                  onTap: () {
                    setState(() {
                      _selectedVenue = v;
                      _venueCtrl.text = v['name'] as String? ?? '';
                      _venueResults = [];
                    });
                  },
                );
              },
            ),
          ),

        if (_selectedVenue != null)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 16, color: Color(0xFF16A34A)),
                const SizedBox(width: 8),
                Expanded(child: Text(venueName, style: const TextStyle(fontSize: 13, color: Color(0xFF166534)))),
                TextButton(
                  onPressed: () => setState(() { _selectedVenue = null; _venueCtrl.clear(); }),
                  child: const Text('Change', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),

        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _useCurrentLocation = !_useCurrentLocation;
              if (_useCurrentLocation) {
                _venueCtrl.text = 'My Current Location';
                _selectedVenue = null;
              } else {
                _venueCtrl.clear();
              }
            });
          },
          icon: Icon(_useCurrentLocation ? LucideIcons.navigation : LucideIcons.navigation_off, size: 16),
          label: Text(_useCurrentLocation ? 'Using Current Location' : 'Use Current Location'),
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF0F766E)),
        ),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _selectedVenue = null;
              _useCurrentLocation = false;
              _venueCtrl.text = '';
              _venueCtrl.clear();
            });
            // Focus the venue field so user can type a new name
            FocusScope.of(context).requestFocus(FocusNode());
          },
          icon: const Icon(LucideIcons.plus, size: 16),
          label: const Text('Create New Venue'),
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF0F766E)),
        ),
        const SizedBox(height: 20),

        // ── Date ──────────────────────────────────────────────
        _label('Date'),
        const SizedBox(height: 6),
        InkWell(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD1D5DB)),
              borderRadius: BorderRadius.circular(4),
              color: cardColor,
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.calendar, size: 18, color: Color(0xFF0F766E)),
                const SizedBox(width: 10),
                Text(_formattedDate, style: TextStyle(fontSize: 15, color: textColor)),
                const Spacer(),
                const Icon(Icons.chevron_right, size: 18, color: Color(0xFF9CA3AF)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ── Start Time ─────────────────────────────────────────
        _label('Start Time'),
        const SizedBox(height: 6),
        InkWell(
          onTap: _pickTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD1D5DB)),
              borderRadius: BorderRadius.circular(4),
              color: cardColor,
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.clock, size: 18, color: Color(0xFF0F766E)),
                const SizedBox(width: 10),
                Text(_formattedTime, style: TextStyle(fontSize: 15, color: textColor)),
                const Spacer(),
                const Icon(Icons.chevron_right, size: 18, color: Color(0xFF9CA3AF)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ── Description ───────────────────────────────────────
        _label('Description (optional)'),
        const SizedBox(height: 6),
        TextField(
          controller: _descriptionCtrl,
          maxLines: 3,
          maxLength: 250,
          buildCounter: (_, {required currentLength, required isFocused, maxLength}) => Text(
            '$currentLength / $maxLength',
            style: TextStyle(fontSize: 11, color: currentLength > 200 ? const Color(0xFFDC2626) : mutedColor),
          ),
          decoration: const InputDecoration(
            hintText: 'Tell attendees what they will gain from attending.',
            border: OutlineInputBorder(),
            filled: true,
          ),
        ),
        const SizedBox(height: 20),

        // ── Event Topics ─────────────────────────────────────
        _label('Event Topics (max 3)'),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6, runSpacing: 6,
          children: _industryOptions.map((tag) {
            final selected = _industryTags.contains(tag);
            final atLimit = _industryTags.length >= 3 && !selected;
            return FilterChip(
              label: Text(tag, style: TextStyle(fontSize: 12, color: selected ? Colors.white : null)),
              selected: selected,
              selectedColor: const Color(0xFF0F766E),
              checkmarkColor: Colors.white,
              onSelected: atLimit ? null : (v) {
                setState(() {
                  if (v) { _industryTags.add(tag); } else { _industryTags.remove(tag); }
                });
              },
            );
          }).toList(),
        ),
        if (_industryTags.length >= 3)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text('Maximum 3 topics selected.',
              style: TextStyle(fontSize: 11, color: mutedColor)),
          ),
        const SizedBox(height: 20),

        // ── Who can join? ─────────────────────────────────────
        _label('Who can join?'),
        const SizedBox(height: 6),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'PUBLIC', label: Text('Public'), icon: Icon(LucideIcons.globe, size: 16)),
            ButtonSegment(value: 'HIDDEN', label: Text('Invite Link'), icon: Icon(LucideIcons.link, size: 16)),
            ButtonSegment(value: 'INVITE_ONLY', label: Text('Invite Only'), icon: Icon(LucideIcons.lock, size: 16), enabled: false),
          ],
          selected: {_visibility},
          onSelectionChanged: (s) => setState(() => _visibility = s.first),
        ),
        const SizedBox(height: 20),

        // ── Audience Size ──────────────────────────────────────
        _label('How many people are you expecting?'),
        const SizedBox(height: 6),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'under_20', label: Text('Under 20')),
            ButtonSegment(value: '20_50', label: Text('20-50')),
            ButtonSegment(value: '50_100', label: Text('50-100')),
            ButtonSegment(value: '100_plus', label: Text('100+')),
          ],
          selected: {_expectedSize},
          onSelectionChanged: (s) => setState(() => _expectedSize = s.first),
        ),
        const SizedBox(height: 24),

        // ── Hosted By ─────────────────────────────────────────
        _label('Hosted by'),
        const SizedBox(height: 6),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'personal', label: Text('👤 You (Personal)')),
            ButtonSegment(value: 'company', label: Text('🏢 Yugrow')),
          ],
          selected: {_organizerWorkspace},
          onSelectionChanged: (s) => setState(() => _organizerWorkspace = s.first),
        ),
        const SizedBox(height: 24),

        // ── Preview ───────────────────────────────────────────
        if (_nameCtrl.text.trim().isNotEmpty)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBAE6FD)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.eye, size: 14, color: Color(0xFF0284C7)),
                    const SizedBox(width: 6),
                    Text('Attendee Preview',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF0284C7))),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event name
                      Text(_nameCtrl.text,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 4),
                      // Event type
                      Text(_eventType.replaceAll('_', ' ').split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' '),
                        style: TextStyle(fontSize: 12, color: mutedColor)),
                      // Topics
                      if (_industryTags.isNotEmpty) ...[const SizedBox(height: 4),
                        Text(_industryTags.join(' · '),
                          style: TextStyle(fontSize: 12, color: const Color(0xFF0F766E))),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(LucideIcons.calendar, size: 13, color: Color(0xFF6B7280)),
                          const SizedBox(width: 4),
                          Text('$_formattedDate · $_formattedTime',
                            style: TextStyle(fontSize: 12, color: mutedColor)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(LucideIcons.map_pin, size: 13, color: Color(0xFF6B7280)),
                          const SizedBox(width: 4),
                          Text(_venueCtrl.text.isNotEmpty ? _venueCtrl.text : 'Venue TBD',
                            style: TextStyle(fontSize: 12, color: mutedColor)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(LucideIcons.globe, size: 13, color: _visibility == 'PUBLIC' ? const Color(0xFF16A34A) : const Color(0xFFD97706)),
                          const SizedBox(width: 4),
                          Text(_visibilityLabel,
                            style: TextStyle(fontSize: 11, color: _visibility == 'PUBLIC' ? const Color(0xFF16A34A) : const Color(0xFFD97706))),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F9FF),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFBAE6FD)),
                            ),
                            child: Text('$_formattedDate · $_formattedTime',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF0284C7))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 24),

        // ── Create Button ──────────────────────────────────────
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _creating ? null : _create,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F766E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: _creating
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                : const Text('Create Event', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSuccess() {
    final event = _createdEvent;
    final name = event?['name'] as String? ?? 'Event Created';
    final venueData = event?['venue'] as Map<String, dynamic>?;
    final venueName = venueData?['name'] as String? ?? '';
    final eventId = event?['id'] as String? ?? '';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text('Event Created!', style: GoogleFonts.inter(
              fontSize: 24, fontWeight: FontWeight.w700, color: const Color(0xFF111827))),
            const SizedBox(height: 8),
            Text(name, style: GoogleFonts.inter(
              fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF111827))),
            if (venueName.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(venueName, style: TextStyle(fontSize: 15, color: Colors.grey[600])),
            ],
            const SizedBox(height: 4),
            Text('$_formattedDate · $_formattedTime',
              style: TextStyle(fontSize: 14, color: Colors.grey[500])),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            Text('What would you like to do?',
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey[700])),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _checkInNow,
                icon: const Icon(LucideIcons.log_in, size: 18),
                label: const Text("I'm Here Now", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  final link = 'https://yugrow.app/e/${eventId.isNotEmpty ? eventId : 'event'}';
                  Clipboard.setData(ClipboardData(text: link));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Invite link copied!'),
                    behavior: SnackBarBehavior.floating,
                  ));
                },
                icon: const Icon(LucideIcons.link, size: 18),
                label: const Text('Copy Invite Link', style: TextStyle(fontSize: 15)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F766E),
                  side: const BorderSide(color: Color(0xFF0F766E)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 10),

            TextButton(
              onPressed: () => context.go('/'),
              child: Text('Back to Events',
                style: TextStyle(fontSize: 14, color: Colors.grey[500])),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F766E)));
  }
}
