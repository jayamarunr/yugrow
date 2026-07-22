import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yugrow_mobile/core/theme/app_colors.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import '../models/professional.dart';
import '../repository/discovery_repository.dart';
import '../widgets/professional_card.dart';
import 'profile_preview_screen.dart';

class DiscoveryScreen extends StatefulWidget {
  final String eventName;

  const DiscoveryScreen({super.key, required this.eventName});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final _repository = DiscoveryRepository();

  List<Professional> _professionals = [];
  bool _isLoading = true;
  bool _showAll = false;
  Timer? _heartbeatTimer;
  String? _heartbeatMessage;

  static const int _initialDisplayCount = 15;

  @override
  void initState() {
    super.initState();
    _loadProfessionals();
    _startHeartbeat();
  }

  @override
  void dispose() {
    _heartbeatTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadProfessionals() async {
    final pros = await _repository.getProfessionals();
    if (mounted) {
      setState(() {
        _professionals = pros;
        _isLoading = false;
      });
    }
  }

  final _heartbeatMessages = [
    'just checked in',
    'arrived in the last 5 minutes',
    'accepted new connections',
    'are arriving now',
    'checked in to the event',
  ];
  int _heartbeatIndex = 0;

  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 18), (_) async {
      final newArrivals = await _repository.getNewArrivals();
      if (!mounted) return;

      HapticFeedback.lightImpact();
      final count = newArrivals.length;
      final name = count > 0 ? newArrivals[0].name : '';
      _heartbeatIndex = (_heartbeatIndex + 1) % _heartbeatMessages.length;

      // Pick message based on rotation
      String message;
      if (count == 1 && name.isNotEmpty) {
        message = '$name ${_heartbeatMessages[0]}';
      } else if (_heartbeatIndex % 3 == 0) {
        message = '$count professionals ${_heartbeatMessages[_heartbeatIndex % _heartbeatMessages.length]}';
      } else if (_heartbeatIndex % 3 == 1) {
        final industries = ['Fintech', 'Manufacturing', 'AI', 'Healthcare', 'SaaS'];
        message = '${industries[_heartbeatIndex % industries.length]} professionals are arriving now';
      } else {
        message = '$count ${count == 1 ? 'person' : 'people'} accepted new connections';
      }

      setState(() {
        if (count > 0) {
          _professionals = [...newArrivals, ..._professionals];
        }
        _heartbeatMessage = message;
      });

      // Clear heartbeat message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _heartbeatMessage = null);
        }
      });
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
                      Text(
                        '${_professionals.length} people nearby',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
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
                    onRefresh: _loadProfessionals,
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
