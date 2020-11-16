import 'package:lineder/admin/allclient/allclientsrequest.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:lineder/helpers/showdialongname.dart';
import 'package:animated_card/animated_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AllClientsPage extends StatefulWidget {
  AllClientsPage({this.uid, this.data5});
  final uid;
  final data5;
  @override
  _AllClientsPageState createState() => _AllClientsPageState();
}

class _AllClientsPageState extends State<AllClientsPage>
    with TickerProviderStateMixin {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  Firestore _firestore = Firestore.instance;
  final Map<String, dynamic> _formData = {
    'name': null,
    'email': null,
    'phone': 0,
  };
  bool nameBool = false;
  var inputEditText = '';
  var inputEditPhone = '';

  _deleProducts(String userId) async {
    await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("AdminAllClients")
        .document("$userId")
        .delete();

    await _firestore
        .collection("CustomerUsers")
        .document("$userId")
        .collection("AdminAllClients")
        .document(widget.uid)
        .delete();
    await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("notific")
        .document("$userId" + "111r11")
        .delete();

    await _firestore
        .collection("CustomerUsers")
        .document("$userId")
        .collection("notific")
        .document(widget.uid + "111r11")
        .delete();
    _firestore.collection("AdminUsers").document(widget.uid).updateData({
      'freinds.$userId': false,
    });
  }

  updProducts(String productId) {
    _firestore.collection("AdminUsers").getDocuments();
    _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("AdminAllClients")
        .document("$productId")
        .updateData({
      "name": "$inputEditText",
    }).whenComplete(() {
      print("update");
    });
  }

  Future _getProducts() async {
    await _getUserData();
    QuerySnapshot q = await _firestore
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("AdminAllClients")
        .getDocuments();

    return q.documents;
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
     _getProductsFuture = _getProducts();
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    // _getProducts();
    // _getProductsReq();
    _iceCreamStores = Firestore.instance
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("AdminAllClients")
        .snapshots();
    _iceCreamClents =
        Firestore.instance.collection("CustomerUsers").snapshots();

    _getProductsFuture = _getProducts();
  }

  // void _onChange(String value) {
  //   setState(() {
  //     inputEditText = value;
  //   });
  // }

  String numberValidator(String value) {
    if (value == null) {
      return null;
    }

    _formData['phone'] = num.tryParse(value);
    if (_formData['phone'] == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }

  var url;
  Color backgroundColor = Colors.grey[100];
  Color firstCircleColor = Colors.green[50];
  // Future _getProductsAdmin(userAdmin) async {
  //   Query q = Firestore.instance
  //       .collection("CustomerUsers")
  //       .where("user", isEqualTo: userAdmin);

  //   QuerySnapshot querySnapshot = await q.getDocuments();
  //   return querySnapshot.documents;
  // }

  // Future _getUserData(userAdmin) async {
  //   final userDataQuery = await Firestore.instance
  //       .collection("CustomerUsers")
  //       .document(userAdmin)
  //       .get();

  //   return userDataQuery.data;
  // }
  Future _getUserData() async {
    QuerySnapshot userDataQuerySnapshot =
        await Firestore.instance.collection("CustomerUsers").getDocuments();
    // .document(userAdmin)
    // .get();

    for (DocumentSnapshot document in userDataQuerySnapshot.documents) {
      _users[document.documentID] = document.data;
    }
  }

  Future _getProductsFuture;
  Map<String, dynamic> _users = {};

  Stream<QuerySnapshot> _iceCreamStores;
  Stream<QuerySnapshot> _iceCreamClents;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      // onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('${DemoLocalizations.of(context).clients}'),
          leading: StreamBuilder<QuerySnapshot>(
              stream: _iceCreamStores,
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return Container();
                }
                return StreamBuilder<QuerySnapshot>(
                    stream: _iceCreamClents,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }

                      return IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: ArticleSearch(
                              snapshots,
                              snapshot,
                              widget.uid,
                            ),
                          );
                        },
                      );
                    });
              }),
          backgroundColor: Colors.blueGrey,
          actions: <Widget>[
            FutureBuilder(
                future: _getProductsReq(),
                builder: (BuildContext context, snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return SliverPadding(
                      padding: EdgeInsets.all(10),
                    );
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
                                    return AllClientsRequest(
                                        uid: widget.uid, snapshots: snapshots);
                                  });
                            } catch (e) {
                              print(e);
                            }

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => AllClientsRequest(
                            //         uid: widget.uid, snapshots: snapshots),
                            //   ),
                            // );
                          },
                          child: Text(
                            '${DemoLocalizations.of(context).requests}',
                            style: TextStyle(),
                          ))
                    ],
                  );
                }),
          ],
        ),
        body: FutureBuilder(
          future: _getProductsFuture,
          builder: (BuildContext context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Container();
            }
            return ListView.builder(
              itemCount: snapshots.data.length,
              itemBuilder: (BuildContext ctx, int index) {
                var document = snapshots.data[index].data;
                var snapshot = _users[document['user']];
                // return FutureBuilder(
                //     future: _getUserData(snapshots.data[index].data['user']),
                //     builder: (context, snapshot) {
                //       if (!snapshot.hasData) {
                //         return Container();
                //       }
                      return AnimatedCard(
                          direction: AnimatedCardDirection
                              .left, //Initial animation direction
                          // initDelay: Duration(
                          //     milliseconds: 2), //Delay to initial animation
                          duration:
                              Duration(seconds: 1), //Initial animation duration
                          onRemove: () {
                            _deleProducts(document['user']);
                            onRefresh();
                          },
                          child: Container(
                            child: Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                leading: Container(
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new CachedNetworkImageProvider(
                                          "${snapshot['photoUrl']}"),
                                    ),
                                  ),
                                ),
                                title: InkWell(
                                  onTap: () {
                                    try {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomDialog(
                                          image: snapshot['photoUrl'],
                                          title: snapshot['userName'],
                                          phone: snapshot['phone'],
                                          description: snapshot['bio'],
                                          user: snapshot['user'],
                                          uid: widget.uid,
                                          namecollection: "CustomerUsers",
                                        ),
                                      );
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        flex: 2,
                                        child: Text(
                                          snapshot['userName'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: CircleAvatar(
                                  minRadius: 15,
                                  maxRadius: 15,
                                  backgroundColor: Color(0xff002651),
                                  child: IconButton(
                                    onPressed: () async {
                                      url =
                                          "tel:" + "${snapshot['phone']}";

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
                          ));
              
              },
            );
          },
        ),
      ),
    );
  }
}

class ArticleSearch extends SearchDelegate {
  final snapshots;
  final snapshot;
  final uid;
  // final List res;

  ArticleSearch(
    this.snapshots,
    this.snapshot,
    this.uid,
  );
  _buildlist(document, context) {
    return ListTile(
      onTap: () {
        try {
          showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(
              image: document['photoUrl'],
              title: document['userName'],
              phone: document['phone'],
              description: document['bio'],
              user: document['user'],
              uid: uid,
              namecollection: "CustomerUsers",
            ),
          );
        } catch (e) {
          print(e);
        }
      },
      leading: Container(
        width: 30.0,
        height: 30.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            fit: BoxFit.fill,
            image: new CachedNetworkImageProvider("${document['photoUrl']}"),
          ),
        ),
      ),
      title: Text("${document['userName']}"),
      trailing: CircleAvatar(
        minRadius: 15,
        maxRadius: 15,
        backgroundColor: Color(0xff002651),
        child: IconButton(
          onPressed: () async {
            var url = "tel:" + "${document['phone']}";

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
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<DocumentSnapshot> _results = [];
    List<DocumentSnapshot> _res = [];
    for (var i = 0; i < snapshots.data.documents.length; i++) {
      for (var j = 0; j < snapshot.data.documents.length; j++) {
        if (snapshots.data.documents[i]['user'] ==
                snapshot.data.documents[j]['user'] &&
            !_res.contains(snapshot.data.documents[j]['user'])) {
          _res.add(snapshot.data.documents[j]);
          // if (_res.contains(snapshot.data.documents[j]['user'])) {
          //   _res.remove(snapshot.data.documents[j]);
          // }
        }
      }
    }
    // print(" _res ${_res.length}");
    for (int i = 0; i < _res.length; i++) {
      if (_res[i].data["userName"].contains(query)) {
        _results.add(_res[i]);
      }
    }

    return ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final document = _results[index];
          return _buildlist(document, context);
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<DocumentSnapshot> _results = [];
    List<DocumentSnapshot> _res = [];
    for (var i = 0; i < snapshots.data.documents.length; i++) {
      for (var j = 0; j < snapshot.data.documents.length; j++) {
        if (snapshots.data.documents[i]['user'] ==
                snapshot.data.documents[j]['user'] &&
            !_res.contains(snapshot.data.documents[j]['user'])) {
          _res.add(snapshot.data.documents[j]);
          // if (_res.contains(snapshot.data.documents[j]['user'])) {
          //   _res.remove(snapshot.data.documents[j]);
          // }
        }
      }
    }
    // print(" _res ${_res.length}");
    for (int i = 0; i < _res.length; i++) {
      if (_res[i].data["userName"].contains(query)) {
        _results.add(_res[i]);
      }
    }

    return ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final document = _results[index];
          return _buildlist(document, context);
        });
  }
}
