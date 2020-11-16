import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class AddReviews extends StatefulWidget {
  final uid;
  final snapshots;
  AddReviews({this.uid, this.snapshots});

  @override
  _AddReviewsState createState() => _AddReviewsState();
}

class _AddReviewsState extends State<AddReviews> {
  var rating = 0.0;
  var result;

  @override
  void initState() {
    super.initState();

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
  }

  @override
  void dispose() {
    sub.cancel();
    subReviews.cancel();
    super.dispose();
  }

  final db = Firestore.instance;
  StreamSubscription sub;
  StreamSubscription subReviews;
  Map data;
  Map data1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: ListTile(
            leading: IconButton(
                onPressed: () {
                  if (widget.snapshots['reviews'][widget.uid] == null ||
                      widget.snapshots['reviews'][widget.uid] == false) {
                    print("new user");
                    var newUsersum = widget.snapshots['reviewsAvarge'] + rating;
                    var cntplus = widget.snapshots['reviewsAvargeCnt'] + 1;
                    Firestore.instance
                        .collection("AdminUsers")
                        .document(widget.snapshots['adminUser'])
                        .collection("reviews")
                        .document(widget.uid)
                        .setData({
                      "adminSuser": "${widget.snapshots['adminUser']}",
                      "user": "${widget.uid}",
                      "reviews": rating,
                      "userName": "${data['userName']}",
                      "photoUrl": "${data['photoUrl']}"
                    });

                    Firestore.instance
                        .collection("AdminUsers")
                        .document(widget.snapshots['adminUser'])
                        .updateData({
                      "reviewsAvarge": newUsersum,
                      "reviewsAvargeCnt": cntplus,
                      "reviewsresult": newUsersum / cntplus,
                      'reviews.${widget.uid}': true,
                    });

                    // rating = 0.0;
                  } else {
                    var olduserSum =
                        (widget.snapshots['reviewsAvarge'] - data1['reviews']) +
                            rating;

                    print(olduserSum);

                    Firestore.instance
                        .collection("AdminUsers")
                        .document(widget.snapshots['adminUser'])
                        .collection("reviews")
                        .document(widget.uid)
                        .setData({
                      "adminSuser": "${widget.snapshots['adminUser']}",
                      "user": "${widget.uid}",
                      "reviews": rating,
                      "userName": "${data['userName']}",
                      "photoUrl": "${data['photoUrl']}"
                    });
                    Firestore.instance
                        .collection("AdminUsers")
                        .document(widget.snapshots['adminUser'])
                        .updateData({
                      "reviewsAvarge": olduserSum,
                      "reviewsresult":
                          olduserSum / widget.snapshots['reviewsAvargeCnt'],
                    });
                  }
                },
                icon: Icon(
                  Icons.save,
                  color: Colors.blue[700],
                )),
            title: StatefulBuilder(
              builder: (context, setState) {
                return SmoothStarRating(
                    allowHalfRating: true,
                    onRatingChanged: (v) {
                      setState(() {
                        rating = v;
                      });
                    },
                    starCount: 5,
                    rating: rating,
                    size: 40.0,
                    color: Colors.yellow[800],
                    borderColor: Colors.black,
                    spacing: 0.0);
              },
            ),
            onTap: () => {},
          ),
        ),
      ),
    );
  }
}
