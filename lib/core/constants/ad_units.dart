import 'dart:io';

import 'package:flutter/foundation.dart';

class AdUnits {
  AdUnits._();

  static const bool _useTestAds = kDebugMode;

  static const String _testBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testBannerIos =
      'ca-app-pub-3940256099942544/2934735716';
  static const String _testInterstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testInterstitialIos =
      'ca-app-pub-3940256099942544/4411468910';
  static const String _testRewardedAndroid =
      'ca-app-pub-3940256099942544/5224354917';
  static const String _testRewardedIos =
      'ca-app-pub-3940256099942544/1712485313';

  static const String _prodBannerAndroid =
      'ca-app-pub-3962967753864866/2699308381';
  static const String _prodInterstitialAndroid =
      'ca-app-pub-3962967753864866/2643468063';
  static const String _prodRewardedAndroid =
      'ca-app-pub-3962967753864866/5133900035';

  static String get banner {
    if (Platform.isIOS) return _testBannerIos;
    if (_useTestAds) return _testBannerAndroid;
    return _prodBannerAndroid;
  }

  static String get interstitial {
    if (Platform.isIOS) return _testInterstitialIos;
    if (_useTestAds) return _testInterstitialAndroid;
    return _prodInterstitialAndroid;
  }

  static String get rewarded {
    if (Platform.isIOS) return _testRewardedIos;
    if (_useTestAds) return _testRewardedAndroid;
    return _prodRewardedAndroid;
  }
}
