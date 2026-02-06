import 'dart:io';

enum Environment {
  dev,
  prod,
}

class ConfigVariables {
  static const String isProduction = "isProduction";
  static const String appName = "appName";
  static const String baseUrl = "baseUrl";
  // --- OPTIONAL: admob ---
  static const String admobBannerIdIos = "admobBannerIdIos";
  static const String admobBannerIdAndroid = "admobBannerIdAndroid";
  static const String admobInterstitialIdIos = "admobInterstitialIdIos";
  static const String admobInterstitialIdAndroid = "admobInterstitialIdAndroid";
  // --- END: admob ---
  // --- OPTIONAL: in_app_purchases ---
  static const String revenueCatApiKeyIos = "revenueCatApiKeyIos";
  static const String revenueCatApiKeyAndroid = "revenueCatApiKeyAndroid";
  // --- END: in_app_purchases ---

  static Map<String, dynamic> devVariables = {
    isProduction: false,
    appName: "Skeleton App Dev",
    baseUrl: "http://localhost:3000",
    // --- OPTIONAL: admob ---
    admobBannerIdIos: "ca-app-pub-3940256099942544/2934735716",
    admobBannerIdAndroid: "ca-app-pub-3940256099942544/6300978111",
    admobInterstitialIdIos: "ca-app-pub-3940256099942544/4411468910",
    admobInterstitialIdAndroid: "ca-app-pub-3940256099942544/1033173712",
    // --- END: admob ---
    // --- OPTIONAL: in_app_purchases ---
    revenueCatApiKeyIos: "appl_YOUR_DEV_KEY",
    revenueCatApiKeyAndroid: "goog_YOUR_DEV_KEY",
    // --- END: in_app_purchases ---
  };

  static Map<String, dynamic> prodVariables = {
    isProduction: true,
    appName: "Skeleton App",
    baseUrl: "https://api.example.com",
    // --- OPTIONAL: admob ---
    admobBannerIdIos: "ca-app-pub-XXXXX/YYYYY",
    admobBannerIdAndroid: "ca-app-pub-XXXXX/YYYYY",
    admobInterstitialIdIos: "ca-app-pub-XXXXX/YYYYY",
    admobInterstitialIdAndroid: "ca-app-pub-XXXXX/YYYYY",
    // --- END: admob ---
    // --- OPTIONAL: in_app_purchases ---
    revenueCatApiKeyIos: "appl_YOUR_PROD_KEY",
    revenueCatApiKeyAndroid: "goog_YOUR_PROD_KEY",
    // --- END: in_app_purchases ---
  };
}

class Config {
  static Map<String, dynamic> _config = {};

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.dev:
        _config = ConfigVariables.devVariables;
        break;
      case Environment.prod:
        _config = ConfigVariables.prodVariables;
        break;
    }
  }

  static bool get isProduction => _config[ConfigVariables.isProduction];

  static String get appName => _config[ConfigVariables.appName];

  static String get baseUrl => _config[ConfigVariables.baseUrl];

  // --- OPTIONAL: admob ---
  static String get admobBannerId {
    if (Platform.isIOS) {
      return _config[ConfigVariables.admobBannerIdIos];
    } else {
      return _config[ConfigVariables.admobBannerIdAndroid];
    }
  }

  static String get admobInterstitialId {
    if (Platform.isIOS) {
      return _config[ConfigVariables.admobInterstitialIdIos];
    } else {
      return _config[ConfigVariables.admobInterstitialIdAndroid];
    }
  }
  // --- END: admob ---

  // --- OPTIONAL: in_app_purchases ---
  static String get revenueCatApiKey {
    if (Platform.isIOS) {
      return _config[ConfigVariables.revenueCatApiKeyIos];
    } else {
      return _config[ConfigVariables.revenueCatApiKeyAndroid];
    }
  }
  // --- END: in_app_purchases ---
}
