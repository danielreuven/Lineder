import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:lineder/store/buynow.dart';
import 'package:lineder/store/storeheart.dart';
import 'package:lineder/user/propile/follow.dart';

class ShowProduct extends StatefulWidget {
  final uid;
  final product;
  final uidAdmin;
  final imagePost;
  final int available;
  final int price;
  final heroTag;

  const ShowProduct(
      {Key key,
      this.uid,
      this.product,
      this.uidAdmin,
      this.imagePost,
      this.available,
      this.price,
      this.heroTag})
      : super(key: key);

  @override
  _ShowProductState createState() => _ShowProductState(heroTag: heroTag);
}

class _ShowProductState extends State<ShowProduct> {
  final heroTag;
  _ShowProductState({this.heroTag});
  final Firestore _firestore = Firestore.instance;
  // Future _getstore() async {
  //   Query q = Firestore.instance
  //       .collection("AdminUsers")
  //       .document(widget.uidAdmin)
  //       .collection("store");

  //   QuerySnapshot querySnapshot = await q.getDocuments();
  //   return querySnapshot.documents;
  // }
  @override
  void initState() {
    super.initState();
    //  cntorderAdmin=available;
    // cntorderAdmin = widget.available;
    // print("$cntorderAdmin");
    price = widget.price;
    print(price);
    print(widget.price);
  }

  Future _getstore() async {
    final userDataQuery = await _firestore
        .collection("AdminUsers")
        .document(widget.uidAdmin)
        .collection("store")
        .document(widget.product)
        .get();

    return userDataQuery.data;
  }

  Future _getUsers() async {
    final userDataQuerys = await _firestore
        .collection("AdminUsers")
        .document(widget.uidAdmin)
        .get();

    return userDataQuerys.data;
  }

  int cntorderAdmin = 0;
  int cntorder = 1;
  int price = 0;
  void add(available) {
    setState(() {
      if (cntorder != 50 && cntorder < available) cntorder++;
    });
  }

  void addAdmin(available) {
    setState(() {
      if (cntorderAdmin != 50) cntorderAdmin++;
    });
  }

  void minusAdmin(available) {
    setState(() {
      if (cntorderAdmin != 1) cntorderAdmin--;
    });
  }

  void minus(available) {
    setState(() {
      if (cntorder != 1) cntorder--;
    });
  }

  Widget sizeB(double numb) {
    return SizedBox(height: numb);
  }

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnack(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  _addproductTocard(user, productId, catalog) {
    _firestore
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("store")
        .document(productId)
        .setData({
      "catalog": catalog,
      "ownerId": user,
      "user": widget.uid,
      "productId": productId,
      "cntoreder": cntorder,
      "timestamp": FieldValue.serverTimestamp(),
    });
    _firestore
        .collection("AdminUsers")
        .document(user)
        .collection("store")
        .document(productId)
        .updateData({
      'addCard.${widget.uid}': true,
    });
  }

  _buildShowProductC(screenHeight, screenWidth, snapshots, snapshot, available,
      bool status, snapsh) {
    return Stack(
      // textDirection: TextDirection.rtl,
      children: <Widget>[
        Container(
          height: screenHeight,
          width: screenWidth,
          color: Colors.grey[100],
        ),
        Hero(
          tag: heroTag,
          child: InkWell(
            onTap: () {
              // showDialog(
              //     context: context,
              //     builder: (context) {
              //       return Material(
              //                             child: Container(
              //           height: screenHeight,
              //           width: screenWidth,
              //           decoration: BoxDecoration(
              //               image: DecorationImage(image: NetworkImage(heroTag))),
              //         ),
              //       );
              //     });
            },
            child: Container(
              height: screenHeight / 3,
              width: screenWidth,
              child: CachedNetworkImage(
                imageUrl: heroTag,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
          ),
        ),
        status == false
            ? Positioned(
                top: screenHeight / 2,
                // bottom: 70.0,
                left: 15.0,
                right: 15.0,
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    // color: Colors.white,
                    padding: EdgeInsets.all(25),

                    child: Container(
                        // height: 20,
                        // width: 20,
                        // height: MediaQuery.of(context).size.width - 330,
                        // width: MediaQuery.of(context).size.width - 270,
                        child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: CachedNetworkImage(
                              imageUrl: "${snapshot['photoUrl']}",
                              fit: BoxFit.cover,
                              height: 30,
                              width: 30,
                            ),
                          ),
                          Text("  ${snapshot['userBrand']}"),
                        ],
                      ),
                    )),

                    // child: ListTile(
                    //   leading: Container(
                    //     child: CachedNetworkImage(
                    //       imageUrl: "${snapshot['photoUrl']}",
                    //       fit: BoxFit.cover,
                    //       height: 30,
                    //       width: 30,
                    //     ),
                    //   ),
                    //   title: Text("${snapshot['userName']}"),
                    // )
                  ),
                ))
            : Container(),
        status == false
            ? Positioned(
                left: 50.0,
                top: (screenHeight / 2) - 30,
                child: StoreHeart(
                  uid: widget.uid,
                  adminUser: snapshots.data['ownerId'],
                  productId: snapshots.data['productId'],
                ))
            : Container(),
        status == false
            ? Positioned(
                left: 50.0,
                top: (screenHeight / 2) - 70,
                child: Followers(
                  adminUser: widget.uidAdmin,
                  snapshots: snapshot,
                  uid: widget.uid,
                  status: false,
                ),
              )
            : Container(),
        Positioned(
          bottom: 15,
          left: 15,
          right: 15,
          child: Material(
            borderRadius: BorderRadius.circular(10.0),
            elevation: 3.0,
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '   ${snapshots.data['catalog']}   ',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15.0),
                Text("${snapshots.data['description']}",
                    maxLines: 2,
                    style: TextStyle(fontSize: 14, color: Color(0xFF8597A0))),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new IconButton(
                      onPressed: () {
                        add(available);
                      },
                      icon: new Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      color: Colors.white,
                    ),
                    Text("$cntorder",
                        style: TextStyle(
                            fontFamily: 'Inconsolata',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: _color)),
                    IconButton(
                      onPressed: () {
                        minus(available);
                      },
                      icon: new Icon(
                          const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                          color: Colors.black),
                      color: Colors.white,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.lightBlue,
                      child: Text("$available",
                          style: TextStyle(
                              fontFamily: 'Inconsolata',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: _color)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    Text(
                        '${snapshots.data['cur']} ${snapshots.data['price'] * cntorder}',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                            fontFamily: 'Inconsolata',
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: _color)),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      color: _color,
                      icon: Icon(Icons.arrow_forward_ios, size: 15.0),
                    ),
                  ],
                )
              ],
            )),
          ),
        )
        // Positioned(
        //     top: 155.0,
        //     left: 25.0,
        //     child: Row(
        //       textDirection: TextDirection.rtl,
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: <Widget>[
        //         Column(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: <Widget>[
        //             Container(
        //               height: 80,
        //               width: 80,
        //               decoration: BoxDecoration(
        //                   shape: BoxShape.circle,
        //                   image: DecorationImage(
        //                       image: CachedNetworkImageProvider(
        //                           "${snapshot.data['photoUrl']}"
        //                           // "${snapshot.data['photoUrl']}",
        //                           ),
        //                       fit: BoxFit.cover)),
        //             ),
        //             sizeB(5.0),
        //             Text("${snapshot.data['userName']}"),
        //             sizeB(15.0),
        //             Text('${DemoLocalizations.of(context).available}',
        //                 style: TextStyle(
        //                     fontFamily: 'Inconsolata',
        //                     fontSize: 16.0,
        //                     color: Color(0xFF88969E))),
        //             sizeB(10.0),
        //             Text("$available",
        //                 style: TextStyle(
        //                     fontFamily: 'Inconsolata',
        //                     fontSize: 16.0,
        //                     fontWeight: FontWeight.bold,
        //                     color: _color)),
        //             SizedBox(height: 10.0),
        //             Text("QTTY",
        //                 style: TextStyle(
        //                     fontFamily: 'Inconsolata',
        //                     fontSize: 16.0,
        //                     fontWeight: FontWeight.bold,
        //                     color: _color)),
        //             Row(
        //               textDirection: TextDirection.rtl,
        //               children: <Widget>[
        //                 new IconButton(
        //                   onPressed: () {
        //                     add(available);
        //                   },
        //                   icon: new Icon(
        //                     Icons.add,
        //                     color: Colors.black,
        //                   ),
        //                   color: Colors.white,
        //                 ),
        //                 Text("$cntorder",
        //                     style: TextStyle(
        //                         fontFamily: 'Inconsolata',
        //                         fontSize: 16.0,
        //                         fontWeight: FontWeight.bold,
        //                         color: _color)),
        //                 IconButton(
        //                   onPressed: () {
        //                     minus(available);
        //                   },
        //                   icon: new Icon(
        //                       const IconData(0xe15b,
        //                           fontFamily: 'MaterialIcons'),
        //                       color: Colors.black),
        //                   color: Colors.white,
        //                 ),
        //               ],
        //             ),
        //             SizedBox(height: 25.0),
        //             Text('TOTAL',
        //                 style: TextStyle(
        //                     fontFamily: 'Inconsolata',
        //                     fontSize: 16.0,
        //                     fontWeight: FontWeight.bold,
        //                     color: _color)),
        //             SizedBox(height: 10.0),
        //             Text(
        //                 '${snapshots.data['cur']} ${snapshots.data['price'] * cntorder}',
        //                 textDirection: TextDirection.ltr,
        //                 style: TextStyle(
        //                     fontFamily: 'Inconsolata',
        //                     fontSize: 22.0,
        //                     fontWeight: FontWeight.bold,
        //                     color: _color)),
        //             SizedBox(height: 20.0),
        //             StoreHeart(
        //               uid: widget.uid,
        //               adminUser: snapshots.data['ownerId'],
        //               // snapshots: document['showHeart'],
        //               productId: snapshots.data['productId'],
        //             ),
        //             // InkWell(
        //             //   onTap: () {
        //             //     showInSnack("התווסף לעגלה");
        //             //     _addproductTocard(
        //             //         snapshots.data['ownerId'],
        //             //         snapshots.data['productId'],
        //             //         snapshots.data['catalog']);
        //             //   },
        //             //   child: Container(
        //             //     padding: EdgeInsets.only(left: 15.0, right: 15.0),
        //             //     height: 40.0,
        //             //     decoration: BoxDecoration(
        //             //         borderRadius: BorderRadius.circular(7.0),
        //             //         color: Color(0xFF44AAFB)),
        //             //     child: Center(
        //             //       child: Text('Add Card',
        //             //           style: TextStyle(
        //             //               fontFamily: 'Inconsolata',
        //             //               fontSize: 15.0,
        //             //               fontWeight: FontWeight.bold,
        //             //               color: Colors.white)),
        //             //     ),
        //             //   ),
        //             // ),
        //             // sizeB(10.0),
        //             // InkWell(
        //             //   onTap: () {
        //             //     Navigator.push(
        //             //         context,
        //             //         MaterialPageRoute(
        //             //             builder: ((context) => StoreBuyNow(
        //             //                   uid: widget.uid,
        //             //                   productId: snapshots.data['productId'],
        //             //                   price: snapshots.data['price'],
        //             //                   cur: snapshots.data['cur'],
        //             //                   cntorder: cntorder,
        //             //                   adminUser: snapshots.data['ownerId'],
        //             //                   imagePost: snapshots.data['imagePost'],
        //             //                   catalog: snapshots.data['catalog'],
        //             //                   avaible: snapshots.data['available'],
        //             //                   address: snapshot.data['address'],
        //             //                   userBrand: snapshot.data['userBrand'],
        //             //                   phone: snapshot.data['phone'],
        //             //                 ))));
        //             //   },
        //             //   child: Container(
        //             //     padding: EdgeInsets.only(left: 15.0, right: 15.0),
        //             //     height: 40.0,
        //             //     decoration: BoxDecoration(
        //             //         borderRadius: BorderRadius.circular(7.0),
        //             //         color: Color(0xFF44AAFB)),
        //             //     child: Center(
        //             //       child: Text('Book Now',
        //             //           style: TextStyle(
        //             //               fontFamily: 'Inconsolata',
        //             //               fontSize: 15.0,
        //             //               fontWeight: FontWeight.bold,
        //             //               color: Colors.white)),
        //             //     ),
        //             //   ),
        //             // )
        //           ],
        //         ),
        //         // RotatedBox(
        //         //   quarterTurns: 0,
        //         //   child: Container(
        //         //     height: screenHeight - 100,
        //         //     width: screenWidth / 2,
        //         //     decoration: BoxDecoration(
        //         //         borderRadius: BorderRadius.circular(10),
        //         //         image: DecorationImage(
        //         //             image: CachedNetworkImageProvider(
        //         //                 "${widget.imagePost}"),
        //         //             fit: BoxFit.cover)),
        //         //   ),
        //         // )
        //       ],
        //     ))
      ],
    );
  }

  bool pricebool = false;

  bool editbool = false;
  String inputDesc = '';
  void _onChangeDesc(String value) {
    setState(() {
      inputDesc = value;
    });
  }

  updateDesc(productId, available) {
    if (inputDesc.isNotEmpty) {
      Firestore.instance
          .collection("AdminUsers")
          .document(widget.uid)
          .collection("store")
          .document(productId)
          .updateData({
        "description": "$inputDesc",
      });
    }
    if (cntorderAdmin != available) {
      Firestore.instance
          .collection("AdminUsers")
          .document(widget.uid)
          .collection("store")
          .document(productId)
          .updateData({
        "available": cntorderAdmin,
      }).whenComplete(() {});
    }
    if (price != widget.price) {
      Firestore.instance
          .collection("AdminUsers")
          .document(widget.uid)
          .collection("store")
          .document(productId)
          .updateData({
        "price": n,
      }).whenComplete(() {
        print("Ddd");
      });
    }
    // Navigator.pop(context);
  }

  editDescription(desc, productId, available) {
    return TextField(
      decoration: InputDecoration(
        labelText: '$desc',
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(25.0),
          borderSide: new BorderSide(),
        ),
        icon: IconButton(
          onPressed: () {
            setState(() {
              editbool = false;
            });
            // print(nameBool);
          },
          icon: Icon(
            Icons.swap_vertical_circle,
            color: Colors.black54,
          ),
        ),
      ),
      onChanged: (value) {
        _onChangeDesc(value);
      },
      onSubmitted: ((e) {
        editbool = false;
        updateDesc(
          productId,
          available,
        );
      }),
    );
  }

  int n = 0;
  onChangePrice(String value) {
    if (value.isNotEmpty) {
      setState(() {
        price = num.tryParse(value).toInt();
        n = num.tryParse(value).toInt();
      });
    }
  }

  editPrice(productId, available) {
    return Container(
      height: 50, width: 150,
      // width: 10,
      // color: Colors.red,
      child: TextField(
        // keyboardType: TextInputType.numberWithOptions(decimal: true),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          // labelText: '${widget.price}',
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(),
          ),
          icon: IconButton(
            onPressed: () {
              setState(() {
                pricebool = false;
              });
              // print(nameBool);
            },
            icon: Icon(
              Icons.swap_vertical_circle,
              color: Colors.black54,
            ),
          ),
        ),
        onChanged: (value) {
          onChangePrice(value);

          print(n);
          // _onChangeDesc(value);
        },
        onSubmitted: ((e) {
          pricebool = false;
          updateDesc(productId, available);
        }),
      ),
    );
  }

  Color _color = Color(0xFF2C4B5D);
  _buildShowProductA(screenHeight, screenWidth, snapshots, snapshot, available,
      bool status,) {
    // cntorder=available;
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            height: screenHeight,
            width: screenWidth,
            color: Colors.grey[100],
          ),
          Hero(
            tag: heroTag,
            child: InkWell(
              onTap: () {
                // showDialog(
                //     context: context,
                //     builder: (context) {
                //       return Material(
                //                             child: Container(
                //           height: screenHeight,
                //           width: screenWidth,
                //           decoration: BoxDecoration(
                //               image: DecorationImage(image: NetworkImage(heroTag))),
                //         ),
                //       );
                //     });
              },
              child: Container(
                height: screenHeight / 3,
                width: screenWidth,
                child: CachedNetworkImage(
                  imageUrl: heroTag,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 15.0,
            left: 15.0,
            right: 15.0,
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              elevation: 3.0,
              child: Container(
                // height: 200.0,
                // width: screenWidth - 30.0,
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10.0),
                //     color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '   ${snapshots.data['catalog']}   ',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                        width: screenWidth - 50,
                        child: editbool == false
                            ? ListTile(
                                title: Text(
                                  "${snapshots.data['description']}",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xFF8597A0)),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      editbool = true;
                                    });
                                  },
                                  icon: Icon(Icons.edit),
                                ))
                            : editDescription(snapshots.data['description'],
                                snapshots.data['productId'], available)),
                    SizedBox(height: 10.0),
                    Container(
                      width: screenHeight - 50.0,
                      height: 1.0,
                      color: Colors.grey.withOpacity(0.4),
                    ),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: <Widget>[
                        new IconButton(
                          onPressed: () {
                            addAdmin(available);
                          },
                          icon: new Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          color: Colors.white,
                        ),
                        Text("${status == true ? cntorderAdmin : cntorder}",
                            style: TextStyle(
                                fontFamily: 'Inconsolata',
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: _color)),
                        IconButton(
                          onPressed: () {
                            minusAdmin(available);
                          },
                          icon: new Icon(
                              const IconData(0xe15b,
                                  fontFamily: 'MaterialIcons'),
                              color: Colors.black),
                          color: Colors.white,
                        ),
                        cntorderAdmin != available
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    updateDesc(
                                        snapshots.data['productId'], available);
                                  });
                                },
                                icon: Icon(
                                  Icons.save,
                                  color: _color,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 5.0),
                        child: Container(
                            width: double.infinity,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '${snapshots.data['cur']} ${snapshots.data['price']}',
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  pricebool == true
                                      ? editPrice(snapshots.data['productId'],
                                          available)
                                      : IconButton(
                                          onPressed: () {
                                            setState(() {
                                              pricebool = true;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.grey,
                                          ),
                                        ),
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    color: _color,
                                    icon: Icon(Icons.arrow_forward_ios,
                                        size: 15.0),
                                  ),
                                ])))
                  ],
                ),
              ),
            ),
          ),
          // Positioned(
          //   left: 50.0,
          //   top: (screenHeight / 2) - 50,
          //   child: Container(
          //     height: 35.0,
          //     width: 125.0,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(7.0),
          //         color: Colors.black.withOpacity(0.4)),
          //     child: Center(
          //         child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         Text(
          //           'Add Card',
          //           style: TextStyle(
          //               fontFamily: 'Montserrat',
          //               color: Colors.white,
          //               fontWeight: FontWeight.bold),
          //         ),
          //         Icon(Icons.arrow_forward_ios, color: Colors.white, size: 17.0)
          //       ],
          //     )),
          //   ),
          // ),
          status == false
              ? Positioned(
                  left: 50.0,
                  top: (screenHeight / 2) - 30,
                  child: StoreHeart(
                    uid: widget.uid,
                    adminUser: snapshots.data['ownerId'],
                    productId: snapshots.data['productId'],
                  ))
              : Container(),
          status == true
              ? Positioned(
                  top: screenHeight / 3,
                  child: IconButton(
                    onPressed: () {
                      _firestore
                          .collection("AdminUsers")
                          .document(widget.uid)
                          .collection("store")
                          .document(snapshots.data['productId'])
                          .delete();
                      Navigator.pop(context);
                      // snapshots.data.forEach((doc){

                      // });

                      //show action
                      //delete product
                    },
                    icon: Icon(
                      Icons.delete,
                      color: _color,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
    // return Stack(
    //   textDirection: TextDirection.rtl,
    //   children: <Widget>[
    //     Container(
    //       height: screenHeight,
    //       width: screenWidth,
    //       color: Colors.white,
    //     ),
    //     Positioned(
    //       top: screenHeight / 2 + 75.0,
    //       child: Text('${snapshots.data['catalog']}',
    //           style: TextStyle(
    //               fontFamily: 'Inconsolata',
    //               fontSize: 175.0,
    //               fontWeight: FontWeight.bold,
    //               color: Color(0xFFF3F5F7))),
    //     ),
    //     Padding(
    //       padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 30),
    //       child: Container(
    //         height: 50.0,
    //         // width: screenWidth,
    //         child: Row(
    //           textDirection: TextDirection.rtl,
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             Padding(
    //               padding: const EdgeInsets.only(left: 40),
    //               child: IconButton(
    //                 onPressed: () => Navigator.pop(context),
    //                 icon: Icon(
    //                   Icons.arrow_back_ios,
    //                   color: Color(0xFF274B61),
    //                   textDirection: TextDirection.rtl,
    //                 ),
    //               ),
    //             ),
    //             Text('${snapshots.data['catalog']}',
    //                 style: TextStyle(
    //                     fontFamily: 'Inconsolata',
    //                     fontSize: 24.0,
    //                     fontWeight: FontWeight.bold,
    //                     color: Color(0xFF274B61))),
    //             IconButton(
    //               onPressed: () {
    //                 _firestore
    //                     .collection("AdminUsers")
    //                     .document(widget.uid)
    //                     .collection("store")
    //                     .document(snapshots.data['productId'])
    //                     .delete();
    //                 // snapshots.data.forEach((doc){

    //                 // });

    //                 //show action
    //                 //delete product
    //               },
    //               icon: Icon(Icons.delete),
    //             )
    //           ],
    //         ),
    //       ),
    //     ),
    //     Positioned(
    //       top: 100,
    //       left: 25,
    //       child: Container(
    //           width: screenWidth - 50,
    //           child: editbool == false
    //               ? ListTile(
    //                   title: Text(
    //                     "${snapshots.data['description']}",
    //                     maxLines: 2,
    //                     style:
    //                         TextStyle(fontSize: 14, color: Color(0xFF8597A0)),
    //                   ),
    //                   trailing: IconButton(
    //                     onPressed: () {
    //                       setState(() {
    //                         editbool = true;
    //                       });
    //                     },
    //                     icon: Icon(Icons.edit),
    //                   ),
    //                 )
    //               : editDescription(snapshots.data['description'],
    //                   snapshots.data['productId'], available)),
    //     ),
    //     Positioned(
    //         top: 155.0,
    //         left: 25.0,
    //         child: Row(
    //           textDirection: TextDirection.rtl,
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: <Widget>[
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: <Widget>[
    //                 pricebool == true
    //                     ? editPrice(snapshots.data['productId'], available)
    //                     : Container(),
    //                 Container(
    //                   height: 80,
    //                   width: 80,
    //                   decoration: BoxDecoration(
    //                       shape: BoxShape.circle,
    //                       image: DecorationImage(
    //                           image: CachedNetworkImageProvider(
    //                               "${snapshot.data['photoUrl']}"
    //                               // "${snapshot.data['photoUrl']}",
    //                               ),
    //                           fit: BoxFit.cover)),
    //                 ),
    //                 sizeB(5.0),
    //                 Text("${snapshot.data['userName']}"),
    //                 sizeB(15.0),
    //                 Text('${DemoLocalizations.of(context).available}',
    //                     style: TextStyle(
    //                         fontFamily: 'Inconsolata',
    //                         fontSize: 16.0,
    //                         color: Color(0xFF88969E))),
    //                 sizeB(10.0),
    //                 Text("$available",
    //                     style: TextStyle(
    //                         fontFamily: 'Inconsolata',
    //                         fontSize: 16.0,
    //                         fontWeight: FontWeight.bold,
    //                         color: _color)),
    //                 SizedBox(height: 10.0),
    //                 Row(
    //                   textDirection: TextDirection.rtl,
    //                   children: <Widget>[
    //                     new IconButton(
    //                       onPressed: () {
    //                         addAdmin(available);
    //                       },
    //                       icon: new Icon(
    //                         Icons.add,
    //                         color: Colors.black,
    //                       ),
    //                       color: Colors.white,
    //                     ),
    //                     Text("$cntorderAdmin",
    //                         style: TextStyle(
    //                             fontFamily: 'Inconsolata',
    //                             fontSize: 16.0,
    //                             fontWeight: FontWeight.bold,
    //                             color: _color)),
    //                     IconButton(
    //                       onPressed: () {
    //                         minusAdmin(available);
    //                       },
    //                       icon: new Icon(
    //                           const IconData(0xe15b,
    //                               fontFamily: 'MaterialIcons'),
    //                           color: Colors.black),
    //                       color: Colors.white,
    //                     ),
    //                   ],
    //                 ),
    //                 cntorder != available
    //                     ? IconButton(
    //                         onPressed: () {
    //                           setState(() {
    //                             updateDesc(
    //                                 snapshots.data['productId'], available);
    //                           });
    //                         },
    //                         icon: Icon(
    //                           Icons.save,
    //                           color: _color,
    //                         ),
    //                       )
    //                     : Container(),
    //                 SizedBox(height: 25.0),
    //                 Text('TOTAL',
    //                     style: TextStyle(
    //                         fontFamily: 'Inconsolata',
    //                         fontSize: 16.0,
    //                         fontWeight: FontWeight.bold,
    //                         color: _color)),
    //                 SizedBox(height: 10.0),
    //                 FlatButton.icon(
    //                   textColor: _color,
    //                   onPressed: () {
    //                     setState(() {
    //                       pricebool = true;
    //                     });
    //                   },
    //                   icon: Icon(Icons.edit),
    //                   label: Text(
    //                     '${snapshots.data['cur']} ${snapshots.data['price']}',
    //                     style: TextStyle(
    //                         fontSize: 22.0, fontWeight: FontWeight.bold),
    //                     textDirection: TextDirection.ltr,
    //                   ),
    //                 ),
    //                 SizedBox(height: 20.0),
    //               ],
    //             ),
    //             RotatedBox(
    //               quarterTurns: 0,
    //               child: Container(
    //                 height: screenHeight - 100,
    //                 width: screenWidth / 2,
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(10),
    //                     image: DecorationImage(
    //                         image: CachedNetworkImageProvider(
    //                             "${widget.imagePost}"),
    //                         fit: BoxFit.cover)),
    //               ),
    //             )
    //           ],
    //         ))
    //   ],
    // );
  }

  int cnt = 0;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: FutureBuilder(
          future: _getstore(),
          builder: (context, snapshots) {
            if (!snapshots.hasData) {
              return Container();
            }
            return FutureBuilder(
                future: _getUsers(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  final available = snapshots.data['available'];

                  if (cnt == 0) {
                    cntorderAdmin = available;
                    cnt++;
                  }
                  return snapshots.data['ownerId'] != widget.uid
                      // ? _buildShowProductA(screenHeight, screenWidth, snapshots,
                      //     snapshot.data, available, false, snapshots.data)
                      ? _buildShowProductC(screenHeight, screenWidth, snapshots,
                          snapshot.data, available, false, snapshots.data)
                      : _buildShowProductA(screenHeight, screenWidth, snapshots,
                          snapshot.data, available, true,);
                });
          }),
    );
  }
}
