import 'dart:async';

import 'package:lineder/animation/loadingscircular.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ScheduleTime extends StatefulWidget {
  ScheduleTime({
    this.uid,
    this.statusGrand,
    this.country,
  });
  final uid;
  final statusGrand;
  final country;

  @override
  _ScheduleTimeState createState() => _ScheduleTimeState();
}

class _ScheduleTimeState extends State<ScheduleTime> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Color _fontColor = Color(0xff5b6990);

  Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    super.initState();
  }

  String myBarberChoice = '';
  Future _getProductsAdmin() async {
    Query q = _selection.isEmpty
        ? _firestore
            .collection("AdminUsers")
            .document(widget.uid)
            .collection("lineschedule")
            .where("timeFull", isEqualTo: timelocal)
        : _firestore
            .collection("AdminUsers")
            .document(widget.uid)
            .collection("lineschedule")
            .where("timeFull", isEqualTo: timelocal)
            .where("nameBarber", isEqualTo: _selection);

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  _deleProductsSchedule(String productId) {
    _firestore
        // .collection(widget.country)
        // .document('${widget.uid}')
        // .collection("${widget.statusGrand}")
        // .document(widget.uid)
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("lineschedule")
        .document("$productId")
        .delete()
        .whenComplete(() {
      print("deleteProduct AdminSchedule");
    });
  }

  _breakProduct(String productId) {
    _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("lineschedule")
        .document("$productId")
        .updateData({"status": "Break"});
  }

  _nNObreakProd(String productId) {
    _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("lineschedule")
        .document("$productId")
        .updateData({"status": "ok"});
  }

  Future onRefresh() async {
    await Future.delayed(Duration(microseconds: 200));
    setState(() {
      _getProductsAdmin();
    });
    return null;
  }

  String productIDdelete;
  var day;

  startTime() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigaotr);
  }

  void navigaotr() {
    Navigator.pop(context);
  }

  bool stat = false;
  void status() {
    setState(() {
      stat = !stat;

      print(stat);
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

  void showInSnackBar(String value, snapshots) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      action: SnackBarAction(
        label: '${DemoLocalizations.of(context).yes}',
        onPressed: () {
          snapshots.data.forEach((doc) {
            _firestore
                .collection("AdminUsers")
                .document(widget.uid)
                .collection("lineschedule")
                .document(doc['productId'])
                .delete();
            status();
          });
        },
      ),
    ));
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
  double _value = 0.0;
  int cntlate = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // title: Text("Schedule"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
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
          builder: (BuildContext context, snapshots) {
            if (!snapshots.hasData) {
              return Center(child: ColorLoader3());
            }

            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Calendar(
                        showTodayAction: false,
                        onSelectedRangeChange: (range) =>
                            print("Range is ${range.item1}, ${range.item2}"),
                        // isExpandable: true,

                        onDateSelected: (date) {
                          handleNewDate(date);
                        }),
                  ]),
                ),
                timelocal != null
                    ? SliverList(
                        delegate: SliverChildListDelegate([
                          RaisedButton.icon(
                            onPressed: () {
                              showInSnackBar(
                                  '${DemoLocalizations.of(context).deleteall}',
                                  snapshots);
                            },
                            label: Text(
                                '${DemoLocalizations.of(context).deleteall}'),
                            icon: Icon(Icons.delete),
                          )
                        ]),
                      )
                    : SliverPadding(
                        padding: EdgeInsets.all(12),
                      ),
                timelocal != null
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          var document = snapshots.data[index].data;
                          var timentpS = document['timentpS'].toDate();
                          var timentpE = document['timentpE'].toDate();

                          return document['status'] != "request"
                              ? Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  // actions: <Widget>[],
                                  actions: <Widget>[
                                    IconSlideAction(
                                      caption:
                                          '${DemoLocalizations.of(context).delete}',
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () {
                                        _deleProductsSchedule(
                                            document['productId']);
                                        onRefresh();
                                      },
                                    ),
                                    document['status'] != "Break"
                                        ? IconSlideAction(
                                            caption:
                                                '${DemoLocalizations.of(context).breakk}',
                                            color: Colors.blue,
                                            icon: Icons.free_breakfast,
                                            onTap: () {
                                              _breakProduct(snapshots
                                                  .data[index]
                                                  .data['productId']);
                                              onRefresh();
                                            },
                                          )
                                        : IconSlideAction(
                                            caption:
                                                '${DemoLocalizations.of(context).deletebreak}',
                                            color: Colors.blue[200],
                                            icon: Icons.visibility_off,
                                            onTap: () {
                                              _nNObreakProd(snapshots
                                                  .data[index]
                                                  .data['productId']);
                                              onRefresh();
                                            },
                                          )
                                  ],
                                  child: Card(
                                    color: document['status'] == "Break"
                                        ? Colors.lightBlue[200]
                                        : Colors.white,
                                    child: ListTile(
                                      leading:
                                          Text("${document['nameBarber']}"),
                                      title: Column(
                                        children: <Widget>[
                                          document['status'] == "Break"
                                              ? Slider(
                                                  min: 0.0,
                                                  max: 30.0,
                                                  divisions: 6,
                                                  value: _value,
                                                  // activeColor: myFeedbackColor,
                                                  inactiveColor:
                                                      Colors.blueGrey,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      _value = newValue;
                                                      cntlate = _value.toInt();
                                                    });
                                                  },
                                                )
                                              : Container(),
                                          Text(
                                            "${DateFormat('Hm').format(timentpE)}  -  ${DateFormat('Hm').format(timentpS)} ",
                                          ),
                                        ],
                                      ),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          document['status'] == "Break"
                                              ? FlatButton.icon(
                                                  onPressed: () {
                                                    var start = timentpS;
                                                    var end = timentpE;
                                                    start = start.add(Duration(
                                                        minutes: cntlate));
                                                    end = end.add(Duration(
                                                        minutes: cntlate));
                                                    _firestore
                                                        .collection(
                                                            "AdminUsers")
                                                        .document(widget.uid)
                                                        .collection(
                                                            "lineschedule")
                                                        .document(document[
                                                            'productId'])
                                                        .updateData({
                                                      "timentpS": start,
                                                      "timentpE": end,
                                                    });
                                                    status();
                                                  },
                                                  icon: Icon(Icons.update),
                                                  label: Text(
                                                      "${DemoLocalizations.of(context).minute}  $cntlate  ${DemoLocalizations.of(context).update}"),
                                                )
                                              : Container(),
                                          Text(
                                            "${DateFormat('MMMEd', DemoLocalizations.of(context).language).format(timentpS)}",
                                            style: TextStyle(color: _fontColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container();
                        }, childCount: snapshots.data.length),
                      )
                    : SliverPadding(
                        padding: EdgeInsets.all(12),
                      )
              ],
            );
          }),
    );
  }
}
