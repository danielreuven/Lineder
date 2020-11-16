import 'package:lineder/helpers/locale.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:intl/intl.dart';

class AddListNew extends StatefulWidget {
  AddListNew({
    this.uid,
  });
  String uid;

  @override
  _AddListNewState createState() => _AddListNewState();
}

class _AddListNewState extends State<AddListNew> {
  Firestore _firestore = Firestore.instance;
  Query q;
  QuerySnapshot querySnapshot;
  Future _getProductsSchedule() async {
    if (datetemp == datetemp) {
      q = _selection.isEmpty
          ? _firestore
              .collection("AdminUsers")
              .document(widget.uid)
              .collection("lineschedule")
              .where('timeFull', isEqualTo: datetemp)
              .where("status", isEqualTo: "ok")
          : _firestore
              .collection("AdminUsers")
              .document(widget.uid)
              .collection("lineschedule")
              .where('timeFull', isEqualTo: datetemp)
              .where("status", isEqualTo: "ok")
              .where("nameBarber", isEqualTo: _selection);

      querySnapshot = await q.getDocuments();
    }
    return querySnapshot.documents;
  }

  Future _getProductsKinds() async {
    QuerySnapshot q = await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("kind")
        .getDocuments();

    return q.documents;
  }

  Future _getProductsClient() async {
    QuerySnapshot q = await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("AdminAllClients")
        .getDocuments();

    return q.documents;
  }

  Future _getRecod() async {
    QuerySnapshot q = await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("record")
        .getDocuments();

    return q.documents;
  }

  var now;
  @override
  void initState() {
    super.initState();
    now = new DateTime.now();
    handleNewDate(now);
  }

  bool isLine = false;
  bool isClient = false;
  funcLine() {
    setState(() {
      this.isLine = true;
      isClient = false;
    });
  }

  funcClient() {
    setState(() {
      this.isClient = true;
      isLine = false;
    });
  }

  var datetemp;
  void handleNewDate(date) {
    print("handleNewDate $date");
    setState(() {
      datetemp = DateFormat('MMMEd').format(date);
      // print(datetemp);
    });
  }

  var timeStartBottom;
  var timeEndBottom;
  var timeFullBottom;

  var userClientID;
  var nameofclinet;
  var nameeBottom;
  var phoneeBottom;
  var imageeBottom;
  DateTime timentpS;
  DateTime timentpE;

  String kinschoice = '';
  var price;
  var currency;
  bool stat = false;
  void status() {
    setState(() {
      stat = !stat;

      print(stat);
    });
  }

  Widget calender() {
    return Calendar(
        showTodayAction: false,
        onSelectedRangeChange: (range) =>
            print("Range is ${range.item1}, ${range.item2}"),
        onDateSelected: (date) {
          handleNewDate(date);
          print("$date");
        });
  }

  var productIdS;

  Future _getUserData(userAdmin) async {
    final userDataQuery = await Firestore.instance
        .collection("CustomerUsers")
        .document(userAdmin)
        .get();

    return userDataQuery.data;
  }

  Future _getBarbers() async {
    QuerySnapshot q = await Firestore.instance
        // .collection(widget.country)
        // .document('${widget.uid}')
        // .collection("${widget.statusGrand}")
        // .document(widget.uid)
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("worker")
        .getDocuments();

    return q.documents;
  }

  String _selection = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          // title: Text(
          //   "Choice Time and client",
          // ),
          backgroundColor: Colors.black,
          actions: <Widget>[
            FutureBuilder(
                future: _getBarbers(),
                builder: (context, snapshot) {
                  return RaisedButton(
                    color: Colors.blue[100],
                    onPressed: () {
                      try {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                actions: <Widget>[
                                  IconButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
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
                                            _selection = snapshot
                                                .data[index].data['name'];
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
                    child: Text(
                        "${_selection.isNotEmpty ? _selection : DemoLocalizations.of(context).all}"),
                  );
                }),
          ],
          // leading: ,
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            calender(),
          ]),
        ),
        FutureBuilder(
            future: _getProductsSchedule(),
            builder: (BuildContext context, snapshots) {
              if (!snapshots.hasData) {
                return SliverPadding(
                  padding: EdgeInsets.all(10),
                );
              }

              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  // crossAxisSpacing: .5,
                  childAspectRatio: 3,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      // color: Colors.blue,
                      child: Column(
                        children: <Widget>[
                          snapshots.data[index].data['status'] != 'Break'
                              ? Card(
                                  color: timentpS ==
                                          snapshots.data[index].data['timentpS']
                                              .toDate()
                                      ? Colors.blue
                                      : Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        productIdS = snapshots
                                            .data[index].data['productId'];
                                        timeStartBottom = snapshots
                                            .data[index].data['timeStart']
                                            .toDate();
                                        timeEndBottom = snapshots
                                            .data[index].data['timeEnd']
                                            .toDate();
                                        // timeStartBottom = snapshots
                                        //     .data[index].data['timess'][2];
                                        // timeEndBottom = snapshots
                                        //     .data[index].data['timess'][3];
                                        timeFullBottom = snapshots
                                            .data[index].data['timeFull'];
                                        timentpS = snapshots
                                            .data[index].data['timentpS']
                                            .toDate();
                                        timentpE = snapshots
                                            .data[index].data['timentpE']
                                            .toDate();

                                        funcLine();
                                      },
                                      child: Text(
                                        "${DateFormat('Hm').format(snapshots.data[index].data['timentpS'].toDate())}"
                                            "  -  " +
                                            "${DateFormat('Hm').format(snapshots.data[index].data['timentpE'].toDate())}",
                                      ),
                                    ),
                                  ))
                              : Card()
                        ],
                      ),
                    );
                  },
                  childCount: snapshots.data.length,
                ),
              );
            }),
        FutureBuilder(
            future: _getProductsClient(),
            builder: (BuildContext context, snapshots) {
              if (!snapshots.hasData) {
                return SliverPadding(
                  padding: EdgeInsets.all(10),
                );
              }
              //  userClientID = snapshots.data[index].data['user'];
              //           nameeBottom = snapshots.data[index].data['name'];
              //           phoneeBottom = snapshots.data[index].data['phone'];
              //           imageeBottom = snapshots.data[index].data['images'];
              //           funcClient();
              return Container(
                child: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, childAspectRatio: 0.7),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return FutureBuilder(
                          future:
                              _getUserData(snapshots.data[index].data['user']),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            }

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  userClientID =
                                      snapshots.data[index].data['user'];
                                  nameofclinet = snapshot.data['userName'];
                                  print(nameofclinet);
                                  print(userClientID);
                                });
                              },
                              child: Card(
                                  elevation: 4.0,
                                  margin: EdgeInsets.all(20),
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                          color: userClientID !=
                                                  snapshots
                                                      .data[index].data['user']
                                              ? Colors.grey[100]
                                              : Colors.blue)),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: 40.0,
                                          height: 40.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: new CachedNetworkImageProvider(
                                                    "${snapshot.data['photoUrl']}"),
                                              )),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Text(
                                            "${snapshot.data['userName']}",
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.fade,
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            );
                          });
                    },
                    childCount: snapshots.data.length,
                  ),
                ),
              );
            }),
        FutureBuilder(
            future: _getProductsKinds(),
            builder: (BuildContext context, snapsho) {
              if (!snapsho.hasData) {
                return SliverPadding(
                  padding: EdgeInsets.all(10),
                );
              }

              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  // crossAxisSpacing: .5,
                  // childAspectRatio: 3,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Card(
                        color: kinschoice == snapsho.data[index].data['kind']
                            ? Colors.blue
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onDoubleTap: () {
                              setState(() {
                                kinschoice = '';
                              });
                            },
                            onTap: () {
                              setState(() {
                                kinschoice = snapsho.data[index].data['kind'];
                                currency = snapsho.data[index].data['currency'];
                                price = snapsho.data[index].data['price'];
                              });
                            },
                            child: Text("${snapsho.data[index].data['kind']}"),
                          ),
                        ));
                  },
                  childCount: snapsho.data.length,
                ),
              );
            }),
        FutureBuilder(
            future: _getRecod(),
            builder: (context, snapsh) {
              if (!snapsh.hasData) {
                return SliverPadding(
                  padding: EdgeInsets.all(10),
                );
              }
              return SliverList(
                delegate: SliverChildListDelegate(
                  [
                    RaisedButton(
                        color: Color(0xFF192d3f),
                        textColor: Colors.white,
                        splashColor: Colors.blueGrey,
                        child:
                            Text("${DemoLocalizations.of(context).createline}"),
                        onPressed: () {
                          if (userClientID == null ||
                              timeFullBottom == null ||
                              timentpS == null ||
                              _selection.isEmpty ||
                              kinschoice.isEmpty)
                            return;
                          else {
                            _firestore
                                .collection("AdminUsers")
                                .document(widget.uid)
                                .collection("listclient")
                                .document('$productIdS')
                                .setData({
                              "productId": "$productIdS",
                              "adminUser": "${widget.uid}",
                              "nameBarber": "$_selection",
                              "startTime": timeStartBottom,
                              "endTime": timeEndBottom,
                              "timeFull": "$timeFullBottom",
                              "user": "$userClientID",
                              "timentpS": timentpS,
                              "timentpE": timentpE,
                              "status": "onList",
                              "statusline": "ok",
                              "kind": "$kinschoice",
                              "price": price,
                              "timelate": 0,
                            });
                            _firestore
                                .collection("CustomerUsers")
                                .document(userClientID)
                                .collection("listclient")
                                .document('$productIdS')
                                .setData({
                              "productId": "$productIdS",
                              "adminUser": "$userClientID",
                              "nameBarber": "$_selection",
                              "startTime": timeStartBottom,
                              "endTime": timeEndBottom,
                              "timeFull": "$timeFullBottom",
                              "user": "${widget.uid}",
                              "timentpS": timentpS,
                              "timentpE": timentpE,
                              "status": "onList",
                              "statusline": "ok",
                              "kind": "$kinschoice",
                            });
                            _firestore
                                .collection("AdminUsers")
                                .document(widget.uid)
                                .collection("lineschedule")
                                .document(productIdS)
                                .updateData({
                              "status": "onList",
                            });
                            _firestore
                                .collection("AdminUsers")
                                .document(widget.uid)
                                .collection("notific")
                                .document("$productIdS")
                                .setData({
                              "productId": "$productIdS",
                              "ownerId": "${widget.uid}",
                              "startTime": timeStartBottom,
                              "endTime": timeEndBottom,
                              "timeFull": "$timeFullBottom",
                              "userId": "$userClientID",
                              "timentpS": timentpS,
                              "timentpE": timentpE,
                              "type": "onlist",
                              "timestamp": FieldValue.serverTimestamp(),
                              "kind": "$kinschoice",
                              "showbool": true,
                                 "language":"${DemoLocalizations.of(context).language}"
                            });
                            _firestore
                                .collection("CustomerUsers")
                                .document(userClientID)
                                .collection("notific")
                                .document("$productIdS")
                                .setData({
                              "productId": "$productIdS",
                              "ownerId": "$userClientID",
                              "startTime": timeStartBottom,
                              "endTime": timeEndBottom,
                              "timeFull": "$timeFullBottom",
                              "userId": "${widget.uid}",
                              "timentpS": timentpS,
                              "timentpE": timentpE,
                              "type": "onlist",
                              "timestamp": FieldValue.serverTimestamp(),
                              "kind": "$kinschoice",
                              "showbool": true,
                                 "language":"${DemoLocalizations.of(context).language}"
                            });
                            var timeWorkingH = timentpE.hour - timentpS.hour;
                            var timeWorkingM =
                                timentpE.minute - timentpS.minute;
                            var sumHours = timeWorkingH * 60 + timeWorkingM;
                            String checkdays = DateFormat('d').format(timentpS);
                            String checkdoco =
                                DateFormat('yMMM').format(timentpS);
                            if (snapsh.data.length == 0) {
                              print("first docoment");
                              // String currency = document['currency'];
                              List oldDaysWorkArray = [];

                              var newDays = {};
                              newDays.addAll({
                                "day": "$checkdays",
                                "nameclients": ['$nameofclinet'],
                                "sumhours": sumHours,
                                "sumprice": price,
                                "cancelsumhours": 0,
                                "cancelsumprice": 0,
                                "cancelnameclients": [],
                              });

                              oldDaysWorkArray.add(newDays);
                              print(oldDaysWorkArray);

                              _firestore
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
                              }).whenComplete(() {
                                print("Done");
                              });
                            } else {
                              for (var i = 0; i < snapsh.data.length; i++) {
                                //check docoments
                                if (checkdoco ==
                                    snapsh.data[i].data['productId']) {
                                  print("yay found docoment");

                                  ///check days
                                  for (var j = 0;
                                      j <
                                          snapsh
                                              .data[i].data['dayswork'].length;
                                      j++) {
                                    ///check days

                                    //found day
                                    if (checkdays ==
                                        snapsh.data[i].data['dayswork'][j]
                                            ['day']) {
                                      print("yay found day");

                                      var oldDaysWorkArray =
                                          snapsh.data[i].data["dayswork"];

                                      var oldDaysWorkToUpdate =
                                          oldDaysWorkArray[j];
                                      // var indexToUpdate = j;

                                      var oldNameClients =
                                          oldDaysWorkToUpdate["nameclients"];

                                      var newNameClients = [];
                                      for (int daniel = 0;
                                          daniel < oldNameClients.length;
                                          daniel++) {
                                        newNameClients
                                            .add(oldNameClients[daniel]);
                                      }

                                      newNameClients
                                          .add('$nameofclinet'); // for demo

                                      var oldSumHours =
                                          oldDaysWorkToUpdate["sumhours"];
                                      var newSumHours = oldSumHours +
                                          sumHours; // hours of day

                                      var oldSumPrice =
                                          oldDaysWorkToUpdate["sumprice"];
                                      var newSumPrice =
                                          oldSumPrice + price; // price of day

                                      var sumhoursM =
                                          snapsh.data[i].data['sumhoursM'];
                                      var newSumHoursM =
                                          sumhoursM + sumHours; //hours of month

                                      var sumpriceM =
                                          snapsh.data[i].data['sumpriceM'];
                                      var newSumpriceM =
                                          sumpriceM + price; //price of month

                                      var newDaysWorkArray = [];

                                      for (int daniel = 0;
                                          daniel < oldDaysWorkArray.length;
                                          daniel++) {
                                        if (daniel == j) {
                                          newDaysWorkArray.add({
                                            "day": oldDaysWorkToUpdate["day"],
                                            "nameclients": newNameClients,
                                            "sumhours": newSumHours,
                                            "sumprice": newSumPrice,
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
                                          newDaysWorkArray
                                              .add(oldDaysWorkArray[daniel]);
                                        }
                                      }

                                      print(newDaysWorkArray);
                                      _firestore
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
                                    } else if (checkdays !=
                                            snapsh.data[i].data['dayswork'][j]
                                                ['day'] &&
                                        j ==
                                            snapsh.data[i].data['dayswork']
                                                    .length -
                                                1) {
                                      print("no found day");
                                      var sumhoursM =
                                          snapsh.data[i].data["sumhoursM"];
                                      var sumpriceM =
                                          snapsh.data[i].data["sumpriceM"];
                                      List oldDaysWorkArray = [];
                                      oldDaysWorkArray.addAll(
                                          snapsh.data[i].data["dayswork"]);
                                      var newDays = {};
                                      newDays.addAll({
                                        "day": "$checkdays",
                                        "nameclients": ['$nameofclinet'],
                                        "sumhours": sumHours,
                                        "sumprice": price,
                                        "cancelnameclients": [],
                                        "cancelsumhours": 0,
                                        "cancelsumprice": 0,
                                      });

                                      oldDaysWorkArray.add(newDays);

                                      _firestore
                                          .collection("AdminUsers")
                                          .document(widget.uid)
                                          .collection("record")
                                          .document(checkdoco)
                                          .updateData({
                                        "sumhoursM": sumhoursM + sumHours,
                                        "sumpriceM": sumpriceM + price,
                                        "dayswork": oldDaysWorkArray,
                                      });
                                    }
                                  }
                                } else {
                                  print("no found docoment");
                                  // String currency =
                                  //     document['currency'];
                                  List oldDaysWorkArray = [];

                                  var newDays = {};
                                  newDays.addAll({
                                    "day": "$checkdays",
                                    "nameclients": ['$nameofclinet'],
                                    "sumhours": sumHours,
                                    "sumprice": price,
                                    "cancelnameclients": [],
                                    "cancelsumhours": 0,
                                    "cancelsumprice": 0,
                                  });

                                  oldDaysWorkArray.add(newDays);
                                  print(oldDaysWorkArray);

                                  _firestore
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
                                  }).whenComplete(() {
                                    print("Done");
                                  });
                                }
                              }
                            }
                            Navigator.of(context).pop();
                          }
                        })
                  ],
                ),
              );
            }),
      ],
    ));
  }
}
