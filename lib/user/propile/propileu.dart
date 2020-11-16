import 'dart:async';

import 'package:app_review/app_review.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lineder/admin/areaperson/propile.dart';
import 'package:lineder/admin/areaperson/showfollowerdelte.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:lineder/store/stroeaddcard.dart';
import 'package:lineder/user/propile/profileedituser.dart';
import 'package:lineder/user/propile/propileextra/settings.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';

class PropileU extends StatefulWidget {
  final String uid;

  PropileU({
    this.uid,
  });
  @override
  _PropileUState createState() => _PropileUState();
}

class _PropileUState extends State<PropileU>
    with SingleTickerProviderStateMixin {
  Firestore _firestore = Firestore.instance;
  AnimationController controller;
  Animation animation;
////////////////////////database string name user ///////////////
  ///

  // Future _getProducts() async {
  //   Query q = _firestore
  //       .collection("CustomerUsers")
  //       .where("user", isEqualTo: widget.uid);

  //   QuerySnapshot querySnapshot = await q.getDocuments();
  //   return querySnapshot.documents;
  // }

  Future _getUserData() async {
    final userDataQuery = await Firestore.instance
        .collection("CustomerUsers")
        .document(widget.uid)
        .get();

    return userDataQuery.data;
  }

  Future onRefresh() async {
    await Future.delayed(Duration(microseconds: 200));
    setState(() {
      _getUserData();
    });
    return null;
  }

  Stream<QuerySnapshot> _followestream;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 8));
    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(controller);

    _followestream = _firestore
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("following")
        .snapshots();
  }

  @override
  void dispose() {
    controller.dispose();
    // sub.cancel();
    // sub.pause();
    super.dispose();
  }

  final db = Firestore.instance;
  // StreamSubscription sub;

  // Map data;

  // void _signOut() {
  //   googleSignIn.signOut();
  //   print("User Signed out");
  // }
  void snackBar(BuildContext context) {
    var snakbar = SnackBar(
      content: Text(" Save Your Image? "),
      action: SnackBarAction(
        label: "SAVE",
        onPressed: () {},
      ),
    );
    Scaffold.of(context).showSnackBar(snakbar);
  }

  Widget barber(snapshots) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          " Barber\n${snapshots.data.length}",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          "Swipe  ",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800]),
        ),
      ],
    );
  }

  // Future _getfollow() async {
  //   QuerySnapshot q = await _firestore
  //       .collection("CustomerUsers")
  //       .document(widget.uid)
  //       .collection("following")
  //       .getDocuments();

  //   return q.documents;
  // }

  String userOradmin = "AdminUsers";
  Widget _buildStatItem(String label, snaphsots) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return InkWell(
      onTap: () {
        snaphsots.data.documents.length != 0
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowFollowrsss(
                        uid: widget.uid,
                        snapshots: snaphsots,
                        userOradmin: userOradmin)))
            : Container();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "${snaphsots.data.documents.length}",
            style: _statCountTextStyle,
          ),
          Text(
            label,
            style: _statLabelTextStyle,
          ),
        ],
      ),
    );
  }

  // final String _followers = "173";
  // final String _posts = "24";
  // final String _scores = "450";
  Widget _buildStatContainer() {
    return StreamBuilder<QuerySnapshot>(
        stream: _followestream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ListTile();
          }
          return Container(
            height: 75.0,
            // margin: EdgeInsets.only(top: 8.0),
            // decoration: BoxDecoration(
            //   // color: Color(0xFFEFF4F7),
            // ),
            child: _buildStatItem(
                "${DemoLocalizations.of(context).following}", snapshot),
          );
        });
  }

  var currentColor = Color.fromRGBO(99, 138, 223, 1.0);
  var urlshare =
      "https://play.google.com/store/apps/details?id=com.daniel.lineder";
  String subject = 'Lineder';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder(
                  future: _getUserData(),
                  builder: (context, snapshots) {
                    if (!snapshots.hasData) {
                      return Container();
                    }

                    return ListView(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListTile(
                          onTap: () {
                            try {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return PropileA(
                                      uid: widget.uid,
                                      userorAdmin: "CustomerUsers",
                                      namesStorage: "profileClient",
                                    );
                                  });
                            } catch (e) {
                              print(e);
                            }
                          },
                          trailing: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new CachedNetworkImageProvider(snapshots
                                            .data['photoUrl'] !=
                                        null
                                    ? "${snapshots.data['photoUrl']}"
                                    : "https://images.unsplash.com/photo-1548586196-aa5803b77379?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=967&q=80"),
                              ),
                            ),
                          ),
                          title: Text(
                            "${snapshots.data['userName'] != "null" ? snapshots.data['userName'] : DemoLocalizations.of(context).fullname}",
                            style: TextStyle(
                                // color: Colors.white70,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            "${snapshots.data['bio'] != "null" ? snapshots.data['bio'] : DemoLocalizations.of(context).bio}",
                            style: TextStyle(
                                // color: Colors.white70,
                                ),
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                          ),
                        ),
                      ),
                      Divider(
                        height: 10,
                        color: Colors.black,
                      ),
                      _buildStatContainer(),
                      Divider(
                        height: 8,
                        color: Colors.black38,
                      ),
                      ListTile(
                        title: Text(
                          "${DemoLocalizations.of(context).invitefriend}",
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(Icons.people_outline),
                        onTap: urlshare.isEmpty
                            ? null
                            : () {
                                // A builder is used to retrieve the context immediately
                                // surrounding the RaisedButton.
                                //
                                // The context's `findRenderObject` returns the first
                                // RenderObject in its descendent tree when it's not
                                // a RenderObjectWidget. The RaisedButton's RenderObject
                                // has its position and size after it's built.
                                final RenderBox box =
                                    context.findRenderObject();
                                Share.share(urlshare,
                                    subject: subject,
                                    sharePositionOrigin:
                                        box.localToGlobal(Offset.zero) &
                                            box.size);
                              },
                      ),
                      // Divider(
                      //   height: 8,
                      //   color: Colors.black38,
                      // ),
                      // ListTile(
                      //   title: Text(
                      //     "My Card",
                      //     textAlign: TextAlign.center,
                      //   ),
                      //   trailing: Icon(
                      //     Icons.shopping_basket,
                      //     color: Colors.red,
                      //   ),
                      //   onTap: () => Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => StoreAddCard(
                      //                 uid: widget.uid,
                      //               ))),
                      // ),
                      Divider(
                        height: 8,
                        color: Colors.black38,
                      ),
                      // ListTile(
                      //   title: Text(
                      //     "${DemoLocalizations.of(context).payments}",
                      //     textAlign: TextAlign.center,
                      //   ),
                      //   trailing: Icon(Icons.payment),
                      //   onTap: () {},
                      // ),
                      // Divider(
                      //   height: 8,
                      //   color: Colors.black38,
                      // ),
                      ListTile(
                        title: Text(
                          "${DemoLocalizations.of(context).reviewsapp}",
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(Icons.rate_review),
                        onTap: () {
                          try {
                            AppReview.requestReview.then((onValue) {
                              print(onValue);
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                      Divider(
                        height: 8,
                        color: Colors.black38,
                      ),
                      ListTile(
                        title: Text(
                          "${DemoLocalizations.of(context).settings}",
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(Icons.settings),
                        onTap: () async {
                          PackageInfo packageInfo =
                              await PackageInfo.fromPlatform();
                          print(packageInfo.version);
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Settings(
                                        uid: widget.uid,
                                        packageInfo: packageInfo,
                                      )));
                        },
                      ),
                    ]);
                  },
                ),
              ),
            ),
          )),
    );
  }
}
