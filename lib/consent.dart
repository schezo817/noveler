import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admob.dart';
import 'func.dart';
import 'privacy_policy.dart';
import 'select_novel.dart';
import 'terms_of_service.dart';

class Consent extends StatefulWidget {
  @override
  _ConsentState createState() => _ConsentState();
}

class _ConsentState extends State<Consent> {
  bool _consent = false;

  @override
  Widget build(BuildContext context) {
    if (_consent) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Func.movePage(context, SelectNovel());
      });
    }
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("同意画面"),
        ),
        body: Center(
          child: consentProcess(context, SelectNovel()),
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
    loadStart();
  }

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
        children: [
          TextSpan(
            text: '[同意して利用]をタップすると、',
          ),
          TextSpan(
            text: 'プライバシーポリシー',
            style: TextStyle(color: Colors.green),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Func.movePage(context, PrivacyPolicy());
              },
          ),
          TextSpan(
            text: 'と',
          ),
          TextSpan(
            text: '利用規約',
            style: TextStyle(color: Colors.green),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Func.movePage(context, TermsOfService());
              },
          ),
          TextSpan(
            text: 'に同意したことになります。',
          ),
        ],
      ),
    );
  }

  static Container consentButton(BuildContext context, StatefulWidget page) {
    return haveTextButton(
        context, page, 44.7, 225, '同意して利用', Colors.green, Colors.white);
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
            final prefs = await SharedPreferences.getInstance();
            final success = await prefs.setBool("consent", true);
            if (!success) {
              debugPrint("Failed to store value");
            }
            await Func.movePage(context, page);
          },
        ),
      ),
    );
  }
}
