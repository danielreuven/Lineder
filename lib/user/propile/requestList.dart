import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lineder/helpers/locale.dart';

class RequestList extends StatefulWidget {
  final uid;
  RequestList({this.uid});
  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  Firestore _firestore = Firestore.instance;

  Future _getListUser() async {
    Query q = _firestore
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("requestTolist")
        .orderBy("timeFull", descending: true);

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  Future onRefresh() async {
    await Future.delayed(Duration(microseconds: 200));
    setState(() {
      _getListUser();
    });
    return null;
  }

  deleteProductRequstBackSchedule(String productId, String adminUid) {
    _firestore
        .collection("AdminUsers")
        .document(adminUid)
        .collection("requestTolist")
        .document('$productId')
        .delete();

    _firestore
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("requestTolist")
        .document('$productId')
        .delete();

    _firestore
        .collection("AdminUsers")
        .document(adminUid)
        .collection("lineschedule")
        .document('$productId')
        .updateData({
      "status": "ok",
    });
  }

  Future _getUserData(userAdmin) async {
    final userDataQuery = await Firestore.instance
        .collection("AdminUsers")
        .document(userAdmin)
        .get();

    return userDataQuery.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          '${DemoLocalizations.of(context).requestlines}',
        ),
      ),
      body: FutureBuilder(
          future: _getListUser(),
          builder: (context, snapshots) {
            if (!snapshots.hasData) {
              return Container();
            }
            return ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                    height: 5.0,
                  ),
              itemCount: snapshots.data.length,
              itemBuilder: (_, index) {
                return FutureBuilder(
                    future:
                        _getUserData(snapshots.data[index].data['adminUser']),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        actions: <Widget>[
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              deleteProductRequstBackSchedule(
                                  snapshots.data[index].data['productId'],
                                  snapshots.data[index].data['adminUser']);
                              onRefresh();
                            },
                          ),
                        ],
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.grey, Colors.white70])),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Flexible(
                                    flex: 2,
                                    child: Text(
                                      "${snapshot.data['userBrand']}",
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    "${snapshots.data[index].data['nameBarber']}",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              "${DateFormat('MMMEd', DemoLocalizations.of(context).language).format(snapshots.data[index].data['timentpS'].toDate())} \n${DateFormat('Hm').format(snapshots.data[index].data['timentpS'].toDate()) + " - " + DateFormat('Hm').format(snapshots.data[index].data['timentpE'].toDate())}\n${snapshots.data[index].data['kind'] != null ? snapshots.data[index].data['kind'] : ""}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            leading: Text(
                                "${snapshots.data[index].data['price']}${snapshots.data[index].data['currency']}"),
                          ),
                        ),
                      );
                    });
              },
            );
          }),
    );
  }
}
