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

  //プライバシーポリシーと利用規約の同意用文章の手順的結合モジュール
  static Widget consentProcess(BuildContext context, StatefulWidget page) {
    return Column(
      children: <Widget>[
        consentMessage(context),
        Container(
          height: 16.675,
        ),
        consentButton(context, page),
      ],
    );
  }

  static RichText consentMessage(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          style: Theme.of(context).textTheme.bodyText2,
          children: const [
            TextSpan(
              text: '[同意して登録]をタップすると、',
            ),
            TextSpan(
              text: 'プライバシーポリシー',
              style: TextStyle(color: Colors.green),
            ),
            TextSpan(
              text: 'と',
            ),
            TextSpan(
              text: '利用規約',
              style: TextStyle(color: Colors.green),
            ),
            TextSpan(
              text: 'に同意したことになります。',
            ),
          ]),
    );
  }

  static Container consentButton(BuildContext context, StatefulWidget page) {
    return haveTextButton(
        context, page, 44.7, 225, '同意して登録', Colors.green, Colors.white);
  }

  static Container haveTextButton(
      BuildContext context,
      StatefulWidget page,
      double _height,
      double _width,
      String text,
      Color color,
      Color textColor) {
    return Container(
      height: _height,
      width: _width,
      child: SizedBox(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: color,
            shape: const StadiumBorder(),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          onPressed: () async {
            if(true) {
              await movePage(context, page);
            }
          },
        ),
      ),
    );
  }

}
