import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lineder/admin/allclient/allclients.dart';
import 'package:lineder/admin/areaperson/areaadmin.dart';
import 'package:lineder/admin/areaperson/schedluecalender.dart';
import 'package:lineder/admin/homepage/designhomepage.dart';
import 'package:lineder/admin/notifFavori/favornotifadmin.dart';
import 'package:lineder/animation/bottombar.dart';
import 'package:lineder/helpers/locale.dart';

class HomeAdminTabs extends StatefulWidget {
  final uid;

  HomeAdminTabs({this.uid});
  @override
  _HomeAdminTabsState createState() => _HomeAdminTabsState();
}

class _HomeAdminTabsState extends State<HomeAdminTabs> {
  @override
  void initState() {
    super.initState();
    // Geolocator().getCurrentPosition().then((currloc) {
    //   setState(() {
    //     // currentocation = currloc;
    //     // mapTogel = true;
    //   });

    // });
    sub = db
        .collection("AdminUsers")
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
  int currentIndex = 0;
  Widget callPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return NativePage(
          uid: widget.uid,
          data5: data,
        );

      case 1:
        return ScheduleCalender(
          uid: widget.uid,
          data5: data,
        );
      case 2:
        return AllClientsPage(
          uid: widget.uid,
          data5: data,
        );
      case 3:
        return FavotiNotifAdmin(
          uid: widget.uid,
          data5: data,
        );
      case 4:
        return AreaAdmin(
          uid: widget.uid,
          data5: data,
        );

        break;
      default:
        return NativePage(
          uid: widget.uid,
          data5: data,
        );
    }
  }

  // Future _getNoti() async {
  //   QuerySnapshot q = await Firestore.instance
  //       .collection("AdminUsers")
  //       .document(widget.uid)
  //       .collection("notific")
  //       .getDocuments();

  //   return q.documents;
  // }

  bool showtrue = false;
  Color colors = Color(0xff2d386b);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,

      body: callPage(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        // showUnselectedLabels: true,
        // showSelectedLabels: true,
        // selectedFontSize: 40,
        iconSize: 26,
        backgroundColor: Colors.grey[100],
        elevation: 10.0,
        fixedColor: Colors.black,
        onTap: (index) => setState(() {
          currentIndex = index;
        }),
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            title: Text(''),
            icon: Icon(Icons.apps),
            backgroundColor: colors,
            // activeIcon: colors,
          ),
          BottomNavigationBarItem(
            title: Text(''),
            icon: Icon(Icons.date_range),
            backgroundColor: colors,
            // activeIcon: colors,
          ),
          BottomNavigationBarItem(
            title: Text(''),
            icon:
                Icon( Icons.linear_scale),
            backgroundColor: colors,
            // activeIcon: colors,
          ),
          BottomNavigationBarItem(
            title: Text(''),
            icon: Icon(Icons.notifications),
            backgroundColor: colors,
            // activeIcon: colors,
          ),
          BottomNavigationBarItem(
            title: Text(''),
            icon: Icon(Icons.perm_contact_calendar),
            backgroundColor: colors,
            // activeIcon: colors,
          )
        ],
      ),
      // bottomNavigationBar:

      // BottomNavyBar(
      //   selectedIndex: currentIndex,
      //   showElevation: true,
      //   onItemSelected: (index) => setState(() {
      //         currentIndex = index;
      //       }),
      //   items: [
      //     BottomNavyBarItem(
      //       icon: Icon(Icons.apps),
      //       title: Text('${DemoLocalizations.of(context).home}'),
      //       activeColor: Colors.black,
      //     ),
      //     BottomNavyBarItem(
      //         icon: Icon(Icons.date_range),
      //         title: Text('${DemoLocalizations.of(context).lines}'),
      //         activeColor: Colors.grey),
      //     BottomNavyBarItem(
      //         icon: Icon(Icons.linear_scale),
      //         title: Text('${DemoLocalizations.of(context).clients}'),
      //         activeColor: Colors.blueGrey[600]),
      //     BottomNavyBarItem(
      //       //
      //       icon: Icon(Icons.notifications),
      //       title: Text('${DemoLocalizations.of(context).notifications}'),
      //       activeColor: Color(0xff2d386b),
      //       inactiveColor: _color,
      //     ),
      //     BottomNavyBarItem(
      //         icon: Icon(Icons.supervised_user_circle),
      //         title: Text('${DemoLocalizations.of(context).profile}'),
      //         activeColor: Colors.blue),
      //   ],
      // ),
    );
  }
}
