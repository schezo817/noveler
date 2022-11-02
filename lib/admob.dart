import 'dart:io';
import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';

class AdMobService {
  static String getBannerAdUnitId() {
    // iOSとAndroidで広告ユニットIDを分岐させる
    if (Platform.isAndroid) {
      // Androidの広告ユニットID
      return 'ca-app-pub-3375813374638211/7971488896';
    } else if (Platform.isIOS) {
      // iOSの広告ユニットID
      return 'ca-app-pub-3375813374638211/2646762603';
    }
    return '';
  }

  // 表示するバナー広告の高さを計算
  static double getHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final percent = (height * 0.06).toDouble();
    return percent;
  }

  static AdmobBanner myAdmobBanner(BuildContext context) {
    return AdmobBanner(
      adUnitId: getBannerAdUnitId(),
      adSize: AdmobBannerSize(
        width: MediaQuery.of(context).size.width.toInt(),
        height: getHeight(context).toInt(),
        name: 'SMART_BANNER',
      ),
    );
  }
}
