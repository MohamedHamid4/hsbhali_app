import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle displayLarge({Color color = AppColors.lightTextPrimary}) =>
      GoogleFonts.marhey(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.3,
      );

  static TextStyle displayMedium({Color color = AppColors.lightTextPrimary}) =>
      GoogleFonts.marhey(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.3,
      );

  static TextStyle headingLarge({Color color = AppColors.lightTextPrimary}) =>
      GoogleFonts.marhey(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.4,
      );

  static TextStyle headingMedium({Color color = AppColors.lightTextPrimary}) =>
      GoogleFonts.marhey(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      );

  static TextStyle headingSmall({Color color = AppColors.lightTextPrimary}) =>
      GoogleFonts.marhey(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      );

  static TextStyle bodyLarge({Color color = AppColors.lightTextPrimary}) =>
      GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  static TextStyle bodyMedium({Color color = AppColors.lightTextSecondary}) =>
      GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  static TextStyle bodySmall({Color color = AppColors.lightTextTertiary}) =>
      GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  static TextStyle labelLarge({Color color = AppColors.lightTextPrimary}) =>
      GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      );

  static TextStyle labelMedium({Color color = AppColors.lightTextSecondary}) =>
      GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      );

  static TextStyle labelSmall({Color color = AppColors.lightTextTertiary}) =>
      GoogleFonts.cairo(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      );

  static TextStyle numberStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.lightTextPrimary,
  }) =>
      GoogleFonts.cairo(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}
