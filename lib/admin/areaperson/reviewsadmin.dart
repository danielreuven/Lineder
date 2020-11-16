import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewsAdmin extends StatefulWidget {
  final uid;

  ReviewsAdmin({
    this.uid,
  });
  @override
  _ReviewsAdminState createState() => _ReviewsAdminState();
}

class _ReviewsAdminState extends State<ReviewsAdmin> {
  Future _getProductsStar() async {
    QuerySnapshot q = await Firestore.instance
        // .collection(widget.country)
        // .document('${widget.uid}')
        // .collection("${widget.statusGrand}")
        // .document(widget.uid)
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("reviews")
        .getDocuments();

    return q.documents;
  }

  Future _getNamefromUser(
    user,
  ) async {
    Query q = Firestore.instance
        // .collection("$countryUser")
        // .document('${widget.uid}')
        .collection("CustomerUsers")
        .where("user", isEqualTo: user);

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  var namee;
  var photo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.black,
        title: Text(
          "${DemoLocalizations.of(context).reviews}",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
          future: _getProductsStar(),
          builder: (context, snapshots) {
            if (!snapshots.hasData) {
              return Center();
            }
            return ListView.builder(
              itemCount: snapshots.data.length,
              itemBuilder: (_, index) {
                var document = snapshots.data[index].data;
                return FutureBuilder(
                    future: _getNamefromUser(
                      snapshots.data[index].data['user'],
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      snapshot.data.forEach((doc) {
                        namee = doc['userName'];
                        photo = doc['photoUrl'];
                      });
                      return snapshots.data.length != 0
                          ? ListTile(
                              title: Text(namee),
                              // title: data1['userName'],
                              subtitle: SmoothStarRating(
                                  allowHalfRating: true,
                                  starCount: 5,
                                  rating: document['reviews'],
                                  size: 12.0,
                                  color: Colors.yellow[800],
                                  borderColor: Colors.black,
                                  spacing: 0.0),
                              leading: Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: CachedNetworkImageProvider("$photo"),
                                  ),
                                ),
                              ),
                            )
                          : Container();
                    });
              },
            );
          }),
    );
  }
}
