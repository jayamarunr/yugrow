import 'package:flutter/material.dart';

/// YDS Border Radius Tokens
///
/// Never use arbitrary radius values. Choose from this scale.
class YRadius {
  YRadius._();

  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 14;
  static const double xl   = 16;
  static const double xxl  = 20;
  static const double full = 9999;

  static BorderRadius get xsCircular   => BorderRadius.circular(xs);
  static BorderRadius get smCircular   => BorderRadius.circular(sm);
  static BorderRadius get mdCircular   => BorderRadius.circular(md);
  static BorderRadius get lgCircular   => BorderRadius.circular(lg);
  static BorderRadius get xlCircular   => BorderRadius.circular(xl);
  static BorderRadius get xxlCircular  => BorderRadius.circular(xxl);
  static BorderRadius get fullCircular => BorderRadius.circular(full);

  /// Top-only radius for bottom sheets
  static BorderRadius get topXxl => const BorderRadius.vertical(
    top: Radius.circular(xxl),
  );
}
