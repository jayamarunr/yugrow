import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// YDS Typography Tokens
///
/// One font (Inter), four weights (400/500/600/700).
class YTypography {
  YTypography._();

  static const String fontFamily = 'Inter';

  // ── Type Scale ─────────────────────────────────────────────────
  static const double hero     = 48;
  static const double h1       = 32;
  static const double h2       = 24;
  static const double h3       = 20;
  static const double body     = 16;
  static const double bodySm   = 14;
  static const double caption  = 12;

  // ── Line Heights ───────────────────────────────────────────────
  static const double lineHeightTight   = 1.2;
  static const double lineHeightNormal  = 1.5;
  static const double lineHeightRelaxed = 1.6;

  // ── Letter Spacing ─────────────────────────────────────────────
  static const double trackingTight = -0.02;
  static const double trackingSlight = -0.01;
  static const double trackingWide = 0.01;

  // ── TextStyle presets ──────────────────────────────────────────
  static TextStyle _inter({
    required double size,
    required FontWeight weight,
    Color? color,
    double height = 1.5,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle heroStyle({Color? color}) =>
      _inter(size: hero, weight: FontWeight.w700, height: lineHeightTight, letterSpacing: trackingTight, color: color);

  static TextStyle h1Style({Color? color}) =>
      _inter(size: h1, weight: FontWeight.w700, height: lineHeightTight, letterSpacing: trackingTight, color: color);

  static TextStyle h2Style({Color? color}) =>
      _inter(size: h2, weight: FontWeight.w600, height: lineHeightTight, letterSpacing: trackingSlight, color: color);

  static TextStyle h3Style({Color? color}) =>
      _inter(size: h3, weight: FontWeight.w600, height: lineHeightNormal, color: color);

  static TextStyle bodyStyle({Color? color}) =>
      _inter(size: body, weight: FontWeight.w400, height: lineHeightRelaxed, color: color);

  static TextStyle bodyBoldStyle({Color? color}) =>
      _inter(size: body, weight: FontWeight.w600, height: lineHeightRelaxed, color: color);

  static TextStyle bodySmallStyle({Color? color}) =>
      _inter(size: bodySm, weight: FontWeight.w400, height: lineHeightNormal, color: color);

  static TextStyle captionStyle({Color? color}) =>
      _inter(size: caption, weight: FontWeight.w500, height: lineHeightNormal, letterSpacing: trackingWide, color: color);

  static TextStyle buttonStyle({Color? color}) =>
      _inter(size: body, weight: FontWeight.w600, height: 1.0, color: color);

  static TextStyle buttonSmallStyle({Color? color}) =>
      _inter(size: bodySm, weight: FontWeight.w600, height: 1.0, color: color);
}
