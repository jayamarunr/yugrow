import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yugrow_mobile/core/theme/app_colors.dart';
import 'package:yugrow_mobile/core/theme/app_spacing.dart';

class GreetingHeader extends StatelessWidget {
  final String userName;
  final int eventCount;

  const GreetingHeader({
    super.key,
    required this.userName,
    required this.eventCount,
  });

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.screenMobile,
        right: AppSpacing.screenMobile,
        top: AppSpacing.lg,
        bottom: AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$_greeting, $userName.',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.2,
              letterSpacing: -0.02,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            eventCount == 1
              ? 'There is 1 business event happening nearby today.'
              : 'There are $eventCount business events happening nearby today.',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
