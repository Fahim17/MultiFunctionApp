import 'package:flutter/material.dart';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

class WView extends StatefulWidget {
  WView({Key? key}) : super(key: key);

  @override
  _WViewState createState() => _WViewState();
}

class _WViewState extends State<WView> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Web View"),
      ),
      body: const WebView(
        initialUrl: 'https://en.wikipedia.org/wiki/Blackbeard',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
