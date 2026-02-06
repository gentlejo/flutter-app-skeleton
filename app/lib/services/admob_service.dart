import 'dart:ui';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:skeleton_app/common/config.dart';

/// AdMob service for managing ads.
///
/// Singleton with private constructor pattern.
class AdmobService {
  static final AdmobService _instance = AdmobService._internal();
  AdmobService._internal();
  static AdmobService get instance => _instance;

  InterstitialAd? _interstitialAd;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    print('[AdmobService] Initialized');
  }

  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: Config.admobInterstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          print('[AdmobService] Interstitial ad loaded');
        },
        onAdFailedToLoad: (error) {
          print('[AdmobService] Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onDismissed}) {
    if (_interstitialAd == null) {
      onDismissed?.call();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        onDismissed?.call();
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        onDismissed?.call();
      },
    );

    _interstitialAd!.show();
  }
}
