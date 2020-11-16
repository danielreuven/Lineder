import 'package:lineder/helpers/locale.dart';
import 'package:lineder/notication/usernotif.dart';
import 'package:lineder/user/favor&notif/favorite.dart';
import 'package:flutter/material.dart';

class FavotiNotifAdmin extends StatelessWidget {
  final uid;
  final data5;
  FavotiNotifAdmin({this.uid, this.data5});
  @override
  Widget build(BuildContext context) {
    String namecollection = 'AdminUsers';
    String collect = 'CustomerUsers';
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
                            text:
                                '${DemoLocalizations.of(context).notifications}',
                            icon: Icon(
                              Icons.notifications_active,
                              size: 40,
                              color: Color(0xff2d386b),
                            ),
                          ),
                          Tab(
                            text: '${DemoLocalizations.of(context).saved}',
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
                uid: uid,
                namecollection: namecollection,
                collect: collect,
              ),
              FavoriteUser(
                uid: uid,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
