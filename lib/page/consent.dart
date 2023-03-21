import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../function/dimensions.dart';
import '../function/func.dart';
import 'privacy_policy.dart';
import 'select_novel.dart';
import 'terms_of_service.dart';

class Consent extends ConsumerWidget {
  //利用規約とプライバシーポリシーに同意済みかどうかを管理する変数
  bool _consent = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: FutureBuilder(
            future: loadStart(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              //一度同意済みならこの画面をパス
              if (_consent) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) {
                    Func.movePage(context, SelectNovel());
                  },
                );
              }
              return Container(
                alignment: Alignment.center,
                padding: Dimensions.defaultEdge(),
                child: consentProcess(context, SelectNovel()),
              );
            }),
      ),
    );
  }

  //ストレージ内の変数の読み込み
  Future<bool> loadStart() async {
    await SharedPreferences.getInstance().then(
      (prefs) {
        const key = "consent";
        if (prefs.containsKey(key)) {
          _consent = prefs.getBool(key)!;
        }
      },
    );
    return _consent;
  }

  //プライバシーポリシーと利用規約の同意用文章と同意ボタンの手順的結合モジュール
  static Widget consentProcess(BuildContext context, Widget page) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        consentMessage(context),
        Container(
          height: Dimensions.midHeight(),
        ),
        consentButton(context, page),
      ],
    );
  }

  //プライバシーポリシーと利用規約の同意用文章
  static RichText consentMessage(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          const TextSpan(
            text: '[同意して開始]をタップすると、',
          ),
          TextSpan(
            text: 'プライバシーポリシー',
            style: const TextStyle(color: Colors.green),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Func.movePage(context, PrivacyPolicy());
              },
          ),
          const TextSpan(
            text: 'と',
          ),
          TextSpan(
            text: '利用規約',
            style: const TextStyle(color: Colors.green),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Func.movePage(context, TermsOfService());
              },
          ),
          const TextSpan(
            text: 'に同意したことになります。',
          ),
        ],
      ),
    );
  }

  //同意ボタン
  static SizedBox consentButton(BuildContext context, Widget page) {
    return haveTextButton(context, page, Dimensions.midHeight() * 2,
        Dimensions.midWidth(), '同意して開始', Colors.green, Colors.white);
  }

  //文章を持つ遷移ボタン
  static SizedBox haveTextButton(
      BuildContext context,
      Widget page,
      double _height,
      double _width,
      String text,
      Color color,
      Color textColor) {
    return SizedBox(
      height: _height,
      width: _width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: const StadiumBorder(),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: Dimensions.bigFont(),
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          final success = await prefs.setBool("consent", true);
          if (!success) {
            debugPrint("Failed to store value");
          }
          await Func.movePage(context, page);
        },
      ),
    );
  }
}
