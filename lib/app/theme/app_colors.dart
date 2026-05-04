import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF00C896);
  static const Color primaryDark = Color(0xFF00A87C);
  static const Color primaryLight = Color(0xFF4DDBB0);
  static const Color primarySoft = Color(0xFFB8F5DD);

  static const Color secondary = Color(0xFFFF6B6B);
  static const Color secondaryDark = Color(0xFFE54B4B);
  static const Color secondaryLight = Color(0xFFFF9999);

  static const Color accent = Color(0xFFFFD93D);
  static const Color accentDark = Color(0xFFE6BD24);

  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF0FDF9);
  static const Color lightSurfaceVariant = Color(0xFFE6F7F1);

  static const Color lightTextPrimary = Color(0xFF1A2E2A);
  static const Color lightTextSecondary = Color(0xFF5A6B66);
  static const Color lightTextTertiary = Color(0xFF8FA199);

  static const Color lightBorder = Color(0x141A2E2A);
  static const Color lightBorderStrong = Color(0x241A2E2A);

  static const Color darkBackground = Color(0xFF0F1A17);
  static const Color darkSurface = Color(0xFF1A2E2A);
  static const Color darkSurfaceVariant = Color(0xFF243832);

  static const Color darkTextPrimary = Color(0xFFF0FDF9);
  static const Color darkTextSecondary = Color(0xFFB4C5BD);
  static const Color darkTextTertiary = Color(0xFF7A8B85);

  static const Color darkBorder = Color(0x14F0FDF9);
  static const Color darkBorderStrong = Color(0x24F0FDF9);

  static const Color success = Color(0xFF00C896);
  static const Color error = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFFD93D);
  static const Color info = Color(0xFF5DADE2);

  static const List<Color> peopleColors = [
    Color(0xFF00C896),
    Color(0xFFFF6B6B),
    Color(0xFFFFD93D),
    Color(0xFF4DDBB0),
    Color(0xFFFF9999),
    Color(0xFF5DADE2),
  ];

  static Color avatarColorForIndex(int index) {
    return peopleColors[index % peopleColors.length];
  }
}
