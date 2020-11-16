import 'dart:async';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lineder/admin/homepage/dcardmodel.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:lineder/newadmin.dart';
import 'package:lineder/user/homepageuser/homepageuser.dart';

class UserOrAdmin extends StatefulWidget {
  final uid;
  final email;
  final displayName;
  String productId;
  final photoUrl;
  final phone;
  final statusGrand;
  final country;
  final currentocation;
  final method;
  UserOrAdmin(
      {this.uid,
      this.email,
      this.displayName,
      this.productId,
      this.photoUrl,
      this.phone,
      this.statusGrand,
      this.country,
      this.currentocation,
      this.method});
  @override
  _UserOrAdminState createState() => _UserOrAdminState();
}

class _UserOrAdminState extends State<UserOrAdmin> {
  // Firestore _firestore = Firestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool setupNotifications = false;

  void setUpNotifications() {
    _saveDeviceToken();
    setState(() {
      setupNotifications = true;
    });
  }

  // Future<Null> _setUpNotifications() async {
  //   if (Platform.isAndroid) {
  //     _firebaseMessaging.configure(
  //       onMessage: (Map<String, dynamic> message) async {
  //         print('on message $message');
  //       },
  //       onResume: (Map<String, dynamic> message) async {
  //         print('on resume $message');
  //       },
  //       onLaunch: (Map<String, dynamic> message) async {
  //         print('on launch $message');
  //       },
  //     );

  //     _firebaseMessaging.getToken().then((token) {
  //       tokenn = token;
  //       print("Firebase Messaging Token: " + token);

  //       // Firestore.instance
  //       //     .collection("CustomerUsers")
  //       //     .document(widget.uid)
  //       //     .updateData({"androidNotificationToken": token});
  //     });
  //   }
  // }
  var tokenn;
  var platporm;
  var timetoken;
  _saveDeviceToken() async {
    String fcmToken = await _firebaseMessaging.getToken();

    if (fcmToken != null) {
      tokenn = fcmToken;
      timetoken = FieldValue.serverTimestamp();
      platporm = Platform.operatingSystem;
      // var tokens = Firestore.instance
      //     .collection('AdminUsers')
      //     .document(widget.uid)
      //     .collection('tokens')
      //     .document(fcmToken);

      // await tokens.setData({
      //   'token': fcmToken,
      //   'createdAt': FieldValue.serverTimestamp(), // optional
      //   'platform': Platform.operatingSystem // optional
      // });
    }
  }

  String phoneNumber = "";

  bool image = false;

  @override
  void initState() {
    super.initState();
    image = true;
    sub = db
        .collection("AdminUsers")
        .document(widget.uid)
        .snapshots()
        .listen((snap) {
      setState(() {
        data = snap.data;
      });
    });
  }

  @override
  void dispose() {
    sub.cancel();

    super.dispose();
  }

  final db = Firestore.instance;
  StreamSubscription sub;

  Map data;
  void _nextNewAdmin() {
    print("Join Admin new");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewAdmin(
                  uid: widget.uid,
                  email: widget.email,
                  displayName: widget.displayName,
                  photoUrl: widget.photoUrl,
                  token: tokenn,
                  platporm: platporm,
                  timetoken: timetoken,
                  currentocation: widget.currentocation,
                  method: widget.method,
                )));
  }

  void _nextPageAdminUsers() {
    print("Join Admin users");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeAdminTabs(
                  uid: widget.uid,
                )));
  }

  void _nextPageCustomerUsers() {
    print("Go to Choice from list Admin Users");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserHomePage(
                  uid: widget.uid,
                )));
  }

  @override
  Widget build(BuildContext context) {
    if (setupNotifications == false) {
      setUpNotifications();
    }
    return Scaffold(
      body: SingleChildScrollView(
              child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.blueGrey[100],
          // color: Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  try {
                    final QuerySnapshot result = await Firestore.instance
                        .collection('AdminUsers')
                        .where('adminUser', isEqualTo: widget.uid)
                        .getDocuments();
                    final List<DocumentSnapshot> documents = result.documents;

                    if (documents.length == 0) {
                      _nextNewAdmin();
                    } else {
                      Firestore.instance
                          .collection("AdminUsers")
                          .document('${widget.uid}')
                          .updateData({
                        "token": tokenn,
                        "available":"available",
                      });

                      // if (data['stripe_subscription_id'] == null) {
                      //   showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return AddCreditCardForCustomer(
                      //           uid: widget.uid,
                      //           data5: data,
                      //           addcard: "addcard",
                      //         );
                      //       });
                      // }
                      // else {
                      _nextPageAdminUsers();
                      // }
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    // image: new DecorationImage(
                    //   fit: BoxFit.cover,
                    //   image: new CachedNetworkImageProvider(
                    //       "https://images.unsplash.com/photo-1548586196-aa5803b77379?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=967&q=80"),
                    // ),
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blueGrey, Colors.grey[300]],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Text(
                      "${DemoLocalizations.of(context).businessowner}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w600),
                    ),
                  ),
                  // child: FlatButton(
                  // splashColor: Colors.white,
                  // onPressed: () async {
                  //   final QuerySnapshot result = await Firestore.instance
                  //       .collection('AdminUsers')
                  //       .where('adminUser', isEqualTo: widget.uid)
                  //       .getDocuments();
                  //   final List<DocumentSnapshot> documents = result.documents;
                  //   if (documents.length == 0) {
                  //     _nextNewAdmin();
                  //   } else {
                  //     print("old");
                  //     await Future.delayed(Duration(milliseconds: 300));
                  //     _nextPageAdminUsers();
                  //   }
                  // },

                  // ),
                ),
              ),
              GestureDetector(
                  onTap: () async {
                    try {
                      // print(tokenn);
                      final QuerySnapshot result = await Firestore.instance
                          .collection('CustomerUsers')
                          .where('user', isEqualTo: widget.uid)
                          .getDocuments();
                      final List<DocumentSnapshot> documents = result.documents;
                      if (documents.length == 0) {
                        var nameq =widget.displayName!=null?widget.displayName:" ";
                        
                        widget.productId =
                            DateTime.now().millisecondsSinceEpoch.toString();

                     await   Firestore.instance
                            .collection("CustomerUsers")
                            .document('${widget.uid}')
                            .setData({
                          "token": tokenn,
                          "platform": platporm,
                          "createdAt": timetoken,
                          "productId": "${widget.productId}",
                          "userName": "$nameq",
                          "userEmail": "${widget.email}",
                          "user": "${widget.uid}",
                          "name": "${widget.displayName}",
                          "phone": " ",
                          "photoUrl": "${widget.photoUrl}",
                          "bio": " ",
                          "followers": {},
                          "statusSize": "לא מוגדר",
                          "statusGrand": "all",
                          "historysearch": [],
                          "method": widget.method,
                        });
                await        Firestore.instance
                            .collection("AllUsers")
                            .document('${widget.uid}')
                            .setData({
                          "userName": "${widget.displayName}",  
                          "userEmail": "${widget.email}",
                          "user": "${widget.uid}",
                          "phone":" ",
                          "photoUrl": "${widget.photoUrl}",
                          "bio": "",
                          "method": widget.method,

                        });
                      } else {
                        Firestore.instance
                            .collection("CustomerUsers")
                            .document('${widget.uid}')
                            .updateData({
                          "token": tokenn,
                        });
                      }
                    } catch (e) {
                      print(e);
                    }

                    await Future.delayed(Duration(milliseconds: 300));
                    _nextPageCustomerUsers();
                  },
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      // image: new DecorationImage(
                      //   fit: BoxFit.cover,
                      //   image: new CachedNetworkImageProvider(
                      //       "https://images.unsplash.com/photo-1548586196-aa5803b77379?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=967&q=80"),
                      // ),
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.blueGrey, Colors.grey[300]],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue,
                          blurRadius: 10.0,
                          offset: const Offset(0.0, 10.0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Text(
                        "${DemoLocalizations.of(context).client}",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 34, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
