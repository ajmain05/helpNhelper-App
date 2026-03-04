import 'package:flutter/material.dart';
import 'my_colors.dart';

/// Theme-aware color helpers.
/// Use these instead of hardcoded MyColors constants inside widgets.
///
/// Usage:
///   color: AppTheme.bg(context)
///   color: AppTheme.card(context)
class AppTheme {
  AppTheme._();

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // ── Backgrounds ─────────────────────────────────────────────────────
  /// Main scaffold/page background
  static Color bg(BuildContext context) =>
      isDark(context) ? const Color(0xFF0F1117) : MyColors.background;

  /// Surface / navbar / appbar
  static Color surface(BuildContext context) =>
      isDark(context) ? const Color(0xFF1A1D27) : MyColors.surface;

  /// Card background
  static Color card(BuildContext context) =>
      isDark(context) ? const Color(0xFF252836) : MyColors.surface;

  // ── Text ─────────────────────────────────────────────────────────────
  static Color textPrimary(BuildContext context) =>
      isDark(context) ? const Color(0xFFE8EAF0) : MyColors.textPrimary;

  static Color textSecondary(BuildContext context) =>
      isDark(context) ? const Color(0xFF9EA3B5) : MyColors.textSecondary;

  // ── Divider ──────────────────────────────────────────────────────────
  static Color divider(BuildContext context) =>
      isDark(context) ? const Color(0xFF2D3147) : MyColors.divider;

  // ── Shadow ───────────────────────────────────────────────────────────
  static List<BoxShadow> shadow(BuildContext context) => [
        BoxShadow(
          color: isDark(context)
              ? Colors.black.withOpacity(0.35)
              : Colors.black.withOpacity(0.06),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ];
}
