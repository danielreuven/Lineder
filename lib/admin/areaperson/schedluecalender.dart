import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lineder/admin/listclient/addlistnew.dart';
import 'package:lineder/admin/listclient/requstlist.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:url_launcher/url_launcher.dart';

class ScheduleCalender extends StatefulWidget {
  final uid;
  final data5;

  ScheduleCalender({
    this.uid,
    this.data5,
  });
  @override
  _ScheduleCalenderState createState() => _ScheduleCalenderState();
}

class _ScheduleCalenderState extends State<ScheduleCalender> {
  final db = Firestore.instance;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  VoidCallback _showPersBottomSheetCallBack;

  Future onRefresh() async {
    await Future.delayed(Duration(microseconds: 200));
    setState(() {
      // _getProducts();
      _getProductsAdmin();
    });
    return null;
  }

  Future onRefreshBottom() async {
    await Future.delayed(Duration(microseconds: 200));
    setState(() {
      _showBottomSheet();
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    // _updateTime();
    var now = new DateTime.now();
    handleNewDate(now);
    _showPersBottomSheetCallBack = _showBottomSheet;
    _getProductsRequestFuture = _getProductsRequest();
    _getBarbersFuture = _getBarbers();
    _getRecodFuture = _getRecod();
    // _getProducts();
  }

  Future _getProductsRequestFuture;
  Future _getBarbersFuture;
  Future _getRecodFuture;
  Map<String, dynamic> _users = {};
  Future _getUserData() async {
    QuerySnapshot userDataQuerySnapshot =
        await Firestore.instance.collection("CustomerUsers").getDocuments();
    // .document(userAdmin)
    // .get();

    for (DocumentSnapshot document in userDataQuerySnapshot.documents) {
      _users[document.documentID] = document.data;
    }
  }
  // _deleProducts(String productId) {
  //   db
  //       .collection("AdminUsers")
  //       .document(widget.uid)
  //       .collection("listclient")
  //       .document("$productId")
  //       .delete()
  //       .whenComplete(() {
  //     print("deleteProduct listclient");
  //   });
  // }

  _deleProductsNewLine(String productId) {
    db
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("listclient")
        .document("$productId")
        .delete()
        .whenComplete(() {
      print("deleteProduct listclient");
    });
    db
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("lineschedule")
        .document("$productId")
        .updateData({"status": "ok"});
  }

  Future _getProductsRequest() async {
    QuerySnapshot q = await db
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("requestTolist")
        .getDocuments();

    return q.documents;
    // setState(() {
    //   _loadingProducts = false;
    // });
  }

  Query q;
  QuerySnapshot querySnapshot;
  Future _getProductsAdmin() async {
    await _getUserData();
    if (timelocal == timelocal) {
      q = _selection.isEmpty
          ? db
              .collection("AdminUsers")
              .document(widget.uid)
              .collection("listclient")
              .where("timeFull", isEqualTo: timelocal)
          : db
              .collection("AdminUsers")
              .document(widget.uid)
              .collection("listclient")
              .where("timeFull", isEqualTo: timelocal)
              .where("nameBarber", isEqualTo: _selection);

      querySnapshot = await q.getDocuments();
    }
    return querySnapshot.documents;
  }

  void _showBottomSheet() {
    setState(() {
      _showPersBottomSheetCallBack = null;
    });

    _scaffoldKey.currentState
        .showBottomSheet((context) {
          return AddListNew(
            uid: widget.uid,
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showPersBottomSheetCallBack = _showBottomSheet;
            });
          }
        });
  }

  var datetemp;
  var timelocal;
  var datetime;
  void handleNewDate(date) {
    print("handleNewDate $date");

    setState(() {
      datetemp = date;

      datetime = DateFormat('MMMEd').format(date);
      timelocal = DateFormat('MMMEd').format(date);

      // _showPersBottomSheetCallBackToday_1();
    });
  }

  // DateTime _currentTime;
  // DateTime _ntpTime;
  // // int _ntpOffset;

  // void _updateTime() async {
  //   _currentTime = await NTP.now();

  //   _ntpTime = await NTP.now();

  //   datetime = DateFormat('MMMEd').format(_currentTime);
  //   setState(() {
  //     timelocal = DateFormat('MMMEd').format(_currentTime);
  //   });

  //   datetemp = _currentTime;
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  var url;
  // Future<bool> _onWillPop() {
  //   return
  // }

  // Future _getUserData(userAdmin) async {
  //   final userDataQuery = await Firestore.instance
  //       .collection("CustomerUsers")
  //       .document(userAdmin)
  //       .get();

  //   return userDataQuery.data;
  // }

  Future _getBarbers() async {
    QuerySnapshot q = await Firestore.instance
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("worker")
        .getDocuments();

    return q.documents;
  }

  Future _getRecod() async {
    QuerySnapshot q = await db
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("record")
        .getDocuments();

    return q.documents;
  }

  String _selection = '';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              try {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AddListNew(
                        uid: widget.uid,
                      );
                    });
              } catch (e) {
                print(e);
              }
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => AddListNew(
              //           uid: widget.uid,
              //         ),
              //   ),
              // );
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
          backgroundColor: Colors.black54,

          // centerTitle: true,
          title: Text('${DemoLocalizations.of(context).lines}'),

          actions: <Widget>[
            FutureBuilder(
                future: _getProductsRequestFuture,
                builder: (context, snapshots) {
                  if (!snapshots.hasData) {
                    return Container();
                  }
                  return Stack(
                    children: <Widget>[
                      Positioned(
                          right: 6,
                          child: snapshots.data.length != 0
                              ? CircleAvatar(
                                  minRadius: 10,
                                  maxRadius: 10,
                                  backgroundColor: Colors.red,
                                  child: Text("${snapshots.data.length}"))
                              : SizedBox()),
                      FlatButton(
                          onPressed: () {
                            try {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return RequestListP(
                                        uid: widget.uid, snapshots: snapshots);
                                  });
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text(
                            '${DemoLocalizations.of(context).requests}',
                            style: TextStyle(),
                          ))
                    ],
                  );
                }),
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
        ),
        body: FutureBuilder(
            future: _getProductsAdmin(),
            builder: (context, snapshots) {
              if (!snapshots.hasData) {
                return Container();
              }

              return FutureBuilder(
                  future: _getRecodFuture,
                  builder: (context, snapsh) {
                    if (!snapsh.hasData) {
                      return Container();
                    }
                    return CustomScrollView(
                      slivers: <Widget>[
                        // SliverAppBar(
                        //   // expandedHeight: 100,
                        //   backgroundColor: Colors.black87,

                        // ),
                        SliverList(
                          delegate: SliverChildListDelegate([
                            Calendar(

                                // isExpandable: true,
                                // showChevronsToChangeRange: true,
                                // initialCalendarDateOverride: DateTime.now(),
                                showTodayAction: false,
                                onSelectedRangeChange: (range) => print(
                                    "Range is ${range.item1}, ${range.item2}"),
                                // isExpandable: true,
                                onDateSelected: (date) {
                                  handleNewDate(date);
                                }),
                          ]),
                        ),
                        SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            var document = snapshots.data[index].data;
                            var snapshot = _users[document['user']];
                            var timentpS = document['timentpS'].toDate();
                            var timentpE = document['timentpE'].toDate();
                            String checkdays = DateFormat('d').format(timentpS);
                            String checkdoco =
                                DateFormat('yMMM').format(timentpS);
                            var price = document['price'];
                            // return FutureBuilder(
                            //     future:
                            //         _getUserData(snapshots.data[index].data['user']),
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
                                      '${DemoLocalizations.of(context).delete}',
                                  color: Colors.red,
                                  icon: Icons.delete,
///////////////////////////////////////////ליצור כאן מחיקה//////////
                                  onTap: () {
                                    var timeWorkingH =
                                        timentpE.hour - timentpS.hour;
                                    var timeWorkingM =
                                        timentpE.minute - timentpS.minute;
                                    var sumHours =
                                        timeWorkingH * 60 + timeWorkingM;
                                    print("sumHours $sumHours");
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
                                          // if (oldNameClients != null) {
                                          //       print("oldNameClients");
                                          for (int daniel = 0;
                                              daniel < oldNameClients.length;
                                              daniel++) {
                                            newNameClients
                                                .add(oldNameClients[daniel]);
                                          }
                                          // }
                                          newNameClients.add(
                                              snapshot['userName']); // for demo

                                          var oldSumHours = oldDaysWorkToUpdate[
                                              "cancelsumhours"];
                                          var newSumHours = oldSumHours +
                                              sumHours; // hours of day

                                          var oldSumPrice = oldDaysWorkToUpdate[
                                              "cancelsumprice"];
                                          var newSumPrice = oldSumPrice +
                                              price; // price of day

                                          var sumhoursM =
                                              snapsh.data[i].data['sumhoursM'];
                                          var newSumHoursM = sumhoursM -
                                              sumHours; //hours of month

                                          var sumpriceM =
                                              snapsh.data[i].data['sumpriceM'];
                                          var newSumpriceM = sumpriceM -
                                              price; //price of month

                                          var newDaysWorkArray = [];

                                          for (int daniel = 0;
                                              daniel < oldDaysWorkArray.length;
                                              daniel++) {
                                            if (daniel == j) {
                                              newDaysWorkArray.add({
                                                "day":
                                                    oldDaysWorkToUpdate["day"],
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

                                    _deleProductsNewLine(document['productId']);

                                    onRefresh();
                                  },
                                ),
//                                       IconSlideAction(
//                                         caption:
//                                             '${DemoLocalizations.of(context).newline}',
//                                         color: Colors.blue,
//                                         icon: Icons.replay,
// ///////////////////////////////////////////ליצור כאן מחיקה//////////
//                                         onTap: () {
//                                           _deleProductsNewLine(snapshots
//                                               .data[index].data['productId']);
//                                           onRefresh();
//                                         },
//                                       ),
                              ],
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [Colors.grey, Colors.white70])),
                                child: ListTile(
                                  leading: Container(
                                    width: 80.0,
                                    height: 60.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image:
                                                new CachedNetworkImageProvider(
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
                                  title: Text(
                                    "${DateFormat('Hm').format(timentpS) + " - " + DateFormat('Hm').format(snapshots.data[index].data['timentpE'].toDate())}  ${snapshots.data[index].data['nameBarber']}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Row(
                                    children: <Widget>[
                                      Text(
                                        "${snapshots.data[index].data['kind']}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    // mainAxisAlignment:
                                    // MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundColor: snapshots.data[index]
                                                    .data['statusline'] !=
                                                "ok"
                                            ? snapshots.data[index]
                                                        .data['statusline'] !=
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
                                            url = "tel:" + snapshot['phone'];

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
                                ),
                              ),
                            );
                            // });
                            // });
                          }, childCount: snapshots.data.length),
                        ),
                      ],
                    );
                  });
            }),
      ),
    );
  }
}
