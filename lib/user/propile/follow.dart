import 'dart:async';

import 'package:lineder/helpers/locale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Followers extends StatefulWidget {
  final adminUser;
  final snapshots;
  final uid;
  final bool status;
  Followers({this.snapshots, this.uid, this.adminUser, this.status});
  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  bool isFollowing = false;
  bool followButtonClicked = false;

  @override
  void initState() {
    super.initState();
    // if (db
    //     .collection("AdminUsers")
    //     .document(widget.snapshots['adminUser'])
    //     .collection("followers")
    //     .document(widget.uid)
    //     .snapshots()) {}
    sub1 = db
        .collection("AdminUsers")
        .document(widget.adminUser) //widget.snapshots['adminUser']
        .collection("followers")
        .document(widget.uid)
        .snapshots()
        .listen((snap) {
      setState(() {
        data1 = snap.data;
      });

      data1 != null
          ? data1['followers'] == true ? isFollowing = true : print("no follow")
          : isFollowing = false;
    });
    print(data1);
    sub = db
        .collection("CustomerUsers")
        .document(widget.uid)
        .snapshots()
        .listen((snap) {
      setState(() {
        data = snap.data;
      });
    });
  }

  // var _iceCreamStores;
  @override
  void dispose() {
    sub.cancel();
    sub1.cancel();
    super.dispose();
  }

  final db = Firestore.instance;
  StreamSubscription sub;

  Map data;
  StreamSubscription sub1;

  Map data1;
  followUser() {
    print('following user');
    // print(currentUserId);
    setState(() {
      this.isFollowing = true;
      followButtonClicked = true;
    });

    // Firestore.instance
    //     .document("AdminUsers/${widget.snapshots['adminUser']}")
    //     .updateData({
    //   'followers.${widget.uid}': true,
    // });
    // String productId = DateTime.now().millisecondsSinceEpoch.toString();
    Firestore.instance
        .document("AdminUsers/${widget.snapshots['adminUser']}")
        .collection("followers")
        .document(widget.uid)
        .setData({
      // "name": "${data['userName']}",
      // "photo": "${data['photoUrl']}",
      "user": widget.uid,
      "adminUser": "${widget.snapshots['adminUser']}",
      "followers": true,
      // "productId": productId,
    });
    Firestore.instance
        .document("CustomerUsers/${widget.uid}")
        .collection("following")
        .document("${widget.snapshots['adminUser']}")
        .setData({
      // "name": "${widget.snapshots['userName']}",
      // "photo": "${widget.snapshots['image']}",
      "user": widget.uid,
      "adminUser": "${widget.snapshots['adminUser']}",
      "followers": true,
    });

    Firestore.instance
        .collection("AdminUsers")
        .document(widget.snapshots['adminUser'])
        .collection("notific")
        .document(widget.uid)
        .setData({
      "ownerId": widget.snapshots['adminUser'],
      // "username": data['userName'],
      "userId": widget.uid,
      "type": "follow",
      // "userProfileImg": data['photoUrl'],
      "timestamp": FieldValue.serverTimestamp(),
      "productId": widget.uid,
      "language": "${DemoLocalizations.of(context).language}"
    });
  }

  unfollowUser() {
    setState(() {
      isFollowing = false;
      followButtonClicked = true;
    });

    // Firestore.instance
    //     .document("AdminUsers/${widget.snapshots['adminUser']}")
    //     .updateData({
    //   'followers.${widget.uid}': false,
    // });
    Firestore.instance
        .collection("AdminUsers")
        .document(widget.snapshots['adminUser'])
        .collection("notific")
        .document(widget.uid)
        .delete();

    Firestore.instance
        .collection("AdminUsers")
        .document(widget.snapshots['adminUser'])
        .collection("followers")
        .document(widget.uid)
        .delete();

    Firestore.instance
        .document("CustomerUsers/${widget.uid}")
        .collection("following")
        .document("${widget.snapshots['adminUser']}")
        .delete();
  }

  Text buildStatColumn(int number) {
    return Text(
      number.toString(),
      style: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Container buildFollowButton(
      {String text,
      Color backgroundcolor,
      Color textColor,
      Color borderColor,
      Function function}) {
    return Container(
      // padding: EdgeInsets.only(top: 2.0),
      child: InkWell(
          onTap: function,
          child: Container(
            decoration: BoxDecoration(
                color: backgroundcolor,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            alignment: Alignment.center,
            child: Text(text, style: TextStyle(color: textColor, fontSize: 12)),
          )),
    );
  }

  Container buildProfileFollowButton(isFollowing) {
    // viewing your own profile - should show edit button
    // if (widget.w == widget.userId) {
    //   return buildFollowButton(
    //     text: "Edit Profile",
    //     backgroundcolor: Colors.white,
    //     textColor: Colors.black,
    //     borderColor: Colors.grey,
    //     function: editProfile,
    //   );
    // }

    // already following user - should show unfollow button
    if (isFollowing) {
      return buildFollowButton(
        text: "${DemoLocalizations.of(context).following}",
        backgroundcolor: Colors.white54,
        textColor: Colors.black87,
        borderColor: Colors.grey,
        function: unfollowUser,
      );
    }

    // does not follow user - should show follow button
    if (!isFollowing) {
      return buildFollowButton(
        text: "${DemoLocalizations.of(context).follow}",
        backgroundcolor: Colors.black38,
        textColor: Colors.white,
        borderColor: Colors.blue,
        function: followUser,
      );
    }

    return buildFollowButton(
        text: "${DemoLocalizations.of(context).loading}",
        backgroundcolor: Colors.white,
        textColor: Colors.black,
        borderColor: Colors.grey);
  }

  // Future _getListUser() async {
  //   Query q = Firestore.instance
  //       .collection("AdminUsers")
  //       .document(widget.snapshots['adminUser'])
  //       .collection("notific");

  //   QuerySnapshot querySnapshot = await q.getDocuments();
  //   return querySnapshot.documents;
  // }

  Future _getfollow() async {
    QuerySnapshot q = await db
        .collection("AdminUsers")
        .document(widget.snapshots['adminUser'])
        .collection("followers")
        .getDocuments();

    return q.documents;
  }

  var simpleNumber;
  String numberOfIntegerDigits(number) {
    simpleNumber = number;
    // .toDouble().abs();
    // It's unfortunate that we have to do this, but we get precision errors
    // that affect the result if we use logs, e.g. 1000000
    if (simpleNumber <= 10) return simpleNumber.toString();
    if (simpleNumber <= 100) return simpleNumber.toString();
    if (simpleNumber <= 1000) return simpleNumber.toString();
    if (simpleNumber <= 10000) return simpleNumber = "10K";
    if (simpleNumber <= 11000) return simpleNumber = "11K";
    if (simpleNumber <= 12000) return simpleNumber = "12K";
    if (simpleNumber <= 13000) return simpleNumber = "13K";
    if (simpleNumber <= 100000) return simpleNumber = "100K";
    if (simpleNumber <= 110000) return simpleNumber = "110K";
    if (simpleNumber <= 120000) return simpleNumber = "120K";
    if (simpleNumber <= 130000) return simpleNumber = "130K";
    if (simpleNumber <= 140000) return simpleNumber = "140K";
    if (simpleNumber <= 1000000) return simpleNumber = "1M";
    if (simpleNumber <= 1500000) return simpleNumber = "1.5M";
    if (simpleNumber <= 10000000) return simpleNumber = "1T";

    // We're past the point where being off by one on the number of digits
    // will affect the pattern, so now we can use logs.
    return simpleNumber;
  }

  Widget _buildStatContainer() {
    return FutureBuilder(
        future: _getfollow(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          numberOfIntegerDigits(snapshot.data.length);

          return Container(
            height: 60.0,
            margin: EdgeInsets.only(top: 8.0),
            // decoration: BoxDecoration(
            //   // color: Color(0xFFEFF4F7),
            // ),
            child: _buildStatItem(
                "${DemoLocalizations.of(context).followers}", simpleNumber),
          );
        });
  }

  Widget _buildStatItem(String label, simpleNumber) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.white70,
      fontSize: 12.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.white70,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            ////navigator all following //incule snapshot
          },
          child: Text(
            "$simpleNumber",
            style: _statCountTextStyle,
          ),
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  // var product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
            height: 30,
            width: 100,
            child: buildProfileFollowButton(isFollowing)),
        widget.status == true
            ? Container(
                height: 65,
                width: 70,
                child: _buildStatContainer(),
              )
            : Container()
      ],
    );
  }
}
