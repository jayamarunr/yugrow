// â”€â”€â”€ Alpha Host Flow â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Sprint 6.9 â€” Create a real event in under 60 seconds.
// NOT a full event management system. No ticketing, payments, Zoom.

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/auth/auth_service.dart';
import '../venue/models/venue.dart';
import '../venue/widgets/venue_search_field.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import 'package:yugrow_mobile/core/theme/app_typography.dart';


class HostEventScreen extends ConsumerStatefulWidget {
  const HostEventScreen({super.key});

  @override
  ConsumerState<HostEventScreen> createState() => _HostEventScreenState();
}

class _HostEventScreenState extends ConsumerState<HostEventScreen> {
  final _api = ApiClient();
  final _nameCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();

  // â”€â”€ State â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 21, minute: 0);
  String _eventType = 'NETWORKING_MEETUP';
  String _visibility = 'PUBLIC';
  String _attendance = 'OPEN';
  String _expectedSize = 'under_20';
  final _descriptionCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _ticketCtrl = TextEditingController();
  final Set<String> _industryTags = {};
  String _organizerWorkspace = 'personal';
  bool _creating = false;
  bool _created = false;
  Map<String, dynamic>? _createdEvent;

  static const _industryOptions = [
    'Technology', 'AI/ML', 'SaaS', 'Fintech', 'Healthcare',
    'E-commerce', 'EdTech', 'Manufacturing', 'Startups',
    'Design', 'Marketing', 'Sales', 'HR', 'Legal', 'Finance',
  ];

  // â”€â”€ Venue search (via VenueSearchField) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Venue? _selectedVenueObj;

  @override
  void initState() {
    super.initState();
    // Populate API client with auth context from the shared provider
    final auth = ref.read(authProvider);
    _api.personId = auth.person?['id'] as String?;
    _api.workspaceId = auth.workspace?['id'] as String?;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _venueCtrl.dispose();
    _descriptionCtrl.dispose();
    _websiteCtrl.dispose();
    _ticketCtrl.dispose();
    super.dispose();
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

  Future<void> _pickEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (time != null) setState(() => _endTime = time);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (time != null) setState(() => _startTime = time);
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

      if (_selectedVenueObj != null) {
        venueId = _selectedVenueObj!.id;
      } else {
        _showSnack('Please search for or create a venue');
        setState(() => _creating = false);
        return;
      }

      // Build date/time
      final startDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _startTime.hour,
        _startTime.minute,
      );
      final endDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _endTime.hour,
        _endTime.minute,
      );
      if (endDate.isBefore(startDate) || endDate.isAtSameMomentAs(startDate)) {
        _showSnack('End time must be after start time');
        setState(() => _creating = false);
        return;
      }

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
      final msg = _parseEventError(e);
      _showSnack(msg);
      setState(() => _creating = false);
    }
  }

  String _parseEventError(dynamic error) {
    try {
      if (error is DioException && error.response?.data != null) {
        final data = error.response!.data;
        if (data is Map<String, dynamic>) {
          if (data['error'] is Map<String, dynamic>) {
            final err = data['error'] as Map<String, dynamic>;
            final message = err['message'] as String?;
            if (message != null) return message;
          }
        }
        final statusCode = error.response?.statusCode;
        if (statusCode == 404) {
          return 'Venue not found. Try selecting a different venue or creating a new one.';
        }
        if (statusCode == 401) {
          return 'Session expired. Please sign in again.';
        }
        if (statusCode == 400) {
          return 'Please fill in all required fields.';
        }
      }
      if (error is DioException && error.type == DioExceptionType.connectionError) {
        return 'Unable to connect. Check your internet connection.';
      }
    } catch (_) {}
    return 'Failed to create event. Please try again.';
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
    final pid = ref.read(authProvider).person?['id'] as String?;
    final wid = ref.read(authProvider).workspace?['id'] as String?;
    if (pid == null || wid == null) return;
    final eventId = _createdEvent!['id'] as String;
    final venueId = (_createdEvent!['venue'] as Map<String, dynamic>?)?['id'] as String? ?? '';

    try {
      await _api.checkIn({
        'personId': pid,
        'workspaceId': wid,
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
  String get _formattedStartTime => _startTime.format(context);
  String get _formattedEndTime => _endTime.format(context);

  String get _visibilityLabel {
    switch (_visibility) {
      case 'PUBLIC': return 'Public';
      case 'LINK_ACCESS': return 'Private Link';
      case 'INVITE_ONLY': return 'Invite Only';
      default: return _visibility;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A2E) : AppColors.background;
    final textColor = isDark ? Colors.white : AppColors.textPrimary;
    final mutedColor = isDark ? AppColors.textDisabled : AppColors.textSecondary;
    final cardColor = isDark ? const Color(0xFF16213E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Create Professional Event'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textInverse,
      ),
      body: _created ? _buildSuccess() : _buildForm(textColor, mutedColor, cardColor),
    );
  }

  Widget _buildForm(Color textColor, Color mutedColor, Color cardColor) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _sectionDivider('ðŸ¤', 'What are you hosting?'),

        // â”€â”€ Event Type â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        _label('Type'),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 6, runSpacing: 6,
          children: [
            ('ðŸ¤ Networking Meetup', 'NETWORKING_MEETUP'),
            ('ðŸŽ“ Workshop', 'WORKSHOP'),
            ('ðŸŽ¤ Conference', 'CONFERENCE'),
            ('ðŸ¢ Expo', 'EXPO'),
            ('ðŸ“š Seminar', 'SEMINAR'),
            ('ðŸš€ Pitch Night', 'PITCH_NIGHT'),
            ('ðŸ‘¥ Community Meetup', 'COMMUNITY_MEETUP'),
            ('ðŸ¢ Company Event', 'COMPANY_EVENT'),
          ].map((e) {
            final label = e.$1;
            final value = e.$2;
            final selected = _eventType == value;
            return ChoiceChip(
              label: Text(label, style: TextStyle(fontSize: 12, color: selected ? Colors.white : null, fontWeight: selected ? FontWeight.w600 : null)),
              selected: selected,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surfaceHover,
              visualDensity: VisualDensity.compact,
              onSelected: (v) {
                if (v) setState(() => _eventType = value);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.xl),

        // â”€â”€ Event Name â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        _label('Event Name'),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _nameCtrl,
          decoration: const InputDecoration(
            hintText: 'e.g. AI Meetup Chennai',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        _sectionDivider('ðŸ“', 'Where is it?'),

        // â”€â”€ Venue (VenueSearchField) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        VenueSearchField(
          api: _api,
          onVenueSelected: (venue) {
            setState(() => _selectedVenueObj = venue);
          },
        ),
        const SizedBox(height: AppSpacing.xl),

        _sectionDivider('ðŸ“…', 'When is it?'),

        // â”€â”€ Date â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: AppRadius.xsCircular,
              color: cardColor,
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.calendar, size: 18, color: AppColors.primary),
                const SizedBox(width: AppSpacing.md),
                Text(_formattedDate, style: TextStyle(fontSize: 15, color: textColor)),
                const Spacer(),
                const Icon(Icons.chevron_right, size: 18, color: AppColors.textDisabled),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // â”€â”€ Start Time â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: _pickTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: AppRadius.xsCircular,
              color: cardColor,
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.clock, size: 18, color: AppColors.primary),
                const SizedBox(width: AppSpacing.md),
                Text(_formattedStartTime, style: TextStyle(fontSize: 15, color: textColor)),
                const Spacer(),
                const Icon(Icons.chevron_right, size: 18, color: AppColors.textDisabled),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // â”€â”€ End Time â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: _pickEndTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: AppRadius.xsCircular,
              color: cardColor,
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.clock, size: 18, color: AppColors.primary),
                const SizedBox(width: AppSpacing.md),
                Text(_formattedEndTime, style: TextStyle(fontSize: 15, color: textColor)),
                const Spacer(),
                const Icon(Icons.chevron_right, size: 18, color: AppColors.textDisabled),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        _sectionDivider('ðŸ“', 'About the Event'),

        // â”€â”€ Description â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _descriptionCtrl,
          maxLines: 3,
          maxLength: 250,
          buildCounter: (_, {required currentLength, required isFocused, maxLength}) => Text(
            '$currentLength / $maxLength',
            style: TextStyle(fontSize: 11, color: currentLength > 200 ? AppColors.error : mutedColor),
          ),
          decoration: const InputDecoration(
            hintText: 'Tell attendees what they will gain from attending.',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // â”€â”€ Event Website â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _websiteCtrl,
          decoration: const InputDecoration(
            hintText: 'e.g. meetup.com/ai-summit-chennai',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
            prefixIcon: Icon(LucideIcons.globe, size: 18),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // â”€â”€ Ticket Link â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _ticketCtrl,
          decoration: const InputDecoration(
            hintText: 'e.g. eventbrite.com/e/...',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
            prefixIcon: Icon(LucideIcons.ticket, size: 18),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // â”€â”€ Event Topics â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 6, runSpacing: 6,
          children: _industryOptions.map((tag) {
            final selected = _industryTags.contains(tag);
            final atLimit = _industryTags.length >= 3 && !selected;
            return FilterChip(
              label: Text(tag, style: TextStyle(fontSize: 12, color: selected ? Colors.white : null, fontWeight: selected ? FontWeight.w600 : null)),
              selected: selected,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surfaceHover,
              visualDensity: VisualDensity.compact,
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
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text('Maximum 3 topics selected.',
              style: TextStyle(fontSize: 11, color: mutedColor)),
          ),
        const SizedBox(height: AppSpacing.xl),

        _sectionDivider('ðŸŒ', 'Access & Settings'),

        // â”€â”€ Access Mode â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        const SizedBox(height: AppSpacing.sm),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'PUBLIC', label: Text('Public'), icon: Icon(LucideIcons.globe, size: 16)),
            ButtonSegment(value: 'LINK_ACCESS', label: Text('Private Link'), icon: Icon(LucideIcons.link, size: 16)),
            ButtonSegment(value: 'INVITE_ONLY', label: Column(mainAxisSize: MainAxisSize.min, children: [Text('Invite Only'), Text('Coming Soon', style: TextStyle(fontSize: 9))]), icon: Icon(LucideIcons.mail, size: 16), enabled: false),
          ],
          selected: {_visibility},
          onSelectionChanged: (s) => setState(() {
            _visibility = s.first;
            if (_visibility == 'INVITE_ONLY') _attendance = 'INVITE_ONLY';
          }),
        ),

        // Sub-options for Public and Link Access
        if (_visibility == 'PUBLIC') ...[
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs),
            child: Text('Anyone can discover this event.',
              style: AppTypography.caption.copyWith(color: mutedColor)),
          ),
          const SizedBox(height: AppSpacing.md),

          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'OPEN', label: Text('Join Instantly'), icon: Icon(LucideIcons.log_in, size: 16)),
              ButtonSegment(value: 'REQUEST', label: Text('Request to Join'), icon: Icon(LucideIcons.file_text, size: 16)),
            ],
            selected: {_attendance},
            onSelectionChanged: (s) => setState(() => _attendance = s.first),
          ),
        ],
        if (_visibility == 'LINK_ACCESS') ...[
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs),
            child: Text('Only people with the invite link can discover it.',
              style: AppTypography.caption.copyWith(color: mutedColor)),
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'OPEN', label: Text('Join Instantly'), icon: Icon(LucideIcons.log_in, size: 16)),
              ButtonSegment(value: 'REQUEST', label: Text('Request to Join'), icon: Icon(LucideIcons.file_text, size: 16)),
            ],
            selected: {_attendance},
            onSelectionChanged: (s) => setState(() => _attendance = s.first),
          ),
        ],

        // â”€â”€ Audience Size â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        const SizedBox(height: AppSpacing.sm),
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
        const SizedBox(height: AppSpacing.xl),

        // â”€â”€ Hosted By â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        const SizedBox(height: AppSpacing.sm),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'personal', label: Text('ðŸ‘¤ You (Personal)')),
            ButtonSegment(value: 'company', label: Text('ðŸ¢ Yugrow')),
          ],
          selected: {_organizerWorkspace},
          onSelectionChanged: (s) => setState(() => _organizerWorkspace = s.first),
        ),
        const SizedBox(height: AppSpacing.xl),

        // â”€â”€ Preview â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        if (_nameCtrl.text.trim().isNotEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: AppRadius.mdCircular,
              border: Border.all(color: const Color(0xFFBAE6FD)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(LucideIcons.eye, size: 14, color: AppColors.info),
                    SizedBox(width: AppSpacing.sm),
                    Text('Attendee Preview',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.info)),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: AppRadius.mdCircular,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event name
                      Text(_nameCtrl.text,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: AppSpacing.xs),
                      // Event type
                      Text(_eventType.replaceAll('_', ' ').split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' '),
                        style: AppTypography.caption.copyWith(color: mutedColor)),
                      // Topics
                      if (_industryTags.isNotEmpty) ...[const SizedBox(height: AppSpacing.xs),
                        Text(_industryTags.join(' Â· '),
                          style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                      ],
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          const Icon(LucideIcons.calendar, size: 13, color: AppColors.textSecondary),
                          const SizedBox(width: AppSpacing.xs),
                          Text('$_formattedDate Â· $_formattedStartTime - $_formattedEndTime',
                            style: AppTypography.caption.copyWith(color: mutedColor)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          const Icon(LucideIcons.map_pin, size: 13, color: AppColors.textSecondary),
                          const SizedBox(width: AppSpacing.xs),
                          Text(_selectedVenueObj?.name ?? 'Venue TBD',
                            style: AppTypography.caption.copyWith(color: mutedColor)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Icon(LucideIcons.globe, size: 13, color: _visibility == 'PUBLIC' ? AppColors.success : AppColors.warning),
                          const SizedBox(width: AppSpacing.xs),
                          Text(_visibilityLabel,
                            style: TextStyle(fontSize: 11, color: _visibility == 'PUBLIC' ? AppColors.success : AppColors.warning)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F9FF),
                              borderRadius: AppRadius.mdCircular,
                              border: Border.all(color: const Color(0xFFBAE6FD)),
                            ),
                            child: Text('$_formattedDate Â· $_formattedStartTime',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.info)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.xl),

        // â”€â”€ Create Button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _creating ? null : _create,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textInverse,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.mdCircular),
              elevation: 0,
              textStyle: AppTypography.bodyBold,
            ),
            child: _creating
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.plus, size: 20),
                      SizedBox(width: AppSpacing.sm),
                      Text('Create Event'),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  Widget _buildSuccess() {
    final event = _createdEvent;
    final name = event?['name'] as String? ?? 'Event Created';
    final venueData = event?['venue'] as Map<String, dynamic>?;
    final venueName = venueData?['name'] as String? ?? '';
    final eventId = event?['id'] as String? ?? '';
    final startDateStr = event?['startDate'] as String?;
    final endDateStr = event?['endDate'] as String?;

    // Determine if check-in should be available
    DateTime? startDate;
    DateTime? endDate;
    if (startDateStr != null) startDate = DateTime.tryParse(startDateStr);
    if (endDateStr != null) endDate = DateTime.tryParse(endDateStr);
    final now = DateTime.now();
    final isEventLive = startDate != null && endDate != null
        && now.isAfter(startDate) && now.isBefore(endDate);

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Confetti decoration
              SizedBox(
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 10, top: 10,
                      child: Container(width: 12, height: 12,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
                    ),
                    Positioned(
                      right: 20, top: 5,
                      child: Container(width: 8, height: 8,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.warning)),
                    ),
                    Positioned(
                      left: 40, bottom: 10,
                      child: Container(width: 10, height: 10,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.info)),
                    ),
                    Positioned(
                      right: 50, bottom: 5,
                      child: Container(width: 6, height: 6,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.error)),
                    ),
                    const SizedBox(
                      width: 64, height: 64,
                      child: Icon(Icons.check_circle, color: AppColors.primary, size: 64),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Event Created!',
                  style: GoogleFonts.inter(
                      fontSize: 24, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: AppRadius.lgCircular,
                ),
                child: Column(
                  children: [
                    Text(name,
                        style: GoogleFonts.inter(
                            fontSize: 18, fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    if (venueName.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.map_pin, size: 14, color: AppColors.primary),
                          const SizedBox(width: AppSpacing.xs),
                          Text(venueName,
                              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xs),
                    Text('$_formattedDate Â· $_formattedStartTime - $_formattedEndTime',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              Text('What would you like to do?',
                  style: GoogleFonts.inter(
                      fontSize: 15, fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary)),
              const SizedBox(height: AppSpacing.lg),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: isEventLive ? _checkInNow : null,
                  icon: const Icon(LucideIcons.log_in, size: 18),
                  label: Text(
                    isEventLive ? "I'm Here Now" : 'Check-in opens at event start',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  style: FilledButton.styleFrom(
                    backgroundColor: isEventLive ? AppColors.primary : AppColors.textDisabled,
                    shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.mdCircular),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
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
                      duration: Duration(seconds: 2),
                    ));
                  },
                  icon: const Icon(LucideIcons.link, size: 18),
                  label: const Text('Copy Invite Link',
                      style: TextStyle(fontSize: 15)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.mdCircular),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => context.go('/'),
                child: Text('Back to Events',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary));
  }

  Widget _sectionDivider(String emoji, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.md),
      child: Row(
        children: [
          Text(emoji, style: AppTypography.body),
          const SizedBox(width: AppSpacing.sm),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const Expanded(child: SizedBox()),
          Container(height: 1, color: AppColors.border),
        ],
      ),
    );

  }
}
