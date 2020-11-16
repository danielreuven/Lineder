import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lineder/user/homepageuser/homepageuser.dart';

class StoreBuyNow extends StatefulWidget {
  final uid;
  final productId;
  final price;
  final String cur;
  final int cntorder;
  final adminUser;
  final imagePost;
  final catalog;
  final int avaible;
  final address;
  final userBrand;
  final phone;

  const StoreBuyNow(
      {Key key,
      this.uid,
      this.productId,
      this.price,
      this.cur,
      this.cntorder,
      this.adminUser,
      this.imagePost,
      this.catalog,
      this.avaible,
      this.address,
      this.userBrand,
      this.phone})
      : super(key: key);
  @override
  _StoreBuyNowState createState() => _StoreBuyNowState();
}

class _StoreBuyNowState extends State<StoreBuyNow> {
  TabBar _tabBarLabel() => TabBar(
        tabs: [
          Tab(
            text: "Pick Up",
            icon: Icon(
              Icons.shopping_basket,
              size: 24,
              color: Color(0xff2d386b),
            ),
          ),
          Tab(
            text: "Shipping",
            icon: Icon(
              FontAwesomeIcons.shippingFast,
              size: 24,
              color: Color(0xff2d386b),
            ),
          ),
        ],
        onTap: (index) {
          var content = "";
          switch (index) {
            case 0:
              content = "Pick Up";
              break;
            case 1:
              content = "Shipping";
              break;
            default:
              content = "Pick Up";
              break;
          }
        },
        indicator: ShapeDecoration(
          shape: BeveledRectangleBorder(
              side: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(30)),
          gradient: SweepGradient(
            colors: [
              Colors.yellow,
              Colors.purple,
              Colors.red,
              Colors.green,
              Colors.blue
            ],
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.grey,
              ),
            ),
            elevation: 0.0,
            backgroundColor: Colors.white,
            bottom: _tabBarLabel(),
          ),
          // appBar: AppBar(),
          body: TabBarView(
            children: <Widget>[
              BuyFromBusiness(
                uid: widget.uid,
                productId: widget.productId,
                price: widget.price,
                cur: widget.cur,
                cntorder: widget.cntorder,
                adminUser: widget.adminUser,
                imagePost: widget.imagePost,
                catalog: widget.catalog,
                avaible: widget.avaible,
                address: widget.address,
                userBrand: widget.userBrand,
                phone: widget.phone,
              ),
              BuyFromApp(
                uid: widget.uid,
                productId: widget.productId,
                price: widget.price,
                cur: widget.cur,
                cntorder: widget.cntorder,
                adminUser: widget.adminUser,
                imagePost: widget.imagePost,
                catalog: widget.catalog,
                avaible: widget.avaible,
                address: widget.address,
                userBrand: widget.userBrand,
                phone: widget.phone,
              ),
            ],
          )),
    );
  }
}

class BuyFromBusiness extends StatelessWidget {
  final uid;
  final productId;
  final price;
  final String cur;
  int cntorder;
  final adminUser;
  final String imagePost;
  final catalog;
  int avaible;
  final address;
  final userBrand;
  final phone;
  BuyFromBusiness(
      {Key key,
      this.uid,
      this.productId,
      this.price,
      this.cur,
      this.cntorder,
      this.adminUser,
      this.imagePost,
      this.catalog,
      this.avaible,
      this.address,
      this.userBrand,
      this.phone})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final sreenH = MediaQuery.of(context).size.height;
    final sreenW = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        height: sreenH,
        child: Column(
          textDirection: TextDirection.ltr,
          children: <Widget>[
            StatefulBuilder(builder: (context, setState) {
              return Row(
                children: <Widget>[
                  Container(
                      height: sreenH - 150,
                      width: sreenW / 2,
                      color: Colors.lightGreen,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("$catalog"),
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                // shape: BoxShape.rectangle,
                                // color: Colors.black,
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        "$imagePost"),
                                    fit: BoxFit.cover)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            textDirection: TextDirection.rtl,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  if (avaible > cntorder) {
                                    setState(() {
                                      cntorder++;
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
                                    });
                                  }
                                },
                                icon: Icon(
                                    const IconData(0xe15b,
                                        fontFamily: 'MaterialIcons'),
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Text("TOTAL"),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            "$cur ${price * cntorder}",
                            textDirection: TextDirection.ltr,
                          )
                        ],
                      )),
                  Container(
                    height: sreenH - 150,
                    width: sreenW / 2,
                    color: Colors.lightBlue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textDirection: TextDirection.ltr,
                      children: <Widget>[
                        Text('$address'),
                        Text('$userBrand'),
                        Text('$phone'),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: RaisedButton(
                            color: Colors.purple,
                            onPressed: () async {
                              int avaibleUpdate = 0;
                              int cntorderupdate = 0;
                              var pro = Firestore.instance
                                  .collection("AdminUsers")
                                  .document(adminUser)
                                  .collection("store")
                                  .document(productId)
                                  .get();
                              pro.then((doc) {
                                avaibleUpdate = doc.data['available'];
                                cntorderupdate = avaibleUpdate - cntorder;
                                print('$cntorderupdate');
                              }).then((docc) {
                                Firestore.instance
                                    .collection("AdminUsers")
                                    .document(adminUser)
                                    .collection("store")
                                    .document(productId)
                                    .updateData({
                                  "available": cntorderupdate,
                                  'addCard.$uid': false,
                                  "paid.$uid": true,
                                }).then((docc) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UserHomePage(
                                                uid: uid,
                                              )));
                                });
                              });
                            },
                            child: Text("PAY"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class BuyFromApp extends StatelessWidget {
  final uid;
  final productId;
  final price;
  final String cur;
  int cntorder;
  final adminUser;
  final imagePost;
  final catalog;
  final avaible;
  final address;
  final userBrand;
  final phone;
  BuyFromApp(
      {Key key,
      this.uid,
      this.productId,
      this.price,
      this.cur,
      this.cntorder,
      this.adminUser,
      this.imagePost,
      this.catalog,
      this.avaible,
      this.address,
      this.userBrand,
      this.phone})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
