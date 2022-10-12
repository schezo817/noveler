import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'func.dart';
import 'select_novel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Noveler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SelectNovel(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
            onPressed: () {
              Func.movePage(context, SelectNovel());
            },
            child: Text("Next"),
          ),
      ),
    );
  }
}
