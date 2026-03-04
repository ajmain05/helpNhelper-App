import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'my_colors.dart';

class DesignSystem {
  DesignSystem._();

  // Spacing
  static const double spacingEmpty = 0;
  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 16;
  static const double spacingL = 24;
  static const double spacingXL = 32;
  static const double spacingXXL = 48;

  // Radius
  static const double radiusS = 8;
  static const double radiusM = 16;
  static const double radiusL = 24;
  static const double radiusXL = 32;

  // Text Styles — NO hardcoded color so theme's textTheme color applies automatically
  static TextStyle get h1 => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get h2 => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get h3 => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyBold => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: MyColors.textSecondary,
      );

  static TextStyle get buttonText => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  // Shadows
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get mediumShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
}
