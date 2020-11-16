import 'dart:async';

import 'package:lineder/admin/homepage/dcardmodel.dart';
import 'package:lineder/loginpage/loginpagee.dart';
import 'package:lineder/loginpage/regulation.dart';
import 'package:lineder/user/homepageuser/homepageuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool loginFlag = false;
  bool isLoggedIn = false;
  SharedPreferences prefs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  void isSignedIn() async {
    this.setState(() {
      loginFlag = true;
    });

    prefs = await SharedPreferences.getInstance();

    // isLoggedIn = await googleSignIn.isSignedIn();
    //  isLoggedIn = await useremail.uid
    // FirebaseUser a =await googleSignIn.isSignedIn();

    FirebaseUser b = await _auth.currentUser();
    b != null ? isLoggedIn = true : isLoggedIn = false;
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      if (isLoggedIn) {
        final QuerySnapshot result = await Firestore.instance
            .collection('AdminUsers')
            .where('user', isEqualTo: b.uid)
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;

        final QuerySnapshot resultemail = await Firestore.instance
            .collection('CustomerUsers')
            .where('user', isEqualTo: b.uid)
            .getDocuments();
        final List<DocumentSnapshot> documentsemail = resultemail.documents;

        if (documents.length == 1) {
          // sub = db
          //     .collection("AdminUsers")
          //     .document(b.uid)
          //     .snapshots()
          //     .listen((snap) {
          //   setState(() {
          //     data = snap.data;

          // if (data['stripe_subscription_id'] == null) {
          //   googleSignIn.signOut();
          //   _auth.signOut();
          //   Navigator.popAndPushNamed(context, '/loginpagee');
          // }
          // else
          //  {
          print(b.uid);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeAdminTabs(
                      uid: b.uid,
                    )),
          );
          // }
          // });
          // });
        } else if (documentsemail.length == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserHomePage(uid: b.uid)),
          );
        } else {
          print("reroorr");
          googleSignIn.signOut();
          print("User Signed out Gmail");

          _auth.signOut();
          print("User Signed out Email");

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );

          // Navigator.popAndPushNamed(context, '/');
        }
      } else {
        Navigator.popAndPushNamed(context, '/loginpagee');
      }
    } else {
      // here I want show the fisrt page

      print("yesssssss");
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegulationApp(
                  pres: prefs,
                )),
      );
      // Navigator.popAndPushNamed(context, '/regulation');
    }

    this.setState(() {
      loginFlag = false;
    });
  }

  @override
  void initState() {
    isSignedIn();
    super.initState();
  }

  @override
  void dispose() {
    sub != null ? sub.cancel() : Container();
    // sub.pause();

    super.dispose();
  }

  final db = Firestore.instance;
  StreamSubscription sub;

  Map data;
  @override
  Widget build(BuildContext context) {
    // var deco =
    return Scaffold(
      // appBar: AppBar(
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //         gradient:
      //             LinearGradient(colors: [Colors.blueGrey, Colors.white])),
      //   ),
      // ),
      body: Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.blueGrey, Colors.grey[300]])),
        height: MediaQuery.of(context).size.height,

        // child: ,
      ),
    );
  }
}
