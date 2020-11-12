import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'dart:io';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription _intentDataStreamSubscription;
  String _sharedText;

  @override
  void initState() {
    super.initState();

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) async {
      setState(() {
        _sharedText = value;
        print("Shared: $_sharedText");
      });
      final taskid = await FlutterDownloader.enqueue(
              url:
                  'https://codeload.github.com/sudonims/c-file-manager/zip/master',
              savedDir: '/sdcard/',
              showNotification: true)
          .then((value) => print("Start"));
      // final tasks = await FlutterDownloader.loadTasks();
      // print("Download");
      // awaitf
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) async {
      setState(() {
        _sharedText = value;
        print("Shared: $_sharedText");
      });
      final taskid = await FlutterDownloader.enqueue(
              url:
                  'https://codeload.github.com/sudonims/c-file-manager/zip/master',
              savedDir: '/sdcard/Download/',
              showNotification: true)
          .then((value) => print("object"));
      // final tasks = await FlutterDownloader.loadTasks();
      // print("Download");
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyleBold = const TextStyle(fontWeight: FontWeight.bold);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 100),
              Text("Shared urls/text:", style: textStyleBold),
              Text(_sharedText ?? "")
            ],
          ),
        ),
      ),
    );
  }
}
