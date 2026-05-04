import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsService {
  bool _isAvailable = false;

  AnalyticsService() {
    try {
      _isAvailable = Firebase.apps.isNotEmpty;
    } catch (_) {
      _isAvailable = false;
    }
  }

  Future<void> _logEvent(
    String name, [
    Map<String, Object>? parameters,
  ]) async {
    if (kDebugMode) {
      debugPrint('[Analytics] $name $parameters');
      return;
    }
    if (!_isAvailable) return;

    try {
      await FirebaseAnalytics.instance.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (_) {}
  }

  Future<void> trackBillCreated({
    required int itemCount,
    required double totalAmount,
    required String currency,
    required bool fromOcr,
  }) {
    return _logEvent('bill_created', {
      'item_count': itemCount,
      'total_amount': totalAmount,
      'currency': currency,
      'from_ocr': fromOcr.toString(),
    });
  }

  Future<void> trackBillShared({required String mode}) {
    return _logEvent('bill_shared', {'share_mode': mode});
  }

  Future<void> trackOcrUsed({required bool success}) {
    return _logEvent('ocr_used', {'success': success.toString()});
  }

  Future<void> trackWhatsAppSent() => _logEvent('whatsapp_sent');

  Future<void> trackInsightsViewed() => _logEvent('insights_viewed');

  Future<void> trackAdShown(String adType) {
    return _logEvent('ad_shown', {'ad_type': adType});
  }

  Future<void> trackRemoveAdsTapped() => _logEvent('remove_ads_tapped');

  Future<void> trackAboutOpened() => _logEvent('about_opened');

  Future<void> trackPrivacyViewed() => _logEvent('privacy_viewed');

  Future<void> trackTermsViewed() => _logEvent('terms_viewed');

  Future<void> trackAllDataCleared() => _logEvent('all_data_cleared');

  Future<void> setUserLanguage(String language) async {
    if (kDebugMode || !_isAvailable) return;
    try {
      await FirebaseAnalytics.instance.setUserProperty(
        name: 'language',
        value: language,
      );
    } catch (_) {}
  }

  Future<void> setUserTheme(String theme) async {
    if (kDebugMode || !_isAvailable) return;
    try {
      await FirebaseAnalytics.instance.setUserProperty(
        name: 'theme',
        value: theme,
      );
    } catch (_) {}
  }

  Future<void> setHasPremium(bool hasPremium) async {
    if (kDebugMode || !_isAvailable) return;
    try {
      await FirebaseAnalytics.instance.setUserProperty(
        name: 'has_premium',
        value: hasPremium.toString(),
      );
    } catch (_) {}
  }
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});
