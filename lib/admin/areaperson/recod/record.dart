import 'package:lineder/admin/areaperson/recod/showdaysrecod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lineder/helpers/locale.dart';

class RecordAdmin extends StatefulWidget {
  String uid;

  RecordAdmin({
    this.uid,
  });
  @override
  _RecordAdminState createState() => _RecordAdminState();
}

class _RecordAdminState extends State<RecordAdmin> {
  Firestore _firestore = Firestore.instance;
  final double _smallFontSize = 12;
  final double _valFontSize = 30;
  final FontWeight _smallFontWeight = FontWeight.w500;
  final FontWeight _valFontWeight = FontWeight.w700;
  final Color _fontColor = Color(0xff5b6990);
  final double _smallFontSpacing = 1.3;

  @override
  void initState() {
    super.initState();
    _getRecodFuture = _getRecod();
  }

  Future _getRecodFuture;
  Future _getRecod() async {
    QuerySnapshot q = await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("record")
        .getDocuments();

    return q.documents;
  }

  deleteProductRecord(String productId) {
    _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("record")
        .document('$productId')
        .delete();
  }

  bool stat = false;
  void status() {
    setState(() {
      stat = !stat;
      _getRecodFuture = _getRecod();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //
  void showInSnackBar(String value, productId) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      action: SnackBarAction(
        label: '${DemoLocalizations.of(context).yes}',
        onPressed: () {
          deleteProductRecord(productId);
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
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
          future: _getRecodFuture,
          builder: (BuildContext context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('${DemoLocalizations.of(context).loading}'),
              );
            }
            return ListView.builder(
              itemCount: snapshots.data.length,
              itemBuilder: (context, index) {
                final document = snapshots.data[index].data;
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  actions: <Widget>[
                    IconSlideAction(
                      caption: '${DemoLocalizations.of(context).delete}',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        showInSnackBar(
                            '${DemoLocalizations.of(context).deleteall}',
                            document['productId']);
                      },
                    ),
                  ],
                  child: Card(
                    elevation: 4.0,
                    color: Colors.grey[200],
                    semanticContainer: true,
                    child: ListTile(
                      onTap: () {
                        try {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowDaysRecord(
                                        uid: widget.uid,
                                        snapshot: document,
                                      )));
                        } catch (e) {
                          print(e);
                        }
                      },
                      leading: Icon(Icons.info_outline),
                      title: Text("${document['productId']}"),
                      subtitle: Row(
                        children: <Widget>[
                          Icon(Icons.schedule),
                          Text("${document['sumhoursM']} "),
                        ],
                      ),
                      trailing: Text(
                          " ${document['sumpriceM']}${document['currency']} "),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}

class GraphPainter extends CustomPainter {
  Paint trackBarPaint = Paint()
    ..color = Color(0xff818aab)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 12;

  Paint trackPaint = Paint()
    ..color = Color(0xffdee6f1)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 12;

  void paint(Canvas canvas, Size size) {
    Path trackPath = Path();
    Path trackBarPath = Path();
    double origin = 8;
    List val = [
      size.height * 0.8,
      size.height * 0.5,
      size.height * 0.9,
      size.height * 0.8,
      size.height * 0.5,
      size.height * 0.8,
      size.height * 0.8,
      size.height * 0.8,
      size.height * 0.8,
      size.height * 0.8,
    ];
    for (var i = 0; i < val.length; i++) {
      trackPath.moveTo(origin, size.height);
      trackPath.lineTo(origin, 0);

      trackBarPath.moveTo(origin, size.height);
      trackBarPath.lineTo(origin, val[i]);

      origin = origin + size.height * 0.22;
    }

    canvas.drawPath(trackPath, trackPaint);
    canvas.drawPath(trackBarPath, trackBarPaint);
  }

  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
