import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Yugrow Typography System
///
/// Every text style in the app comes from here.
/// Never hardcode font sizes inside widgets.
class AppTypography {
  AppTypography._();

  // ── Card Name ─────────────────────────────────────
  /// 16sp, SemiBold, max 1 line, ellipsis
  static TextStyle get cardName => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get cardNameDark => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
      );

  // ── Card Title ────────────────────────────────────
  /// 14sp, Medium, max 1 line
  static TextStyle get cardTitle => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  // ── Card Company ──────────────────────────────────
  /// 13sp, Regular, max 1 line
  static TextStyle get cardCompany => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  // ── Looking For ──────────────────────────────────
  /// 12sp, Medium for the chip
  static TextStyle get lookingFor => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.primary.withValues(alpha: 0.7),
      );

  // ── Card Metadata ────────────────────────────────
  /// 12sp, Regular for time, mutuals, status
  static TextStyle get cardMetadata => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textDisabled,
      );

  /// 12sp, Medium for mutual count (emerald)
  static TextStyle get cardMutual => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
      );

  /// 12sp, SemiBold for Checked in (success green)
  static TextStyle get cardCheckedIn => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.success,
      );

  // ── Avatar Initial ───────────────────────────────
  static TextStyle get avatarInitial => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      );

  // ── Checked In badge (top-right) ─────────────────
  static TextStyle get checkedInBadge => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.success,
      );

  // ── Screen Title ─────────────────────────────────
  static TextStyle get screenTitle => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // ── Counter ──────────────────────────────────────
  static TextStyle get counter => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get counterDark => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
      );

  // ── Section Title ────────────────────────────────
  static TextStyle get sectionTitle => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // ── Body Text ────────────────────────────────────
  static TextStyle get body => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  // ── Button Label ─────────────────────────────────
  static TextStyle get buttonLabel => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textInverse,
      );
}
