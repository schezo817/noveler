import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'admob.dart';
import 'edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Func.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //本文管理
  List<String> _memoList = [];

  //タイトル管理
  List<String> _titleList = [];

  //前書き管理
  List<String> _forwardList = [];

  //後書き管理
  List<String> _backList = [];

  //選ばれたメモのインデックス
  var _currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    var itemCount = _titleList.length * 2;
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
            _allClearMemo(),
          ],
        ),
        body: ListView.builder(
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
                  storeList(_memoList, "memo-list");
                  storeList(_titleList, "title-list");
                  storeList(_forwardList, "forward-list");
                  storeList(_backList, "back-list");
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _titleList.add("");
              _memoList.add("");
              _forwardList.add("");
              _backList.add("");
              _currentIndex = _titleList.length - 1;
              storeList(_memoList, "memo-list");
              storeList(_titleList, "title-list");
              storeList(_forwardList, "forward-list");
              storeList(_backList, "back-list");
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
    SharedPreferences.getInstance().then((prefs) {
      const key = "memo-list";
      const key2 = "title-list";
      const key3 = "forward-list";
      const key4 = "back-list";
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
      storeList(_memoList, "memo-list");
    });
  }

  void _onChangedTitle(String text) {
    setState(() {
      _titleList[_currentIndex] = text;
      storeList(_titleList, "title-list");
    });
  }

  void _onChangedForward(String text) {
    setState(() {
      _forwardList[_currentIndex] = text;
      storeList(_forwardList, "forward-list");
    });
  }

  void _onChangedBack(String text) {
    setState(() {
      _backList[_currentIndex] = text;
      storeList(_backList, "back-list");
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
          storeList(_memoList, "memo-list");
          storeList(_titleList, "title-list");
          storeList(_forwardList, "forward-list");
          storeList(_backList, "back-list");
        });
      },
    );
  }
}
