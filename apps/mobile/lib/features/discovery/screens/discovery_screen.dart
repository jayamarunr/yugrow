import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yugrow_mobile/core/theme/app_colors.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import '../models/professional.dart';
import '../engine/presence_engine.dart' show PresenceEngine, PresenceEvent, PresenceArrival, Presence;
import '../widgets/professional_card.dart';
import 'profile_preview_screen.dart';

class DiscoveryScreen extends StatefulWidget {
  final String eventName;

  const DiscoveryScreen({super.key, required this.eventName});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> with WidgetsBindingObserver {
  final _engine = PresenceEngine();

  List<Professional> _professionals = [];
  bool _isLoading = true;
  bool _showAll = false;
  Timer? _heartbeatTimer;
  String? _heartbeatMessage;
  StreamSubscription<PresenceEvent>? _subscription;

  // Re-entry tracking
  int _arrivalsSinceLastView = 0;
  String? _reentryMessage;

  static const int _initialDisplayCount = 15;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = _engine.events.listen(_onPresenceEvent);
    _engine.start();
    _startHeartbeat();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    _heartbeatTimer?.cancel();
    _engine.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _arrivalsSinceLastView > 0) {
      _showReentryMessage();
    }
  }

  void _showReentryMessage() {
    if (!mounted) return;
    final count = _arrivalsSinceLastView;
    setState(() {
      _reentryMessage = count == 1
          ? '1 new professional arrived while you were away'
          : '$count new professionals arrived while you were away';
    });
    _arrivalsSinceLastView = 0;
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _reentryMessage = null);
      }
    });
  }

  void _onPresenceEvent(PresenceEvent event) {
    if (!mounted) return;
    setState(() {
      _professionals = Presence.onlyProfessionals(event.presences);
      _isLoading = false;

      if (event is PresenceArrival) {
        // Track arrivals even while away
        _arrivalsSinceLastView++;
        HapticFeedback.lightImpact();
        _showHeartbeat(_engine.generateHeartbeatMessage());
      }
    });
  }

  void _showHeartbeat(String message) {
    setState(() => _heartbeatMessage = message);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _heartbeatMessage = null);
      }
    });
  }

  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 18), (_) {
      if (!mounted) return;
      _showHeartbeat(_engine.generateHeartbeatMessage());
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevron_left, size: 24),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.eventName,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                ),
              ),
            )
          : Column(
              children: [
                // Heartbeat banner — animated slide-down with fade
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: _heartbeatMessage != null
                      ? Container(
                          key: ValueKey(_heartbeatMessage),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenMobile,
                            vertical: 10,
                          ),
                          color: AppColors.primarySoft.withValues(alpha: 0.5),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _heartbeatMessage!,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // Re-entry banner — arrivals while away
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: _reentryMessage != null
                      ? Container(
                          key: ValueKey(_reentryMessage),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenMobile,
                            vertical: 10,
                          ),
                          color: AppColors.success.withValues(alpha: 0.08),
                          child: Row(
                            children: [
                              Icon(LucideIcons.sparkles, size: 14, color: AppColors.success),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _reentryMessage!,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenMobile,
                    AppSpacing.lg,
                    AppSpacing.screenMobile,
                    AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Text(
                          '${_professionals.length} people nearby',
                          key: ValueKey(_professionals.length),
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Best matches first',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Professional list
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _engine.stop();
                      _engine.start();
                    },
                    color: AppColors.primary,
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xxxl),
                      itemCount: _showAll
                          ? _professionals.length + 1
                          : (_professionals.length > _initialDisplayCount
                              ? _initialDisplayCount + 1
                              : _professionals.length),
                      itemBuilder: (context, index) {
                        // Show More button
                        if (!_showAll && index == _initialDisplayCount) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.screenMobile,
                              vertical: AppSpacing.lg,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() => _showAll = true);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(color: AppColors.border),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.lgCircular,
                                  ),
                                ),
                                child: Text(
                                  'Show More (${_professionals.length - _initialDisplayCount} more)',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        // Show all and end of list reached
                        if (_showAll && index == _professionals.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.screenMobile,
                              vertical: AppSpacing.lg,
                            ),
                            child: Center(
                              child: Text(
                                'New arrivals will appear here',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          );
                        }

                        final p = _professionals[index];
                        return ProfessionalCard(
                          professional: p,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProfilePreviewScreen(professional: p),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
