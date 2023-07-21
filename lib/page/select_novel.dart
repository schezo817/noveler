import 'package:flutter/material.dart';
import 'package:noveler/function/dimensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'posting_button_link_change.dart';
import 'terms_of_service.dart';
import '../function/func.dart';
import 'home.dart';
import '../component/novel_title_dialog.dart';
import 'privacy_policy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectNovel extends ConsumerStatefulWidget {
  @override
  ConsumerState createState() => _SelectNovelState();
}

class _SelectNovelState extends ConsumerState<SelectNovel> {
  //小説タイトルのリスト
  List<String> _novelList = [];

  //小説タイトルのリストのキー
  final novelKey = "novel-list";

  //選ばれたメモのインデックス
  var _currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Noveler"),
        ),
        drawer: Drawer(
          child: setting(context),
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
                  padding: Dimensions.defaultEdge(),
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
                          style: TextStyle(
                            fontSize: Dimensions.normalFont(),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          _currentIndex = (i / 2).floor();
                          Func.movePage(
                            context,
                            Home(novelTitle: _novelList[_currentIndex]),
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadStart();
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

  ListView setting(BuildContext context) {
    return ListView(
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
        ListTile(
          title: TextButton(
            onPressed: () async {
              await Func.movePage(context, PostingButtonLinkChange());
            },
            child: const Text("投稿ボタンのリンク変更"),
          ),
        ),
        ListTile(
          title: TextButton(
            onPressed: () async {
              String url = "https://twitter.com/hiragi_flutter";
              if (await canLaunchUrlString(url)) {
                await launchUrlString(
                  url,
                  mode: LaunchMode.externalApplication,
                );
              }
            },
            child: const Text("作者Twitter"),
          ),
        ),
      ],
    );
  }
}
