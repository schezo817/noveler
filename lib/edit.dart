import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'func.dart';
import 'Home.dart';

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
  var _isSelectedTextForm = [true, false, false];
  var _isTrueindex = 0;

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
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
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
                      _isSelectedTextForm[_isTrueindex] = false;
                      _isSelectedTextForm[index] = !_isSelectedTextForm[index];
                      _isTrueindex = index;
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
                _sentenceField(_isTrueindex),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var sentence = "";
            if(_isTrueindex ==0){
              sentence = widget.current;
            }
            if(_isTrueindex == 1){
              sentence = widget.forward;
            }
            if(_isTrueindex == 2){
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
    if (_isTrueindex == 0) {
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
    if (_isTrueindex == 1) {
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
    if (_isTrueindex == 2) {
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
      return Text("不具合が発生しました。再起動してください。");
    }
  }
}
