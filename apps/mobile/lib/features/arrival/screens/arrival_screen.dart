import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yugrow_mobile/core/theme/app_colors.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import '../models/arrival_models.dart';
import '../repository/arrival_repository.dart';
import '../widgets/greeting_header.dart';
import '../widgets/event_card.dart';
import 'event_detail_screen.dart';
import '../../discovery/screens/discovery_screen.dart';

class ArrivalScreen extends StatefulWidget {
  const ArrivalScreen({super.key});

  @override
  State<ArrivalScreen> createState() => _ArrivalScreenState();
}

class _ArrivalScreenState extends State<ArrivalScreen> {
  final _repository = ArrivalRepository();

  bool _isLoading = true;
  List<BusinessEvent> _events = [];
  Persona? _currentUser;
  String? _error;

  // "I'm Here" flow state
  BusinessEvent? _selectedEvent;
  bool _isNearby = false; // proximity gate — simulates GPS arrival
  bool _isCheckingIn = false;
  bool _isCheckedIn = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final events = await _repository.getNearbyEvents();
      final user = await _repository.getCurrentUser();
      setState(() {
        _events = events;
        _currentUser = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onEventTap(BusinessEvent event) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventDetailScreen(
          event: event,
          onCheckIn: () => _onJoinEvent(event),
        ),
      ),
    );
  }

  void _onJoinEvent(BusinessEvent event) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedEvent = event;
      _isNearby = false;
    });

    // Simulate GPS proximity detection after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _selectedEvent?.id == event.id && !_isCheckingIn) {
        HapticFeedback.mediumImpact();
        setState(() {
          _isNearby = true;
        });
      }
    });
  }

  void _onCheckIn() {
    HapticFeedback.mediumImpact();
    final eventName = _selectedEvent?.name ?? '';
    setState(() {
      _isCheckingIn = true;
    });

    // Simulate instant check-in with a tiny delay for the animation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        HapticFeedback.heavyImpact();
        setState(() {
          _isCheckingIn = false;
          _isCheckedIn = true;
        });

        // After showing confirmation, navigate to Discovery
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isCheckedIn = false;
              _selectedEvent = null;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DiscoveryScreen(eventName: eventName),
              ),
            );
          }
        });
      }
    });
  }

  void _onBack() {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedEvent = null;
      _isCheckedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If user has checked in, show confirmation overlay
    if (_isCheckedIn && _selectedEvent != null) {
      return _buildCheckInComplete(context);
    }

    // If user selected an event, show the "I'm Here" screen
    if (_selectedEvent != null) {
      return _buildJoinScreen(context);
    }

    // Main Arrival screen
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Y',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Yugrow',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell, size: 22),
            color: AppColors.textSecondary,
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primarySoft,
            child: Text(
              _currentUser?.name.isNotEmpty == true
                  ? _currentUser!.name[0].toUpperCase()
                  : '?',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.wifi_off, size: 48, color: AppColors.textDisabled),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Could not load events',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Check your connection and try again.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: _loadData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textInverse,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.lgCircular,
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                ),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                LucideIcons.calendar,
                size: 48,
                color: AppColors.textDisabled,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'No business events nearby today',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Explore upcoming events or create one for your community.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textInverse,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.lgCircular,
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                ),
                child: const Text('Explore Events'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xxxl),
        itemCount: _events.length + 1, // +1 for greeting header
        itemBuilder: (context, index) {
          if (index == 0) {
            return GreetingHeader(
              userName: _currentUser?.name ?? 'there',
              eventCount: _events.length,
            );
          }
          final event = _events[index - 1];
          return EventCard(
            event: event,
            onJoin: () => _onJoinEvent(event),
            onTap: () => _onEventTap(event),
          );
        },
      ),
    );
  }

  /// The "I'm Here" screen shown after tapping Join
  Widget _buildJoinScreen(BuildContext context) {
    final event = _selectedEvent!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevron_left, size: 24),
          color: AppColors.textPrimary,
          onPressed: _onBack,
        ),
        title: Text(
          event.name,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Event illustration area
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: AppRadius.xlCircular,
                ),
                child: const Icon(
                  LucideIcons.map_pin,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // "You're joining" text
              Text(
                "You're joining",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Event name
              Text(
                event.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Venue
              Text(
                event.venue,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Proximity indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _isNearby
                      ? AppColors.primarySoft
                      : AppColors.textSecondary.withValues(alpha: 0.08),
                  borderRadius: AppRadius.lgCircular,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isNearby ? LucideIcons.circle_check : LucideIcons.map_pin,
                      size: 18,
                      color: _isNearby ? AppColors.primary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isNearby
                          ? '${event.presentCount > 0 ? event.presentCount : event.professionalCount} professionals here now'
                          : '${event.distance} away · ${event.businessCount > 0 ? '${event.businessCount} ${event.primaryMetricLabel} · ${event.professionalCount} ${event.secondaryMetricLabel}' : '${event.professionalCount} ${event.primaryMetricLabel}'}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _isNearby ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Get Directions button — only when outside venue
              if (!_isNearby) ...[
                SizedBox(
                  width: 240,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Open Google Maps / Apple Maps with event venue coordinates
                    },
                    icon: const Icon(LucideIcons.map_pin, size: 18),
                    label: Text(
                      'Get Directions',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.lgCircular,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Walk into the venue to become visible.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // Proximity-gated button
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: _isNearby && !_isCheckingIn ? _onCheckIn : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isNearby ? AppColors.primary : AppColors.textDisabled,
                    foregroundColor: AppColors.textInverse,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.lgCircular,
                    ),
                    elevation: 0,
                    disabledBackgroundColor: AppColors.textDisabled.withValues(alpha: 0.3),
                    disabledForegroundColor: AppColors.textSecondary,
                  ),
                  child: _isCheckingIn
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _isNearby ? "I'm Here" : 'Arrive to become visible',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  /// Brief celebration screen after checking in
  Widget _buildCheckInComplete(BuildContext context) {
    final event = _selectedEvent!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated checkmark
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.circle_check,
                  size: 48,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                "You're now visible",
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${event.professionalCount} professionals can now discover you.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                event.venue,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
