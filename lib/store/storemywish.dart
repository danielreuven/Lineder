import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lineder/store/showproduct.dart';

class StoreMyWish extends StatefulWidget {
  final uid;
  final List myproduct;

  const StoreMyWish({Key key, this.uid, this.myproduct}) : super(key: key);
  @override
  _StoreMyWishState createState() => _StoreMyWishState();
}

class _StoreMyWishState extends State<StoreMyWish> {
  Future<QuerySnapshot> _mywish;
  List productnews = [];
  @override
  void initState() {
    super.initState();
    _mywish = Firestore.instance
        .document("CustomerUsers/${widget.uid}")
        .collection("showHeart")
        .getDocuments();
    _mywish.then((snap) {
      setState(() {
        for (var i = 0; i < widget.myproduct.length; i++) {
          for (var j = 0; j < snap.documents.length; j++) {
            if (widget.myproduct[i]['productId'] ==
                snap.documents[j]['productId']) {
              productnews.add(widget.myproduct[i]);
            }
          }
        }
      });
    });
  }

  Future _getstore(user, productId) async {
    Query q = Firestore.instance
        .collection("AdminUsers")
        .document(user)
        .collection("store")
        .where("productId", isEqualTo: productId);

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("מוצרים שאהבתי"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: productnews.length,
          itemBuilder: (context, index) {
            var document = productnews[index];
            return FutureBuilder(
                future: _getstore(document['ownerId'], document['productId']),
                builder: (context, snapshot) {
                  return ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ShowProduct(
                              uid: widget.uid,
                              product: document['productId'],
                              uidAdmin: document['ownerId'],
                              imagePost: document['imagePost'],
                              available: document['available'],
                              price: document['price'],
                            );
                          });
                    },
                    leading: Container(
                      child: CachedNetworkImage(
                        imageUrl: "${document['imagePost']}",
                        fit: BoxFit.cover,height: 80,
                        width: 50,
                      ),
                    ),
                    title: Text("${document['catalog']}"),
                    subtitle: Text(
                      "${document['cur']} ${document['price']}",
                    ),
                    trailing: Text("${document['available']}"),
                  );
                });
          },
        ),
      ),
      // body: StreamBuilder<QuerySnapshot>(
      //     stream: _mywish,
      //     builder: (context, snapshots) {
      //       if (!snapshots.hasData) {
      //         return Container();
      //       }
      //       return Container(
      //         child: ListView.builder(
      //           itemCount: snapshots.data.documents.length,
      //           itemBuilder: (context, index) {
      //             return FutureBuilder(
      //                 future: _getstore(
      //                     snapshots.data.documents[index]['ownerId'],
      //                     snapshots.data.documents[index]['productId']),
      //                 builder: (context, snapshot) {
      //                   if (!snapshot.hasData) {
      //                     return Container();
      //                   }
      //                   return Container(
      //                     height: MediaQuery.of(context).size.height,
      //                     child: ListView.builder(
      //                       itemCount: snapshot.data.length,
      //                       itemBuilder: (context, inde) {
      //                         print(snapshot.data.length);
      //                         return Text(
      //                             "${snapshot.data[inde].data['productId']}");
      //                       },
      //                     ),
      //                   );
      //                 });
      //           },
      //         ),
      //       );
      //     }),
    );
  }
}
