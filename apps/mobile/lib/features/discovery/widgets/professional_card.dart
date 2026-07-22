import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yugrow_mobile/core/theme/app_colors.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import '../models/professional.dart';

class ProfessionalCard extends StatelessWidget {
  final Professional professional;
  final VoidCallback onTap;

  const ProfessionalCard({
    super.key,
    required this.professional,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = professional;
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
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: avatar + info + freshness dot
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Center(
                          child: Text(
                            p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),

                      // Name row — identity left, status right
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    p.name,
                                    style: GoogleFonts.inter(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                                if (p.isRecentlyArrived)
                                  Row(
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
                                      const SizedBox(width: 4),
                                      Text(
                                        'Checked in',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: AppColors.success,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              p.title,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              p.company,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Looking for — user-sourced intent
                  if (p.lookingFor.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.crosshair, size: 10, color: AppColors.primary.withValues(alpha: 0.6)),
                          const SizedBox(width: 4),
                          Text(
                            p.lookingFor.length > 55
                                ? '${p.lookingFor.substring(0, 55)}...'
                                : p.lookingFor,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: AppSpacing.md),

                  // Bottom row: time (grey) → mutual (emerald) → checked in (green dot + bold green)
                  Row(
                    children: [
                      Icon(LucideIcons.clock, size: 12, color: AppColors.textDisabled),
                      const SizedBox(width: 4),
                      Text(
                        p.timeAgo,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textDisabled,
                        ),
                      ),
                      if (p.mutualConnections > 0) ...[
                        const SizedBox(width: AppSpacing.lg),
                        Icon(LucideIcons.link_2, size: 12, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          '${p.mutualConnections} mutual',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      const Spacer(),

                      // Quick Connect
                      if (p.mutualConnections >= 3 || p.lookingFor.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Request sent to ${p.name.split(' ')[0]}'),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.user_plus,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
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
