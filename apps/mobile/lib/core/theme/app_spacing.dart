import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;    // space-1
  static const double sm = 8;    // space-2
  static const double md = 12;   // space-3
  static const double lg = 16;   // space-4
  static const double xl = 24;   // space-5
  static const double xxl = 32;  // space-6
  static const double xxxl = 48; // space-7
  static const double huge = 64; // space-8

  // Screen margins
  static const double screenMobile = 24;
  static const double screenDesktop = 32;

  // Card padding
  static const double cardDense = 16;
  static const double cardComfortable = 24;

  // Touch targets
  static const double touchMin = 44.0;

  // Common edge insets
  static const EdgeInsets screenHorizontal = EdgeInsets.symmetric(
    horizontal: screenMobile,
  );

  static const EdgeInsets cardPadding = EdgeInsets.all(cardDense);
  static const EdgeInsets cardPaddingComfortable = EdgeInsets.all(cardComfortable);
}
