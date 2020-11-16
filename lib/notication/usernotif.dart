import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lineder/helpers/locale.dart';

class UserNotification extends StatefulWidget {
  final snapshot;
  final String uid;
  final namecollection;
  final collect;

  UserNotification(
      {this.uid, this.snapshot, this.namecollection, this.collect});
  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Future _getProductsFuture;
  Map<String, dynamic> _users = {};

  @override
  void initState() {
    super.initState();
    _getProductsFuture = _getProducts();
    // _fcm.subscribeToTopic('puppies');
  }

  Future _getUserData() async {
    QuerySnapshot userDataQuerySnapshot =
        await Firestore.instance.collection("${widget.collect}").getDocuments();
    // .document(userAdmin)
    // .get();

    for (DocumentSnapshot document in userDataQuerySnapshot.documents) {
      _users[document.documentID] = document.data;
    }
  }

  Future _getProducts() async {
    // Getting all users
    await _getUserData();

    Query q = Firestore.instance
        .document("${widget.namecollection}/${widget.uid}")
        .collection('notific')
        .orderBy("timestamp", descending: true);

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  @override
  void dispose() {
    // sub.cancel();
    super.dispose();
  }

  final db = Firestore.instance;
  // StreamSubscription sub;
  // Map data;
  String actionText;

  bool stat = false;
  status() {
    setState(() {
      stat = true;
    });
  }

  _checkshowbool(showbools, product) {
    if (showbools == true) {
      Firestore.instance
          .collection("${widget.namecollection}")
          .document(widget.uid)
          .collection("notific")
          .document(product)
          .updateData({
        "showbool": false,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _getProductsFuture,
          builder: (context, snapshots) {
            if (!snapshots.hasData) return Container();
            return Container(
              child: ListView.builder(
                itemCount: snapshots.data.length,
                itemBuilder: (_, index) {
                  var document = snapshots.data[index].data;
                  var snapshot = _users[document['userId']];

                  // return FutureBuilder(
                  //     future: _getUserData(document['userId']),
                  //     builder: (context, snapshot) {
                  //       print("Called inner FutureBuilder");
                  //       if (!snapshot.hasData) {
                  //         return Container();
                  //       }

                  if (document['type'] == "follow") {
                    actionText =
                        '${DemoLocalizations.of(context).followingyou}';
                  } else if (document['type'] == "comment") {
                    actionText = " commented: ${document['commentData']}";
                  } else if (document['type'] == "request") {
                    actionText = '${DemoLocalizations.of(context).sendrequest}';
                  } else if (document['type'] == "friend") {
                    actionText = '${DemoLocalizations.of(context).friendsnow}';
                  } else if (document['type'] == "requestline") {
                    actionText =
                        '${DemoLocalizations.of(context).requestlines}';
                  } else if (document['type'] == "onlist") {
                    actionText = '${DemoLocalizations.of(context).lineisset}';
                  } else if (document['type'] == "onlistlate") {
                    actionText = '${DemoLocalizations.of(context).linedelay}';
                  } else if (document['type'] == "onlistcancel") {
                    actionText =
                        '${DemoLocalizations.of(context).canceledline}';
                  } else {
                    actionText = " ${document['type']}";
                  }

                  return Card(
                    // color: document['showbool'] == true
                    //     ? Colors.blue[100]
                    //     : Colors.white,
                    child: ListTile(
                      onTap: () {
                        // _checkshowbool(
                        //     document['showbool'], document['productId']);

                        // if (widget.namecollection == "AdminUsers") {
                        //   if (document['type'] == "request") {}
                        // } else {}
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: ((context) => Scaffold(
                        //               appBar: AppBar(),
                        //               body: ListView(
                        //                 children: <Widget>[
                        //                   Container(
                        //                     child: ListTile(),
                        //                   )
                        //                 ],
                        //               ),
                        //             ))));

                        // status();
                      },
                      title: Row(
                        children: <Widget>[
                          Flexible(
                              flex: 2,
                              child: InkWell(
                                onTap: () {
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (BuildContext context) =>
                                  //       CustomDialog(
                                  //         image: snapshot.data['photoUrl'],

                                  //         title:
                                  //             snapshot.data['userName'],
                                  //         description:
                                  //             snapshot.data['bio'],
                                  //         phone: snapshot.data['phone'],
                                  //         snapshots: document,
                                  //         user: document['user'],
                                  //         uid: widget.uid,

                                  //       namecollection: widget.namecollection,
                                  //       ),
                                  // );
                                },
                                child: Text(
                                  "${snapshot['userName']}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                          Text(" $actionText"),
                        ],
                      ),
                      subtitle: document['type'] == "requestline" ||
                              document['type'] == "onlist" ||
                              document['type'] == "onlistlate" ||
                              document['type'] == "onlistcancel"
                          ? Card(
                              color:
                                  // document['type'] == "onlistlate"
                                  //     ? Colors.orange[200]
                                  //     : document['type'] == "onlistcancel"
                                  //         ? Colors.red[200]
                                  //         :
                                  Colors.cyanAccent,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Flexible(
                                    flex: 2,
                                    child: Text(
                                      "${DateFormat('Hm').format(document['timentpS'].toDate()) + "-" + DateFormat('Hm').format(document['timentpE'].toDate())}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // Text(
                                  //   "${document['type'] == "requestline" ? DateFormat('Hm').format(document['timentpE'].toDate()) : ""}",
                                  // ),
                                  Flexible(
                                    flex: 2,
                                    child: Text(
                                        "${DateFormat('MMMEd', DemoLocalizations.of(context).language).format(document['timentpS'].toDate())}",
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Text("${document["kind"]}",
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      leading: Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: CachedNetworkImageProvider(
                                  "${snapshot['photoUrl']}"),
                            )),
                      ),
                      trailing: document["timelate"] != null
                          ? Card(
                              color: Colors.amber,
                              child: Text(
                                "${document["timelate"]}",
                              ),
                            )
                          : Text(""),
                    ),
                  );
                },
              ),
            );
          }),
    );
  }
}
