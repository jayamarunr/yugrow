import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yugrow_mobile/core/theme/app_colors.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import 'package:yugrow_mobile/features/arrival/models/arrival_models.dart';

class EventDetailScreen extends StatelessWidget {
  final BusinessEvent event;
  final VoidCallback onCheckIn;

  const EventDetailScreen({
    super.key,
    required this.event,
    required this.onCheckIn,
  });

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
          event.name,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surface,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event name
                  Text(
                    event.name,
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),

                  // Day label
                  if (event.dayLabel.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        event.dayLabel,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.md),

                  // Venue + Distance
                  Row(
                    children: [
                      const Icon(LucideIcons.building_2, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.venue,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(LucideIcons.map_pin, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        event.distance,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  // Full ecosystem breakdown
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.surface,
                      borderRadius: AppRadius.lgCircular,
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.border,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        _EcoRow(icon: LucideIcons.building_2, label: 'Businesses', value: '${event.businessCount}', color: AppColors.textPrimary),
                        const Divider(height: 20, color: AppColors.border),
                        _EcoRow(icon: LucideIcons.users, label: 'Professionals', value: '${event.professionalCount}', color: AppColors.textPrimary),
                        if (event.visitorCount > 0) ...[
                          const Divider(height: 20, color: AppColors.border),
                          _EcoRow(icon: LucideIcons.footprints, label: 'Visitors Today', value: '${event.visitorCount}', color: AppColors.textPrimary),
                        ],
                        const Divider(height: 20, color: AppColors.border),
                        _EcoRow(icon: LucideIcons.map_pin, label: 'Here Now', value: '${event.presentCount}', color: AppColors.primary),
                      ],
                    ),
                  ),

                  // Your Opportunity section
                  if (event.status == 'live') ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Your Opportunity',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Connections here
                    if (event.connectionsAttending > 0)
                      _OpportunityRow(
                        icon: LucideIcons.link_2,
                        text: '${event.connectionsAttending} of your connections are here',
                      ),

                    // Expertise matches
                    if (event.expertiseMatches > 0)
                      _OpportunityRow(
                        icon: LucideIcons.star,
                        text: '${event.expertiseMatches} professionals match your interests',
                      ),

                    // Available to connect
                    if (event.visibleCount > 0)
                      _OpportunityRow(
                        icon: LucideIcons.users,
                        text: '${event.visibleCount} professionals are available to connect',
                      ),

                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Become visible to discover who\'s nearby.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Description
            if (event.description.isNotEmpty)
              Padding(
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
                      'About',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      event.description,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        height: 1.6,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

            // People breakdown
            if (event.peopleBreakdown.isNotEmpty)
              Padding(
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
                      'Who\'s here',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...event.peopleBreakdown.entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.key,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            '${entry.value}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),

            const SizedBox(height: AppSpacing.xxl),

            // Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMobile),
              child: Column(
                children: [
                  // I'm Here button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onCheckIn();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textInverse,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.lgCircular,
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "I'm Here",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // External ticket link
                  if (event.ticketUrl.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Launch URL
                        },
                        icon: const Icon(LucideIcons.external_link, size: 18),
                        label: Text(
                          'Buy Ticket',
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
                  ],

                  const SizedBox(height: AppSpacing.xxxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EcoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _EcoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _OpportunityRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _OpportunityRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
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
