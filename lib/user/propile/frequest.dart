import 'dart:async';

import 'package:lineder/helpers/locale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequstU extends StatefulWidget {
  final adminUser;
  final snapshots;
  final uid;
  RequstU({this.snapshots, this.uid, this.adminUser});
  @override
  _RequstUState createState() => _RequstUState();
}

class _RequstUState extends State<RequstU> {
  Firestore _firestore = Firestore.instance;
  var adminSuser;
  var adminName;
  var adminAddress;

  var adminImage;
  var adminBrand;

  bool isRequest = false;
  bool requestButtonClicked = false;
  bool isFreind = false;

  @override
  void initState() {
    super.initState();

    widget.snapshots['request'][widget.uid] == true
        ? isRequest = true
        : print("no ");
    widget.snapshots['freinds'][widget.uid] == true
        ? isFreind = true
        : print("no Freid");

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

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  final db = Firestore.instance;
  StreamSubscription sub;
  Map data;

  requestUser() {
    print('request user');
    // print(currentUserId);

    setState(() {
      this.isRequest = true;
      requestButtonClicked = true;
      // buildPostHeader();
    });
    String productId = widget.uid + "111r11";
    Firestore.instance
        .document("AdminUsers/${widget.snapshots['adminUser']}")
        .updateData({'request.${widget.uid}': true});

    _firestore
        .collection("AdminUsers")
        .document(widget.snapshots['adminUser'])
        .collection("AdminClientsRequst")
        .document(widget.uid)
        .setData({
      "user": "${widget.uid}",
      "productId": "$productId",
      // "name": "${data['userName']}",
      // "images": "${data['photoUrl']}",
      "status": "ClientRequst",
      // "phone": "${data['phone']}",
      "adminSuser": "${widget.snapshots['adminUser']}",
      // "adminName": "${widget.snapshots['userName']}",
      // "adminImage": "${widget.snapshots['image']}",
      // "adminBrand": "${widget.snapshots['userBrand']}",
      // "adminAddress": "${widget.snapshots['address']}",
      // "locationAdmin": GeoPoint(widget.snapshots['location'].latitude,
      //     widget.snapshots['location'].longitude)
    });
    _firestore
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("AdminClientsRequst")
        .document(widget.snapshots['adminUser'])
        .setData({
      "user": "${widget.uid}",
      "productId": "$productId",
      // "name": "${data['userName']}",
      // "images": "${data['photoUrl']}",
      "status": "ClientRequst",
      // "phone": "${data['phone']}",
      "adminSuser": "${widget.snapshots['adminUser']}",
      // "adminName": "${widget.snapshots['userName']}",
      // "adminImage": "${widget.snapshots['image']}",
      // "adminBrand": "${widget.snapshots['userBrand']}",
      // "adminAddress": "${widget.snapshots['address']}",
      // "locationAdmin": GeoPoint(widget.snapshots['location'].latitude,
      //     widget.snapshots['location'].longitude)
    });

    Firestore.instance
        .collection("AdminUsers")
        .document(widget.snapshots['adminUser'])
        .collection("notific")
        .document(productId)
        .setData({
      "ownerId": widget.snapshots['adminUser'],
      // "username": data['userName'],
      "userId": widget.uid,
      "type": "request",
      // "userProfileImg": data['photoUrl'],
      "timestamp": FieldValue.serverTimestamp(),
      "productId": productId,
      "language": "${DemoLocalizations.of(context).language}"
    });
  }

  unRequestUser() {
    setState(() {
      isRequest = false;
      requestButtonClicked = true;
    });

    Firestore.instance
        .document("AdminUsers/${widget.snapshots['adminUser']}")
        .updateData({
      'request.${widget.uid}': false
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });
    _firestore
        .collection("AdminUsers")
        .document(widget.snapshots['adminUser'])
        .collection("AdminClientsRequst")
        .document(widget.uid)
        .delete();

    _firestore
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("AdminClientsRequst")
        .document(widget.snapshots['adminUser'])
        .delete();

    _firestore
        .collection("AdminUsers")
        .document(widget.snapshots['adminUser'])
        .collection("notific")
        .document(widget.uid + "111r11")
        .delete();
  }

  unFreindUser() {
    setState(() {
      isFreind = false;
      // requestButtonClicked = true;
    });

    Firestore.instance
        .document("AdminUsers/${widget.snapshots['adminUser']}")
        .updateData({
      'freinds.${widget.uid}': false
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });
    _firestore
        .collection("AdminUsers")
        .document(widget.snapshots['adminUser'])
        .collection("AdminAllClients")
        .document(widget.uid)
        .delete();

    _firestore
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("AdminAllClients")
        .document(widget.snapshots['adminUser'])
        .delete();

    // Firestore.instance
    //     .collection("insta_a_feed")
    //     .document(widget.snapshots['adminUser'])
    //     .collection("items")
    //     .document(productId)
    //     .delete();
    _firestore
        .collection("AdminUsers")
        .document(widget.snapshots['adminUser'])
        .collection("notific")
        .document(widget.uid + "111r11")
        .delete();
    _firestore
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("notific")
        .document(widget.uid + "111r11")
        .delete();
  }

  Container buildFollowButton({
    String text,
    Color backgroundcolor,
    Color textColor,
    Color borderColor,
    Function function,
  }) {
    return Container(
      // padding: EdgeInsets.only(top: 2.0),
      child: InkWell(
          onTap: function,
          // onDoubleTap: function,
          child: Container(
            height: MediaQuery.of(context).size.height - 580,
            // width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: backgroundcolor,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(10.0)),
            alignment: Alignment.center,
            child: Text(text, style: TextStyle(color: textColor, fontSize: 12)),
          )),
    );
  }

  Container buildProfileFollowButton() {
    if (isRequest) {
      return buildFollowButton(
        text: "${DemoLocalizations.of(context).waiting}",
        backgroundcolor: Colors.white54,
        textColor: Colors.black87,
        borderColor: Colors.grey,
        function: unRequestUser,
      );
    }

    // does not follow user - should show follow button
    if (!isRequest && !isFreind) {
      return buildFollowButton(
        text: "${DemoLocalizations.of(context).request}",
        backgroundcolor: Colors.black38,
        textColor: Colors.white,
        borderColor: Colors.blue,
        function: requestUser,
      );
    }

    if (isFreind) {
      return buildFollowButton(
        text: "${DemoLocalizations.of(context).friend}",
        backgroundcolor: Colors.blue,
        textColor: Colors.white,
        borderColor: Colors.blue[800],
        function: unFreindUser,

        // unFreindUser();

        //
      );
    }
    return buildFollowButton(
        text: "${DemoLocalizations.of(context).loading}",
        backgroundcolor: Colors.white,
        textColor: Colors.black,
        borderColor: Colors.grey);
  }

  // Future _getProductsNotif() async {
  //   QuerySnapshot q = await _firestore
  //       .collection("insta_a_feed")
  //       .document(widget.snapshots['adminUser'])
  //       .collection("items")
  //       .where("userId", isEqualTo: widget.uid)
  //       .getDocuments();

  //   return q.documents;

  // }

  // Future _getListUser() async {
  //   Query q = Firestore.instance
  //       .collection("AdminUsers")
  //       .document(widget.snapshots['adminUser'])
  //       .collection("notific");

  //   QuerySnapshot querySnapshot = await q.getDocuments();
  //   return querySnapshot.documents;
  // }

  var product;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildProfileFollowButton(),
    );
    // return FutureBuilder(
    //     future: _getProductsNotif(),
    //     builder: (context, snapshots) {
    //       if (!snapshots.hasData) return Container();

    //       return ListView.builder(
    //           itemCount: 1,
    //           itemBuilder: (_, index) {
    //             String productId =
    //                 DateTime.now().millisecondsSinceEpoch.toString();
    //             return buildProfileFollowButton(productId);
    //           });
    //     });
  }
}
