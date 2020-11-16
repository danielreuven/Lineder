import 'dart:async';

import 'package:lineder/helpers/locale.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestListP extends StatefulWidget {
  RequestListP({this.uid, this.snapshots});
  final uid;
  final snapshots;

  @override
  _RequestListPState createState() => _RequestListPState();
}

class _RequestListPState extends State<RequestListP> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // var user;
  // var nameee;
  // var imagesss;

  // var phoneee;
  var startTime;
  var endTime;
  var kinds;
  // var adminUser;
  // var productIdd;
  var timeFull;
  var url;
  DateTime timentpS;
  DateTime timentpE;
  Firestore _firestore = Firestore.instance;

  Future _getProductsRequest() async {
    QuerySnapshot q = await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("requestTolist")
        .getDocuments();

    return q.documents;
    // setState(() {
    //   _loadingProducts = false;
    // });
  }

  _ssetProducts(productIdd, user, nameBarber, price) async {
    await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("listclient")
        .document('$productIdd')
        .setData({
      "productId": "$productIdd",
      "user": "$user",
      "adminUser": widget.uid,
      "nameBarber": "$nameBarber",
      "kind": "$kinds",
      "price": price,
      "startTime": "$startTime",
      "endTime": "$endTime",
      "timeFull": "$timeFull",
      "timentpS": timentpS,
      "timentpE": timentpE,
      "status": "onList",
      "statusline": "ok",
      "timelate":0,
    });
    await _firestore
        .collection("CustomerUsers")
        .document(user)
        .collection("listclient")
        .document('$productIdd')
        .setData({
      "productId": "$productIdd",
      "user": "$user",
      "adminUser": widget.uid,
      "nameBarber": "$nameBarber",
      "kind": "$kinds",
      "startTime": "$startTime",
      "endTime": "$endTime",
      "timeFull": "$timeFull",
      "timentpS": timentpS,
      "timentpE": timentpE,
      "status": "onList",
      "statusline": "ok",
    });
  }

  deleteProductRequst(String productId, String userUid) async {
    await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("requestTolist")
        .document('$productId')
        .delete()
        .whenComplete(() {
      print("deleteproducts requestTolist");
    });
    await _firestore
        .collection("CustomerUsers")
        .document(userUid)
        .collection("requestTolist")
        .document('$productId')
        .delete();
  }

  deleteProductRequstBackSchedule(String productId, String userUid) async {
    await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("requestTolist")
        .document('$productId')
        .delete();

    await _firestore
        .collection("CustomerUsers")
        .document(userUid)
        .collection("requestTolist")
        .document('$productId')
        .delete();
    await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("lineschedule")
        .document('$productId')
        .updateData({
      "status": "ok",
    });
  }

  _setNotification(productIdd, user, adminname, adminimage) async {
    await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("notific")
        .document(productIdd)
        .updateData({
      "type": "onlist",
      "timestamp": FieldValue.serverTimestamp(),
    });
    await _firestore
        .collection("CustomerUsers")
        .document(user)
        .collection("notific")
        .document(productIdd)
        .setData({
      "ownerId": user,
      "userId": widget.uid,
      "type": "onlist",
      "timestamp": FieldValue.serverTimestamp(),
      "productId": "$productIdd",
      "timentpS": timentpS,
      "timentpE": timentpE,
      "timeFull": "$timeFull",
      "kind": "$kinds",
      "showbool": true,
         "language":"${DemoLocalizations.of(context).language}"
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // sub.pause();

    super.dispose();
  }

  final db = Firestore.instance;
  // StreamSubscription sub;

  Map data;

  Future onRefresh() async {
    await Future.delayed(Duration(microseconds: 200));
    setState(() {
      _getProductsRequest();
    });
    return null;
  }

  bool isloading = false;
  funcFlaseall() {
    setState(() {
      this.isloading = true;
    });
  }

  bool stat = false;
  void status() {
    setState(() {
      this.stat = !stat;
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      action: SnackBarAction(
        label: '${DemoLocalizations.of(context).yes}',
        onPressed: () {
          widget.snapshots.data.forEach((doc) {
            _firestore
                .collection("AdminUsers")
                .document(widget.uid)
                .collection("requestTolist")
                .document(doc['productId'])
                .delete();
          });
          status();
        },
      ),
    ));
  }

  void showInSnack(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  // Future _getProductsAdmin(user) async {
  //   Query q = Firestore.instance
  //       .collection("CustomerUsers")
  //       .where("user", isEqualTo: user);

  //   QuerySnapshot querySnapshot = await q.getDocuments();
  //   return querySnapshot.documents;
  // }
  Future _getUserData(userAdmin) async {
    final userDataQuery = await Firestore.instance
        .collection("CustomerUsers")
        .document(userAdmin)
        .get();

    return userDataQuery.data;
  }

  Future _getRecod() async {
    QuerySnapshot q = await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("record")
        .getDocuments();

    return q.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.black54, Colors.grey])),
        ),
        title: Text(
          '${DemoLocalizations.of(context).requestlines}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              FlatButton.icon(
                onPressed: () {
                  showInSnackBar(
                      '${DemoLocalizations.of(context).requestlines}');
                },
                label: Text('${DemoLocalizations.of(context).deleteall}'),
                icon: Icon(
                  Icons.delete,
                  color: Colors.red[300],
                ),
              ),
            ]),
          ),
          FutureBuilder(
              future: _getProductsRequest(),
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return SliverPadding(
                    padding: EdgeInsets.all(10),
                  );
                }
                return SliverList(
                  delegate:
                      SliverChildBuilderDelegate((BuildContext context, index) {
                    return FutureBuilder(
                        future:
                            _getUserData(snapshots.data[index].data['user']),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          final document = snapshots.data[index].data;
                          var productIdd = document['productId'];
                          var user = document['user'];
                          return FutureBuilder(
                              future: _getRecod(),
                              builder: (context, snapsh) {
                                if (!snapsh.hasData) {
                                  return Container();
                                }
                                return Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  actions: <Widget>[
                                    IconSlideAction(
                                        caption:
                                            '${DemoLocalizations.of(context).accept}',
                                        color: Colors.blue,
                                        icon: Icons.verified_user,
                                        onTap: ()  {
                                          timeFull = document['timeFull'];

                                          kinds = document['kind'];

                                          startTime = document['startTime'];
                                          endTime = document['endTime'];

                                          timentpS =
                                              document['timentpS'].toDate();
                                          timentpE =
                                              document['timentpE'].toDate();

                                          var nameBarber =
                                              document['nameBarber'];
                                          deleteProductRequst(productIdd, user);
                                 
                                          onRefresh();
                                           _ssetProducts(productIdd, user,
                                              nameBarber, document['price']);
                                           _setNotification(
                                              productIdd,
                                              user,
                                              document['adminName'],
                                              document['adminImage']);

                                          // funcFlaseall();
                                          // showInSnack(
                                          //     '${DemoLocalizations.of(context).added}');
                                          String checkdays =
                                              DateFormat('d').format(timentpS);
                                          String checkdoco = DateFormat('yMMM')
                                              .format(timentpS);
                                          int price = document['price'];

                                          // DateTime s = snapshots
                                          //     .data[index].data['timentpS']
                                          //     .toDate();
                                          // DateTime e = snapshots
                                          //     .data[index].data['timentpE']
                                          //     .toDate();

                                          var timeWorkingH =
                                              timentpE.hour - timentpS.hour;
                                          var timeWorkingM =
                                              timentpE.minute - timentpS.minute;
                                          var sumHours =
                                              timeWorkingH * 60 + timeWorkingM;

                                          print(sumHours);

                                          ///check documents
                                          if (snapsh.data.length == 0) {
                                            print("first docoment");
                                            String currency =
                                                document['currency'];
                                            List oldDaysWorkArray = [];

                                            var newDays = {};
                                            newDays.addAll({
                                              "day": "$checkdays",
                                              "nameclients": [
                                                '${snapshot.data['userName']}'
                                              ],
                                              "cancelnameclients": [],
                                              "cancelsumhours": 0,
                                              "cancelsumprice": 0,
                                              "sumhours": sumHours,
                                              "sumprice": price,
                                            });

                                            oldDaysWorkArray.add(newDays);
                                            print(oldDaysWorkArray);

                                             db
                                                .collection("AdminUsers")
                                                .document(widget.uid)
                                                .collection("record")
                                                .document(checkdoco)
                                                .setData({
                                              "productId": "$checkdoco",
                                              "sumhoursM": sumHours,
                                              "sumpriceM": price,
                                              "currency": "$currency",
                                              "dayswork": oldDaysWorkArray,
                                            });
                                          } else {
                                            for (var i = 0;
                                                i < snapsh.data.length;
                                                i++) {
                                              //check docoments
                                              if (checkdoco ==
                                                  snapsh.data[i]
                                                      .data['productId']) {
                                                print("yay found docoment");

                                                ///check days
                                                for (var j = 0;
                                                    j <
                                                        snapsh
                                                            .data[i]
                                                            .data['dayswork']
                                                            .length;
                                                    j++) {
                                                  ///check days

                                                  //found day
                                                  if (checkdays ==
                                                      snapsh.data[i]
                                                              .data['dayswork']
                                                          [j]['day']) {
                                                    print("yay found day");

                                                    var oldDaysWorkArray =
                                                        snapsh.data[i]
                                                            .data["dayswork"];

                                                    var oldDaysWorkToUpdate =
                                                        oldDaysWorkArray[j];
                                                    // var indexToUpdate = j;

                                                    var oldNameClients =
                                                        oldDaysWorkToUpdate[
                                                            "nameclients"];

                                                    var newNameClients = [];
                                                    for (int daniel = 0;
                                                        daniel <
                                                            oldNameClients
                                                                .length;
                                                        daniel++) {
                                                      newNameClients.add(
                                                          oldNameClients[
                                                              daniel]);
                                                    }

                                                    newNameClients.add(snapshot
                                                            .data[
                                                        'userName']); // for demo

                                                    var oldSumHours =
                                                        oldDaysWorkToUpdate[
                                                            "sumhours"];
                                                    var newSumHours = oldSumHours +
                                                        sumHours; // hours of day

                                                    var oldSumPrice =
                                                        oldDaysWorkToUpdate[
                                                            "sumprice"];
                                                    var newSumPrice =
                                                        oldSumPrice +
                                                            price; // price of day

                                                    var sumhoursM = snapsh
                                                        .data[i]
                                                        .data['sumhoursM'];
                                                    var newSumHoursM = sumhoursM +
                                                        sumHours; //hours of month

                                                    var sumpriceM = snapsh
                                                        .data[i]
                                                        .data['sumpriceM'];
                                                    var newSumpriceM = sumpriceM +
                                                        price; //price of month

                                                    var newDaysWorkArray = [];

                                                    for (int daniel = 0;
                                                        daniel <
                                                            oldDaysWorkArray
                                                                .length;
                                                        daniel++) {
                                                      if (daniel == j) {
                                                        newDaysWorkArray.add({
                                                          "day":
                                                              oldDaysWorkToUpdate[
                                                                  "day"],
                                                          "nameclients":
                                                              newNameClients,
                                                          "sumhours":
                                                              newSumHours,
                                                          "sumprice":
                                                              newSumPrice,
                                                          "cancelnameclients":
                                                              oldDaysWorkToUpdate[
                                                                  "cancelnameclients"],
                                                          "cancelsumhours":
                                                              oldDaysWorkToUpdate[
                                                                  "cancelsumhours"],
                                                          "cancelsumprice":
                                                              oldDaysWorkToUpdate[
                                                                  "cancelsumprice"],
                                                        });
                                                      } else {
                                                        newDaysWorkArray.add(
                                                            oldDaysWorkArray[
                                                                daniel]);
                                                      }
                                                    }

                                                    print(newDaysWorkArray);
                                                     db
                                                        .collection(
                                                            "AdminUsers")
                                                        .document(widget.uid)
                                                        .collection("record")
                                                        .document(checkdoco)
                                                        .updateData({
                                                      "sumhoursM": newSumHoursM,
                                                      "sumpriceM": newSumpriceM,
                                                      "dayswork":
                                                          newDaysWorkArray,
                                                    });

                                                    //no found day
                                                  } else if (checkdays !=
                                                          snapsh.data[i].data[
                                                                  'dayswork'][j]
                                                              ['day'] &&
                                                      j ==
                                                          snapsh
                                                                  .data[i]
                                                                  .data[
                                                                      'dayswork']
                                                                  .length -
                                                              1) {
                                                    print("no found day");
                                                    var sumhoursM = snapsh
                                                        .data[i]
                                                        .data["sumhoursM"];
                                                    var sumpriceM = snapsh
                                                        .data[i]
                                                        .data["sumpriceM"];
                                                    List oldDaysWorkArray = [];
                                                    oldDaysWorkArray.addAll(
                                                        snapsh.data[i]
                                                            .data["dayswork"]);
                                                    var newDays = {};
                                                    newDays.addAll({
                                                      "day": "$checkdays",
                                                      "nameclients": [
                                                        '${snapshot.data['userName']}'
                                                      ],
                                                      "sumhours": sumHours,
                                                      "sumprice": price,
                                                      "cancelnameclients": [],
                                                      "cancelsumhours": 0,
                                                      "cancelsumprice": 0,
                                                    });

                                                    oldDaysWorkArray
                                                        .add(newDays);

                                                     db
                                                        .collection(
                                                            "AdminUsers")
                                                        .document(widget.uid)
                                                        .collection("record")
                                                        .document(checkdoco)
                                                        .updateData({
                                                      "sumhoursM":
                                                          sumhoursM + sumHours,
                                                      "sumpriceM":
                                                          sumpriceM + price,
                                                      "dayswork":
                                                          oldDaysWorkArray,
                                                    });
                                                  }
                                                }
                                              } else {
                                                print("no found docoment");
                                                String currency =
                                                    document['currency'];
                                                List oldDaysWorkArray = [];

                                                var newDays = {};
                                                newDays.addAll({
                                                  "day": "$checkdays",
                                                  "nameclients": [
                                                    '${snapshot.data['userName']}'
                                                  ],
                                                  "sumhours": sumHours,
                                                  "sumprice": price,
                                                  "cancelnameclients": [],
                                                  "cancelsumhours": 0,
                                                  "cancelsumprice": 0,
                                                });

                                                oldDaysWorkArray.add(newDays);
                                                print(oldDaysWorkArray);

                                                 db
                                                    .collection("AdminUsers")
                                                    .document(widget.uid)
                                                    .collection("record")
                                                    .document(checkdoco)
                                                    .setData({
                                                  "productId": "$checkdoco",
                                                  "sumhoursM": sumHours,
                                                  "sumpriceM": price,
                                                  "currency": "$currency",
                                                  "dayswork": oldDaysWorkArray,
                                                });
                                              }
                                            }
                                          }
                                        }),
                                    IconSlideAction(
                                      caption:
                                          '${DemoLocalizations.of(context).delete}',
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () {
                                        deleteProductRequstBackSchedule(
                                            productIdd, user);

                                        onRefresh();
                                      },
                                    ),
                                  ],
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                      Colors.grey,
                                      Colors.white70
                                    ])),
                                    child: ListTile(
                                      leading: Container(
                                          width: 80.0,
                                          height: 60.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new CachedNetworkImageProvider(
                                                      "${snapshot.data['photoUrl']}"))),
                                          child: Text(
                                            "${snapshot.data['userName']}",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                background: Paint()),
                                          ),
                                        ),
                                      subtitle: Text(
                                        "${DateFormat('Hm').format(snapshots.data[index].data['timentpS'].toDate()) + " - " + DateFormat('Hm').format(snapshots.data[index].data['timentpE'].toDate())}\n${snapshots.data[index].data['kind']}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      title: Text(
                                        "${snapshots.data[index].data['nameBarber']}\n${snapshots.data[index].data['timeFull']}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                      trailing: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Color(0xff002651),
                                        child: IconButton(
                                          onPressed: () async {
                                            var url =
                                                "tel:" + snapshot.data['phone'];

                                            if (await canLaunch(url))
                                              launch(url);
                                            else
                                              print("URL can Not be");
                                            print('open click');
                                          },
                                          icon: Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        });
                  }, childCount: snapshots.data.length),
                );
              })
        ],
      ),
    );
  }
}
