import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../app/providers/preferences_provider.dart';
import '../constants/ad_units.dart';
import 'analytics_service.dart';
import 'preferences_service.dart';

class AdsService {
  final PreferencesService _prefs;
  final AnalyticsService? _analytics;

  static const String _billsCountKey = 'ads_bills_saved_count';
  static const String _adsRemovedKey = 'ads_removed';
  static const int _interstitialFrequency = 3;

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isInterstitialLoading = false;
  bool _isRewardedLoading = false;

  AdsService(this._prefs, {AnalyticsService? analytics})
      : _analytics = analytics;

  static const List<String> _testDeviceIds = [
    'A580BFD157CF5721DE6E17D7129EBE58',
  ];

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: _testDeviceIds),
    );
  }

  bool get areAdsRemoved => _prefs.getBool(_adsRemovedKey) ?? false;

  Future<void> setAdsRemoved(bool removed) async {
    await _prefs.setBool(_adsRemovedKey, removed);
  }

  Future<void> onBillSaved() async {
    if (areAdsRemoved) return;

    final count = (_prefs.getInt(_billsCountKey) ?? 0) + 1;
    await _prefs.setInt(_billsCountKey, count);

    if (count % _interstitialFrequency == 0) {
      await _showInterstitial();
    } else {
      _loadInterstitial();
    }
  }

  void _loadInterstitial() {
    if (_isInterstitialLoading || _interstitialAd != null) return;
    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId: AdUnits.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isInterstitialLoading = false;
        },
      ),
    );
  }

  Future<void> _showInterstitial() async {
    if (_interstitialAd == null) {
      _loadInterstitial();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) {
        _analytics?.trackAdShown('interstitial');
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
      },
    );

    await _interstitialAd!.show();
  }

  Future<bool> showRewardedAd() async {
    if (areAdsRemoved) return true;

    if (_rewardedAd == null) {
      await _loadRewardedAndWait();
    }

    if (_rewardedAd == null) return false;

    bool earnedReward = false;
    final completer = Completer<bool>();

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) {
        _analytics?.trackAdShown('rewarded');
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewarded();
        if (!completer.isCompleted) completer.complete(earnedReward);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    await _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      earnedReward = true;
    });

    return completer.future;
  }

  void _loadRewarded() {
    if (_isRewardedLoading || _rewardedAd != null) return;
    _isRewardedLoading = true;

    RewardedAd.load(
      adUnitId: AdUnits.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoading = false;
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _isRewardedLoading = false;
        },
      ),
    );
  }

  Future<void> _loadRewardedAndWait() async {
    _loadRewarded();
    int attempts = 0;
    while (_isRewardedLoading && attempts < 50) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}

final adsServiceProvider = Provider<AdsService>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  return AdsService(prefs);
});
