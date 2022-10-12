import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:noveler/terms_of_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admob.dart';
import 'func.dart';
import 'home.dart';
import 'novel_title_dialog.dart';
import 'terms_of_service.dart';
import 'privacy_policy.dart';
import 'consent.dart';

class SelectNovel extends StatefulWidget {
  @override
  _SelectNovelState createState() => _SelectNovelState();
}

class _SelectNovelState extends State<SelectNovel> {
  //小説タイトルのリスト
  List<String> _novelList = [];

  bool _consent = false;

  //選ばれたメモのインデックス
  var _currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    var itemCount = _novelList.length * 2;
    if (itemCount < 0) {
      itemCount = 0;
    }
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Noveler"),
          actions: [
            // _allClearMemo(),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Text("設定"),
              ),
              ListTile(
                title: TextButton(
                  onPressed: () async {
                    await Func.movePage(context, TermsOfService());
                  },
                  child: Text("利用規約"),
                ),
              ),
              ListTile(
                title: TextButton(
                  onPressed: () async {
                    await Func.movePage(context, PrivacyPolicy());
                  },
                  child: Text("プライバシーポリシー"),
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
        body: ListView.builder(
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
                  storeList(_novelList, "novel-list");
                });
              },
              child: ListTile(
                title: Text(
                  _novelList[(i / 2).floor()],
                  style: TextStyle(
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String? _novelTitle = await showDialog<String>(
              context: context,
              builder: (context) {
                return NovelTitleDialog(text: '');
              },
            );
            setState(() {
              _novelList.add(_novelTitle!);
              _currentIndex = _novelList.length - 1;
              storeList(_novelList, "novel-list");
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
        bottomNavigationBar: AdmobBanner(
          adUnitId: AdMobService().getBannerAdUnitId(),
          adSize: AdmobBannerSize(
            width: MediaQuery.of(context).size.width.toInt(),
            height: AdMobService().getHeight(context).toInt(),
            name: 'SMART_BANNER',
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      const key = "novel-list";
      const key2 = "consent";
      if (prefs.containsKey(key)) {
        _novelList = prefs.getStringList(key)!;
      }
      if (prefs.containsKey(key2)) {
        _consent = prefs.getBool(key2)!;
        if (!_consent) {
          Func.movePage(context, Consent());
          _consent = true;
          storeBoolean(_consent, key2);
        }
      }
    });
  }

  void storeList(List<String> textList, String key) async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setStringList(key, textList);
    if (!success) {
      debugPrint("Failed to store value");
    }
  }

  void storeBoolean(bool b, String key) async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setBool(key, b);
    if (!success) {
      debugPrint("Failed to store value");
    }
  }

  Widget _allClearMemo() {
    return IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        setState(() {
          _novelList.clear();
          storeList(_novelList, "novel-list");
        });
      },
    );
  }
}
