import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:yugrow_mobile/core/theme/app_colors.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import 'package:yugrow_mobile/core/theme/app_typography.dart';
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
                  // Top row: avatar + info + status
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
                            style: AppTypography.avatarInitial,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),

                      // Name + title + company
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    p.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: isDark ? AppTypography.cardNameDark : AppTypography.cardName,
                                  ),
                                ),
                                if (p.isRecentlyArrived)
                                  Padding(
                                    padding: const EdgeInsets.only(left: AppSpacing.sm),
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
                                        const SizedBox(width: AppSpacing.xs),
                                        Text(
                                          'Checked in',
                                          style: AppTypography.checkedInBadge,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              p.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.cardTitle,
                            ),
                            const SizedBox(height: 1),
                            Text(
                              p.company,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.cardCompany,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Looking for — user-sourced intent
                  if (p.lookingFor.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.crosshair, size: 10, color: AppColors.primary.withValues(alpha: 0.6)),
                          const SizedBox(width: AppSpacing.xs),
                          Flexible(
                            child: Text(
                              p.lookingFor,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.lookingFor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.md),

                  // Bottom row: time + mutuals + checked in + quick connect
                  Row(
                    children: [
                        const Icon(LucideIcons.clock, size: 12, color: AppColors.textDisabled),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          p.timeAgo,
                          style: AppTypography.cardMetadata,
                        ),
                        if (p.mutualConnections > 0) ...[
                          const SizedBox(width: AppSpacing.lg),
                          const Icon(LucideIcons.link_2, size: 12, color: AppColors.primary),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '${p.mutualConnections} mutual',
                            style: AppTypography.cardMutual,
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
