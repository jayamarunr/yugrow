import 'package:flutter/material.dart';

/// YDS Elevation / Shadow Tokens
///
/// Very subtle shadows. Never floating glass or large blur.
class YElevation {
  YElevation._();

  // BoxShadow values for Flutter
  static const List<BoxShadow> none = [];

  static const List<BoxShadow> level1 = [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 3,
      color: Color.fromRGBO(0, 0, 0, 0.06),
    ),
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      color: Color.fromRGBO(0, 0, 0, 0.04),
    ),
  ];

  static const List<BoxShadow> level2 = [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 12,
      color: Color.fromRGBO(0, 0, 0, 0.05),
    ),
    BoxShadow(
      offset: Offset(0, 2),
      blurRadius: 4,
      color: Color.fromRGBO(0, 0, 0, 0.04),
    ),
  ];

  static const List<BoxShadow> level3 = [
    BoxShadow(
      offset: Offset(0, 20),
      blurRadius: 60,
      color: Color.fromRGBO(0, 0, 0, 0.08),
    ),
    BoxShadow(
      offset: Offset(0, 8),
      blurRadius: 20,
      color: Color.fromRGBO(0, 0, 0, 0.06),
    ),
  ];
}
