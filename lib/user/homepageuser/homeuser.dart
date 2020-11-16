import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:intl/intl.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:lineder/user/homepageuser/myfollowers.dart';
import 'package:lineder/user/propile/lineList.dart';
import 'package:lineder/user/propile/requestClients.dart';
import 'package:lineder/user/propile/requestList.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeUser extends StatefulWidget {
  final uid;
  final photo;
  final name;

  HomeUser({this.uid, this.photo, this.name});
  @override
  _HomeUserState createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> with TickerProviderStateMixin {
  DateTime _currentTime;

  // void _updateTime() async {
  //   print("ok!");
  //   // NTP.getNtpOffset().then((value) {
  //   //   print('runninf here');
  //   _currentTime = await NTP.now();
  //   // setState(() {
  //   _currentTime = _currentTime;
  //   // _ntpOffset = value;
  //   // _ntpTime = _currentTime.add(Duration(milliseconds: _ntpOffset));
  //   // print(_ntpOffset);
  //   // print(_ntpTime);
  //   // print(_currentTime);
  //   // });
  //   // });
  // }

  var appColors = [
    Color.fromRGBO(99, 138, 223, 1.0),
    Color.fromRGBO(99, 138, 223, 1.0),
    Color.fromRGBO(111, 194, 173, 1.0),
  ];
  // var cardIndex = 0;
  // ScrollController scrollController;
  var currentColor = Color.fromRGBO(99, 138, 223, 1.0);

  // AnimationController animationController;
  // ColorTween colorTween;
  // CurvedAnimation curvedAnimation;
  DateTime startDate;
  var timeFull;
  var day;
  //  _currentTime = DateTime.now();
  versionCheck(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));

    //Get Latest version info from firebase config
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      remoteConfig.getString('version');
      double newVersion = double.parse(
          remoteConfig.getString('version').trim().replaceAll(".", ""));
      if (newVersion > currentVersion) {
        String title =
            "${DemoLocalizations.of(context).newupdateavailable}"; //New Update Available
        String message =
            "${DemoLocalizations.of(context).thereisnewversion}"; //There is a newer version of app available please update it now.
        String btnLabel = "${DemoLocalizations.of(context).updatenow}";
        _showVersionDialog(title, message, btnLabel);
      }
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print("same Verion");
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  _showVersionDialog(title, message, btnLabel) async {
    RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: Duration(milliseconds: 5));
    await remoteConfig.activateFetched();
    print(remoteConfig.getString("version"));

    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        const APP_STORE_URL =
            'https://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=YOUR-APP-ID&mt=8';
        const PLAY_STORE_URL =
            'https://play.google.com/store/apps/details?id=com.daniel.lineder';

        // String btnLabelCancel = "מאוחר יותר";
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(APP_STORE_URL),
                  ),
                  // FlatButton(
                  //   child: Text(btnLabelCancel),
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                ],
              )
            : new AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(PLAY_STORE_URL),
                  ),
                  // FlatButton(
                  //   child: Text(btnLabelCancel),
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                ],
              );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    // _updateTime();
    // print("${DateFormat('MMMEd').format(_currentTime)}");
    // scrollController = new ScrollController();
    // _navigationController.value = 0;
    timeFull = DateFormat('MMMEd').format(_currentTime);
    day = timeFull;
    versionCheck(context);
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("האם את/ה בטוח רוצה לצאת?"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("לא"),
                ),
                FlatButton(
                  onPressed: () => exit(0),
                  child: Text("כן"),
                ),
              ],
            ));
  }

  double valuework = 0.0;
  final db = Firestore.instance;
  Query q;
  QuerySnapshot querySnapshot;
  Future _getProducts() async {
    if (day == timeFull) {
      q = db
          .collection("CustomerUsers")
          .document(widget.uid)
          .collection("listclient")
          .where('timeFull', isEqualTo: timeFull);

      querySnapshot = await q.getDocuments();
      return querySnapshot.documents;
    }
  }

  void future(snapshots) {
    if (snapshots.connectionState == ConnectionState.waiting) {
      return;
    }
    if (snapshots.data.length > 0 && 3 > snapshots.data.length) {
      valuework = 0.25;
    } else if (snapshots.data.length >= 3 && 8 > snapshots.data.length) {
      valuework = 0.50;
    } else if (snapshots.data.length >= 8 && 12 > snapshots.data.length) {
      valuework = 0.70;
    } else if (snapshots.data.length >= 12 && 16 > snapshots.data.length) {
      valuework = 0.85;
    } else if (snapshots.data.length >= 16) {
      valuework = 1.00;
    }
  }

  // void _sendScreenView() async {
  //   final String screenName = "homeuser";
  //   if (screenName != null) {
  //     await widget.analytics
  //         .setCurrentScreen(screenName: "homeuser")
  //         .whenComplete(() {
  //       print("Done");
  //     });
  //   }
  // }

  // Future<void> _testSetUserId() async {
  //   await widget.analytics.setUserId('some-user');
  // }

  // Future<void> _sendAnalyticsEvent() async {
  //   await widget.analytics.logEvent(
  //     name: 'test_event',
  //     parameters: <String, dynamic>{
  //       'string': 'string',
  //       'int': 42,
  //       'long': 12345678910,
  //       'double': 42.0,
  //       'bool': true,
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        // backgroundColor: currentColor,
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: Image.asset("images/lineder.png"),
          leading: Container(),
          // backgroundColor: currentColor,
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.0,
          // actions: <Widget>[
          //   IconButton(
          //       onPressed: () {
          //         try {
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => MyFollowers(
          //                         uid: widget.uid,
          //                       )));
          //         } catch (e) {
          //           print(e);
          //         }
          //       },
          //       icon: Icon(Icons.swap_horiz, color: Colors.blue))
          // ],
        ),
        body: Builder(builder: (context) {
          return OfflineBuilder(
            connectivityBuilder: (BuildContext context,
                ConnectivityResult connectivity, Widget child) {
              final coneected = connectivity != ConnectivityResult.none;
              return Stack(
                fit: StackFit.expand,
                children: [
                  child,
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    height: 32.0,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      color: coneected ? null : Color(0xFFEE4400),
                      child: coneected
                          ? null
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${DemoLocalizations.of(context).offline}',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                SizedBox(
                                  width: 12.0,
                                  height: 12.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              ],
                            ),
                    ),
                  ),
                ],
              );
            },
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        try {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LineOnList(
                                        uid: widget.uid,
                                      )));
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Card(
                        child: Container(
                          // width: 250.0,
                          child: FutureBuilder(
                              future: _getProducts(),
                              builder: (context, snapshots) {
                                future(snapshots);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Icon(
                                            Icons.work,
                                            color: appColors[0],
                                          ),
                                          Icon(
                                            Icons.more_vert,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 4.0),
                                            child: Text(
                                              '${DemoLocalizations.of(context).linescheck}',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 4.0),
                                            child: Text(
                                              '${DemoLocalizations.of(context).alllines}',
                                              style: TextStyle(fontSize: 28.0),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: LinearProgressIndicator(
                                              value: valuework,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        try {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return RequestList(
                                  uid: widget.uid,
                                );
                              });
                        } catch (e) {
                          print(e);
                        }
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => RequestList(
                        //               uid: widget.uid,
                        //             )));
                      },
                      child: Card(
                        child: Container(
                          // height: 200,
                          // width: 100.0,
                          // width: 250.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.perm_media,
                                  color: appColors[1],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Text(
                                        '${DemoLocalizations.of(context).requestcheck}',
                                        // "צפה בתמונות חדשות",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Text(
                                        '${DemoLocalizations.of(context).requestlines}',
                                        style: TextStyle(fontSize: 28.0),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: LinearProgressIndicator(
                                        backgroundColor: Colors.grey[100],
                                        value: 0.00,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        try {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return RequestClinets(
                                  uid: widget.uid,
                                );
                              });
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Card(
                        child: Container(
                          // height: 200.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.business,
                                  color: appColors[2],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Text(
                                        '${DemoLocalizations.of(context).requestcheck}',
                                        // "הזמן כבר מוצרים ",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Text(
                                        '${DemoLocalizations.of(context).requestclients}',
                                        // "חיפוש מוצרים",
                                        style: TextStyle(fontSize: 28.0),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: LinearProgressIndicator(
                                        backgroundColor: Colors.grey[100],
                                        value: 0.00,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     try {
                    //       //showHeart
                    //       showDialog(
                    //           context: context,
                    //           builder: (context) {
                    //             return ShowAllPrudcts(
                    //               uid: widget.uid,
                    //             );
                    //           });

                    //     } catch (e) {
                    //       print(e);
                    //     }
                    //   },
                    //   child: Card(
                    //     child: Container(
                    //       // height: 200.0,
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: <Widget>[
                    //           Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Icon(
                    //               Icons.store,
                    //               color: appColors[2],
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: <Widget>[
                    //                 Padding(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       horizontal: 8.0, vertical: 4.0),
                    //                   child: Text(
                    //                     'הזמן כבר מוצרים',
                    //                     // "הזמן כבר מוצרים ",
                    //                     style: TextStyle(color: Colors.grey),
                    //                   ),
                    //                 ),
                    //                 Padding(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       horizontal: 8.0, vertical: 4.0),
                    //                   child: Text(
                    //                     'חיפוש מוצרים',
                    //                     // "חיפוש מוצרים",
                    //                     style: TextStyle(fontSize: 28.0),
                    //                   ),
                    //                 ),
                    //                 Padding(
                    //                   padding: const EdgeInsets.all(8.0),
                    //                   child: LinearProgressIndicator(
                    //                     backgroundColor: Colors.grey[100],
                    //                     value: 0.00,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10.0)),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
