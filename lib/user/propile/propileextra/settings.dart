import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lineder/animation/splashicon.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:lineder/user/propile/propileextra/sendmail.dart';

class Settings extends StatelessWidget {
  final uid;
  final packageInfo;
  final admin;

  const Settings({Key key, this.uid, this.packageInfo, this.admin});
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    String odot =
        "dddddddddd asd,jnaskjnd asd jlajskd aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadaskld kas";
    String version = packageInfo.version;
    void _signOut() {
      googleSignIn.signOut();
      print("User Signed out Gmail");
    }

    void _signOutEmail() {
      _auth.signOut();
      print("User Signed out Email");
    }

    // _delete() async {
    //   Response response = await http.post(
    //     "https://us-central1-danielhaircutnew.cloudfunctions.net/deleteUserFirebase",
    //     body: json.encode({"uid": uid}),
    //   );

    //   print(response.body.toString());
    // }
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    void showInSnackBar(
      String value,
    ) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value),
        action: SnackBarAction(
          label: '${DemoLocalizations.of(context).yes}',
          onPressed: () async {
            await Firestore.instance
                .collection("AdminUsers")
                .document(uid)
                .updateData({
              "available": "unavailable",
            });
            await Firestore.instance
                .collection("AllUsers")
                .document(uid)
                .updateData({
              "available": "unavailable",
            });
            await Navigator.pushNamed(context, '/loginpagee');
          },
        ),
      ));
    }

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: <Widget>[
            InformationApp(),

            ListTile(
              title: Text(
                '${DemoLocalizations.of(context).contactbymail}',
                textAlign: TextAlign.center,
              ),
              trailing: Icon(Icons.mail_outline),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return SendMails(
                        uid: uid,
                      );
                    });
              },
            ),
            // Divider(
            //   height: 8,
            //   color: Colors.black38,
            // ),
            // ListTile(
            //   title: Text(
            //     'שפה',
            //     textAlign: TextAlign.center,
            //   ),
            //   trailing: Icon(
            //     Icons.content_paste,
            //     color: Colors.blueAccent,
            //   ),
            //   onTap: () {
            //     showDialog(
            //         context: context,
            //         builder: (context) {
            //           return AlertDialog(
            //             content: Text(
            //               "aaaa",
            //               textAlign: TextAlign.center,
            //             ),
            //             actions: <Widget>[
            //               IconButton(
            //                 onPressed: () => Navigator.pop(context),
            //                 icon: Icon(
            //                   Icons.check,
            //                   color: Colors.green,
            //                 ),
            //               )
            //             ],
            //           );
            //         });
            //   },
            // ),
            Divider(
              height: 8,
              color: Colors.black38,
            ),
            ListTile(
              title: Text(
                '${DemoLocalizations.of(context).regulation}',
                textAlign: TextAlign.center,
              ),
              trailing: Icon(
                Icons.content_paste,
                color: Colors.blueAccent,
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(
                          "הנך מאשר/ת את תקנון אפליקציה\nכרגע בגרסת בדיקה אין אחריות על נתונים שנמחקים\nהאחריות על המשתמש בלבד",
                          textAlign: TextAlign.center,
                        ),
                        actions: <Widget>[
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                          )
                        ],
                      );
                    });
              },
            ),
            // Divider(
            //   height: 8,
            //   color: Colors.black38,
            // ),
            // ExpansionTile(
            //   title: Text(
            //     '${DemoLocalizations.of(context).aboutus}',
            //     textAlign: TextAlign.center,
            //   ),
            //   children: <Widget>[
            //     Text("$odot"),
            //   ],
            // ),
            Divider(
              height: 5,
              color: Colors.grey,
            ),
            ExpansionTile(
              title: Text(
                '${DemoLocalizations.of(context).version}',
                textAlign: TextAlign.center,
              ),
              children: <Widget>[
                Text(
                  "${version != null ? version : 1.0}",
                ),
              ],
            ),
            Divider(
              height: 5,
              color: Colors.grey,
            ),
            ListTile(
              onTap: () {
                _signOut();
                _signOutEmail();
                Navigator.pushNamed(context, '/loginpagee');
              },
              title: Text(
                '${DemoLocalizations.of(context).logout}',
                textAlign: TextAlign.center,
              ),
              trailing: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
            ),
            Divider(
              height: 5,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.all(40),
            ),
            admin == "admin"
                ? ListTile(
                    onTap: () {
                      showInSnackBar(
                          '${DemoLocalizations.of(context).areusure}');
                    },
                    title: Text(
                      '${DemoLocalizations.of(context).deleteaccont}',
                      textAlign: TextAlign.center,
                    ),
                    trailing: Icon(
                      Icons.delete_sweep,
                      color: Colors.red[700],
                    ),
                  )
                : Container(),
            admin == "admin"
                ? Divider(
                    height: 5,
                    color: Colors.grey,
                  )
                : Container(),
            // ListTile(
            //   onTap: (){

            //     _delete();
            //   },
            //   title: Text("ddddd"),
            // )
          ],
        ));
  }
}
