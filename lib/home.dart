import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'admob.dart';
import 'edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Func.dart';

class Home extends StatefulWidget {
  String novelTitle;

  Home({
    required this.novelTitle,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //本文管理
  List<String> _memoList = [];

  //本文管理のキー
  String memoKey = "memo-list";

  //タイトル管理
  List<String> _titleList = [];

  //タイトル管理のキー
  String titleKey = "title-list";

  //前書き管理
  List<String> _forwardList = [];

  //前書き管理のキー
  String forwardKey = "forward-list";

  //後書き管理
  List<String> _backList = [];

  //後書き管理のキー
  String backKey = "back-list";

  //選ばれたメモのインデックス
  var _currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.novelTitle),
        ),
        body: FutureBuilder(
            future: loadNovelData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var itemCount = _titleList.length * 2;
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
                        key: Key("divider" + i.toString()),
                      );
                    }
                    return Dismissible(
                      background: Container(color: Colors.red),
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          _titleList.removeAt((i / 2).floor());
                          _memoList.removeAt((i / 2).floor());
                          _forwardList.removeAt((i / 2).floor());
                          _backList.removeAt((i / 2).floor());
                          storeList(_memoList, widget.novelTitle + memoKey);
                          storeList(_titleList, widget.novelTitle + titleKey);
                          storeList(
                              _forwardList, widget.novelTitle + forwardKey);
                          storeList(_backList, widget.novelTitle + backKey);
                        });
                      },
                      child: ListTile(
                        title: Text(
                          _titleList[(i / 2).floor()],
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
                            Edit(
                              title: _titleList[_currentIndex],
                              current: _memoList[_currentIndex],
                              forward: _forwardList[_currentIndex],
                              back: _backList[_currentIndex],
                              onChangedTitle: _onChangedTitle,
                              onChangedBody: _onChangedBody,
                              onChangedForward: _onChangedForward,
                              onChangedBack: _onChangedBack,
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
          onPressed: () {
            setState(() {
              _titleList.add("");
              _memoList.add("");
              _forwardList.add("");
              _backList.add("");
              _currentIndex = _titleList.length - 1;
              storeList(_memoList, widget.novelTitle + memoKey);
              storeList(_titleList, widget.novelTitle + titleKey);
              storeList(_forwardList, widget.novelTitle + forwardKey);
              storeList(_backList, widget.novelTitle + backKey);
              Func.movePage(
                context,
                Edit(
                  title: _titleList[_currentIndex],
                  current: _memoList[_currentIndex],
                  forward: _forwardList[_currentIndex],
                  back: _backList[_currentIndex],
                  onChangedTitle: _onChangedTitle,
                  onChangedBody: _onChangedBody,
                  onChangedForward: _onChangedForward,
                  onChangedBack: _onChangedBack,
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
    loadNovelData();
  }

  Future<List<String>> loadNovelData() async {
    await SharedPreferences.getInstance().then((prefs) {
      var key = widget.novelTitle + memoKey;
      var key2 = widget.novelTitle + titleKey;
      var key3 = widget.novelTitle + forwardKey;
      var key4 = widget.novelTitle + backKey;
      if (prefs.containsKey(key)) {
        _memoList = prefs.getStringList(key)!;
      }
      if (prefs.containsKey(key2)) {
        _titleList = prefs.getStringList(key2)!;
      }
      if (prefs.containsKey(key3)) {
        _forwardList = prefs.getStringList(key3)!;
      }
      if (prefs.containsKey(key4)) {
        _backList = prefs.getStringList(key4)!;
      }
    });
    return _memoList;
  }

  void storeList(List<String> textList, String key) async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setStringList(key, textList);
    if (!success) {
      debugPrint("Failed to store value");
    }
  }

  void _onChangedBody(String text) {
    setState(() {
      _memoList[_currentIndex] = text;
      storeList(_memoList, widget.novelTitle + memoKey);
    });
  }

  void _onChangedTitle(String text) {
    setState(() {
      _titleList[_currentIndex] = text;
      storeList(_titleList, widget.novelTitle + titleKey);
    });
  }

  void _onChangedForward(String text) {
    setState(() {
      _forwardList[_currentIndex] = text;
      storeList(_forwardList, widget.novelTitle + forwardKey);
    });
  }

  void _onChangedBack(String text) {
    setState(() {
      _backList[_currentIndex] = text;
      storeList(_backList, widget.novelTitle + backKey);
    });
  }

  Widget _allClearMemo() {
    return IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        setState(() {
          _titleList.clear();
          _memoList.clear();
          _forwardList.clear();
          _backList.clear();
          storeList(_memoList, widget.novelTitle + memoKey);
          storeList(_titleList, widget.novelTitle + titleKey);
          storeList(_forwardList, widget.novelTitle + forwardKey);
          storeList(_backList, widget.novelTitle + backKey);
        });
      },
    );
  }
}
