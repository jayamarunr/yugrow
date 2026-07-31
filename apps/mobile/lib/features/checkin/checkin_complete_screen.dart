import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';
import 'package:yugrow_mobile/core/theme/app_radius.dart';
import 'package:yugrow_mobile/core/theme/app_typography.dart';

class CheckinCompleteScreen extends StatelessWidget {
  final String eventName;
  final String venueName;

  const CheckinCompleteScreen({
    super.key,
    this.eventName = '',
    this.venueName = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Success icon with confetti dots
              SizedBox(
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 10, top: 8,
                      child: Container(width: 10, height: 10,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
                    ),
                    Positioned(
                      right: 15, top: 5,
                      child: Container(width: 8, height: 8,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.warning)),
                    ),
                    Positioned(
                      right: 40, bottom: 8,
                      child: Container(width: 6, height: 6,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.info)),
                    ),
                    const Icon(Icons.check_circle, color: AppColors.primary, size: 64),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              Text("You're visible!",
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.md),

              if (eventName.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: AppRadius.mdCircular,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.map_pin, size: 14, color: AppColors.primary),
                      const SizedBox(width: AppSpacing.sm),
                      Text(eventName,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500,
                              color: AppColors.primary)),
                    ],
                  ),
                ),

              Text(
                'Others can now discover and connect with you.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Professionals nearby can see your profile, send connection requests, and start conversations.',
                style: TextStyle(color: AppColors.textDisabled, fontSize: 12),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(LucideIcons.eye, size: 18),
                  label: const Text("See Who's Here"),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
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

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );

  }
}
