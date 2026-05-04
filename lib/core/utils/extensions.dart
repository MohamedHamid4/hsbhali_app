import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => theme.colorScheme;

  TextTheme get textStyles => theme.textTheme;

  bool get isDark => theme.brightness == Brightness.dark;

  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  void unfocus() => FocusScope.of(this).unfocus();
}

extension StringX on String {
  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => trim().isNotEmpty;

  bool get isValidEmail {
    final regex = RegExp(r'^[\w\.-]+@[\w-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(trim());
  }

  bool get isValidEgyptianPhone {
    final regex = RegExp(r'^01[0125]\d{8}$');
    return regex.hasMatch(trim());
  }

  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

extension DateTimeX on DateTime {
  String get formattedArabic => DateFormat('d MMMM yyyy', 'ar_EG').format(this);

  String get formattedWithTime =>
      DateFormat('d MMMM yyyy - hh:mm a', 'ar_EG').format(this);

  String get timeOnly => DateFormat('hh:mm a', 'ar_EG').format(this);

  String get shortDate => DateFormat('d/M/yyyy').format(this);

  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inSeconds < 60) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} يوم';
    return formattedArabic;
  }
}
