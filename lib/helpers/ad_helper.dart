import 'dart:io';

class AdHelper {
  static String get appId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7143569692901327~2223010527';
    } else if (Platform.isIOS) {
      return '###';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7143569692901327/8277282987';
    } else if (Platform.isIOS) {
      return '###';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get testBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7143569692901327/8277282987';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7143569692901327/7368854989';
    } else if (Platform.isIOS) {
      return '###';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get testInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7143569692901327/7368854989';
    } else if (Platform.isIOS) {
      return '###';
    }
    throw UnsupportedError("Unsupported platform");
  }
}
