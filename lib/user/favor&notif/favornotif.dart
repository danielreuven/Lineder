
import 'package:lineder/notication/usernotif.dart';
import 'package:lineder/user/favor&notif/favorite.dart';
import 'package:flutter/material.dart';

class FavorNotif extends StatefulWidget {
  final uid;

  FavorNotif({this.uid, });
  @override
  _FavorNotifState createState() => _FavorNotifState();
}

class _FavorNotifState extends State<FavorNotif> {
  String namecollection = 'CustomerUsers';
  String collect = 'AdminUsers';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            leading: Container(),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(55),
              child: Container(
                color: Colors.transparent,
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      TabBar(
                        indicator: UnderlineTabIndicator(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 4.0),
                          insets: EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0),
                        ),
                        indicatorWeight: 10,
                        labelColor: Colors.cyan[300],
                        labelStyle: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1.3,
                            fontWeight: FontWeight.w500),
                        unselectedLabelColor: Colors.black26,
                        tabs: [
                          Tab(
                            text: "עדכונים",
                            icon: Icon(
                              Icons.notifications_active,
                              size: 40,
                              color: Color(0xff2d386b),
                            ),
                          ),
                          Tab(
                            text: "שמירה",
                            icon: Icon(
                              Icons.bookmark,
                              size: 40,
                              // color: Colors.red,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              UserNotification(
                uid: widget.uid,
                namecollection: namecollection,
                collect: collect,
              ),
              FavoriteUser(
                uid: widget.uid,
                namecollection: namecollection,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
