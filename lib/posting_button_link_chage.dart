import 'package:flutter/material.dart';
import 'package:noveler/select_novel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Func.dart';

class PostingButtonLinkChange extends StatefulWidget {
  @override
  _PostingButtonLinkChangeState createState() =>
      _PostingButtonLinkChangeState();
}

class _PostingButtonLinkChangeState extends State<PostingButtonLinkChange> {
  //投稿ボタンのリンク
  String _link = "";

  //投稿ボタンのリンクのキー
  final linkKey = "link";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("投稿ボタンのリンク変更"),
          actions: [
            TextButton(
              onPressed: () async {
                _onChangedLink("https://syosetu.com");
              },
              child: const Text(
                "初期化",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: FutureBuilder(
            future: loadLink(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    const Text("更新する投稿リンクを入力"),
                    TextFormField(
                      controller: TextEditingController(text: _link),
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      onChanged: (text) {
                        _link = text;
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        "保存",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        _onChangedLink(_link);
                        await Func.movePage(context, SelectNovel());
                      },
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadLink();
  }

  Future<String> loadLink() async {
    await SharedPreferences.getInstance().then(
      (prefs) {
        if (prefs.containsKey(linkKey)) {
          _link = prefs.getString(linkKey)!;
        }
      },
    );
    return _link;
  }

  void storeString(String text, String key) async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setString(key, text);
    if (!success) {
      debugPrint("Failed to store value");
    }
  }

  void _onChangedLink(String text) {
    setState(() {
      _link = text;
      storeString(_link, linkKey);
    });
  }
}
