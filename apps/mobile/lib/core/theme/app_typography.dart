import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Yugrow Typography System
///
/// Every text style in the app comes from here.
/// Never hardcode font sizes inside widgets.
/// Uses TextStyle with fontFamily 'Inter' — loaded via CSS link in index.html.
class AppTypography {
  AppTypography._();

  // ── Card Name ─────────────────────────────────────
  static TextStyle get cardName => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get cardNameDark => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
        height: 1.2,
      );

  // ── Card Title ────────────────────────────────────
  static TextStyle get cardTitle => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  // ── Card Company ──────────────────────────────────
  static TextStyle get cardCompany => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  // ── Looking For ──────────────────────────────────
  static TextStyle get lookingFor => TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.primary.withValues(alpha: 0.7),
      );

  // ── Card Metadata ────────────────────────────────
  static TextStyle get cardMetadata => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textDisabled,
      );

  static TextStyle get cardMutual => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
      );

  static TextStyle get cardCheckedIn => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.success,
      );

  // ── Avatar Initial ───────────────────────────────
  static TextStyle get avatarInitial => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      );

  // ── Checked In badge (top-right) ─────────────────
  static TextStyle get checkedInBadge => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.success,
      );

  // ── Screen Title ─────────────────────────────────
  static TextStyle get screenTitle => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // ── Counter ──────────────────────────────────────
  static TextStyle get counter => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get counterDark => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
      );

  // ── Section Title ────────────────────────────────
  static TextStyle get sectionTitle => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );



  // ── Button Label ─────────────────────────────────
  static TextStyle get buttonLabel => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textInverse,
      );

  // ── YDS Canonical API (matches packages/design-system/lib/src/typography.dart) ──
  static const TextStyle body = TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w400, height: 1.6, color: AppColors.textPrimary);
  static const TextStyle bodyBold = TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, height: 1.6, color: AppColors.textPrimary);
  static const TextStyle bodySmall = TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textSecondary);
  static const TextStyle caption = TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, height: 1.4, letterSpacing: 0.01, color: AppColors.textSecondary);
  static const TextStyle h3 = TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w600, height: 1.4, color: AppColors.textPrimary);
  static const TextStyle h2 = TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w600, height: 1.3, letterSpacing: -0.01, color: AppColors.textPrimary);
  static const TextStyle h1 = TextStyle(fontFamily: 'Inter', fontSize: 32, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: -0.02, color: AppColors.textPrimary);
  static const TextStyle button = TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, height: 1.0, color: AppColors.textInverse);
  static const TextStyle buttonSmall = TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, height: 1.0, color: AppColors.primary);
}
