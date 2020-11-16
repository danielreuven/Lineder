import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:lineder/loginpage/firstpage.dart';
import 'package:lineder/loginpage/loginpagee.dart';
import 'package:lineder/loginpage/regulation.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

// void main() => runApp(MyApp());
Future<void> main() async {
  Firestore.instance.settings(timestampsInSnapshotsEnabled: true).then((_) {
    print('[Main] Firestore timestamps in snapshots set');
  }, onError: (_) => print('[Main] Error setting timestamps in snapshots'));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({
    Key key,
  }) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // static FirebaseAnalytics analytics = FirebaseAnalytics();
  // static FirebaseAnalyticsObserver observer =
  //     FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    super.initState();
    _setlocalNotification();
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  // Future onSelectNotification(String payload) {
  //   debugPrint("payload : $payload");
  //   Navigator.pushNamed(context, '/');
  //   return null;
  // }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage(
                playload: payload,
              )),
    );
  }

  _setlocalNotification() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings(
        "@mipmap/ic_notification"); //lineder_icons //ic_notification
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (int id, String a, String b, String c) {
      print(id.toString() + " " + a + " " + b + " " + c);
      return null;
    });
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.Max,
            priority: Priority.High,
            ticker: 'ticker',
            style: AndroidNotificationStyle.BigPicture,
            icon: 'Lineder',
            color: Colors.blue);
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await _flutterLocalNotificationsPlugin.show(
            0,
            "Lineder",
            message['notification']['title'] + message['notification']['body'],
            platformChannelSpecifics,
            payload: 'item x');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      onGenerateTitle: (BuildContext context) => "Lineder",

      localizationsDelegates: [
        const DemoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('he'), // Hebrew
        // const Locale('fr'), //France
        // const Locale('ru'), //Russia
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        for (Locale supportedLocale in supportedLocales) {
          // Crashes on the following line
          if (supportedLocale.languageCode == locale.languageCode ||
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }

        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      // navigatorObservers: <NavigatorObserver>[observer],
      theme: ThemeData(
        // appBarTheme: AppBarTheme(
        //     color: Colors.white, iconTheme: IconThemeData(color: Colors.black)),
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (BuildContext context) => FirstPage(),
        '/loginpagee': (BuildContext context) => LoginPage(),
        '/regulation': (BuildContext context) => RegulationApp(),
      },
    );
  }
}
