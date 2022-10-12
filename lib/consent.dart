import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'admob.dart';
import 'func.dart';
import 'select_novel.dart';

class Consent extends StatefulWidget {
  @override
  _ConsentState createState() => _ConsentState();
}

class _ConsentState extends State<Consent> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("同意画面"),
        ),
        body: SingleChildScrollView(
          child: Func.consentProcess(context, SelectNovel()),
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
}