import 'dart:async';

// import 'package:analog_time_picker/analog_time_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:intl/intl.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:lineder/user/appointment/mybarber.dart';
import 'package:lineder/user/homepageuser/homepageuser.dart';

class AppointmentMake extends StatefulWidget {
  final String uid;

  final String userAdmin;

  final ValueChanged<Map> onChanged;
  AppointmentMake({this.uid, this.userAdmin, Key key, this.onChanged})
      : super(key: key);

  @override
  _AppointmentMakeState createState() => _AppointmentMakeState();
}

class _AppointmentMakeState extends State<AppointmentMake> {
  Color backgroundColor = Colors.amber[100];
  Color firstCircleColor = Colors.amber[50];
  DateTime selected;
  // Map<String, DateTime> _dateTime = new Map();
  DateTime colckTime = DateTime.now();
  // List<DateModel> dateList = new List<DateModel>();

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _scaffoldKeyYY = new GlobalKey<ScaffoldState>();

  // VoidCallback _closearrow;
  // VoidCallback _showTime;

  // VoidCallback _showPersBottomSheetCallBackToday_1;

  Firestore _firestore = Firestore.instance;
  // var imagesss =
  //     "https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940";

  // var phoneee = "05005050505050";

  var tempTime;

  var timechoicenow;
  // var timechoicenEnd;
  var timeDatechoice;
  var timeDatechoicee;
  var kindHair;

  var kindDuration;
  var kindDurationBeard;

  DateTime timeStartInt;
  DateTime timeEndInt;

  var timeSumM;
  var timeSumH;

  var timeSumDuration;

  // var kindExtra;
  // String hairMan = 'גבר';
  // String hairBeard = 'גבר כולל זקן';
  // String hairKids = 'ילד';
  // String hairWomen = 'נשים';
  // String hairWomenFan = 'נשים כולל פן';
  // String hairFan = 'פן';
  // String hairHaclaca = 'החלקה';

  var kindHairPrice;
  var kindHairCurrency;

  var timentpS;
  var timentpE;

  // bool isSellec = false;
  // bool isSellect = false;
  // bool isSellectt = false;

  // bool selcetBread = false;
  // bool tempBool = false;

  var timelocal;

  void showInSnack(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  void showInSnackBarYY(String value) {
    _scaffoldKeyYY.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  void _buildSumDur() {
    // timeStartInt = timestart;
    // timeEndInt = timeend;
    print(timeStartInt);
    print(timeEndInt);
    timeSumH = (timeEndInt.hour - timeStartInt.hour) * 60;
    timeSumM = timeSumH + (timeEndInt.minute - timeStartInt.minute);
    if (timeSumM < 0) {
      timeSumM = timeSumM * (-1);
    }
    print("${DateFormat('Hm').format(timeStartInt)}");

    print("${DateFormat('Hm').format(timeEndInt)}");
    print(timeSumH);
    print(timeSumM);

    timeSumDuration = timeSumM - kindDuration;
    if (timeSumDuration < 0) {
      timeSumDuration = timeSumDuration * (-1);
    }
    print(timeSumDuration);
    timeEndInt = timeEndInt.add(Duration(minutes: timeSumDuration));
    if (timeEndInt.millisecondsSinceEpoch >
            indexNextStart.millisecondsSinceEpoch &&
        indexNextStatus != "ok") {
      try {
        showInSnackBarYY("${DemoLocalizations.of(context).choocelineorkind}");
      } catch (e) {
        print(e);
      }

      // _showPersBottomSheetCallBackToday_1();
    }
  }

  Future _getProductsNew() async {
    Query q = db
        .collection("AdminUsers")
        .document(widget.userAdmin)
        .collection("lineschedule")
        .where("timeFull", isEqualTo: timelocal)
        .where("nameBarber", isEqualTo: myBarberChoice);

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  Future _getKinds() async {
    QuerySnapshot q = await Firestore.instance
        .collection("AdminUsers")
        .document(widget.userAdmin)
        .collection("kind")
        .getDocuments();

    return q.documents;
  }

  Future _getBarbers() async {
    QuerySnapshot q = await Firestore.instance
        .collection("AdminUsers")
        .document(widget.userAdmin)
        .collection("worker")
        .getDocuments();

    return q.documents;
  }

  Future _getProductsStatus() async {
    Query q = db
        .collection("AdminUsers")
        .document(widget.userAdmin)
        .collection("lineschedule")
        .where("timeFull", isEqualTo: timelocal)
        .where("status", isEqualTo: "ok");

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  Future onRefresh() async {
    await Future.delayed(Duration(microseconds: 200));
    setState(() {
      _getProductsNew();
      // _getProductsToRequest();
      _getProductsToKinds();

      // selcetBread == true || tempBool == true ? _showTimeChoice() : Container();
    });
    return Container();
  }

  Future onRef() async {
    await Future.delayed(Duration(microseconds: 200));
    setState(() {
      _showTimeChoice();
    });
    return Container();
  }

  Future onR() async {
    await Future.delayed(Duration(microseconds: 200));
    setState(() {
      _showBottomSheetToday_1();
    });
    return Container();
  }

  _ssetProductsRequst(productId) async {
    // String productId = DateTime.now().millisecondsSinceEpoch.toString();
    await _firestore
        .collection("AdminUsers")
        .document('${widget.userAdmin}')
        .collection("requestTolist")
        .document('$productId')
        .setData({
      "productId": "$productId",
      "user": "${widget.uid}",
      "adminUser": "${widget.userAdmin}",
      "nameBarber": "$myBarberChoice",
      "timeFull": "$timeDatechoice",
      "kind": "$kindHair",
      "currency": "$kindHairCurrency",
      "price": kindHairPrice,
      "startTime": "$timechoicenow",
      "endTime": "${DateFormat('Hm').format(timeEndInt)}",
      "timentpS": timentpS,
      "timentpE": timeEndInt,
      "status": "request",
      "statusline": "ok",
      "timestamp": FieldValue.serverTimestamp(),
    });
    await _firestore
        .collection("CustomerUsers")
        .document('${widget.uid}')
        .collection("requestTolist")
        .document('$productId')
        .setData({
      "productId": "$productId",
      "user": "${widget.uid}",
      "adminUser": "${widget.userAdmin}",
      "nameBarber": "$myBarberChoice",
      "timeFull": "$timeDatechoice",
      "kind": "$kindHair",
      "currency": "$kindHairCurrency",
      "price": kindHairPrice,
      "startTime": "$timechoicenow",
      "endTime": "${DateFormat('Hm').format(timeEndInt)}",
      "timentpS": timentpS,
      "timentpE": timeEndInt,
      "status": "request",
      "statusline": "ok",
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  deleteProductRequst(String productId) {
    _firestore.collection("requestTolist").getDocuments();
    _firestore
        .collection("requestTolist")
        .document('$productId')
        .delete()
        .whenComplete(() {
      print("deleteproducts requestTolist");
    });
  }

  // Future _getProductsToRequest() async {
  //   Query q = _firestore
  //       .collection("requestTolist")
  //       .where("adminUser", isEqualTo: widget.userAdmin);

  //   QuerySnapshot querySnapshot = await q.getDocuments();
  //   return querySnapshot.documents;
  // }

  Future _getProductsToKinds() async {
    Query q = _firestore
        .collection("AdminUsers")
        .where("adminUser", isEqualTo: widget.uid);

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  Future _checkrequest() async {
    Query q = db
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("requestTolist")
        .where("adminUser", isEqualTo: widget.userAdmin);

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  // Future _getUserData(userAdmin) async {
  //   final userDataQuery = await Firestore.instance
  //       .collection("CustomerUsers")
  //       .document(widget.uid)
  //       .get();

  //   return userDataQuery.data;
  // }

  @override
  void initState() {
    super.initState();
    _getProductsNew();
    // _showPersBottomSheetCallBackToday_1 = _showBottomSheetToday_1;
    // _showTime = _showTimeChoice;
  }

  final db = Firestore.instance;

  void _buildShowDialog() {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('בחר אחד מהסוגים'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    child: Container(
                      height: 50,
                      color: Colors.white24,
                      child: Text(
                        "שם עובד וסוג עבודה",
                        style:
                            TextStyle(fontSize: 24, color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('אוקי'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  // void _closeContaner() {
  //   setState(() {
  //     _closearrow = null;

  //     print("closse");
  //   });
  // _scaffoldKey.currentState.closed.whenComplete(() {
  //   if (mounted) {
  //     setState(() {
  //       _closearrow = _closeContaner;
  //     });
  //   }
  // });
  // _scaffoldKey.currentState
  //     .showBottomSheet((context) {
  //       return Container();
  //     })
  //     .closed
  //     .whenComplete(() {
  //       if (mounted) {
  //         setState(() {
  //           _closearrow = _closeContaner;
  //         });
  //       }
  //     });
  // }

  var timeFullcheck;
  var kindCheck;

  _updateone() {
    db
        .collection("AdminUsers")
        .document(widget.userAdmin)
        .collection("lineschedule")
        .document(indexone)
        .updateData({"timentpE": timeEndInt, "status": "request"});
  }

  _updatenext() {
    db
        .collection("AdminUsers")
        .document(widget.userAdmin)
        .collection("lineschedule")
        .document(indexnext)
        .updateData({
      "timentpS": timeEndInt,
    });
  }

  _updatebefore() {
    db
        .collection("AdminUsers")
        .document(widget.userAdmin)
        .collection("lineschedule")
        .document(indexbefore)
        .updateData({
      "timentpE": timeStartInt,
    });
  }

  _setNotification(prdocutId) {
    db
        .collection("AdminUsers")
        .document(widget.userAdmin)
        .collection("notific")
        .document(prdocutId)
        .setData({
      "ownerId": widget.userAdmin,
      // "username": "$namee",
      "userId": widget.uid,
      "type": "requestline",
      // "userProfileImg": "$photo",
      "timestamp": FieldValue.serverTimestamp(),
      "productId": prdocutId,
      "timentpS": timentpS,
      "timentpE": timeEndInt,
      "timeFull": "$timeDatechoice",
      "kind": "$kindHair",
      "showbool": true,
      "language": "${DemoLocalizations.of(context).language}"
    });
  }

  Color colorG = Color(0xFFebf8f3);
  void _showTimeChoice() {
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: MediaQuery.of(context).size.height - 200,
                // color: Colors.blue,
                child: Column(
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // _showPersBottomSheetCallBackToday_1();
                          // selcetBread = false;
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_right,
                          size: 40,
                          color: Colors.black54,
                        )),
                    Text(
                      " ${DemoLocalizations.of(context).request}\n $myBarberChoice",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("${DemoLocalizations.of(context).date}"),
                        Text("${DemoLocalizations.of(context).time}")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Card(color: colorG, child: Text("$timeDatechoicee ")),
                        Card(
                          color: colorG,
                          child: Text(
                            "${DateFormat('Hm').format(timeEndInt)} - $timechoicenow ",
                          ),
                        )
                      ],
                    ),
                    ListTile(
                      title: Card(
                          color: colorG,
                          child: Text(
                            "  $kindHair  ",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          )),
                      // leading: Column(
                      //   children: <Widget>[
                      //     CircleAvatar(
                      //       radius: 20,
                      //       backgroundImage: NetworkImage(photo),
                      //     ),
                      //     Text(
                      //       "$namee",
                      //       style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      //     ),
                      //   ],
                      // ),
                      trailing: Text(
                        "${kindHairPrice != null ? "$kindHairCurrency" "$kindHairPrice" : ""}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      child: RaisedButton.icon(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.blue[600],
                        onPressed: () async {
                          try {
                            await _updateone();
                            await _updatenext();
                            await _updatebefore();

                            await _setNotification(indexone);
                            await _ssetProductsRequst(indexone);
                            // _closeContaner();
                            // showInSnack("נשלח בקשה לעסק");
                            // onRefresh();
                            // Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserHomePage(
                                          uid: widget.uid,
                                        )));
                          } catch (e) {
                            print(e);
                          }
                        },
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: Text(
                          "${DemoLocalizations.of(context).sentrequest}",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.3,
                              fontSize: 18),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
    //   setState(() {
    //     _showTime = null;
    //   });
    //   _scaffoldKeyYY.currentState
    //       .showBottomSheet((context) {
    //         return
    //       })
    //       .closed
    //       .whenComplete(() {
    //         if (mounted) {
    //           setState(() {
    //             _showTime = _showTimeChoice;
    //           });
    //         }
    //       });
  }

  var indexone;
  var indexnext;
  var indexbefore;

  var indexNextStart;
  var indexNextStatus;
  var adminId;

  // var prodcutIdr;
//////////////////////////////cobe  /////////////

  void _showBottomSheetToday_1() {
    // setState(() {
    //   _showPersBottomSheetCallBackToday_1 = null;
    // });

    // _scaffoldKey.currentState
    //     .showBottomSheet((context) {
    //       return
    showDialog(
        context: context,
        builder: (context) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: Scaffold(
              key: _scaffoldKeyYY,
              body: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.grey[100],
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // _closeContaner();
                              },
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: 40,
                                color: Colors.black54,
                              ))
                        ],
                      ),
                      Expanded(
                        child: FutureBuilder(
                            future: _getProductsNew(),
                            builder: (BuildContext context, snapshots) {
                              if (!snapshots.hasData) {
                                return Center(
                                  child: Text("loading"),
                                );
                              }

                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshots.data.length,
                                  itemBuilder: (BuildContext context, index) {
                                    var documnet = snapshots.data[index].data;
                                    var length = snapshots.data.length - 1;
                                    return documnet['status'] == "ok"
                                        ? FutureBuilder(
                                            future: _checkrequest(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Container();
                                              }
                                              // snapshot.data.forEach((doc) {
                                              //   timeFullcheck = doc['timeFull'];
                                              //   kindCheck = doc['kind'];
                                              //   adminId = doc['adminUser'];
                                              //   // userId = doc['user'];
                                              // });
                                              return Container(
                                                  child: Card(
                                                shape: Border.all(
                                                    color: Colors.black12),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: ListTile(
                                                    onTap: () {
                                                      bool hadrequestbool =
                                                          false;
                                                      for (var i = 0;
                                                          i <
                                                              snapshot
                                                                  .data.length;
                                                          i++) {
                                                        if (snapshots
                                                                        .data[index]
                                                                        .data[
                                                                    'timeFull'] ==
                                                                snapshot.data[i]
                                                                        .data[
                                                                    'timeFull'] &&
                                                            snapshots
                                                                        .data[index]
                                                                        .data[
                                                                    'nameBarber'] ==
                                                                snapshot.data[i]
                                                                        .data[
                                                                    'nameBarber']) {
                                                          print("yes");
                                                          hadrequestbool = true;
                                                        }
                                                      }
                                                      if (hadrequestbool ==
                                                          true) {
                                                        showInSnackBarYY(
                                                            "קיים תור במערכת בחר יום אחר");
                                                      } else {
                                                        timeStartInt =
                                                            documnet['timentpS']
                                                                .toDate();
                                                        timeEndInt =
                                                            documnet['timentpE']
                                                                .toDate();

                                                        indexbefore = snapshots
                                                            .data[index != 0
                                                                ? index - 1
                                                                : index]
                                                            .data['productId'];

                                                        indexone = snapshots
                                                            .data[index]
                                                            .data['productId'];

                                                        indexnext = snapshots
                                                            .data[
                                                                index != length
                                                                    ? index + 1
                                                                    : index]
                                                            .data['productId'];

                                                        indexNextStart =
                                                            snapshots
                                                                .data[index !=
                                                                        length
                                                                    ? index + 1
                                                                    : index]
                                                                .data[
                                                                    'timentpS']
                                                                .toDate();
                                                        indexNextStatus =
                                                            snapshots
                                                                .data[index !=
                                                                        length
                                                                    ? index + 1
                                                                    : index]
                                                                .data['status'];

                                                        timechoicenow =
                                                            "${DateFormat('Hm').format(snapshots.data[index].data['timentpS'].toDate())}";
                                                        timeDatechoice =
                                                            snapshots
                                                                    .data[index]
                                                                    .data[
                                                                'timeFull'];
                                                        timeDatechoicee = DateFormat(
                                                                'MMMEd',
                                                                DemoLocalizations.of(
                                                                        context)
                                                                    .language)
                                                            .format(snapshots
                                                                .data[index]
                                                                .data[
                                                                    'timentpS']
                                                                .toDate());

                                                        timentpS = snapshots
                                                            .data[index]
                                                            .data['timentpS'];
                                                        timentpE = snapshots
                                                            .data[index]
                                                            .data['timentpE'];
                                                        _buildSumDur();
                                                        _showTimeChoice();
                                                      }
                                                    },
                                                    title: Text(
                                                      "${DateFormat('MMMEd', DemoLocalizations.of(context).language).format(snapshots.data[index].data['timentpS'].toDate())}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    subtitle: Text(
                                                      "${DateFormat('Hm').format(snapshots.data[index].data['timentpS'].toDate())}",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    trailing: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 30, top: 6),
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                            Icons
                                                                .keyboard_arrow_right,
                                                            color: Colors
                                                                .blue[600]),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                color: Colors.white,
                                              ));
                                            })
                                        : Container();
                                  });
                            }),
                      ),
                    ],
                  )),
            ),
          );
        });

    // })
    // .closed
    // .whenComplete(() {
    //   if (mounted) {
    //     setState(() {
    //       _showPersBottomSheetCallBackToday_1 = _showBottomSheetToday_1;
    //     });
    //   }
    // });
  }

  var datetemp;
  void handleNewDate(date) {
    print("handleNewDate $date");

    setState(() {
      datetemp = DateFormat('MMMEd').format(date);
      print(datetemp);

      timelocal = datetemp;
      // _showPersBottomSheetCallBackToday_1();
    });
  }

  int cntlate = 0;
  List arrystart = [];
  List arryend = [];
  List arryAll = [];
  String myChoice;
  bool isMan = false;
  funcMan(kind, duration, price, curr) {
    if (duration != null) {
      setState(() {
        myChoice = kind;
        kindHair = kind;

        isMan = true;
      });
      kindDuration = duration;
      kindHairPrice = price;
      kindHairCurrency = curr;
    }
  }

  funcFlaseall() {
    setState(() {
      kindHair = null;
      myChoice = '';
    });
  }

  String myBarberChoice = '';
  funcBarber(
    name,
  ) {
    if (name != null) {
      setState(() {
        myBarberChoice = name;
      });
    }
  }

  funcFlaseallBarber() {
    setState(() {
      myBarberChoice = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          FutureBuilder(
              future: _getProductsStatus(),
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return SliverPadding(
                    padding: EdgeInsets.all(10),
                  );
                }
                return SliverList(
                  delegate: SliverChildListDelegate([
                    Calendar(
                        showTodayAction: false,
                        onSelectedRangeChange: (range) =>
                            print("Range is ${range.item1}, ${range.item2}"),
                        // isExpandable: true,
                        onDateSelected: (date) {
                          handleNewDate(date);
                        }),
                    timelocal != null
                        ? RaisedButton.icon(
                            onPressed: () {
                              if (snapshots.data.length == 0) return;
                              if (kindHair == null ||
                                  myBarberChoice.isEmpty ||
                                  myBarberChoice.isEmpty) {
                                _buildShowDialog();
                              } else {
                                // _showPersBottomSheetCallBackToday_1();
                                _showBottomSheetToday_1();
                              }
                            },
                            label: Text(
                              " ${snapshots.data.length}  ${DemoLocalizations.of(context).lines} ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            icon: Icon(
                              Icons.navigate_before,
                              color: Colors.blue[800],
                              size: 26,
                            ),
                          )
                        : Container(),
                  ]),
                );
              }),
          FutureBuilder(
            future: _getBarbers(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SliverPadding(
                  padding: EdgeInsets.all(12),
                );
              }
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 1.0),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final name = snapshot.data[index].data['name'];

                  return InkWell(
                    onDoubleTap: funcFlaseallBarber,
                    onTap: () {
                      funcBarber(
                        name,
                      );
                    },
                    child: Card(
                      color: myBarberChoice == name
                          ? Colors.blue[200]
                          : Colors.white,
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }, childCount: snapshot.data.length),
              );
            },
          ),
          FutureBuilder(
              future: _getKinds(),
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return SliverPadding(
                    padding: EdgeInsets.all(12),
                  );
                }
                return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, childAspectRatio: 1.0),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      var document = snapshots.data[index].data;
                      final kind = document['kind'];
                      final duration = document['duration'];
                      final price = document['price'];
                      final currency = document['currency'];
                      return GestureDetector(
                        onDoubleTap: funcFlaseall,
                        onTap: () {
                          funcMan(kind, duration, price, currency);
                        },
                        child: Card(
                          color: myChoice == kind
                              ? Colors.purple[200]
                              : Colors.white,
                          elevation: 4.0,
                          child: Center(
                            child: Text(
                              "$kind",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }, childCount: snapshots.data.length));
              }),
        ],
      ),
    );
  }
}
