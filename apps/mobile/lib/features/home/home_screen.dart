// ─── Yugrow Home Screen (Events Timeline) ─────────────────────────
// "Where should I go today?"
// Shows nearby events organized by time. Not a dashboard — no stats,
// no recent activity, no relationship reminders. Pure event timeline.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yugrow_mobile/core/theme/app_colors.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import '../arrival/models/arrival_models.dart';
import '../arrival/models/event_state.dart';
import '../arrival/repository/arrival_repository.dart';
import '../arrival/widgets/greeting_header.dart';
import '../arrival/widgets/event_card.dart';
import '../arrival/screens/event_detail_screen.dart';
import '../discovery/screens/discovery_screen.dart';
import '../debug/founder_console_screen.dart';
import '../host/host_event_screen.dart';
import '../../core/widgets/founder_mode_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = ArrivalRepository();

  bool _isLoading = true;
  List<BusinessEvent> _events = [];
  Persona? _currentUser;
  String? _error;

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
      // AH-015: Only show events whose calendar date is today
      final todayEvents = events.where((e) => EventState.isToday(e.startDate)).toList();
      final user = await _repository.getCurrentUser();
      setState(() {
        _events = todayEvents;
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
          onCheckIn: () {
            // Navigate to Live tab with this event selected
            // For now, pop back and let user join from Live
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _onJoinEvent(BusinessEvent event) {
    HapticFeedback.lightImpact();
    // Navigate to the Live tab for check-in
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DiscoveryScreen(eventName: event.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            GestureDetector(
              onLongPress: () {
                HapticFeedback.mediumImpact();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FounderConsole()),
                );
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: AppRadius.smCircular,
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
            ),
            const SizedBox(width: AppSpacing.md),
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
          const SizedBox(width: AppSpacing.sm),
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
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      body: Column(
        children: [
          const FounderModeBanner(),
          Expanded(child: _buildBody()),
        ],
      ),
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
                'Nothing happening nearby today',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Explore upcoming events or check back later.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HostEventScreen()),
                  );
                },
                icon: const Icon(LucideIcons.plus, size: 18),
                label: const Text('Host an Event'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textInverse,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.lgCircular,
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
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
        itemCount: _events.length + 2, // greeting + host card + events
        itemBuilder: (context, index) {
          if (index == 0) {
            return GreetingHeader(
              userName: _currentUser?.name ?? 'there',
              eventCount: _events.length,
            );
          }
          if (index == 1) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenMobile,
                vertical: AppSpacing.sm / 2,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: AppRadius.lgCircular,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: AppRadius.lgCircular,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const HostEventScreen()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: AppRadius.mdCircular,
                            ),
                            child: const Icon(LucideIcons.plus, size: 22, color: Colors.white),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '+ Host Event',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Create a professional event in under a minute',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(LucideIcons.chevron_right, size: 18, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          final event = _events[index - 2];
          return EventCard(
            event: event,
            onJoin: () => _onJoinEvent(event),
            onTap: () => _onEventTap(event),
          );
        },
      ),
    );
  }
}
