import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:simple_permissions/simple_permissions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      // debug: true // optional: set false to disable printing logs to console
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

  Future<bool> _checkPermission() async {
    final status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

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
      final a = await _checkPermission();
      final downloadsDirectory = new Directory("storage/emulated/0/Lol");
      // print(downloadsDirectory.path);
      if ((await downloadsDirectory.exists())) {
        print("exist");
      } else {
        print("not exist");
        await downloadsDirectory.create(recursive: true);
      }
      final taskid = await FlutterDownloader.enqueue(
              url: 'https://ytdl-backend-lol.herokuapp.com/9em32dDnTck',
              savedDir: downloadsDirectory.path,
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
      final a = await _checkPermission();
      final downloadsDirectory = new Directory("storage/emulated/0/Lol");
      // print(downloadsDirectory.downloadsDirectory);
      if ((await downloadsDirectory.exists())) {
        print("exist");
      } else {
        print("not exist");
        await downloadsDirectory.create(recursive: true);
      }
      print(downloadsDirectory.path);
      final taskid = await FlutterDownloader.enqueue(
              url: 'https://ytdl-backend-lol.herokuapp.com/9em32dDnTck',
              savedDir: downloadsDirectory.path,
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
          title: const Text('Not Youtube-dl'),
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
