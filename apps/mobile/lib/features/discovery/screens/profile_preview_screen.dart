import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yugrow_mobile/core/theme/app_colors.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import '../models/professional.dart';
import 'first_message_screen.dart';

class ProfilePreviewScreen extends StatefulWidget {
  final Professional professional;

  const ProfilePreviewScreen({super.key, required this.professional});

  @override
  State<ProfilePreviewScreen> createState() => _ProfilePreviewScreenState();
}

class _ProfilePreviewScreenState extends State<ProfilePreviewScreen> {
  bool _requestSent = false;
  bool _accepted = false;
  bool _showReassurance = false;
  bool _isPendingPermanent = false;

  void _onConnect() {
    HapticFeedback.mediumImpact();
    setState(() => _requestSent = true);

    // Show reassurance after 5 seconds if still pending
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && !_accepted) {
        setState(() => _showReassurance = true);
      }
    });

    _simulateAcceptance();
  }

  void _simulateAcceptance() {
    // Randomized acceptance timing for realistic feel
    // 30%: 2s, 40%: 5s, 30%: 10s — always accepts
    final rand = DateTime.now().microsecondsSinceEpoch % 100;

    int delay;
    if (rand < 30) {
      delay = 2;
    } else if (rand < 70) {
      delay = 5;
    } else {
      delay = 10;
    }

    Future.delayed(Duration(seconds: delay), () {
      if (mounted) {
        HapticFeedback.heavyImpact();
        setState(() {
          _accepted = true;
          _showReassurance = false;
          _isPendingPermanent = false;
        });
      }
    });
  }

  void _onSayHello() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FirstMessageScreen(professional: widget.professional),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.professional;
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
          'Profile',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surface,
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Name
                  Text(
                    p.name,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Title + Company
                  Text(
                    p.title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    p.company,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Relevance badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      p.relevanceReason,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  // Mutual connections
                  if (p.mutualConnections > 0) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${p.mutualConnections} mutual connections',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Why you should connect
            _Section(
              title: 'Why you should connect',
              child: Column(
                children: [
                  _ReasonRow(icon: LucideIcons.check, text: p.relevanceReason),
                  if (p.lookingFor.isNotEmpty)
                    _ReasonRow(icon: LucideIcons.search, text: p.lookingFor),
                  if (p.mutualConnections > 0)
                    _ReasonRow(icon: LucideIcons.link_2, text: '${p.mutualConnections} mutual connections'),
                  _ReasonRow(icon: LucideIcons.calendar, text: 'Attending AI Summit Chennai'),
                ],
              ),
            ),
            // About
            if (p.about.isNotEmpty)
              _Section(
                title: 'About',
                child: Text(
                  p.about,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.6,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

            // Skills
            if (p.skills.isNotEmpty)
              _Section(
                title: 'Skills',
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: p.skills.map((s) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      s,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  )).toList(),
                ),
              ),

            // Looking for
            if (p.lookingFor.isNotEmpty)
              _Section(
                title: 'Looking for',
                child: Row(
                  children: [
                    const Icon(LucideIcons.search, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        p.lookingFor,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Recent activity
            if (p.recentActivity.isNotEmpty)
              _Section(
                title: 'Recent Activity',
                child: Row(
                  children: [
                    const Icon(LucideIcons.activity, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        p.recentActivity,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Connect button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenMobile,
                AppSpacing.xl,
                AppSpacing.screenMobile,
                AppSpacing.xxxl,
              ),
              child: Column(
                children: [
                  // Connected context card
                  if (_accepted)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.05),
                        borderRadius: AppRadius.lgCircular,
                        border: Border.all(color: AppColors.success.withValues(alpha: 0.15)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(LucideIcons.circle_check, size: 20, color: AppColors.success),
                              const SizedBox(width: 8),
                              Text(
                                "You're Connected",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'You met at AI Summit Chennai',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            'Today · Hall B',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textDisabled,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: _accepted
                        ? ElevatedButton.icon(
                            onPressed: _onSayHello,
                            icon: const Icon(LucideIcons.message_square, size: 20),
                            label: Text(
                              'Say Hello',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textInverse,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.lgCircular,
                              ),
                              elevation: 0,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: _requestSent ? null : _onConnect,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _requestSent ? AppColors.success.withValues(alpha: 0.1) : AppColors.primary,
                              foregroundColor: _requestSent ? AppColors.success : AppColors.textInverse,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.lgCircular,
                              ),
                              elevation: 0,
                            ),
                            child: _requestSent
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(LucideIcons.check, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Request Sent',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(LucideIcons.user_plus, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Connect with ${p.name.split(' ')[0]}',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                  ),

                  // Reassuring message during pending
                  if (_requestSent && !_accepted)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.md),
                      child: Text(
                        _isPendingPermanent
                            ? "We'll let you know when ${p.name.split(' ')[0]} responds."
                            : _showReassurance
                                ? 'Still waiting...\nPeople often reply during the event.'
                                : "${p.name.split(' ')[0]} will decide when they're available.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textDisabled,
                          height: 1.4,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenMobile,
        AppSpacing.xl,
        AppSpacing.screenMobile,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _ReasonRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ReasonRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.success),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
