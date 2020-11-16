import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'dart:async';

class TestPageDynamic extends StatefulWidget {
  final uid;

  const TestPageDynamic({Key key, this.uid}) : super(key: key);
  @override
  _TestPageDynamicState createState() => _TestPageDynamicState();
}

class _TestPageDynamicState extends State<TestPageDynamic> {
  String _linkMessage;
  bool _isCreatingLink = false;
  String _testString =
      "To test: long press link and then copy and click from a non-browser "
      "app. Make sure this isn't being tested on iOS simulator and iOS xcode "
      "is properly setup. Look at firebase_dynamic_links/README.md for more "
      "details.";

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.retrieveDynamicLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print(deepLink.path);
      Navigator.pushNamed(context, deepLink.path);
    }

    // FirebaseDynamicLinks.instance.onLink(
    //     onSuccess: (PendingDynamicLinkData dynamicLink) async {
    //   final Uri deepLink = dynamicLink?.link;

    //   if (deepLink != null) {
    //     Navigator.pushNamed(context, deepLink.path);
    //   }
    // }, onError: (OnLinkErrorException e) async {
    //   print('onLinkError');
    //   print(e.message);
    // });
  }

  Future<void> _createDynamicLink(bool short) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://cx4k7.app.goo.gl',
      link: Uri.parse('https://lineder.page.link/myclients'),
      androidParameters: AndroidParameters(
        packageName: 'io.flutter.plugins.firebasedynamiclinksexample',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
        minimumVersion: '0',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dynamic Links Example'),
        ),
        body: Builder(builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: !_isCreatingLink
                          ? () => _createDynamicLink(false)
                          : null,
                      child: const Text('Get Long Link'),
                    ),
                    RaisedButton(
                      onPressed: !_isCreatingLink
                          ? () => _createDynamicLink(true)
                          : null,
                      child: const Text('Get Short Link'),
                    ),
                  ],
                ),
                InkWell(
                  child: Text(
                    _linkMessage ?? '',
                    style: const TextStyle(color: Colors.blue),
                  ),
                  onTap: () async {
                    if (_linkMessage != null) {
                      await launch(_linkMessage);
                    }
                  },
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: _linkMessage));
                    Scaffold.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied Link!')),
                    );
                  },
                ),
                Text(_linkMessage == null ? '' : _testString)
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _DynamicLinkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hello World DeepLink'),
        ),
        body: const Center(
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}
