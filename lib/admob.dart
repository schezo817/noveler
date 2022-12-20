import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  /*
  static String getBannerAdUnitId() {
    // iOSとAndroidで広告ユニットIDを分岐させる
    if (Platform.isAndroid) {
      // Androidの広告ユニットID
      return 'ca-app-pub-3375813374638211/7971488896';
    } else if (Platform.isIOS) {
      // iOSの広告ユニットID
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    return '';
  }

  // 表示するバナー広告の高さを計算
  static double getHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final percent = (height * 0.06).toDouble();
    return percent;
  }

   */

  final BannerAd myBanner = BannerAd(
    //Release ANDROID :ca-app-pub-3375813374638211/7971488896
    //Release IOS : ca-app-pub-3375813374638211/2646762603
    adUnitId: Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) => print('バナー広告がロードされました'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('バナー広告の読み込みが次の理由で失敗しました: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('バナー広告が開かれました'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('バナー広告が閉じられました'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    ),
  );
}
