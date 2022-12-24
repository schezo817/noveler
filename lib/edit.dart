import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'func.dart';

class Edit extends StatefulWidget {
  String title;
  String current;
  String forward;
  String back;
  Function onChangedBody;
  Function onChangedTitle;
  Function onChangedForward;
  Function onChangedBack;

  Edit({
    required this.title,
    required this.current,
    required this.forward,
    required this.back,
    required this.onChangedTitle,
    required this.onChangedBody,
    required this.onChangedForward,
    required this.onChangedBack,
  });

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final _isSelectedTextForm = [true, false, false];
  var _isTrueIndex = 0;

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
          title: Text(widget.title),
          actions: [
            Func.myShare(),
            FutureBuilder(
              future: loadLink(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return TextButton(
                  onPressed: () async {
                    String url = _link;
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      throw 'Unable to launch url $url';
                    }
                  },
                  child: const Text(
                    "投稿",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              ToggleButtons(
                isSelected: _isSelectedTextForm,
                children: const <Widget>[
                  Text("本文"),
                  Text("前書き"),
                  Text("後書き"),
                ],
                onPressed: (index) {
                  setState(() {
                    _isSelectedTextForm[_isTrueIndex] = false;
                    _isSelectedTextForm[index] = !_isSelectedTextForm[index];
                    _isTrueIndex = index;
                  });
                },
              ),
              TextFormField(
                controller: TextEditingController(text: widget.title),
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
                onChanged: (text) {
                  widget.title = text;
                  widget.onChangedTitle(widget.title);
                },
              ),
              const Divider(height: 2),
              _sentenceField(_isTrueIndex),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var sentence = "";
            if (_isTrueIndex == 0) {
              sentence = widget.current;
            }
            if (_isTrueIndex == 1) {
              sentence = widget.forward;
            }
            if (_isTrueIndex == 2) {
              sentence = widget.back;
            }
            await Clipboard.setData(
              ClipboardData(
                text: sentence,
              ),
            );
          },
          child: const Icon(
            Icons.article,
          ),
        ),
      ),
    );
  }

  Widget _sentenceField(int index) {
    if (_isTrueIndex == 0) {
      return Column(
        children: <Widget>[
          Text("文字数:" + widget.current.length.toString()),
          TextFormField(
            controller: TextEditingController(text: widget.current),
            maxLines: 999,
            style: const TextStyle(
              color: Colors.black,
            ),
            onChanged: (text) {
              widget.current = text;
              widget.onChangedBody(widget.current);
            },
          ),
        ],
      );
    }
    if (_isTrueIndex == 1) {
      return Column(
        children: <Widget>[
          Text("文字数:" + widget.forward.length.toString()),
          TextFormField(
            controller: TextEditingController(text: widget.forward),
            maxLines: 999,
            style: const TextStyle(
              color: Colors.black,
            ),
            onChanged: (text) {
              widget.forward = text;
              widget.onChangedForward(widget.forward);
            },
          ),
        ],
      );
    }
    if (_isTrueIndex == 2) {
      return Column(
        children: <Widget>[
          Text("文字数:" + widget.back.length.toString()),
          TextFormField(
            controller: TextEditingController(text: widget.back),
            maxLines: 999,
            style: const TextStyle(
              color: Colors.black,
            ),
            onChanged: (text) {
              widget.back = text;
              widget.onChangedBack(widget.back);
            },
          ),
        ],
      );
    } else {
      return const Text("不具合が発生しました。再起動してください。");
    }
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
}
