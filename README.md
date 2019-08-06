# yandex_sign

Flutter plugin for yandex map sign and yandex navigator sign.

__Disclaimer__: This project uses Yandex sign algorithm which discribed 
in [commercial_use_signature_navigator](https://yandex.ru/dev/yandex-apps-launch/navigator/doc/concepts/navigator-commercial-use-signature-docpage/)
and [commercial_use_signature_yandexmaps](https://yandex.ru/dev/yandex-apps-launch/maps/doc/concepts/yandexmaps-commercial-use-signature-docpage/)

## Getting Started

### Generate your API Key

Get key and client Id from [yandex_navigator](https://yandex.ru/dev/yandex-apps-launch/navigator/doc/concepts/navigator-commercial-use-signature-docpage/) or [yandexmaps](https://yandex.ru/dev/yandex-apps-launch/maps/doc/concepts/yandexmaps-commercial-use-signature-docpage/)

### Initilazing for IOS
1. Convert key.pem file to key.der file with openssl `$ openssl rsa -in key.pem -out key.der -outform DER`
2. Add file key.der to ios project Bundle [example](https://stackoverflow.com/questions/10247680/adding-resource-files-to-xcode)


### Initilazing for Android
1. Get String(base64) from file key.pem
2. Add to local variable for flutter project like in example

### Usage

Example:

```dart
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

  Future<void> initPlatformState() async {
    String signUrl;
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
      //Sign url for both android & ios with key
      signUrl = await YandexSign.getSignUrl(url, androidKey, iosNameOfDerFile);
    } on PlatformException {
      signUrl = 'Failed to get platform version.';
    }
    
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
```

For more info see example

### Features

- [X] iOS Support
- [X] Android Support
