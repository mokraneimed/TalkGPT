import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';

class AdsManager {
  static bool testMode = true;

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-9357850075411810~9836310269";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  static String get interstitialAdUnit {
    if (testMode == true) {
      return AdmobInterstitial.testAdUnitId;
    } else if (Platform.isAndroid) {
      return "ca-app-pub-9357850075411810/6635431851";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }
}
