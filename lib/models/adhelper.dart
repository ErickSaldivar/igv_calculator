import 'dart:io';

class Adhelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2240957964862139/7655440450';
    } else if (Platform.isIOS) {
      return 'your-ios-banner-ad-unit-id';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
