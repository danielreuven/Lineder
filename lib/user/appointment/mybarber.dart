import 'dart:async';

import 'package:lineder/helpers/locale.dart';
import 'package:lineder/user/appointment/appointment.dart';
import 'package:lineder/user/propile/showprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MyBarber extends StatefulWidget {
  final uid;

  MyBarber({
    this.uid,
  });
  @override
  _MyBarberState createState() => _MyBarberState();
}

class _MyBarberState extends State<MyBarber> {
  // VoidCallback _showPersBottomSheetCallBack;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Stream<QuerySnapshot> _iceCreamStores;
  @override
  void initState() {
    super.initState();
    _iceCreamStores = _firestore
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("AdminAllClients")
        .snapshots();
    _getProductsFuture = _getProducts();
  }

  Future _getProductsFuture;
  Map<String, dynamic> _users = {};
  Future _getProducts() async {
    // Getting all users
    await _getUserData();

    Query q = Firestore.instance
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection('AdminAllClients');

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  ListTile _createTile(BuildContext context, String name, IconData icon,
      Color coler, Function action, document, snapshot) {
    return ListTile(
      leading: Icon(
        icon,
        color: coler,
      ),
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        action(document, snapshot);
      },
    );
  }

  // _action3(document) {
  //   print('action 3');
  // }

  var url;
  _action4(document, snapshot) async {
    print('action 4');

    var url = "tel:" + snapshot['phone'];

    if (await canLaunch(url))
      launch(url);
    else
      print("URL can Not be");
    print('open click');
  }

  // Future _getListUser() async {
  //   Query q = _firestore
  //       .collection("AdminUsers")
  //       .where("adminUser", isEqualTo: docum);

  //   QuerySnapshot querySnapshot = await q.getDocuments();
  //   return querySnapshot.documents;
  // }

  var doc;
  var docum;
  _action2(document, snapshot) {
    // print(snapshot['userName']);
    // docum = document['adminSuser'];
    // db
    //     .collection("AdminUsers")
    //     .document(document['adminSuser'])
    //     .snapshots()
    //     .listen((snap) {
    //   setState(() {
    //     data1 = snap.data;
    //   });
    // });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowProfile(
          uid: widget.uid,
          adminuid: document['adminSuser'],
          adminImage: snapshot['photoUrl'],
        ),
      ),
    );

    // : Container();
  }

  _action1(document, snapshot) {
    print('action 1');
    print(document['adminSuser']);
    print(snapshot['userName']);
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppointmentMake(
            uid: widget.uid,
            userAdmin: document['adminSuser'],
          ),
        ),
      );
    });
  }

  Firestore _firestore = Firestore.instance;
  // var chooceBarber;

  // Future _getBarbers() async {
  //   QuerySnapshot q = await _firestore
  //       .collection("CustomerUsers")
  //       .document(widget.uid)
  //       .collection("AdminAllClients")
  //       .getDocuments();

  //   return q.documents;
  // }

  _actionwze(document, snapshot) async {
    String url = "https://waze.com/ul?q=" +
        "${snapshot['location'].latitude}" +
        "," +
        "${snapshot['location'].longitude}" +
        "&navigate=yes&zoom=17";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('cannot launch');
    }
  }

  _actiongoogle(document, snapshot) async {
    String url1 =
        "google.navigation:q=${snapshot['location'].latitude},${snapshot['location'].longitude}";
    if (await canLaunch(url1)) {
      await launch(url1);
    } else {
      print('cannot launch');
    }
  }

  var currentColor = Color.fromRGBO(255, 255, 255, 1.0);

  // Future _getUserData(userAdmin) async {
  //   final userDataQuery = await Firestore.instance
  //       .collection("AdminUsers")
  //       .document(userAdmin)
  //       .get();

  //   return userDataQuery.data;
  // }
  Future _getUserData() async {
    QuerySnapshot userDataQuerySnapshot =
        await Firestore.instance.collection("AdminUsers").getDocuments();
    // .document(userAdmin)
    // .get();

    for (DocumentSnapshot document in userDataQuerySnapshot.documents) {
      _users[document.documentID] = document.data;
    }
  }

  // var namee;
  // var photo;
  // var phoneee;
  // var address;
  // var letit;
  // var longit;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: currentColor,
          appBar: AppBar(
            backgroundColor: currentColor,
            leading: Container(),
            title: Text(
              "${DemoLocalizations.of(context).addline}",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0.0,
          ),
          body: FutureBuilder(
              future: _getProductsFuture,
              builder: (BuildContext context, snapshots) {
                if (!snapshots.hasData) {
                  return Container();
                }

                return ListView.builder(
                    itemCount: snapshots.data.length,
                    addSemanticIndexes: true,
                    itemBuilder: (BuildContext context, int index) {
                      final document = snapshots.data[index].data;
                      var snapshot = _users[document['adminSuser']];
                      // return FutureBuilder(
                      //     future: _getUserData(snapshots
                      //         .data.documents[index].data['adminSuser']),
                      //     builder: (context, snapshot) {
                      //       if (!snapshot.hasData) {
                      //         return Container();
                      //       }
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 7.0,
                            child: ListTile(
                              trailing: IconButton(
                                  onPressed: () async {
                                    ///open Gps
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              _createTile(
                                                  context,
                                                  "${DemoLocalizations.of(context).gowaze}",
                                                  FontAwesomeIcons.map,
                                                  Colors.blue,
                                                  _actionwze,
                                                  document,
                                                  snapshot),
                                              _createTile(
                                                  context,
                                                  "${DemoLocalizations.of(context).gogoogle}",
                                                  FontAwesomeIcons.map,
                                                  Colors.red,
                                                  _actiongoogle,
                                                  document,
                                                  snapshot),
                                            ],
                                          );
                                        });
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.route,
                                    color: Colors.blue[300],
                                  )),
                              title: Text("${snapshot['userName']}"),
                              subtitle: Text("${snapshot['address']}"),
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          _createTile(
                                              context,
                                              "${DemoLocalizations.of(context).addline}",
                                              Icons.add_box,
                                              Colors.blue,
                                              _action1,
                                              document,
                                              snapshot),
                                          _createTile(
                                              context,
                                              "${DemoLocalizations.of(context).showprofile}",
                                              Icons.supervised_user_circle,
                                              Colors.blueGrey,
                                              _action2,
                                              document,
                                              snapshot),
                                          _createTile(
                                              context,
                                              "${DemoLocalizations.of(context).call}",
                                              FontAwesomeIcons.phone,
                                              Colors.green,
                                              _action4,
                                              document,
                                              snapshot),
                                        ],
                                      );
                                    });
                              },
                            )),
                      );
                      // });
                    });
              })),
    );
  }
}
