import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lineder/store/showallproduct.dart';
// import 'package:lineder/animation/bottombar.dart';
// import 'package:lineder/helpers/locale.dart';
// import 'package:lineder/store/showallproduct.dart';
import 'package:lineder/user/appointment/mybarber.dart';
import 'package:lineder/user/favor&notif/favornotif.dart';
import 'package:lineder/user/homepageuser/homeuser.dart';
import 'package:lineder/user/propile/propileu.dart';
import 'package:lineder/user/searchbarber/searchbloc.dart';

class UserHomePage extends StatefulWidget {
  final uid;

  UserHomePage({
    Key key,
    @required this.uid,
  }) : super(key: key);
  @override
  _UserHomePageState createState() => _UserHomePageState(uid: uid);
}

class _UserHomePageState extends State<UserHomePage> {
  int currentIndex = 0;
  final String uid;

  _UserHomePageState({Key key, @required this.uid});

  @override
  void initState() {
    super.initState();

    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        currentocation = currloc;
        // mapTogel = true;
      });
    });
  }

  @override
  void dispose() {
    // sub != null ? sub.cancel() : Container();

    super.dispose();
  }

  final db = Firestore.instance;
  StreamSubscription sub;

  Map data;
  // String namecollection = 'AdminUsers';
  Widget callPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return HomeUser(
          uid: widget.uid,
        );
      case 1:
        return SearchBlocs(
          uid: widget.uid,
        );
      case 2:
        return MyBarber(
          uid: widget.uid,
        );
      case 3:
        return FavorNotif(
          uid: widget.uid,
        );
      case 4:
        return ShowAllPrudcts(
          uid: widget.uid,
        );
      case 5:
        return PropileU(
          uid: widget.uid,
        );

        break;
      default:
        return HomeUser(
          uid: widget.uid,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color colors = Colors.grey[400]; //Color(0xff2d386b);
    Color colorsgrey = Colors.grey[100];
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
            icon: Icon(currentIndex == 1 ? FontAwesomeIcons.search : Icons.search),
            backgroundColor: colors,
            // activeIcon: colors,
          ),
          BottomNavigationBarItem(
            title: Text(''),
            icon: Icon(currentIndex == 2?Icons.local_hospital:Icons.add_box),
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
            icon: Icon(Icons.store),
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
      // bottomNavigationBar: BottomNavyBar(
      //   selectedIndex: currentIndex,
      //   showElevation: true,
      //   onItemSelected: (index) => setState(() {
      //     currentIndex = index;
      //   }),
      //   items: [
      //     BottomNavyBarItem(
      //       icon: Icon(Icons.apps),
      //       title: Text('${DemoLocalizations.of(context).home}'),
      //       activeColor: Colors.black,
      //     ),
      //     BottomNavyBarItem(
      //         icon: Icon(Icons.search),
      //         title: Text('${DemoLocalizations.of(context).search}'),
      //         activeColor: Colors.grey),
      //     BottomNavyBarItem(
      //         icon: Icon(Icons.add_box),
      //         title: Text('${DemoLocalizations.of(context).addlines}'),
      //         activeColor: Colors.blueGrey[600]),
      //     BottomNavyBarItem(
      //         icon: Icon(Icons.notifications),
      //         title: Text('${DemoLocalizations.of(context).notifications}'),
      //         activeColor: Color(0xff2d386b)),
      //     // BottomNavyBarItem(
      //     //     icon: Icon(
      //     //       Icons.store,
      //     //     ),
      //     //     title: Text('store'),
      //     //     activeColor: Colors.green[300]),
      //     BottomNavyBarItem(
      //         icon: Icon(Icons.supervised_user_circle),
      //         title: Text('${DemoLocalizations.of(context).profile}'),
      //         activeColor: Colors.blue),
      //   ],
      // ),
    );
  }
}
