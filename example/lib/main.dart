import 'package:flutter/material.dart';
import 'package:flutteradform/adform_adinline.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Adform plugin example app'),
        ),
        body: Center(
          child: AdformAdinline(masterTagId: 111111, width: 300, height: 250),
        ),
      ),
    );
  }
}
