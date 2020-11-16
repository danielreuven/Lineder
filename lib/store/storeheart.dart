import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StoreHeart extends StatefulWidget {
  final adminUser;
  // final snapshots;
  final uid;
  final productId;

  const StoreHeart({Key key, this.adminUser, this.uid, this.productId})
      : super(key: key);
  @override
  _StoreHeartState createState() => _StoreHeartState();
}

class _StoreHeartState extends State<StoreHeart> {
  bool isFollowing = false;
  bool followButtonClicked = false;

  @override
  void initState() {
    super.initState();
    sub = db
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("showHeart")
        .document(widget.productId)
        .snapshots()
        .listen((snap) {
      setState(() {
        data1 = snap.data;
      });

      data1 != null
          ? data1['showHeart'] == true ? isFollowing = true : print("no follow")
          : isFollowing = false;
    });
    // print(data1);
    // sub = db
    //     .collection("CustomerUsers")
    //     .document(widget.uid)
    //     .snapshots()
    //     .listen((snap) {
    //   setState(() {
    //     data = snap.data;
    //   });
    // });
  }

  // var _iceCreamStores;
  @override
  void dispose() {
    sub.cancel();
    // sub.pause();
    // sub1.cancel();
    super.dispose();
  }

  final db = Firestore.instance;
  StreamSubscription sub;

  // Map data;
  // StreamSubscription sub1;

  Map data1;
  followUser() {
    print('following user');
    // print(currentUserId);
    setState(() {
      this.isFollowing = true;
      followButtonClicked = true;
    });

    db
        .document("AdminUsers/${widget.adminUser}")
        .collection("store")
        .document(widget.productId)
        .updateData({'showHeart.${widget.uid}': true});
    db
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("showHeart")
        .document(widget.productId)
        .setData({
      "ownerId": "${widget.adminUser}",
      "productId": widget.productId,
      "user": widget.uid,
      "timestamp": FieldValue.serverTimestamp(),
      "showHeart": true,
    });
  }

  unfollowUser() {
       print('unfollowing user');
    setState(() {
      this.isFollowing = false;
      followButtonClicked = true;
    });

    db
        .document("AdminUsers/${widget.adminUser}")
        .collection("store")
        .document(widget.productId)
        .updateData({'showHeart.${widget.uid}': false});
    db
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("showHeart")
        .document(widget.productId)
        .delete();
  }

  // Text buildStatColumn(int number) {
  //   return Text(
  //     number.toString(),
  //     style: TextStyle(
  //         fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white),
  //   );
  // }

  Container buildFollowButton(
      {IconData icon,
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
              child: Icon(
                icon,
                size: 14,
                color: Colors.blue,
              ))),
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
        icon: FontAwesomeIcons.solidHeart,
        backgroundcolor: Colors.white54,
        textColor: Colors.black87,
        borderColor: Colors.grey,
        function: unfollowUser,
      );
    }

    // does not follow user - should show follow button
    if (!isFollowing) {
      return buildFollowButton(
        icon: FontAwesomeIcons.heart,
        backgroundcolor: Colors.black38,
        textColor: Colors.white,
        borderColor: Colors.blue,
        function: followUser,
      );
    }

    return buildFollowButton(
        icon: Icons.replay,
        backgroundcolor: Colors.white,
        textColor: Colors.black,
        borderColor: Colors.grey);
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
      ],
    );
  }
}
