import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lineder/helpers/locale.dart';

class FavoriteUser extends StatefulWidget {
  final String uid;
  final namecollection;

  FavoriteUser({this.uid, this.namecollection});
  @override
  _FavoriteUserState createState() => _FavoriteUserState();
}

class _FavoriteUserState extends State<FavoriteUser> {
  Future _getProducts() async {
    Query q = Firestore.instance
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("bookmark")
        // .document("CustomerUsers/${widget.uid}")
        .orderBy("timestamp", descending: true);

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  bool stat = false;
  void status() {
    setState(() {
      stat = !stat;

      print(stat);
    });
  }

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnackBar(String value, productId, ownerId) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      action: SnackBarAction(
        label: "${DemoLocalizations.of(context).yes}",
        onPressed: () {
          Firestore.instance
              .collection("CustomerUsers")
              .document(widget.uid)
              .collection("bookmark")
              .document(productId)
              .delete();
          Firestore.instance
              .collection("AdminUsers")
              .document(ownerId)
              .collection("posts")
              .document(productId)
              .updateData({
            'bookmark.${widget.uid}': false,
          });

          // _breakProduct(productId, user);
          status();
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: FutureBuilder(
        future: _getProducts(),
        builder: (context, snapshots) {
          if (!snapshots.hasData) {
            return Center(
              child: Text("טוען"),
            );
          }
          return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemCount: snapshots.data.length,
              itemBuilder: (_, index) {
                var document = snapshots.data[index].data;
                return Stack(
                  fit: StackFit.expand,
                  // alignment: Alignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                                // height: 30,
                                child: CachedNetworkImage(
                              imageUrl: "${document['imagePost']}",
                              fit: BoxFit.cover,
                            ));
                          },
                        );
                      },
                      child: Container(
                          // height: 80,
                          // width: 50,
                          child: CachedNetworkImage(
                        imageUrl: "${document['imagePost']}",
                        fit: BoxFit.cover,
                      )),
                    ),
                    Positioned(
                        right: 30.0,
                        left: 0.0,
                        height: 18.0,
                        // left: 25.0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: InkWell(
                              onTap: () {
                                showInSnackBar(
                                  "${DemoLocalizations.of(context).delete}",
                                  document['productId'],
                                  document['ownerId'],
                                );
                              },
                              child: Icon(
                                Icons.close,
                                size: 12,
                              )),
                        )),
                  ],
                );
              });
        },
      ),
    );
  }
}
