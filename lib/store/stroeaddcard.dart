import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoreAddCard extends StatefulWidget {
  final uid;

  const StoreAddCard({Key key, this.uid}) : super(key: key);
  @override
  _StoreAddCardState createState() => _StoreAddCardState();
}

class _StoreAddCardState extends State<StoreAddCard> {
  Future _getstore() async {
    Query q = Firestore.instance
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("store");

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  Future _getProducts(user, productId) async {
    Query q = Firestore.instance
        .collection("AdminUsers")
        .document(user)
        .collection("store");
    // .where("productId", isEqualTo: productId);

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  Future<QuerySnapshot> adminId;
  Future<QuerySnapshot> daniel;

  List adminlist = [];
  List productId = [];
  List myproduct = [];
  List myorder = [];
  @override
  void initState() {
    adminId = Firestore.instance
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("store")
        .getDocuments();
    adminId.then((snap) {
      setState(() {
        for (var i = 0; i < snap.documents.length; i++) {
          // adminlist.add(snap.documents[i]['ownerId']);
          // productId.add(snap.documents[i]['productId']);
          daniel = Firestore.instance
              .collection("AdminUsers")
              .document(snap.documents[i]['ownerId'])
              .collection("store")
              .where("productId", isEqualTo: snap.documents[i]['productId'])
              .getDocuments();
          daniel.then((snaps) {
            setState(() {
              for (var j = 0; j < snaps.documents.length; j++) {
                myproduct.add(snaps.documents[j]);
                myorder.add(snap.documents[i]);
              }
            });
          });
        }
      });

      print(adminlist.length);
      print(productId.length);
    });

    super.initState();
  }

  _updatecntorder(cntorder, productId) {
    print(myorder.length);
    Firestore.instance
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("store")
        .document(productId)
        .updateData({
      "cntoreder": cntorder++,
    });
  }

  // bool stat = false;
  // _statu() {
  //   setState(() {
  //     stat = true;
  //   });
  // }
  List add = [];
  var price;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Card"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              color: Colors.lightBlue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("TOTAL 3 items"),
                  Text("Clean Card"),
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                        height: 5.0,
                      ),
                  itemCount: myproduct.length,
                  itemBuilder: (context, index) {
                    var cntorder = myorder[index]['cntoreder'];

                    var document = myproduct[index];
                    var available = document['available'];
                    price = document['price'] * cntorder;
                    print(myproduct.length);
                    print(document['catalog']);
                    print(document['productId']);
                    return Container(
                      color: Colors.black,
                      height: 140,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        textDirection: TextDirection.ltr,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                  width: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: BoxBorder.lerp(
                                        Border.all(color: Colors.red),
                                        Border.all(color: Colors.red),
                                        20),
                                    // color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  )),
                              InkWell(
                                onTap: () {
                                  if (add.contains(document['productId'])) {
                                    setState(() {
                                      add.remove(document['productId']);
                                    });
                                  } else {
                                    setState(() {
                                      add.add(document['productId']);
                                    });
                                  }
                                },
                                child: Container(
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: BoxBorder.lerp(
                                        Border.all(color: Colors.blue),
                                        Border.all(color: Colors.blue),
                                        20),
                                    // color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: add.contains(document['productId'])
                                        ? Colors.green
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 160,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                Container(
                                  width: 160,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            "${document['imagePost']}",
                                          ),
                                          fit: BoxFit.cover)),
                                ),
                                Positioned(
                                  child: StatefulBuilder(
                                      builder: (context, setState) {
                                    return Card(
                                      color: Colors.white,
                                      child: Row(
                                        textDirection: TextDirection.rtl,
                                        children: <Widget>[
                                          Text("$price"),
                                          IconButton(
                                            onPressed: () {
                                              if (available > cntorder) {
                                                setState(() {
                                                  cntorder++;
                                                  price =
                                                      price + document['price'];
                                                });
                                              }
                                            },
                                            icon: Icon(Icons.add),
                                          ),
                                          Text("$cntorder"),
                                          IconButton(
                                            onPressed: () {
                                              if (cntorder != 1) {
                                                setState(() {
                                                  cntorder--;
                                                  price =
                                                      price - document['price'];
                                                });
                                              }
                                            },
                                            icon: Icon(
                                                const IconData(0xe15b,
                                                    fontFamily:
                                                        'MaterialIcons'),
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 230,
                            color: Colors.blue,
                            child: Column(
                              children: <Widget>[
                                Text(document['catalog']),
                                Text("${document['cur']} $price")
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                    // ListTile(
                    //   title: Text(document['catalog']),
                    //   leading: Container(
                    //     height: 80,
                    //     width: 80,
                    //     decoration: BoxDecoration(
                    //         image: DecorationImage(
                    //             image: CachedNetworkImageProvider(
                    //               "${document['imagePost']}",
                    //             ),
                    //             fit: BoxFit.cover)),
                    //   ),
                    //   trailing: Text("${myorder[index]['cntoreder']}"),
                    //   subtitle: Text("${document['productId']}"),
                    //   // Text("${document['cur']} ${document['price']}"),
                    // );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
