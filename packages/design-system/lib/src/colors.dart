import 'package:flutter/material.dart';

/// YDS Colour Tokens — single source of truth for all platform colours.
///
/// Light and dark values for every token. Web CSS variables in
/// web/css-variables.css must mirror these values exactly.
class YColors {
  YColors._();

  // ── Brand ──────────────────────────────────────────────────────
  static const primary       = Color(0xFF0F8B6D);
  static const hover         = Color(0xFF0B755C);
  static const pressed       = Color(0xFF065F46);
  static const soft          = Color(0xFFE8F8F2);

  // ── Surface / Background ───────────────────────────────────────
  static const background          = Color(0xFFFAFAFA);
  static const surface             = Color(0xFFFFFFFF);
  static const surfaceElevated     = Color(0xFFFFFFFF);
  static const surfaceHover        = Color(0xFFF8FAFC);

  // ── Text ───────────────────────────────────────────────────────
  static const textPrimary   = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const textDisabled  = Color(0xFF94A3B8);
  static const textInverse   = Color(0xFFFFFFFF);
  static const textLink      = Color(0xFF0F8B6D);

  // ── Border ─────────────────────────────────────────────────────
  static const border       = Color(0xFFE2E8F0);
  static const borderHover  = Color(0xFFCBD5E1);
  static const borderActive = Color(0xFF0F8B6D);

  // ── Semantic ───────────────────────────────────────────────────
  static const success       = Color(0xFF059669);
  static const successSoft   = Color(0xFFECFDF5);
  static const warning       = Color(0xFFD97706);
  static const warningSoft   = Color(0xFFFFFBEB);
  static const error         = Color(0xFFDC2626);
  static const errorSoft     = Color(0xFFFEF2F2);
  static const info          = Color(0xFF2563EB);

  // ── Dark Mode ──────────────────────────────────────────────────
  static const backgroundDark         = Color(0xFF0F172A);
  static const surfaceDark            = Color(0xFF1E293B);
  static const surfaceElevatedDark    = Color(0xFF334155);
  static const surfaceHoverDark       = Color(0xFF1E293B);
  static const textPrimaryDark        = Color(0xFFF1F5F9);
  static const textSecondaryDark      = Color(0xFF94A3B8);
  static const textDisabledDark       = Color(0xFF64748B);
  static const textInverseDark        = Color(0xFF0F172A);
  static const borderDark             = Color(0xFF334155);
  static const borderHoverDark        = Color(0xFF475569);
  static const borderActiveDark       = Color(0xFF34D399);
  static const primaryDark            = Color(0xFF34D399);
  static const hoverDark              = Color(0xFF6EE7B7);
  static const pressedDark            = Color(0xFFA7F3D0);
  static const softDark               = Color(0xFF022C22);
  static const successDark            = Color(0xFF34D399);
  static const successSoftDark        = Color(0xFF022C22);
  static const warningDark            = Color(0xFFFBBF24);
  static const warningSoftDark        = Color(0xFF451A03);
  static const errorDark              = Color(0xFFF87171);
  static const errorSoftDark          = Color(0xFF450A0A);
  static const infoDark               = Color(0xFF60A5FA);
}
