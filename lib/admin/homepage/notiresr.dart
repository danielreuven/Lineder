import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


class NotifTest extends StatefulWidget {
  final uid;
  NotifTest({this.uid});
  @override
  _NotifTestState createState() => _NotifTestState();
}

class _NotifTestState extends State<NotifTest> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
    String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";
  @override
  void initState() {
    super.initState();
    firemessing();
    notitite();
  }

  void firemessing() {
    if (Platform.isIOS) iOS_Permission();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: ListTile(
                  title: Text(message['notification']['title']),
                  subtitle: Text(message['notification']['body']),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  void iOS_Permission() {
    _fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void notitite(){
     _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onResume: $message");
      },
    );
    _fcm.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _fcm.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _fcm.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });
  }

  _saveDeviceToken() async {
    // Get the current user
    // String uid = 'jeffd23';
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = Firestore.instance
          .collection('AdminUsers')
          .document(widget.uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("noti"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                 
                },
                child: Text(_homeScreenText),
              ),
              FlatButton(
                onPressed: () {
                  _saveDeviceToken();
                },
                child: Text(_messageText),
              ),
              FlatButton(
                child: Text('I like puppies'),
                onPressed: () => _fcm.subscribeToTopic('puppies'),
              ),
              FlatButton(
                child: Text('I hate puppies'),
                onPressed: () => _fcm.unsubscribeFromTopic('puppies'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
