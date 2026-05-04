import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CrashlyticsService {
  bool _isAvailable = false;

  CrashlyticsService() {
    try {
      _isAvailable = Firebase.apps.isNotEmpty;
    } catch (_) {
      _isAvailable = false;
    }
  }

  Future<void> logError(
    Object error,
    StackTrace? stack, {
    String? reason,
    Map<String, Object?>? extras,
  }) async {
    if (kDebugMode) {
      debugPrint('[Crashlytics] error: $error');
      if (reason != null) debugPrint('  reason: $reason');
      if (extras != null) debugPrint('  extras: $extras');
      if (stack != null) debugPrint('  stack: $stack');
      return;
    }

    if (!_isAvailable) return;

    try {
      if (extras != null) {
        for (final entry in extras.entries) {
          await FirebaseCrashlytics.instance.setCustomKey(
            entry.key,
            (entry.value ?? '').toString(),
          );
        }
      }

      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason: reason,
        fatal: false,
      );
    } catch (_) {
    }
  }

  Future<void> log(String message) async {
    if (kDebugMode) {
      debugPrint('[Crashlytics] log: $message');
      return;
    }
    if (!_isAvailable) return;

    try {
      await FirebaseCrashlytics.instance.log(message);
    } catch (_) {}
  }
}

final crashlyticsServiceProvider = Provider<CrashlyticsService>((ref) {
  return CrashlyticsService();
});
