import 'package:lineder/helpers/locale.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';

class AllClientsRequest extends StatefulWidget {
  AllClientsRequest({this.uid, this.snapshots});
  final uid;
  final snapshots;

  @override
  _AllClientsRequestState createState() => _AllClientsRequestState();
}

class _AllClientsRequestState extends State<AllClientsRequest> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Firestore _firestore = Firestore.instance;
  @override
  void initState() {
    super.initState();

    _getProductsReq();
  }

  Future _getProductsReq() async {
    QuerySnapshot q = await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("AdminClientsRequst")
        .getDocuments();

    return q.documents;
  }

  Future onRefresh() async {
    await Future.delayed(Duration(microseconds: 200));
    setState(() {
      _getProductsReq();
    });
    return null;
  }

  var adminSuser;
  var adminName;
  var adminAddress;
  var adminImage;

  // var user;
  var url;
  var userName;
  var userPhone;
  var userImage;
  // var productNotif;

  _ssetProductsClients(String userId, String productNot) {
    _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("AdminAllClients")
        .document("$userId")
        .setData({
      "user": userId,
      "adminSuser": "$adminSuser",
      "status": "client",
      "statusline": "ok",
    });
    _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("notific")
        .document(productNot)
        .delete();
    _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("notific")
        .document(productNot)
        .setData({
      "ownerId": "${widget.uid}",
      "productId": "$productNot",
      "userId": "$userId",
      "timestamp": FieldValue.serverTimestamp(),
      "type": "friend",
      "language": "${DemoLocalizations.of(context).language}"
    });
  }

  _ssetProductsClientsFromClient(String userId, String productNot) async {
    _firestore
        .collection("CustomerUsers")
        .document("$userId")
        .collection("AdminAllClients")
        .document(widget.uid)
        .setData({
      "user": userId,
      "adminSuser": "$adminSuser",
      "status": "client",
      "statusline": "ok",
    });
    _firestore
        .collection("CustomerUsers")
        .document(userId)
        .collection("notific")
        .document(productNot)
        .setData({
      "ownerId": userId,
      "userId": widget.uid,
      "type": "friend",
      "timestamp": FieldValue.serverTimestamp(),
      "productId": productNot,
      "showbool": true,
         "language":"${DemoLocalizations.of(context).language}"
    });
  }

  deleteProductRequst(String userId) {
    _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("AdminClientsRequst")
        .document("$userId")
        .delete();
  }

  deleteProductRequstFromClient(String userId) {
    _firestore
        .collection("CustomerUsers")
        .document("$userId")
        .collection("AdminClientsRequst")
        .document(widget.uid)
        .delete();
  }

  deleteProductNotif(String productNot) {
    _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("notific")
        .document(productNot)
        .delete();
  }

  setClientFreinds(String userId) {
    _firestore.collection("AdminUsers").document(widget.uid).updateData({
      'request.$userId': false,
      'freinds.$userId': true,
    });
  }

  cancelRequestClient(String userId) {
    _firestore.collection("AdminUsers").document(widget.uid).updateData({
      'request.$userId': false,
    });
  }

  var adminlatitude;
  var adminLongitude;

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      action: SnackBarAction(
        label: '${DemoLocalizations.of(context).yes}',
        onPressed: () {
          widget.snapshots.data.forEach((doc) {
            _firestore
                .collection("AdminUsers")
                .document(widget.uid)
                .collection("AdminClientsRequst")
                .document(doc['user'])
                .delete();
            _firestore
                .collection("CustomerUsers")
                .document(doc['user'])
                .collection("AdminClientsRequst")
                .document(widget.uid);
            _firestore
                .collection("AdminUsers")
                .document(widget.uid)
                .updateData({
              'request.${doc['user']}': false,
            });
          });
        },
      ),
    ));
  }

  // Future _getProductsAdmin(userAdmin) async {
  //   Query q = Firestore.instance
  //       .collection("CustomerUsers")
  //       .where("user", isEqualTo: userAdmin);

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
          '${DemoLocalizations.of(context).requestclientsrelly}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              FlatButton.icon(
                onPressed: () {
                  showInSnackBar('${DemoLocalizations.of(context).deleteall}');
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
            future: _getProductsReq(),
            builder: (BuildContext context, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return SliverPadding(
                  padding: EdgeInsets.all(10),
                );
              }
              return SliverList(
                delegate:
                    SliverChildBuilderDelegate((BuildContext ctx, int index) {
                  var document = snapshots.data[index].data;
                  var productNot = document['productId'];
                  var user = document['user'];
                  return FutureBuilder(
                      future: _getUserData(
                          widget.snapshots.data[index].data['user']),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }

                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          actions: <Widget>[
                            IconSlideAction(
                              caption:
                                  '${DemoLocalizations.of(context).delete}',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {
                                deleteProductRequst(user);
                                deleteProductRequstFromClient(
                                    document['adminSuser']);
                                cancelRequestClient(user);
                                deleteProductNotif(productNot);

                                onRefresh();
                              },
                            ),
                            IconSlideAction(
                              caption:
                                  '${DemoLocalizations.of(context).accept}',
                              color: Colors.blue,
                              icon: Icons.verified_user,
                              onTap: () {
                                // user = document['user'];

                                adminSuser = document['adminSuser'];
                                // adminName = document['adminName'];
                                // adminAddress = document['adminAddress'];
                                // adminImage = document['adminImage'];

                                // adminlatitude = document['locationAdmin'].latitude;
                                // adminLongitude = document['locationAdmin'].longitude;
                                // userName = document['name'];
                                // userPhone = document['phone'];
                                // userImage = document['images'];

                                // productNotif = document['productId'];
                                deleteProductRequst(user);
                                onRefresh();
                                _ssetProductsClients(user, productNot);
                                _ssetProductsClientsFromClient(
                                    user, productNot);
                                setClientFreinds(user);
                                deleteProductRequstFromClient(user);
                              },
                            ),
                          ],
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.grey, Colors.white70])),
                            child: ListTile(
                              leading: Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new CachedNetworkImageProvider(
                                        "${snapshot.data['photoUrl']}"),
                                  ),
                                ),
                              ),
                              title: Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 2,
                                    child: Text(
                                      "${snapshot.data['userName']}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: CircleAvatar(
                                radius: 15,
                                backgroundColor: Color(0xff002651),
                                child: IconButton(
                                  onPressed: () async {
                                    url = "tel:" + "${snapshot.data['phone']}";

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
                }, childCount: snapshots.data.length),
              );
            },
          ),
        ],
      ),
    );
  }
}
