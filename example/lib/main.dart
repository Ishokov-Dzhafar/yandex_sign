import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:yandex_sign/yandex_sign.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _signUrl = 'Unknown';


  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String signUrl;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final url = 'yandexnavi://build_route_on_map?lat_to=55.70500&lon_to=37.587200&client=007';
      final androidKey = '''-----BEGIN RSA PRIVATE KEY-----
MIIBOgIBAAJBALUwoxjKUZtMiFPe1K4XAPDYZCX1b6wOM8UXeGS5EbsJe/h12VM1
asx9rtVXJ1Kwhb1N7KcSFc1l9wl2gqe1f8cCAwEAAQJAGV0Dl7bKkai29LaeovgJ
Y62G52FiDn22dYKBkefuOXYwFBSD6+pbHby3m5oBEy51aZJ+QQBIv+RjHN1h1aUQ
8QIhAN9hr9dxgzKYw8FUQBZ4qgd6hRSjb/ryfjgiF5qPt2FbAiEAz6XFDvwkbwE5
FLrO8MigLVXuEuhiCsbkwn8aobBUGwUCIBGlTNeu/tcrXCNUfW+I/p1ynzqfIoRn
TXMvtj+eZLULAiB/n4s2YpKiB0ZmD0sRgr2wH5hr1pgrt4LyZ9yedBm9YQIhAMIB
oRxLAAcDDIlC6vDrYk94nCT0OQ6ZH2YK3rxu8iyy
-----END RSA PRIVATE KEY-----
''';
      final iosNameOfDerFile = 'private_key';
      signUrl = await YandexSign.getSignUrl(url, androidKey, iosNameOfDerFile);
    } on PlatformException {
      signUrl = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _signUrl = signUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_signUrl\n'),
        ),
      ),
    );
  }
}
