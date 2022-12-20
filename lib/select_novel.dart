import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:noveler/terms_of_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admob.dart';
import 'func.dart';
import 'home.dart';
import 'novel_title_dialog.dart';
import 'terms_of_service.dart';
import 'privacy_policy.dart';

class SelectNovel extends StatefulWidget {
  @override
  _SelectNovelState createState() => _SelectNovelState();
}

class _SelectNovelState extends State<SelectNovel> {
  //小説タイトルのリスト
  List<String> _novelList = [];

  //小説タイトルのリストのキー
  final novelKey = "novel-list";

  //選ばれたメモのインデックス
  var _currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    final AdWidget adWidget = AdWidget(ad: myBanner);
    final Container adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Noveler"),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              const DrawerHeader(
                child: Text("設定"),
              ),
              ListTile(
                title: TextButton(
                  onPressed: () async {
                    await Func.movePage(context, TermsOfService());
                  },
                  child: const Text("利用規約"),
                ),
              ),
              ListTile(
                title: TextButton(
                  onPressed: () async {
                    await Func.movePage(context, PrivacyPolicy());
                  },
                  child: const Text("プライバシーポリシー"),
                ),
              ),
              /*
              ListTile(
                title: TextButton(
                  onPressed: () async {
                    await Func.movePage(
                      context,
                    );
                  },
                  child: Text("投稿ボタンのリンク変更"),
                ),
              ),

               */
            ],
          ),
        ),
        body: FutureBuilder(
            future: loadStart(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var itemCount = _novelList.length * 2;
                if (itemCount < 0) {
                  itemCount = 0;
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: itemCount,
                  itemBuilder: (context, i) {
                    if (i.isOdd) {
                      return Divider(
                        height: 2,
                        key: Key("NovelerDivider" + i.toString()),
                      );
                    }
                    return Dismissible(
                      background: Container(color: Colors.red),
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          _novelList.removeAt((i / 2).floor());
                          storeList(_novelList, novelKey);
                        });
                      },
                      child: ListTile(
                        title: Text(
                          _novelList[(i / 2).floor()],
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          _currentIndex = (i / 2).floor();
                          Func.movePage(
                            context,
                            Home(
                              novelTitle: _novelList[_currentIndex],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("loading..."),
                );
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String? _novelTitle = await showDialog<String>(
              context: context,
              builder: (context) {
                return const NovelTitleDialog(text: '');
              },
            );
            setState(() {
              _novelList.add(_novelTitle!);
              _currentIndex = _novelList.length - 1;
              storeList(_novelList, novelKey);
              Func.movePage(
                context,
                Home(
                  novelTitle: _novelList[_currentIndex],
                ),
              );
            });
          },
          child: const Icon(
            Icons.add,
          ),
        ),
        bottomNavigationBar: adContainer,
      ),
    );
  }

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

  @override
  void initState() {
    super.initState();
    loadStart();
    myBanner.load();
  }

  @override
  void dispose() {
    super.dispose();
    myBanner.dispose();
  }

  Future<List<String>> loadStart() async {
    await SharedPreferences.getInstance().then(
      (prefs) {
        if (prefs.containsKey(novelKey)) {
          _novelList = prefs.getStringList(novelKey)!;
        }
      },
    );
    return _novelList;
  }

  void storeList(List<String> textList, String key) async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setStringList(key, textList);
    if (!success) {
      debugPrint("Failed to store value");
    }
  }

}
