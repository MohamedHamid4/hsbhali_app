import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme() {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primarySoft,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFFFE0E0),
      onSecondaryContainer: AppColors.secondaryDark,
      tertiary: AppColors.accent,
      onTertiary: AppColors.lightTextPrimary,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.lightBackground,
      onSurface: AppColors.lightTextPrimary,
      surfaceContainerHighest: AppColors.lightSurfaceVariant,
      onSurfaceVariant: AppColors.lightTextSecondary,
      outline: AppColors.lightBorderStrong,
      outlineVariant: AppColors.lightBorder,
    );

    return _buildTheme(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackground: AppColors.lightBackground,
      surface: AppColors.lightSurface,
      textPrimary: AppColors.lightTextPrimary,
      textSecondary: AppColors.lightTextSecondary,
      textTertiary: AppColors.lightTextTertiary,
      border: AppColors.lightBorder,
      borderStrong: AppColors.lightBorderStrong,
    );
  }

  static ThemeData darkTheme() {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.primarySoft,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondaryDark,
      onSecondaryContainer: Color(0xFFFFE0E0),
      tertiary: AppColors.accent,
      onTertiary: AppColors.darkBackground,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.darkBackground,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      onSurfaceVariant: AppColors.darkTextSecondary,
      outline: AppColors.darkBorderStrong,
      outlineVariant: AppColors.darkBorder,
    );

    return _buildTheme(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackground: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      textPrimary: AppColors.darkTextPrimary,
      textSecondary: AppColors.darkTextSecondary,
      textTertiary: AppColors.darkTextTertiary,
      border: AppColors.darkBorder,
      borderStrong: AppColors.darkBorderStrong,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
    required Color surface,
    required Color textPrimary,
    required Color textSecondary,
    required Color textTertiary,
    required Color border,
    required Color borderStrong,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      fontFamily: GoogleFonts.cairo().fontFamily,
    );

    return base.copyWith(
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge(color: textPrimary),
        displayMedium: AppTextStyles.displayMedium(color: textPrimary),
        headlineLarge: AppTextStyles.headingLarge(color: textPrimary),
        headlineMedium: AppTextStyles.headingMedium(color: textPrimary),
        headlineSmall: AppTextStyles.headingSmall(color: textPrimary),
        bodyLarge: AppTextStyles.bodyLarge(color: textPrimary),
        bodyMedium: AppTextStyles.bodyMedium(color: textSecondary),
        bodySmall: AppTextStyles.bodySmall(color: textTertiary),
        labelLarge: AppTextStyles.labelLarge(color: textPrimary),
        labelMedium: AppTextStyles.labelMedium(color: textSecondary),
        labelSmall: AppTextStyles.labelSmall(color: textTertiary),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headingMedium(color: textPrimary),
        systemOverlayStyle: brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(AppDimensions.buttonMedium),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          textStyle: AppTextStyles.labelLarge(color: Colors.white),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingXl,
            vertical: AppDimensions.spacingMd,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(AppDimensions.buttonMedium),
          side: const BorderSide(
            color: AppColors.primary,
            width: AppDimensions.borderThick,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          textStyle: AppTextStyles.labelLarge(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingXl,
            vertical: AppDimensions.spacingMd,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(0, AppDimensions.buttonSmall),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          textStyle: AppTextStyles.labelLarge(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingLg,
            vertical: AppDimensions.spacingSm,
          ),
        ),
      ),

      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          side: BorderSide(color: border, width: AppDimensions.borderThin),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingLg,
          vertical: AppDimensions.spacingMd,
        ),
        hintStyle: AppTextStyles.bodyMedium(color: textTertiary),
        labelStyle: AppTextStyles.bodyMedium(color: textSecondary),
        errorStyle: AppTextStyles.bodySmall(color: AppColors.error),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide(color: borderStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide(color: borderStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: AppDimensions.borderThick,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: AppDimensions.borderThick,
          ),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scaffoldBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: textTertiary,
        selectedLabelStyle: AppTextStyles.labelMedium(color: AppColors.primary),
        unselectedLabelStyle: AppTextStyles.labelMedium(color: textTertiary),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
      ),

      dividerTheme: DividerThemeData(
        color: border,
        thickness: AppDimensions.borderThin,
        space: AppDimensions.spacingLg,
      ),
    );
  }
}
