import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const double sm = 6;
  static const double md = 10;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 24;
  static const double full = 9999;

  static BorderRadius get smCircular => BorderRadius.circular(sm);
  static BorderRadius get mdCircular => BorderRadius.circular(md);
  static BorderRadius get lgCircular => BorderRadius.circular(lg);
  static BorderRadius get xlCircular => BorderRadius.circular(xl);
  static BorderRadius get xxlCircular => BorderRadius.circular(xxl);
  static BorderRadius get fullCircular => BorderRadius.circular(full);

  // Top-only radii for bottom sheets
  static BorderRadius get topXxl => const BorderRadius.vertical(
    top: Radius.circular(xxl),
  );
}
