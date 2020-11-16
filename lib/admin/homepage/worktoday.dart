import 'package:lineder/helpers/locale.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkingToday extends StatefulWidget {
  WorkingToday({
    this.uid,
  });
  final String uid;

  @override
  _WorkingTodayState createState() => _WorkingTodayState();
}

class _WorkingTodayState extends State<WorkingToday> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  var day;
  var timeFull;

  @override
  void initState() {
    super.initState();
    checkTime();
    _getProductsFuture = _getProducts();
    _getRecodFuture = _getRecod();
    _getBarbersFuture = _getBarbers();
  }

  Firestore _firestore = Firestore.instance;
  void checkTime() async {
    DateTime startDate = await NTP.now();
    print(startDate);
    timeFull = DateFormat('MMMEd').format(startDate);

    startDate != null ? day = timeFull : print("ddd");
    setState(() {
      _getProducts();
    });
  }

  Query q;
  QuerySnapshot querySnapshot;
  Future _getProducts() async {
    await _getUserData();
    if (day == timeFull) {
      q = _selection.isEmpty
          ? _firestore
              .collection("AdminUsers")
              .document(widget.uid)
              .collection("listclient")
              .where('timeFull', isEqualTo: timeFull)
          : _firestore
              .collection("AdminUsers")
              .document(widget.uid)
              .collection("listclient")
              .where('timeFull', isEqualTo: timeFull)
              .where("nameBarber", isEqualTo: _selection);

      querySnapshot = await q.getDocuments();
      return querySnapshot.documents;
    }
  }

  var url;

  bool stat = false;
  String ok = "ok";
  String mitacev = "mitacev";
  String cancel = "cancel";
  var statuslist;
  String onlist = "onlist";
  String onlistlate = "onlistlate";
  String onlistcancel = "onlistcancel";
  var statusnotif;

  void status() {
    setState(() {
      stat = !stat;

      // print(stat);
    });
  }

  _deleProducts(String productId, String user) async {
    await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("listclient")
        .document("$productId")
        .delete()
        .whenComplete(() {
      print("deleteProduct listclient");
    });
    await _firestore
        .collection("CustomerUsers")
        .document(user)
        .collection("listclient")
        .document("$productId")
        .delete();
  }

  _breakProduct(String productId, user, timentpS, timentpE, timeFullS, kind,
      language) async {
    // _firestore.collection("listclient").getDocuments();

    await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("listclient")
        .document("$productId")
        .updateData({"statusline": "$statuslist"});
    await _firestore
        .collection("CustomerUsers")
        .document(user)
        .collection("listclient")
        .document("$productId")
        .updateData({"statusline": "$statuslist"});
    await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("notific")
        .document("$productId")
        .delete();
    await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("notific")
        .document("$productId")
        .setData({
      "ownerId": widget.uid,
      "userId": user,
      "productId": productId,
      "timentpS": timentpS,
      "timentpE": timentpE,
      "timeFull": "$timeFullS",
      "kind": "$kind",
      "type": "$statusnotif",
      "timestamp": FieldValue.serverTimestamp(),
      "language": "$language"
    });
    await _firestore
        .collection("CustomerUsers")
        .document(user)
        .collection("notific")
        .document("$productId")
        .delete();
    await _firestore
        .collection("CustomerUsers")
        .document(user)
        .collection("notific")
        .document("$productId")
        .setData({
      "ownerId": user,
      "userId": widget.uid,
      "productId": productId,
      "timentpS": timentpS,
      "timentpE": timentpE,
      "timeFull": "$timeFullS",
      "kind": "$kind",
      "type": "$statusnotif",
      "timestamp": FieldValue.serverTimestamp(),
      "language": "$language"
    });
  }

  var myFeedbackText = "COULD BE BETTER";
  var sliderValue = 0.0;

  int cntlate = 0;
  int startTime;
  var stringS;
  Color myFeedbackColor = Colors.green;

  double _value = 0.0;
  // void _setvalue(double value) {
  //   setState(() {
  //     _value = value;
  //     cntlate = _value.toInt();
  //   });
  // }
  void showInSnackBar(
      String value, productId, user, timentpS, timentpE, timeFullS, kind) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      action: SnackBarAction(
        label: "${DemoLocalizations.of(context).yes}",
        onPressed: () {
          _breakProduct(productId, user, timentpS, timentpE, timeFullS, kind,
              DemoLocalizations.of(context).language);
          status();
        },
      ),
    ));
  }

  // Future _getUserData(userAdmin) async {
  //   final userDataQuery = await Firestore.instance
  //       .collection("CustomerUsers")
  //       .document(userAdmin)
  //       .get();

  //   return userDataQuery.data;
  // }
  Future _getUserData() async {
    QuerySnapshot userDataQuerySnapshot =
        await Firestore.instance.collection("CustomerUsers").getDocuments();

    for (DocumentSnapshot document in userDataQuerySnapshot.documents) {
      _users[document.documentID] = document.data;
    }
  }

  Future _getBarbers() async {
    QuerySnapshot q = await Firestore.instance
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("worker")
        .getDocuments();

    return q.documents;
  }

  final db = Firestore.instance;
  Future _getRecod() async {
    QuerySnapshot q = await db
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("record")
        .getDocuments();

    return q.documents;
  }

  Future _getProductsFuture;
  Future _getRecodFuture;
  Future _getBarbersFuture;
  Map<String, dynamic> _users = {};
  String _selection = '';
  Future onRefresh() async {
    await Future.delayed(Duration(microseconds: 200));
    setState(() {
      // _getProducts();
      _getProductsFuture = _getProducts();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(99, 138, 223, 1.0),
        title: Text('${DemoLocalizations.of(context).linestoday}'),
        centerTitle: true,
        actions: <Widget>[
          FutureBuilder(
              future: _getBarbersFuture,
              builder: (context, snapshot) {
                return RaisedButton(
                  onPressed: () {
                    try {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: <Widget>[
                                IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: Icon(Icons.close),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      _selection = '';
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                      '${DemoLocalizations.of(context).all}'),
                                )
                              ],
                              content: Container(
                                height: 400,
                                width: 400,
                                child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return FlatButton(
                                      color: Colors.grey[300],
                                      onPressed: () {
                                        setState(() {
                                          _selection =
                                              snapshot.data[index].data['name'];
                                          _getProductsFuture = _getProducts();
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                          snapshot.data[index].data['name']),
                                    );
                                  },
                                ),
                              ),
                            );
                          });
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text("${_selection.isNotEmpty ? _selection : "כולם"}"),
                );
              }),
        ],
      ),
      body: FutureBuilder(
          future: _getProductsFuture,
          builder: (BuildContext context, snapshots) {
            if (!snapshots.hasData) {
              return Container();
            }

            return FutureBuilder(
                future: _getRecodFuture,
                builder: (context, snapsh) {
                  if (!snapsh.hasData) {
                    return Container();
                  }
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          FlatButton.icon(
                            onPressed: () {
                              snapshots.data.forEach((doc) async {
                                String productId = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                var start = doc['timentpS'].toDate();
                                var end = doc['timentpE'].toDate();
                                start = start.add(Duration(minutes: cntlate));
                                end = end.add(Duration(minutes: cntlate));
                                _firestore
                                    .collection("AdminUsers")
                                    .document(widget.uid)
                                    .collection("listclient")
                                    .document(doc['productId'])
                                    .updateData({
                                  "timentpS": start,
                                  "timentpE": end,
                                  "timelate": doc['timelate'] + cntlate,
                                });
                                _firestore
                                    .collection("AdminUsers")
                                    .document(widget.uid)
                                    .collection("notific")
                                    .document(doc['productId'])
                                    .updateData({
                                  "timentpS": start,
                                  "timentpE": end,
                                  "type": "onlistlate",
                                  "timestamp": FieldValue.serverTimestamp(),
                                });
                                _firestore
                                    .collection("CustomerUsers")
                                    .document(doc['user'])
                                    .collection("listclient")
                                    .document(doc['productId'])
                                    .updateData({
                                  "timentpS": start,
                                  "timentpE": end,
                                });
                                // _firestore
                                //     .collection("CustomerUsers")
                                //     .document(doc['user'])
                                //     .collection("notific")
                                //     .document(doc['productId'])
                                //     .delete()
                                //     .whenComplete(() {
                                //   print('delete');
                                // });
                                _firestore
                                    .collection("CustomerUsers")
                                    .document(doc['user'])
                                    .collection("notific")
                                    .document(productId)
                                    .setData({
                                  "ownerId": doc['user'],
                                  "showbool": true,
                                  "userId": widget.uid,
                                  "productId": productId,
                                  "timeFull": doc['timeFull'],
                                  "kind": doc['kind'],
                                  "timentpS": start,
                                  "timentpE": end,
                                  "type": "onlistlate",
                                  "timestamp": FieldValue.serverTimestamp(),
                                  "timelate": doc['timelate'] + cntlate,
                                  "language":
                                      "${DemoLocalizations.of(context).language}"
                                }).whenComplete(() {
                                  print('set notifc');
                                });
                                // _firestore
                                //     .collection("CustomerUsers")
                                //     .document(doc['user'])
                                //     .collection("notific")
                                //     .document(doc['productId'])
                                //     .updateData({
                                //   "timentpS": start,
                                //   "timentpE": end,
                                //   "type": "onlistlate",
                                //   "timestamp": FieldValue.serverTimestamp(),
                                //   // "timelate": doc['timelate'] + cntlate,
                                // });
                              });

                              status();
                            },
                            label: Text(
                                "${DemoLocalizations.of(context).minute}  $cntlate  ${DemoLocalizations.of(context).update}"),
                            icon: Icon(Icons.update),
                          ),
                          Flexible(
                            flex: 2,
                            child: Slider(
                              min: 0.0,
                              max: 30.0,
                              divisions: 6,
                              value: _value,
                              activeColor: myFeedbackColor,
                              inactiveColor: Colors.blueGrey,
                              onChanged: (newValue) {
                                setState(() {
                                  _value = newValue;
                                  cntlate = _value.toInt();
                                  print(cntlate);
                                  if (_value >= 0.0 && _value <= 10.0) {
                                    myFeedbackColor = Colors.green;
                                    // myFeedbackText = "COULD BE BETTER";
                                  }
                                  if (_value >= 11.0 && _value <= 20.0) {
                                    myFeedbackColor = Colors.orange;
                                    // myFeedbackText = "COULD BE BETTER";
                                  }
                                  if (_value >= 21.0 && _value <= 30.0) {
                                    myFeedbackColor = Colors.red;
                                    // myFeedbackText = "COULD BE BETTER";
                                  }
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 5.0,
                                ),
                            itemCount: snapshots.data.length,
                            // itemExtent: 70,
                            itemBuilder: (BuildContext context, index) {
                              var document = snapshots.data[index].data;
                              var snapshot = _users[document['user']];
                              var user = document['user'];
                              var timentpS = document['timentpS'].toDate();
                              var timentpE = document['timentpE'].toDate();
                              String checkdays =
                                  DateFormat('d').format(timentpS);
                              String checkdoco =
                                  DateFormat('yMMM').format(timentpS);
                              var price = document['price'];

                              // return FutureBuilder(
                              //     future: _getUserData(
                              //         snapshots.data[index].data['user']),
                              //     builder: (context, snapshot) {
                              //       if (!snapshot.hasData) {
                              //         return Container();
                              //       }

                              return Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                actions: <Widget>[
                                  IconSlideAction(
                                    caption:
                                        "${DemoLocalizations.of(context).delete}",
                                    color: Colors.red,
                                    icon: Icons.delete,
                                    onTap: () {
                                      _deleProducts(
                                          document['productId'], user);
                                      var timeWorkingH =
                                          timentpE.hour - timentpS.hour;
                                      var timeWorkingM =
                                          timentpE.minute - timentpS.minute;
                                      var sumHours =
                                          timeWorkingH * 60 + timeWorkingM;
                                      for (var i = 0;
                                          i < snapsh.data.length;
                                          i++) {
                                        for (var j = 0;
                                            j <
                                                snapsh.data[i].data['dayswork']
                                                    .length;
                                            j++) {
                                          if (checkdays ==
                                              snapsh.data[i].data['dayswork'][j]
                                                  ['day']) {
                                            print("yay found day");

                                            var oldDaysWorkArray =
                                                snapsh.data[i].data["dayswork"];

                                            var oldDaysWorkToUpdate =
                                                oldDaysWorkArray[j];
                                            // var indexToUpdate = j;

                                            var allnameClinets =
                                                oldDaysWorkToUpdate[
                                                    "nameclients"];
                                            var allhours =
                                                oldDaysWorkToUpdate["sumhours"];
                                            var allprice =
                                                oldDaysWorkToUpdate["sumprice"];

                                            var oldNameClients =
                                                oldDaysWorkToUpdate[
                                                    "cancelnameclients"];

                                            var newNameClients = [];

                                            for (int daniel = 0;
                                                daniel < oldNameClients.length;
                                                daniel++) {
                                              newNameClients
                                                  .add(oldNameClients[daniel]);
                                            }

                                            newNameClients.add(snapshot[
                                                'userName']); // for demo

                                            var oldSumHours =
                                                oldDaysWorkToUpdate[
                                                    "cancelsumhours"];
                                            var newSumHours = oldSumHours +
                                                sumHours; // hours of day

                                            var oldSumPrice =
                                                oldDaysWorkToUpdate[
                                                    "cancelsumprice"];
                                            var newSumPrice = oldSumPrice +
                                                price; // price of day

                                            var sumhoursM = snapsh
                                                .data[i].data['sumhoursM'];
                                            var newSumHoursM = sumhoursM -
                                                sumHours; //hours of month

                                            var sumpriceM = snapsh
                                                .data[i].data['sumpriceM'];
                                            var newSumpriceM = sumpriceM -
                                                price; //price of month

                                            var newDaysWorkArray = [];

                                            for (int daniel = 0;
                                                daniel <
                                                    oldDaysWorkArray.length;
                                                daniel++) {
                                              if (daniel == j) {
                                                newDaysWorkArray.add({
                                                  "day": oldDaysWorkToUpdate[
                                                      "day"],
                                                  "cancelnameclients":
                                                      newNameClients,
                                                  "cancelsumhours": newSumHours,
                                                  "cancelsumprice": newSumPrice,
                                                  "nameclients": allnameClinets,
                                                  "sumhours": allhours,
                                                  "sumprice": allprice
                                                });
                                              } else {
                                                newDaysWorkArray.add(
                                                    oldDaysWorkArray[daniel]);
                                              }
                                            }

                                            print(newDaysWorkArray);
                                            db
                                                .collection("AdminUsers")
                                                .document(widget.uid)
                                                .collection("record")
                                                .document(checkdoco)
                                                .updateData({
                                              "sumhoursM": newSumHoursM,
                                              "sumpriceM": newSumpriceM,
                                              "dayswork": newDaysWorkArray,
                                            });

                                            //no found day
                                          }
                                        }
                                      }
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
                                                  "${snapshot['photoUrl']}"))),
                                      child: Text(
                                        "${snapshot['userName']}",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            background: Paint()),
                                      ),
                                    ),
                                    trailing: Column(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 10,
                                          backgroundColor:
                                              document['statusline'] != "ok"
                                                  ? document['statusline'] !=
                                                          "mitacev"
                                                      ? Colors.red
                                                      : Colors.orange
                                                  : Colors.green,
                                        ),
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundColor: Color(0xff002651),
                                          child: IconButton(
                                            onPressed: () async {
                                              url = "tel:" +
                                                  "${snapshot['phone']}";

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
                                      ],
                                    ),
                                    title: Text(
                                      "${DateFormat('Hm').format(snapshots.data[index].data['timentpS'].toDate()) + " - " + DateFormat('Hm').format(snapshots.data[index].data['timentpE'].toDate())}  ${snapshots.data[index].data['nameBarber']} \n${snapshots.data[index].data['kind']}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            statuslist = cancel;
                                            statusnotif = onlistcancel;
                                            showInSnackBar(
                                                'לבטל תור?',
                                                snapshots.data[index]
                                                    .data['productId'],
                                                user,
                                                snapshots.data[index]
                                                    .data['timentpS']
                                                    .toDate(),
                                                snapshots.data[index]
                                                    .data['timentpE']
                                                    .toDate(),
                                                snapshots.data[index]
                                                    .data['timeFull'],
                                                snapshots
                                                    .data[index].data['kind']);
                                          },
                                          child: Text(
                                            "ביטול",
                                            style: TextStyle(
                                                background: Paint()
                                                  ..color = Colors.red
                                                  ..style = PaintingStyle.stroke
                                                  ..strokeCap = StrokeCap.round,
                                                color: Colors.black),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            statuslist = mitacev;
                                            statusnotif = onlistlate;
                                            showInSnackBar(
                                                'לעכב תור?',
                                                snapshots.data[index]
                                                    .data['productId'],
                                                user,
                                                snapshots.data[index]
                                                    .data['timentpS']
                                                    .toDate(),
                                                snapshots.data[index]
                                                    .data['timentpE']
                                                    .toDate(),
                                                snapshots.data[index]
                                                    .data['timeFull'],
                                                snapshots
                                                    .data[index].data['kind']);
                                          },
                                          child: Text(
                                            "עיכוב",
                                            style: TextStyle(
                                                background: Paint()
                                                  ..color = Colors.orange[600]
                                                  ..style = PaintingStyle.stroke
                                                  ..strokeCap = StrokeCap.round,
                                                color: Colors.black),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            statuslist = ok;
                                            statusnotif = onlist;
                                            showInSnackBar(
                                                ' להפוך תור לזמין?',
                                                snapshots.data[index]
                                                    .data['productId'],
                                                user,
                                                snapshots.data[index]
                                                    .data['timentpS']
                                                    .toDate(),
                                                snapshots.data[index]
                                                    .data['timentpE']
                                                    .toDate(),
                                                snapshots.data[index]
                                                    .data['timeFull'],
                                                snapshots
                                                    .data[index].data['kind']);
                                          },
                                          child: Text(
                                            "בזמן",
                                            style: TextStyle(
                                                background: Paint()
                                                  ..color = Colors.green
                                                  ..style = PaintingStyle.stroke
                                                  ..strokeCap = StrokeCap.round,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                              // });
                              // });
                            }),
                      ),
                    ],
                  );
                });
          }),
    );
  }
}
