import 'dart:async';
// import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
// import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/src/material/dialog.dart' as Dialog;
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';
import 'package:lineder/helpers/locale.dart';
// import 'package:analog_time_picker/analog_time_picker.dart';
// import 'package:analog_time_picker/timepicker/clock_text.dart';
//remove

class TimeArea extends StatefulWidget {
  final uid;
  // final ClockText clockText;
  final ValueChanged<Map> onChanged;
  TimeArea({
    this.uid,
    // this.clockText = ClockText.arabic,
    Key key,
    this.onChanged,
  }) : super(key: key);
  @override
  _TimeAreaState createState() => _TimeAreaState();
}

class _TimeAreaState extends State<TimeArea> {
  Firestore _firestore = Firestore.instance;
  DateTime selected;
  // Map<String, DateTime> _dateTime = new Map();
  DateTime colckTime = DateTime.now();
  // List<DateModel> dateList = new List<DateModel>();
  String stateText;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int cnt = 10;
  // var durationMan;
  // var durationBread;
  // var durationWoman;
  // var durationKid;

  // var priceMan;
  // var priceBread;
  // var priceKid;
  // var priceWoman;

  void add() {
    setState(() {
      cnt += 5;
    });
  }

  void minus() {
    if (cnt > 10) {
      setState(() {
        cnt -= 5;
      });
    }
  }

  final FontWeight _smallFontWeight = FontWeight.w500;
  final Color _fontColor = Color(0xff5b6990);
  final double _smallFontSpacing = 1.3;

  // DateTime _currentTime;
  // DateTime _ntpTime;
  // // int _ntpOffset;
  // DateTime timentp;

  // void _updateTime() async {
  //   _currentTime = await NTP.now();
  //   _ntpTime = await NTP.now();

  //   timentp = _ntpTime;
  // }
  Future _checkLinesAvaibleFuture;
  Future _getBarbersFuture;
  Future _getKindsFuture;
  @override
  void initState() {
    super.initState();
    _checkLinesAvaibleFuture = _checkLinesAvaible();
    _getBarbersFuture = _getBarbers();
    _getKindsFuture = _getKinds();

    // _updateTime();

    // _shuffle();
    // _getProductsNew();

    // if (mounted) {
    //   _dateTime['date'] = colckTime;
    //   _dateTime['time'] = colckTime;
    //   _publishSelection(_dateTime);
    // }
    // sub = db
    //     // .collection(widget.country)
    //     // .document('${widget.uid}')
    //     // .collection("${widget.statusGrand}")
    //     // .document(widget.uid)
    //     .collection("AdminUsers")
    //     .document(widget.uid)
    //     .snapshots()
    //     .listen((snap) {
    //   setState(() {
    //     data = snap.data;
    //   });
    // });
  }

  @override
  void dispose() {
    // sub.cancel();

    super.dispose();
  }

  final db = Firestore.instance;
  // StreamSubscription sub;

  // Map data;
  final baseColor = Color.fromRGBO(255, 255, 255, 0.3);

  // int initTime;
  // int endTime;

  // int inBedTime;
  // int outBedTime;

  int inBedTimeNew = 0;
  int qutBedTimeNew = 0;

  bool datechoiceBool = false;

  DateTime timeStart;
  DateTime timeEnd;
  DateTime timeChoiceS;
  DateTime timeChoiceE;

  DateTime temp;
  int timeRange = 0;
  var timeWorkingH;
  var timeWorkingM;
  bool timeDayBool = true;
  bool saveBool = false;

  // void _publishSelection(Map _dateTime) {
  //   if (widget.onChanged != null) {
  //     widget.onChanged(_dateTime);
  //   }
  // }

  // void _shuffle() {
  //   setState(() {
  //     initTime = _generateRandomTime();
  //     endTime = _generateRandomTime();
  //     inBedTime = initTime;
  //     outBedTime = endTime;
  //   });
  // }

  Future _getProductsNew() async {
    Query q = _firestore
        .collection("AdminSchedule")
        .where("adminUser", isEqualTo: widget.uid);

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  // _setDataToday() {
  //   String productId = DateTime.now().millisecondsSinceEpoch.toString();
  //   _firestore.collection("AdminRecord").document('$productId').setData({
  //     "productId": "$productId",
  //     "adminUser": "${widget.uid}",
  //     "timeDay": "${DateFormat('EEEE').format(timeChoiceS)}",
  //     "timeFull": "${DateFormat('MMMEd').format(timeChoiceS)}",
  //     "dateFull": "${DateFormat('yMMMMd').format(temp)}",
  //     "dayNumber": "${DateFormat("d").format(temp)}",
  //     "day": "${DateFormat("EEEE").format(temp)}",
  //     "mounth": "${DateFormat("M").format(temp)}",
  //     "year": "${DateFormat("y").format(temp)}",
  //     "timeWorkH": '$timeWorkingH',
  //     "timeWorkM": '$timeWorkingM',
  //     "timentpS": temp.millisecondsSinceEpoch,
  //     "timentpE": timeStart.millisecondsSinceEpoch,
  //   });
  // }

  Future onRefresh() async {
    await Future.delayed(Duration(microseconds: 200));
    setState(() {
      _getProductsNew();
    });
    return null;
  }

  var inStart;
  var outEnd;

  // void _updateLabels(int init, int end) {
  //   setState(() {
  //     inBedTime = init;
  //     outBedTime = end;
  //     inBedTimeNew = inBedTime;
  //     qutBedTimeNew = outBedTime;
  //     inStart = inBedTimeNew;
  //     outEnd = inBedTimeNew;
  //   });
  // }

  // String _formatTime(int time) {
  //   if (time == 0 || time == null) {
  //     return '00:00';
  //   }
  //   var hours = time ~/ 12;
  //   var minutes = (time % 12) * 5;
  //   return '$hours:$minutes';
  // }

  // String _formatIntervalTime(int init, int end) {
  //   var sleepTime = end > init ? end - init : 288 - init + end;
  //   var hours = sleepTime ~/ 12;
  //   var minutes = (sleepTime % 12) * 5;
  //   return '${hours}h${minutes}m';
  // }

  // int _generateRandomTime() => Random().nextInt(288);

  // _showDateTimePicker() async {
  //   selected = await showDatePicker(
  //     context: context,
  //     initialDate: new DateTime.now(),
  //     firstDate: new DateTime(1960),
  //     lastDate: new DateTime(2050),
  //   );

  // }

  var sumWork;
  var sumHours;
  void showInSnack(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  // var timedataS;
  // var timedataE;
  // Future _chechktimeS() async {
  //   QuerySnapshot q = await _firestore
  //       .collection("AdminUsers")
  //       .document(widget.uid)
  //       .collection("lineschedule")
  //       .getDocuments();

  //   return q.documents;
  //   // setState(() {
  //   //   _loadingProducts = false;
  //   // });
  // }

  showPickerDateRange(BuildContext context) {
    Picker ps = new Picker(
        hideHeader: true,
        adapter: new DateTimePickerAdapter(
          type: PickerDateTimeType.kYMDHM,
          // isNumberMonth: true,
          yearBegin: DateTime.now().year,
          yearEnd: DateTime.now().year + 2,

          // yearSuffix: "Y",
          // monthSuffix: "ח",
          // daySuffix: "י"
        ),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
        });

    Picker pe = new Picker(
        hideHeader: true,
        adapter: new DateTimePickerAdapter(
          yearBegin: DateTime.now().year,
          yearEnd: DateTime.now().year + 2,
          // isNumberMonth: true,
          type: PickerDateTimeType.kYMDHM,
          // monthSuffix: "ח",
          // daySuffix: "י"
        ),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
        });

    List<Widget> actions = [
      FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text(DemoLocalizations.of(context).cancel)),
      FlatButton(
          onPressed: () {
            Navigator.pop(context);
            ps.onConfirm(ps, ps.selecteds);
            pe.onConfirm(pe, pe.selecteds);

            timeChoiceS = (ps.adapter as DateTimePickerAdapter).value;
            timeChoiceE = (pe.adapter as DateTimePickerAdapter).value;
            timeStart = (ps.adapter as DateTimePickerAdapter).value;
            timeEnd = (pe.adapter as DateTimePickerAdapter).value;

            timeWorkingH = timeEnd.hour - timeStart.hour;
            timeWorkingM = timeEnd.minute - timeStart.minute;
            sumWork = ((timeWorkingH * 60) + timeWorkingM) / timeRange;
            sumHours = ((timeWorkingH * 60) + timeWorkingM) / 60;

            // sumWork = ((timeWorkingH * 60) + timeWorkingM) / 60; //timeRange;

            if (0 > timeWorkingM) {
              timeWorkingM = timeWorkingM * -1;
            }
            if (sumWork <= 0) {
              showInSnack(
                  "${DemoLocalizations.of(context).timechoicenotcorrect}");
            }
            if (timeChoiceE.day != timeChoiceS.day ||
                timeChoiceE.month != timeChoiceS.month ||
                timeChoiceE.year != timeChoiceS.year) {
              showInSnack("${DemoLocalizations.of(context).choicesamedate}");
            }
            onRefresh();
          },
          child: new Text(DemoLocalizations.of(context).accept))
    ];

    Dialog.showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text("${DemoLocalizations.of(context).chooseworkinghours}"),
            actions: actions,
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("${DemoLocalizations.of(context).beginningtime}"),
                  ps.makePicker(),
                  Text("${DemoLocalizations.of(context).endtime}"),
                  pe.makePicker()
                ],
              ),
            ),
          );
        });
  }

  // Future _getProductsAdmin() async {
  //   Query q = _firestore
  //       .collection("AdminUsers")
  //       .where("adminUser", isEqualTo: widget.uid);

  //   QuerySnapshot querySnapshot = await q.getDocuments();
  //   return querySnapshot.documents;
  //   // setState(() {
  //   //   _loadingProducts = false;
  //   // });
  // }

  // void showSnackBar(BuildContext context) {
  //   var snackBar = SnackBar(
  //     content: Text("Point Must Until 30"),
  //   );
  //   Scaffold.of(context).showSnackBar(snackBar);
  // }

  String myChoice;
  // String myBarberChoice = '';

  funcMan(
    kind,
    duration,
  ) {
    if (duration != null) {
      setState(() {
        myChoice = kind;
        timeRange = duration;
      });
    }
  }

  funcBarber(
    name,
  ) {
    if (name != null) {
      setState(() {
        _selection = name;
      });
    }
  }

  funcFlaseall() {
    setState(() {
      timeRange = 0;
      myChoice = '';
    });
  }

  funcFlaseallBarber() {
    setState(() {
      _selection = '';
    });
  }

  Future _getKinds() async {
    QuerySnapshot q = await Firestore.instance
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("kind")
        .getDocuments();

    return q.documents;
  }

  Future _checkLinesAvaible() async {
    QuerySnapshot q = await Firestore.instance
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("lineschedule")
        .getDocuments();

    return q.documents;
  }

  Future _getBarbers() async {
    QuerySnapshot q = await Firestore.instance
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("worker")
        .getDocuments();

    return q.documents;
  }

  bool hidebool = false;
  String _selection = '';
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // _updateTime();
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            // color: Colors.black,
            child: Column(children: <Widget>[
              Container(
                  height: 80,
                  // color: Colors.green,
                  child: Row(
                    mainAxisAlignment: prefix0.MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FutureBuilder(
                          future: _getBarbersFuture,
                          builder: (context, snapsh) {
                            if (!snapsh.hasData) {
                              return prefix0.RaisedButton(
                                color: _fontColor,
                                textColor: Colors.white,
                                onPressed: () {},
                                child: Text(
                                    "${DemoLocalizations.of(context).choice}"),
                              );
                            }
                            return RaisedButton(
                              color: _fontColor,
                              textColor: Colors.white,
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
                                                  "${DemoLocalizations.of(context).all}"),
                                            )
                                          ],
                                          content: Container(
                                            height: 400,
                                            width: 400,
                                            child: ListView.builder(
                                              itemCount: snapsh.data.length,
                                              itemBuilder: (context, index) {
                                                return FlatButton(
                                                  color: Colors.grey[300],
                                                  onPressed: () {
                                                    setState(() {
                                                      _selection = snapsh
                                                          .data[index]
                                                          .data['name'];
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(snapsh.data[index]
                                                      .data['name']),
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
                                  "${_selection.isNotEmpty ? _selection : DemoLocalizations.of(context).choice}"),
                            );
                          }),
                      Text(
                        "${timeRange != null ? timeRange : ""}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: prefix0.FontWeight.w500),
                      ),
                      timeStart != null && timeEnd != null
                          ? FlatButton.icon(
                              label: Text(
                                  "${DemoLocalizations.of(context).edittime}"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: _fontColor,
                              textColor: Colors.white,
                              icon: Icon(Icons.data_usage),
                              onPressed: () {
                                saveBool = false;
                                showPickerDateRange(context);
                              },
                            )
                          : Container(),
                    ],
                  )),
              FutureBuilder(
                  future: _getKindsFuture,
                  builder: (context, snapshots) {
                    if (!snapshots.hasData) {
                      return Container();
                    }
                    return Container(
                      height: height / 5,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, childAspectRatio: 1.0),
                        itemCount: snapshots.data.length,
                        itemBuilder: (_, index) {
                          var document = snapshots.data[index].data;
                          final kind = document['kind'];
                          return InkWell(
                            onDoubleTap: funcFlaseall,
                            onTap: () {
                              funcMan(
                                kind,
                                document['duration'],
                              );
                            },
                            child: Card(
                              color: myChoice == kind
                                  ? Colors.purple[200]
                                  : Colors.white,
                              elevation: 4.0,
                              child: Center(
                                child: Text("$kind"),
                              ),
                            ),
                          );
                          //
                        },
                      ),
                    );
                  }),
              FutureBuilder(
                  future: _checkLinesAvaibleFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }

                    return Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: ListView(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 30,
                              ),
                              timeStart == null && timeEnd == null
                                  ? Container()
                                  : Text(
                                      "${DateFormat('MMMEd', DemoLocalizations.of(context).language).format(timeChoiceS)}",
                                      style: TextStyle(
                                          fontWeight: _smallFontWeight,
                                          fontSize: 30,
                                          letterSpacing: _smallFontSpacing,
                                          color: _fontColor),
                                      textAlign: TextAlign.center,
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Center(
                                    child: timeStart == null && timeEnd == null
                                        ? Card(
                                            color: _fontColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30))),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.date_range,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      if (timeRange != 0 &&
                                                          _selection
                                                              .isNotEmpty) {
                                                        showPickerDateRange(
                                                            context);
                                                      } else {
                                                        showDialog<void>(
                                                          context: context,
                                                          barrierDismissible:
                                                              false, // user must tap button!
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(30),
                                                              title: Text(
                                                                  'בחר סוג עבודה\nבמידה ולא קיים הוסף\nסוג וזמן עבודה'),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                  child: Text(
                                                                      'אוקי'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Text(
                                            // " $sumWork" +
                                            // "תורים" +
                                            "${sumWork.toStringAsFixed(0)} ${DemoLocalizations.of(context).lines}\n $timeWorkingH:$timeWorkingM",
                                            style: TextStyle(
                                                fontWeight: _smallFontWeight,
                                                fontSize: 24,
                                                letterSpacing:
                                                    _smallFontSpacing,
                                                color: _fontColor))),
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    timeEnd == null
                                        ? Container()
                                        : Text(
                                            "${timeEnd.hour}" +
                                                ":" +
                                                "${timeEnd.minute}",
                                            style: TextStyle(
                                                fontWeight: _smallFontWeight,
                                                fontSize: 24,
                                                letterSpacing:
                                                    _smallFontSpacing,
                                                color: _fontColor)),
                                    timeStart == null
                                        ? Container()
                                        : Text(
                                            "${timeChoiceS.hour}" +
                                                ":" +
                                                "${timeChoiceS.minute}",
                                            style: TextStyle(
                                                fontWeight: _smallFontWeight,
                                                fontSize: 24,
                                                letterSpacing:
                                                    _smallFontSpacing,
                                                color: _fontColor),
                                          ),
                                  ]),
                              hidebool == false
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 34),
                                      child: FlatButton(
                                        child: Text(
                                          '${DemoLocalizations.of(context).createlines}',
                                          style: TextStyle(
                                            fontWeight: _smallFontWeight,
                                            fontSize: 16,
                                            letterSpacing: _smallFontSpacing,
                                            // color: Colors.white,
                                          ),
                                        ),
                                        color: Colors.purple[200],
                                        textColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                        onPressed: () async {
                                          bool checkbool = false;
                                          for (var i = 0;
                                              i < snapshot.data.length;
                                              i++) {
                                            if (snapshot.data[i]
                                                        .data['nameBarber'] ==
                                                    _selection &&
                                                snapshot.data[i]
                                                        .data['timeFull'] ==
                                                    DateFormat('MMMEd')
                                                        .format(timeChoiceS)) {
                                              checkbool = true;
                                            }
                                          }

                                          try {
                                            if (timeRange != 0 &&
                                                _selection.isNotEmpty &&
                                                sumWork < 50 &&
                                                checkbool == false) {
                                              setState(() {
                                                hidebool = true;
                                              });

                                              for (var i = 0;
                                                  i < sumWork;
                                                  i++) {
                                                temp = timeStart;
                                                timeStart = timeStart.add(
                                                    Duration(
                                                        minutes: timeRange));

                                                String productId =
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch
                                                        .toString();
                                                await _firestore
                                                    .collection("AdminUsers")
                                                    .document(widget.uid)
                                                    .collection("lineschedule")
                                                    .document('$productId')
                                                    .setData({
                                                  "productId": "$productId",
                                                  // "timeDayBool": "$timeDayBool",
                                                  "time": "$temp",
                                                  "timentpS": temp,
                                                  "timentpE": timeStart,
                                                  "timeStart": timeChoiceS,
                                                  "timeEnd": timeChoiceE,
                                                  "timeWorkH": '$timeWorkingH',
                                                  "timeWorkM": '$timeWorkingM',
                                                  "timeRange": timeRange,
                                                  "timeDay":
                                                      "${DateFormat('EEEE').format(timeChoiceS)}",
                                                  "timeFull":
                                                      "${DateFormat('MMMEd').format(timeChoiceS)}",
                                                  "hour": "${temp.hour}",
                                                  "adminUser": "${widget.uid}",
                                                  "status": "ok",
                                                  "nameBarber": "$_selection",
                                                });
                                              }
                                              Navigator.pop(context);
                                            } else {
                                              print("no way");
                                              showInSnack(
                                                  " לא ניתן לקבוע פעמיים לאותו יום או יותר מ50 תורים");
                                              // showSnackBar(context);
                                            }
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                          '${DemoLocalizations.of(context).loading}'),
                                    ),
                            ],
                          ),
                          //
                        ],
                      ),
                    );
                  }),
            ]),
          ),
        ));
    // return Scaffold(
    //     backgroundColor: Colors.grey[100],
    //     key: _scaffoldKey,
    //     appBar: AppBar(
    //       actions: <Widget>[
    //         timeStart != null && timeEnd != null
    //             ? FlatButton.icon(
    //                 label: Text("${DemoLocalizations.of(context).edittime}"),
    //                 shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(20)),
    //                 color: _fontColor,
    //                 textColor: Colors.white,
    //                 icon: Icon(Icons.data_usage),
    //                 onPressed: () {
    //                   saveBool = false;
    //                   showPickerDateRange(context);
    //                 },
    //               )
    //             : Container(),
    //         FutureBuilder(
    //             future: _getBarbers(),
    //             builder: (context, snapshot) {
    //               if (!snapshot.hasData) {
    //                 return Container();
    //               }
    //               return RaisedButton(
    //                 onPressed: () {
    //                   try {
    //                     showDialog(
    //                         context: context,
    //                         builder: (context) {
    //                           return AlertDialog(
    //                             actions: <Widget>[
    //                               IconButton(
    //                                 onPressed: () =>
    //                                     Navigator.of(context).pop(),
    //                                 icon: Icon(Icons.close),
    //                               ),
    //                               FlatButton(
    //                                 onPressed: () {
    //                                   setState(() {
    //                                     _selection = '';
    //                                   });
    //                                   Navigator.of(context).pop();
    //                                 },
    //                                 child: Text(
    //                                     "${DemoLocalizations.of(context).all}"),
    //                               )
    //                             ],
    //                             content: Container(
    //                               height: 400,
    //                               width: 400,
    //                               child: ListView.builder(
    //                                 itemCount: snapshot.data.length,
    //                                 itemBuilder: (context, index) {
    //                                   return FlatButton(
    //                                     color: Colors.grey[300],
    //                                     onPressed: () {
    //                                       setState(() {
    //                                         _selection = snapshot
    //                                             .data[index].data['name'];
    //                                       });
    //                                       Navigator.of(context).pop();
    //                                     },
    //                                     child: Text(
    //                                         snapshot.data[index].data['name']),
    //                                   );
    //                                 },
    //                               ),
    //                             ),
    //                           );
    //                         });
    //                   } catch (e) {
    //                     print(e);
    //                   }
    //                 },
    //                 child: Text(
    //                     "${_selection.isNotEmpty ? _selection : DemoLocalizations.of(context).choice}"),
    //               );
    //             }),
    //       ],
    //       backgroundColor: _fontColor,
    //       title: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: <Widget>[
    //           // Text('${DemoLocalizations.of(context).timesforline}'),
    //           Text(" $timeRange"),
    //         ],
    //       ),
    //     ),
    //     body: SingleChildScrollView(
    //       child: Container(
    //         child: Column(children: <Widget>[
    //           FutureBuilder(
    //               future: _getKinds(),
    //               builder: (context, snapshots) {
    //                 if (!snapshots.hasData) {
    //                   return Container();
    //                 }
    //                 return Container(
    //                   height: MediaQuery.of(context).size.height / 5,
    //                   child: GridView.builder(
    //                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                         crossAxisCount: 4, childAspectRatio: 1.0),
    //                     itemCount: snapshots.data.length,
    //                     itemBuilder: (_, index) {
    //                       var document = snapshots.data[index].data;
    //                       final kind = document['kind'];
    //                       return InkWell(
    //                         onDoubleTap: funcFlaseall,
    //                         onTap: () {
    //                           funcMan(
    //                             kind,
    //                             document['duration'],
    //                           );
    //                         },
    //                         child: Card(
    //                           color: myChoice == kind
    //                               ? Colors.purple[200]
    //                               : Colors.white,
    //                           elevation: 4.0,
    //                           child: Center(
    //                             child: Text("$kind"),
    //                           ),
    //                         ),
    //                       );
    //                       //
    //                     },
    //                   ),
    //                 );
    //               }),
    //           FutureBuilder(
    //               future: _checkLinesAvaible(),
    //               builder: (context, snapshot) {
    //                 if (!snapshot.hasData) {
    //                   return Container();
    //                 }

    //                 return Container(
    //                   height: MediaQuery.of(context).size.height - 120,
    //                   child: ListView(
    //                     children: <Widget>[
    //                       Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: <Widget>[
    //                           SizedBox(
    //                             height: 30,
    //                           ),
    //                           timeStart == null && timeEnd == null
    //                               ? Container()
    //                               : Text(
    //                                   "${DateFormat('MMMEd', DemoLocalizations.of(context).language).format(timeChoiceS)}",
    //                                   style: TextStyle(
    //                                       fontWeight: _smallFontWeight,
    //                                       fontSize: 30,
    //                                       letterSpacing: _smallFontSpacing,
    //                                       color: _fontColor),
    //                                   textAlign: TextAlign.center,
    //                                 ),
    //                           Padding(
    //                             padding: const EdgeInsets.all(24.0),
    //                             child: Center(
    //                                 child: timeStart == null && timeEnd == null
    //                                     ? Card(
    //                                         color: _fontColor,
    //                                         shape: RoundedRectangleBorder(
    //                                             borderRadius: BorderRadius.all(
    //                                                 Radius.circular(30))),
    //                                         child: Container(
    //                                           height: MediaQuery.of(context)
    //                                                   .size
    //                                                   .height /
    //                                               5,
    //                                           width: MediaQuery.of(context)
    //                                                   .size
    //                                                   .width /
    //                                               5,
    //                                           child: Column(
    //                                             mainAxisAlignment:
    //                                                 MainAxisAlignment.center,
    //                                             children: <Widget>[
    //                                               IconButton(
    //                                                 icon: Icon(
    //                                                   Icons.date_range,
    //                                                   color: Colors.white,
    //                                                 ),
    //                                                 onPressed: () {
    //                                                   if (timeRange != 0 &&
    //                                                       _selection
    //                                                           .isNotEmpty) {
    //                                                     showPickerDateRange(
    //                                                         context);
    //                                                   } else {
    //                                                     showDialog<void>(
    //                                                       context: context,
    //                                                       barrierDismissible:
    //                                                           false, // user must tap button!
    //                                                       builder: (BuildContext
    //                                                           context) {
    //                                                         return AlertDialog(
    //                                                           contentPadding:
    //                                                               EdgeInsets
    //                                                                   .all(30),
    //                                                           title: Text(
    //                                                               'בחר סוג עבודה\nבמידה ולא קיים הוסף\nסוג וזמן עבודה'),
    //                                                           actions: <Widget>[
    //                                                             FlatButton(
    //                                                               child: Text(
    //                                                                   'אוקי'),
    //                                                               onPressed:
    //                                                                   () {
    //                                                                 Navigator.of(
    //                                                                         context)
    //                                                                     .pop();
    //                                                               },
    //                                                             ),
    //                                                           ],
    //                                                         );
    //                                                       },
    //                                                     );
    //                                                   }
    //                                                 },
    //                                               ),
    //                                             ],
    //                                           ),
    //                                         ),
    //                                       )
    //                                     : Text(
    //                                         // " $sumWork" +
    //                                         // "תורים" +
    //                                         "${sumWork.toStringAsFixed(0)} ${DemoLocalizations.of(context).lines}\n $timeWorkingH:$timeWorkingM",
    //                                         style: TextStyle(
    //                                             fontWeight: _smallFontWeight,
    //                                             fontSize: 24,
    //                                             letterSpacing:
    //                                                 _smallFontSpacing,
    //                                             color: _fontColor))),
    //                           ),
    //                           Row(
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceEvenly,
    //                               children: [
    //                                 timeEnd == null
    //                                     ? Container()
    //                                     : Text(
    //                                         "${timeEnd.hour}" +
    //                                             ":" +
    //                                             "${timeEnd.minute}",
    //                                         style: TextStyle(
    //                                             fontWeight: _smallFontWeight,
    //                                             fontSize: 24,
    //                                             letterSpacing:
    //                                                 _smallFontSpacing,
    //                                             color: _fontColor)),
    //                                 timeStart == null
    //                                     ? Container()
    //                                     : Text(
    //                                         "${timeChoiceS.hour}" +
    //                                             ":" +
    //                                             "${timeChoiceS.minute}",
    //                                         style: TextStyle(
    //                                             fontWeight: _smallFontWeight,
    //                                             fontSize: 24,
    //                                             letterSpacing:
    //                                                 _smallFontSpacing,
    //                                             color: _fontColor),
    //                                       ),
    //                               ]),
    //                           hidebool == false
    //                               ? Padding(
    //                                   padding: const EdgeInsets.symmetric(
    //                                       vertical: 10.0, horizontal: 34),
    //                                   child: FlatButton(
    //                                     child: Text(
    //                                       '${DemoLocalizations.of(context).createlines}',
    //                                       style: TextStyle(
    //                                         fontWeight: _smallFontWeight,
    //                                         fontSize: 16,
    //                                         letterSpacing: _smallFontSpacing,
    //                                         // color: Colors.white,
    //                                       ),
    //                                     ),
    //                                     color: Colors.purple[200],
    //                                     textColor: Colors.white,
    //                                     shape: RoundedRectangleBorder(
    //                                       borderRadius:
    //                                           BorderRadius.circular(50.0),
    //                                     ),
    //                                     onPressed: () async {
    //                                       bool checkbool = false;
    //                                       for (var i = 0;
    //                                           i < snapshot.data.length;
    //                                           i++) {
    //                                         if (snapshot.data[i]
    //                                                     .data['nameBarber'] ==
    //                                                 _selection &&
    //                                             snapshot.data[i]
    //                                                     .data['timeFull'] ==
    //                                                 DateFormat('MMMEd')
    //                                                     .format(timeChoiceS)) {
    //                                           checkbool = true;
    //                                         }
    //                                       }

    //                                       try {
    //                                         if (timeRange != 0 &&
    //                                             _selection.isNotEmpty &&
    //                                             sumWork < 50 &&
    //                                             checkbool == false) {
    //                                           setState(() {
    //                                             hidebool = true;
    //                                           });

    //                                           for (var i = 0;
    //                                               i < sumWork;
    //                                               i++) {
    //                                             temp = timeStart;
    //                                             timeStart = timeStart.add(
    //                                                 Duration(
    //                                                     minutes: timeRange));

    //                                             String productId =
    //                                                 DateTime.now()
    //                                                     .millisecondsSinceEpoch
    //                                                     .toString();
    //                                             await _firestore
    //                                                 .collection("AdminUsers")
    //                                                 .document(widget.uid)
    //                                                 .collection("lineschedule")
    //                                                 .document('$productId')
    //                                                 .setData({
    //                                               "productId": "$productId",
    //                                               // "timeDayBool": "$timeDayBool",
    //                                               "time": "$temp",
    //                                               "timentpS": temp,
    //                                               "timentpE": timeStart,
    //                                               "timeStart": timeChoiceS,
    //                                               "timeEnd": timeChoiceE,
    //                                               "timeWorkH": '$timeWorkingH',
    //                                               "timeWorkM": '$timeWorkingM',
    //                                               "timeRange": timeRange,
    //                                               "timeDay":
    //                                                   "${DateFormat('EEEE').format(timeChoiceS)}",
    //                                               "timeFull":
    //                                                   "${DateFormat('MMMEd').format(timeChoiceS)}",
    //                                               "hour": "${temp.hour}",
    //                                               "adminUser": "${widget.uid}",
    //                                               "status": "ok",
    //                                               "nameBarber": "$_selection",
    //                                             });
    //                                           }
    //                                           Navigator.pop(context);
    //                                         } else {
    //                                           print("no way");
    //                                           showInSnack(
    //                                               " לא ניתן לקבוע פעמיים לאותו יום או יותר מ50 תורים");
    //                                           // showSnackBar(context);
    //                                         }
    //                                       } catch (e) {
    //                                         print(e);
    //                                       }
    //                                     },
    //                                   ),
    //                                 )
    //                               : Center(
    //                                   child: Text(
    //                                       '${DemoLocalizations.of(context).loading}'),
    //                                 ),
    //                         ],
    //                       ),
    //                       //
    //                     ],
    //                   ),
    //                 );
    //               }),
    //         ]),
    //       ),
    //     ));
  }
}
