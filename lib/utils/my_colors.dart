import 'package:flutter/material.dart';

class MyColors {
  MyColors._();

  // Primary Colors - Premium Teal/Green
  static const Color primary = Color(0xFF00BFA5);
  static const Color primaryDark = Color(0xFF00796B);
  static const Color primaryLight = Color(0xFFE0F2F1);

  // Background Colors - Clean & Airy
  static const Color background = Color(0xFFF8FAFB);
  static const Color surface = Colors.white;
  static const Color cardBg = Colors.white;

  // Neutral Colors
  static const Color textPrimary = Color(0xFF1A1C1E);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color divider = Color(0xFFE9ECEF);

  // Accents
  static const Color accent = Color(0xFF2D31FA);
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFFFA000);

  // Deprecated/Legacy compatibility for minimal breakage
  static const Color ash = Color(0xFF9E9E9E);
  static const Color blue = primary;
  static const Color yellow = Color(0Xfffac213);
  static const Color appColor = primary;
  static const Color appColorBg = background;
  static const Color appColorLight = primaryLight;
  static const Color white = Colors.white;
}
