import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lineder/store/searchcatalog.dart';
import 'package:lineder/store/showproduct.dart';
import 'package:lineder/store/storeheart.dart';
import 'package:lineder/store/storemywish.dart';

class ShowAllPrudcts extends StatefulWidget {
  final uid;

  const ShowAllPrudcts({Key key, this.uid}) : super(key: key);
  @override
  _ShowAllPrudctsState createState() => _ShowAllPrudctsState();
}

class _ShowAllPrudctsState extends State<ShowAllPrudcts> {
  List result = [];
  List prod = [];
  int cnt = 0;

  Stream<QuerySnapshot> clients;
  Future<QuerySnapshot> daniel;
  _inits(quar) {
    clients = Firestore.instance
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("AdminAllClients")
        .snapshots();
    // quar == ''
    //     ?
    clients.listen((snap) {
      // myproduct.clear();
      setState(() {
        for (var i = 0; i < snap.documents.length; i++) {
          myclients.add(snap.documents[i]['adminSuser']);
          daniel = Firestore.instance
              .collection("AdminUsers")
              .document(snap.documents[i]['adminSuser'])
              .collection("store")
              .where("available", isGreaterThan: 0)
              .getDocuments();

          daniel.then((snaps) {
            setState(() {
              for (var j = 0; j < snaps.documents.length; j++) {
                myproduct.add(snaps.documents[j]);
              }
            });
          });
        }
      });
    });
    // : clients.listen((snap) {
    //     myproduct.clear();
    //     setState(() {
    //       for (var i = 0; i < snap.documents.length; i++) {
    //         myclients.add(snap.documents[i]['adminSuser']);
    //         daniel = Firestore.instance
    //             .collection("AdminUsers")
    //             .document(snap.documents[i]['adminSuser'])
    //             .collection("store")
    //             // .where("available", isGreaterThan: 0)
    //             .where("catalog", isEqualTo: quar)
    //             .getDocuments();

    //         daniel.then((snaps) {
    //           setState(() {
    //             for (var j = 0; j < snaps.documents.length; j++) {
    //               myproduct.add(snaps.documents[j]);
    //             }
    //           });
    //         });
    //       }
    //     });
    //   });
  }

  String quar = '';

  @override
  void initState() {
    _inits(quar);

    super.initState();
  }

  @override
  void dispose() {
    // sub.cancel();
    // sub1.cancel();
    super.dispose();
  }

  Stream<QuerySnapshot> product;
  List myclients = [];
  List myproduct = [];
  String quary = '';
  bool showicons = false;
  // List<String> mySearch = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
                height: 40,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // FlatButton.icon(
                    //   onPressed: () {
                    //     showDialog(
                    //         context: context,
                    //         builder: (context) {
                    //           return StoreAddCard(
                    //             uid: widget.uid,
                    //           );
                    //         });
                    //   },
                    //   label: Text("עגלה"),
                    //   icon: Icon(Icons.add_shopping_cart),
                    // ),
                    FlatButton.icon(
                      onPressed: () {
                        try {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return StoreMyWish(
                                  uid: widget.uid,
                                  myproduct: myproduct,
                                );
                              });
                        } catch (e) {
                          print(e);
                        }
                      },
                      label: Text("מוצרים שאהבתי"),
                      icon: Icon(FontAwesomeIcons.solidHeart),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50.0,
                padding: EdgeInsets.only(left: 25.0, right: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Color(0xFFF3FAFC)),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      showSearch(
                        context: context,
                        delegate: ArticleSearch(
                          widget.uid,
                          myproduct,
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "חפש את המוצר",
                          style: TextStyle(color: Color(0xFF89969C)),
                        ),
                        Icon(
                          Icons.search,
                          color: Color(0xFF89969C),
                        ),
                      ],
                      // decoration: InputDecoration(
                      //   border: InputBorder.none,
                      //   hintText: 'חפש את המוצר ',
                      //   hintStyle: TextStyle(
                      //     color: Color(0xFF89969C),
                      //     fontSize: 16.0,
                      //   ),
                      // ),
                    ),
                  ),
                ),
              ),
              // Container(
              //   height: 30,
              //   child: ListView.builder(
              //     itemCount: mySearch.length,
              //     itemBuilder: (context, index) {
              //       var catalog = myproduct[index]['catalog'];
              //             // 'הכל'
              //       if (catalog == mySearch.contains(catalog).hashCode) {
              //         print("yes have ${mySearch.length}");
              //       } else {
              //         mySearch.add(catalog);
              //       }
              //       return FlatButton(
              //           onPressed: () {
              //             quar = 'לק';
              //             _inits(quar);
              //           },
              //           child: Text("mySearch[index]"));
              //     },
              //     itemExtent: 100.0,
              //     scrollDirection: Axis.horizontal,
              //     // children: <Widget>[
              //     //   FlatButton(
              //     //       onPressed: () {
              //     //         quar = 'לק';
              //     //         _inits(quar);
              //     //       },
              //     //       child: Text(myproduct[index][''])),
              //     //   FlatButton(
              //     //       onPressed: () {
              //     //         quar = '';
              //     //         _inits(quar);
              //     //       },
              //     //       child: Text("הכל")),
              //     //   Icon(Icons.tab),
              //     //   Icon(Icons.tab),
              //     // ],
              //   ),
              // ),
              Expanded(
                child: GridView.builder(
                  itemCount: myproduct.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 0.4),
                  itemBuilder: (context, index) {
                    var document = myproduct[index];
                    var heroTag = document['imagePost'];
                    return GestureDetector(
                      onTap: () {
                        try {
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
                                    heroTag: heroTag);
                              });
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: GridTile(
                        header: StoreHeart(
                          uid: widget.uid,
                          adminUser: document['ownerId'],
                          // snapshots: document['showHeart'],
                          productId: document['productId'],
                        ),
                        // header: IconButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       // showHeart = true;
                        //     });
                        //   },
                        //   icon: Icon(FontAwesomeIcons.solidHeart),
                        //   alignment: Alignment.topLeft,
                        // ),
                        footer: AppBar(
                          backgroundColor: Colors.black38,
                          leading:
                              Text("${document['cur']} ${document['price']}"),
                          title: Text(document['catalog']),
                        ),
                        child: Hero(
                          tag: heroTag,
                          child: Container(
                              // height: 80,
                              // width: 50,
                              child: CachedNetworkImage(
                            imageUrl: "${document['imagePost']}",
                            fit: BoxFit.cover,
                          )),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // }),
        ),
      ),
    );
  }
}
