import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowFollowrsss extends StatefulWidget {
  final uid;
  final snapshots;
  final String userOradmin;
  ShowFollowrsss({this.uid, this.snapshots, this.userOradmin = 'AdminUsers'});

  @override
  _ShowFollowrsssState createState() => _ShowFollowrsssState();
}

class _ShowFollowrsssState extends State<ShowFollowrsss> {
  @override
  void initState() {
    // aa = widget.userOradmin;
    // print(widget.userOradmin);
    // print(aa);
    super.initState();
  }

  // var aa;

  Future _getUserData(userAdmin) async {
    final userDataQuery = await Firestore.instance
        .collection("AdminUsers")
        .document(userAdmin)
        .get();

    return userDataQuery.data;
  }

  // var namee;
  // var photo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.snapshots.data.documents.length,
        itemBuilder: (_, index) {
          return FutureBuilder(
              future:
                  _getUserData(widget.snapshots.data.documents[index].data['adminUser']),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

// snapshot.data.forEach
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 4.0,
                  child: ListTile(
                    title: Text(
                      "${snapshot.data['userName']}",
                      // "${snapshot.data[index].data['userName']}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    leading: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new CachedNetworkImageProvider(
                              "${snapshot.data['photoUrl']}"),
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
