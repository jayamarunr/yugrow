import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yugrow_mobile/core/theme/app_colors.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import 'package:yugrow_mobile/features/arrival/models/arrival_models.dart';

class EventCard extends StatelessWidget {
  final BusinessEvent event;
  final VoidCallback onJoin;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onJoin,
    this.onTap,
  });

  Color get _statusColor {
    switch (event.status) {
      case 'live':
        return AppColors.success;
      case 'starting_soon':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData get _statusIcon {
    switch (event.status) {
      case 'live':
        return LucideIcons.circle;
      case 'starting_soon':
        return LucideIcons.clock;
      default:
        return LucideIcons.calendar;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenMobile,
        vertical: AppSpacing.sm / 2,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: AppRadius.lgCircular,
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.border,
            width: 0.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.lgCircular,
          child: InkWell(
            borderRadius: AppRadius.lgCircular,
            onTap: onTap ?? onJoin,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge — alive for live events
                  Row(
                    children: [
                      if (event.status == 'live')
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                event.businessCount > 0
                                    ? '${event.businessCount} ${event.primaryMetricLabel} · ${event.professionalCount} ${event.secondaryMetricLabel}'
                                    : '${event.professionalCount} ${event.primaryMetricLabel}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _statusIcon,
                                size: 10,
                                color: _statusColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                event.statusText,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: _statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (event.distance.isNotEmpty) ...[
                        const Spacer(),
                        const Icon(
                          LucideIcons.map_pin,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          event.distance,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Day label for multi-day events
                  if (event.dayLabel.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        event.dayLabel,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                          letterSpacing: 0.02,
                        ),
                      ),
                    ),

                  // Event name
                  Text(
                    event.name,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Venue
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.building_2,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        event.venue,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Stats row — ecosystem metrics
                  Row(
                    children: [
                      _StatItem(
                        icon: LucideIcons.building_2,
                        value: _formatCount(event.businessCount > 0 ? event.businessCount : event.primaryMetricValue),
                        label: event.businessCount > 0 ? 'Businesses' : event.primaryMetricLabel,
                      ),
                      if (event.presentCount > 0) ...[
                        const SizedBox(width: AppSpacing.lg),
                        _StatItem(
                          icon: LucideIcons.map_pin,
                          value: _formatCount(event.presentCount),
                          label: 'Here Now',
                          color: AppColors.primary,
                        ),
                      ] else if (event.visibleCount > 0) ...[
                        const SizedBox(width: AppSpacing.lg),
                        _StatItem(
                          icon: LucideIcons.eye,
                          value: _formatCount(event.visibleCount),
                          label: 'Visible',
                          color: AppColors.primary,
                        ),
                      ],
                      if (event.expertiseMatches > 0) ...[
                        const SizedBox(width: AppSpacing.lg),
                        _StatItem(
                          icon: LucideIcons.star,
                          value: '${event.expertiseMatches}',
                          label: 'relevant',
                          color: AppColors.primary,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Join button — quiet, not dominant
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: onJoin,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.lgCircular,
                        ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _formatCount(int count) {
  if (count >= 1000) {
    final k = count / 1000;
    if (k == k.roundToDouble()) {
      return '${k.round()}K';
    }
    return '${k.toStringAsFixed(1)}K';
  }
  return count.toString();
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: effectiveColor),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: effectiveColor,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: effectiveColor.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
