import 'package:lineder/helpers/locale.dart';
import 'package:lineder/user/propile/requestList.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class LineOnList extends StatefulWidget {
  final uid;

  LineOnList({
    this.uid,
  });
  @override
  _LineOnListState createState() => _LineOnListState();
}

class _LineOnListState extends State<LineOnList> {
  DateTime _currentTime;
  DateTime _ntpTime;
  int _ntpOffset;
  var timeDay;

  @override
  void initState() {
    // _currentTime = DateTime.now();
    _updateTime();
    super.initState();
  }

  DateTime startDate;
  void _updateTime() async {
    startDate = await NTP.now();

    setState(() {
      startDate != null
          ? timeDay = DateFormat('MMMEd').format(startDate)
          : Container();
    });
    // NTP.getNtpOffset().then((value) {
    //   setState(() {
    //     _ntpOffset = value;
    //     _ntpTime = _currentTime.add(Duration(milliseconds: _ntpOffset));
    //     print(_ntpTime);
    //     timeDay = DateFormat('MMMEd').format(_ntpTime);
    //     // print(_currentTime);
    //   });
    // });
  }

  Firestore _firestore = Firestore.instance;
  Future _getListUser() async {
    Query q = _firestore
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("listclient")
        .orderBy("timentpS", descending: true);

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

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

      print(stat);
    });
  }

  _statusProduct(String productId, String adminUser, String kind, timeFull,
      DateTime timentpS, DateTime timentpE) {
    _firestore
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("listclient")
        .document("$productId")
        .updateData({"statusline": "$statuslist"});

    _firestore
        .collection("AdminUsers")
        .document(adminUser)
        .collection("listclient")
        .document("$productId")
        .updateData({"statusline": "$statuslist"});
    _firestore
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("notific")
        .document("$productId")
        .delete();

    _firestore
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("notific")
        .document("$productId")
        .setData({
      "ownerId": widget.uid,
      "userId": adminUser,
      "kind": kind,
      "timeFull": timeFull,
      "timentpS": timentpS,
      "timentpE": timentpE,
      "productId": productId,
      "type": "$statusnotif",
      "timestamp": FieldValue.serverTimestamp(),
      "language": "${DemoLocalizations.of(context).language}"
    });
    _firestore
        .collection("AdminUsers")
        .document(adminUser)
        .collection("notific")
        .document("$productId")
        .delete();
    _firestore
        .collection("AdminUsers")
        .document(adminUser)
        .collection("notific")
        .document("$productId")
        .setData({
      "ownerId": adminUser,
      "userId": widget.uid,
      "kind": kind,
      "timeFull": timeFull,
      "timentpS": timentpS,
      "timentpE": timentpE,
      "productId": productId,
      "type": "$statusnotif",
      "timestamp": FieldValue.serverTimestamp(),
      "language": "${DemoLocalizations.of(context).language}"
    });
  }

  Future _getUserData(userAdmin) async {
    final userDataQuery = await Firestore.instance
        .collection("AdminUsers")
        .document(userAdmin)
        .get();

    return userDataQuery.data;
  }

  // var namee;
  // var address;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnackBar(String value, productId, adminUser, kind, timeFull,
      DateTime timentpS, DateTime timentpE) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      action: SnackBarAction(
        label: '${DemoLocalizations.of(context).yes}',
        onPressed: () {
          _statusProduct(
              productId, adminUser, kind, timeFull, timentpS, timentpE);
          status();
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            '${DemoLocalizations.of(context).alllines}',
          ),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.add),
            //   onPressed: () {
            //     // Navigator.push(
            //     //     context,
            //     //     MaterialPageRoute(
            //     //         builder: (context) => Caleee(
            //     //               uid: widget.uid,
            //     //             )));
            //   },
            // ),
            FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequestList(
                              uid: widget.uid,
                            )));
              },
              child: Text(
                '${DemoLocalizations.of(context).requests}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    const Color(0xFF00AAFF),
                    const Color.fromRGBO(99, 138, 223, 1.0),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
        ),
        backgroundColor: Colors.grey[100],
        body: FutureBuilder(
            future: _getListUser(),
            builder: (BuildContext context, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text(
                    '${DemoLocalizations.of(context).loading}',
                  ),
                );
              }

              return ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                        height: 5.0,
                      ),
                  scrollDirection: Axis.vertical,
                  itemCount: snapshots.data.length,
                  itemBuilder: (BuildContext context, index) {
                    return FutureBuilder(
                        future: _getUserData(
                            snapshots.data[index].data['adminUser']),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }

                          return Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.grey, Colors.white70])),
                            child: ListTile(
                              leading: Column(
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    child: Text(
                                      "${snapshot.data['userBrand']}",
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 14,
                                          // color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Event event = Event(
                                        title:
                                            "${DemoLocalizations.of(context).lineisset} ${snapshots.data[index].data['nameBarber']}",
                                        description:
                                            "${snapshots.data[index].data['userBrand']}",
                                        location: "${snapshot.data['address']}",
                                        startDate: snapshots
                                            .data[index].data['timentpS']
                                            .toDate(),
                                        endDate: snapshots
                                            .data[index].data['timentpE']
                                            .toDate(),
                                        allDay: false,
                                      );
                                      Add2Calendar.addEvent2Cal(event)
                                          .then((success) {
                                        _scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                                content: Text(success
                                                    ? '${DemoLocalizations.of(context).added}'
                                                    : '')));
                                      });
                                    },
                                    child: Card(
                                      child: Text(
                                          '  ${DemoLocalizations.of(context).reminder}  '),
                                    ),
                                  )
                                ],
                              ),
                              title: Text(
                                "${DateFormat('MMMEd', DemoLocalizations.of(context).language).format(snapshots.data[index].data['timentpS'].toDate())} ${snapshots.data[index].data['nameBarber']} \n${DateFormat('Hm').format(snapshots.data[index].data['timentpS'].toDate()) + " - " + DateFormat('Hm').format(snapshots.data[index].data['timentpE'].toDate())}\n${snapshots.data[index].data['kind'] != null ? snapshots.data[index].data['kind'] : ""}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: timeDay ==
                                      snapshots.data[index].data['timeFull']
                                  ? Row(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            statuslist = mitacev;
                                            statusnotif = onlistlate;
                                            showInSnackBar(
                                                'לעכב תור?',
                                                snapshots.data[index]
                                                    .data['productId'],
                                                snapshots.data[index]
                                                    .data['adminUser'],
                                                snapshots
                                                    .data[index].data['kind'],
                                                snapshots.data[index]
                                                    .data['timeFull'],
                                                snapshots.data[index]
                                                    .data['timentpS']
                                                    .toDate(),
                                                snapshots.data[index]
                                                    .data['timentpE']
                                                    .toDate());
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
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            statuslist = ok;
                                            statusnotif = onlist;
                                            showInSnackBar(
                                                'בזמן?',
                                                snapshots.data[index]
                                                    .data['productId'],
                                                snapshots.data[index]
                                                    .data['adminUser'],
                                                snapshots
                                                    .data[index].data['kind'],
                                                snapshots.data[index]
                                                    .data['timeFull'],
                                                snapshots.data[index]
                                                    .data['timentpS']
                                                    .toDate(),
                                                snapshots.data[index]
                                                    .data['timentpE']
                                                    .toDate());
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
                                    )
                                  : Container(),
                              trailing: Column(
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
                                ],
                              ),
                            ),
                          );
                        });
                  });
            }));
  }
}
