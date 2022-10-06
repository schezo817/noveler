import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class Func {
  //共有機能のための関数
  static void _share() => Share.share('みんなも小説を書こう!', subject: '便利な小説管理ツール');

  static Widget myShare() {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: () => _share(),
    );
  }

  //Appbarの共通のための関数
  static PreferredSizeWidget? myAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.blue,
      iconTheme: IconThemeData(
        color: Colors.blue,
      ),
      //共有(share)のボタン
      actions: [
        myShare(),
      ],
    );
  }

//ページ遷移のための関数
  static Future movePage(BuildContext context, var pages) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => pages,
      ),
    );
  }
}
