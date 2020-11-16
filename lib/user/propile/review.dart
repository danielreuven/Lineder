import 'dart:async';
import 'dart:io';

import 'package:lineder/admin/areaperson/imageuplode/models/image_picker_handler.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewsAdmin extends StatefulWidget {
  final snapshots;
  final String uid;
  final String adminUid;
  ReviewsAdmin({this.snapshots, this.uid, this.adminUid});

  @override
  _ReviewsAdminState createState() => _ReviewsAdminState();
}

class _ReviewsAdminState extends State<ReviewsAdmin>
    with TickerProviderStateMixin, ImagePickerListener {
  VoidCallback voidCallback;
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double rating = 0.0;
  var result;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    sub = db
        .collection("CustomerUsers")
        .document(widget.uid)
        .snapshots()
        .listen((snap) {
      setState(() {
        data = snap.data;
      });
    });
    subReviews = db
        .collection("AdminUsers")
        .document(widget.snapshots['adminUser'])
        .collection("reviews")
        .document(widget.uid)
        .snapshots()
        .listen((snapReviews) {
      setState(() {
        data1 = snapReviews.data;
      });
    });

    _getProductsStarFuture = _getProductsStar();
  }

  Future _getProductsStarFuture;
  Map<String, dynamic> _users = {};
  @override
  void dispose() {
    sub.cancel();
    subReviews.cancel();
    _controller.dispose();
    super.dispose();
  }

  final db = Firestore.instance;
  StreamSubscription sub;
  StreamSubscription subReviews;
  Map data;
  Map data1;
  bool stat = false;
  void status() {
    setState(() {
      stat = !stat;

      print(stat);
    });
  }

  TextEditingController textreviews = TextEditingController();
  // Color myColor = Color(0xff00bfa5);
  openAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: Container(
                width: 300.0,
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   // shape: BoxShape.rectangle,
                //   boxShadow: [
                //     BoxShadow(
                //       color: Colors.blue,
                //       blurRadius: 10.0,
                //       offset: const Offset(0.0, 10.0),
                //     ),
                //   ],
                // ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SmoothStarRating(
                        allowHalfRating: true,
                        onRatingChanged: (v) {
                          setState(() {
                            rating = v;
                          });
                        },
                        starCount: 5,
                        rating: rating,
                        size: 30.0,
                        color: Colors.blue[800],
                        borderColor: Colors.blue,
                        spacing: 0.0),
                    SizedBox(
                      height: 5.0,
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: TextField(
                        controller: textreviews,
                        decoration: InputDecoration(
                          hintText:
                              "${DemoLocalizations.of(context).writesometing}",
                          border: InputBorder.none,
                        ),
                        maxLines: 4,
                        maxLength: 40,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        var texts =
                            textreviews.text != null ? textreviews.text : " ";
                        if (widget.snapshots['reviews'][widget.uid] == null ||
                            widget.snapshots['reviews'][widget.uid] == false) {
                          print("new user");
                          var newUsersum =
                              widget.snapshots['reviewsAvarge'] + rating;
                          var cntplus =
                              widget.snapshots['reviewsAvargeCnt'] + 1;
                          Firestore.instance
                              .collection("AdminUsers")
                              .document(widget.adminUid)
                              .collection("reviews")
                              .document(widget.uid)
                              .setData({
                            "adminSuser": "${widget.adminUid}",
                            "user": "${widget.uid}",
                            "reviews": rating,
                            "textreview": texts,
                            // "userName": "${data['userName']}",
                            // "photoUrl": "${data['photoUrl']}"
                          });

                          Firestore.instance
                              .collection("AdminUsers")
                              .document(widget.adminUid)
                              .updateData({
                            "reviewsAvarge": newUsersum,
                            "reviewsAvargeCnt": cntplus,
                            "reviewsresult": newUsersum / cntplus,
                            'reviews.${widget.uid}': true,
                          });

                          // rating = 0.0;
                        } else {
                          var olduserSum = (widget.snapshots['reviewsAvarge'] -
                                  data1['reviews']) +
                              rating;

                          print(olduserSum);
                          setState(() {
                            Firestore.instance
                                .collection("AdminUsers")
                                .document(widget.adminUid)
                                .collection("reviews")
                                .document(widget.uid)
                                .setData({
                              "adminSuser": "${widget.adminUid}",
                              "user": "${widget.uid}",
                              "reviews": rating,
                              "userName": "${data['userName']}",
                              "photoUrl": "${data['photoUrl']}",
                              "textreview": texts,
                            });
                            Firestore.instance
                                .collection("AdminUsers")
                                .document(widget.adminUid)
                                .updateData({
                              "reviewsAvarge": olduserSum,
                              "reviewsresult": olduserSum /
                                  widget.snapshots['reviewsAvargeCnt'],
                            });
                          });
                        }
                        _getProductsStarFuture = _getProductsStar();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(32.0),
                              bottomRight: Radius.circular(32.0)),
                        ),
                        child: Text(
                          "${DemoLocalizations.of(context).addreviews}",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  Future _getUserData() async {
    QuerySnapshot userDataQuerySnapshot =
        await Firestore.instance.collection("CustomerUsers").getDocuments();
    // .document(userAdmin)
    // .get();

    for (DocumentSnapshot document in userDataQuerySnapshot.documents) {
      _users[document.documentID] = document.data;
    }
  }

  Future _getProductsStar() async {
    await _getUserData();
    QuerySnapshot q = await Firestore.instance
        .collection("AdminUsers")
        .document(widget.adminUid)
        .collection("reviews")
        .getDocuments();

    return q.documents;
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future onRefresh() async {
    await Future.delayed(Duration(microseconds: 200));
    setState(() {
      _getProductsStar();
    });
    return null;
  }

  // Future _getUserData(userAdmin) async {
  //   final userDataQuery = await Firestore.instance
  //       .collection("CustomerUsers")
  //       .document(userAdmin)
  //       .get();

  //   return userDataQuery.data;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: widget.snapshots['reviews'][widget.uid] == false ||
              widget.snapshots['reviews'][widget.uid] == null
          ? FloatingActionButton(
              onPressed: () {
                if (widget.snapshots['freinds'][widget.uid] == false ||
                    widget.snapshots['freinds'][widget.uid] == null) {
                  showInSnackBar("רק חברים יכולים");
                } else {
                  openAlertBox();
                  // _addReviews(context);
                }
              },
              child: Icon(Icons.rate_review),
            )
          : Container(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
          future: _getProductsStarFuture,
          builder: (context, snapshots) {
            if (!snapshots.hasData) {
              return Container();
            }
            return SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      child: ListTile(
                        title: Text.rich(TextSpan(
                            text:
                                "${DemoLocalizations.of(context).reviews} ${snapshots.data.length}")),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 50,
                      child: ListView.builder(
                        itemCount: snapshots.data.length,
                        itemBuilder: (context, index) {
                          var document = snapshots.data[index].data;
                          var snapshot = _users[document['user']];
                          // return FutureBuilder(
                          //     future: _getUserData(
                          //         snapshots.data[index].data['user']),
                          //     builder: (context, snapshot) {
                          //       if (!snapshot.hasData) {
                          //         return Container();
                          //       }

                          return Card(
                            color: Colors.grey[50],
                            elevation: 4.0,
                            child: ListTile(
                              trailing: snapshots.data[index].data['user'] ==
                                      widget.uid
                                  ? IconButton(
                                      onPressed: () {
                                        var reviewsav =
                                            widget.snapshots['reviewsAvarge'] -
                                                data1['reviews'];
                                        var reviews = widget
                                                .snapshots['reviewsAvargeCnt'] -
                                            1;
                                        Firestore.instance
                                            .collection("AdminUsers")
                                            .document(widget.adminUid)
                                            .collection("reviews")
                                            .document(widget.uid)
                                            .delete();
                                        Firestore.instance
                                            .collection("AdminUsers")
                                            .document(widget.adminUid)
                                            .updateData({
                                          "reviewsAvarge": reviewsav,
                                          "reviewsAvargeCnt": reviews,
                                          "reviewsresult": reviewsav / reviews,
                                          'reviews.${widget.uid}': false,
                                        });
                                        _getProductsStarFuture =
                                            _getProductsStar();
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red[300],
                                      ),
                                    )
                                  : SizedBox(),
                              title: Row(
                                children: <Widget>[
                                  Text("${snapshot['userName']}"),
                                  SmoothStarRating(
                                      allowHalfRating: true,
                                      starCount: 5,
                                      rating:
                                          snapshots.data[index].data['reviews'],
                                      size: 12.0,
                                      color: Colors.yellow[800],
                                      borderColor: Colors.black,
                                      spacing: 0.0),
                                ],
                              ),
                              subtitle: Text(
                                  "${snapshots.data[index].data['textreview']}"),
                              leading: Container(
                                // width: 40.0,
                                // height: 40.0,
                                // decoration: new BoxDecoration(
                                //   shape: BoxShape.circle,
                                //   // image: new DecorationImage(
                                //   //   fit: BoxFit.fill,
                                //   //   image: new CachedNetworkImageProvider(
                                //   //       "${snapshot['photoUrl']}"),
                                //   // ),
                                // ),
                                child: CachedNetworkImage(
                                  imageUrl: "${snapshot['photoUrl']}",
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                  fit: BoxFit.cover,
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ),
                          );
                          // });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  userImage(File _image) {
    setState(() {
      this._image = _image;
    });
  }
}
