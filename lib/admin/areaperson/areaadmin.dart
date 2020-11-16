import 'dart:async';

import 'package:app_review/app_review.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lineder/admin/areaperson/addbarbers.dart';
import 'package:lineder/admin/areaperson/addkind.dart';
import 'package:lineder/admin/areaperson/imageuplode/models/upload_page.dart';
import 'package:lineder/admin/areaperson/propile.dart';
import 'package:lineder/admin/areaperson/recod/record.dart';
import 'package:lineder/admin/areaperson/reviewsadmin.dart';
import 'package:lineder/admin/areaperson/schedule.dart';
import 'package:lineder/admin/areaperson/showfollowrs.dart';
import 'package:lineder/admin/areaperson/showiamges.dart';
import 'package:lineder/admin/areaperson/time.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:lineder/user/propile/propileextra/settings.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class AreaAdmin extends StatefulWidget {
  AreaAdmin({
    this.uid,
    this.data5,
  });
  final uid;
  final data5;
  @override
  _AreaAdminState createState() => _AreaAdminState();
}

class _AreaAdminState extends State<AreaAdmin> with TickerProviderStateMixin {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Firestore _firestore = Firestore.instance;

  Widget buildStatColumn(int number) {
    return RaisedButton(
      onPressed: () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.grey[100],
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        "Followers ${number != -1 ? number.toString() : 0}",
        style: TextStyle(
            fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Future _getfollow() async {
    QuerySnapshot q = await _firestore
        // .collection(widget.country)
        // .document('${widget.uid}')
        // .collection("${widget.statusGrand}")
        // .document(widget.uid)
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("followers")
        .getDocuments();

    return q.documents;
  }

  // Future _getPosts() async {
  //   QuerySnapshot q = await _firestore
  //       // .collection(widget.country)
  //       // .document('${widget.uid}')
  //       // .collection("${widget.statusGrand}")
  //       // .document(widget.uid)
  //       .collection("AdminUsers")
  //       .document(widget.uid)
  //       .collection("posts")
  //       .getDocuments();

  //   return q.documents;
  // }
  var urlshare =
      "https://play.google.com/store/apps/details?id=com.daniel.lineder";
  String subject = 'Lineder';
  Widget _buildStatContainer() {
    return FutureBuilder(
        future: _getfollow(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return _buildStatItem(
              '${DemoLocalizations.of(context).followers}', snapshot, context);
        });
  }

  Widget _buildStatItem(String label, snaphsots, context) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return InkWell(
      onTap: () {
        snaphsots.data.length != 0
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowFollowrs(
                          uid: widget.uid,
                          snapshots: snaphsots,
                          // statusGrand: widget.statusGrand,
                          //                   country: widget.country,
                        )))
            : Container();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "${snaphsots.data.length}",
            style: _statCountTextStyle,
          ),
          Text(
            label,
            style: _statLabelTextStyle,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: ListTile(
                  onTap: () {
                    try {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return PropileA(
                                 uid: widget.uid,
                              userorAdmin: "AdminUsers",
                              namesStorage: "profileAdmin",
                            );
                          });
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => PropileA(
                      //               uid: widget.uid,
                      //               images: widget.data5['photoUrl'],
                      //             )));
                    } catch (e) {
                      print(e);
                    }
                  },
                  trailing: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new CachedNetworkImageProvider(
                            "${widget.data5['photoUrl']}"),
                      ),
                    ),
                  ),
                  title: Text(
                    "${widget.data5['userName'] != "null" ? widget.data5['userName'] : DemoLocalizations.of(context).fullname}",
                    style: TextStyle(
                        // color: Colors.white70,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    "${widget.data5['bio'] != "null" ? widget.data5['bio'] : " "}",
                    style: TextStyle(
                        // color: Colors.white70,
                        ),
                    overflow: TextOverflow.clip,
                    maxLines: 2,
                  ),
                ),
              ),
              Divider(
                height: 2,
                color: Colors.grey,
                indent: 60.0,
              ),
              ListTile(
                title: Text(
                  widget.data5['address'],
                  textAlign: TextAlign.center,
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconTheme(
                      data: IconThemeData(
                        color: Colors.amber,
                        size: 12,
                      ),
                      child: SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: widget.data5['reviewsresult'] > 0.5
                              ? widget.data5['reviewsresult']
                              : 0,
                          size: 12.0,
                          color: Colors.yellow[800],
                          borderColor: Colors.black,
                          spacing: 0.0),
                    ),
                  ],
                ),
                onTap: () {
                  try {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReviewsAdmin(
                                  uid: widget.uid,
                                )));
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              // Divider(
              //   height: 2,
              //   color: Colors.black,
              // ),
              _buildStatContainer(),
              Divider(
                height: 8,
                color: Colors.black38,
              ),
              ListTile(
                title: Text(
                  '${DemoLocalizations.of(context).kinds}',
                  textAlign: TextAlign.center,
                ),
                trailing: Icon(Icons.content_cut),
                onTap: () {
                  try {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AddKind(
                            uid: widget.uid,
                          );
                        });
                  } catch (e) {
                    print(e);
                  }
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => AddKind(
                  //               uid: widget.uid,
                  //               // statusGrand: widget.statusGrand,
                  //               //       country: widget.country,
                  //             )));
                },
              ),
              Divider(
                height: 8,
                color: Colors.black38,
              ),
              ListTile(
                title: Text(
                  '${DemoLocalizations.of(context).addlines}',
                  textAlign: TextAlign.center,
                ),
                trailing: Icon(Icons.add_circle_outline),
                onTap: () {
                  try {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TimeArea(
                                  uid: widget.uid,
                                )));
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              Divider(
                height: 8,
                color: Colors.black38,
              ),
              ListTile(
                title: Text(
                  '${DemoLocalizations.of(context).alllines}',
                  textAlign: TextAlign.center,
                ),
                trailing: Icon(Icons.schedule),
                onTap: () {
                  try {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return ScheduleTime(
                            uid: widget.uid,
                          );
                        });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              Divider(
                height: 8,
                color: Colors.black38,
              ),
              ListTile(
                title: Text(
                  '${DemoLocalizations.of(context).record}',
                  textAlign: TextAlign.center,
                ),
                trailing: Icon(Icons.recent_actors),
                onTap: () {
                  try {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecordAdmin(
                                  uid: widget.uid,
                                )));
                  } catch (e) {
                    print(e);
                  }
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => Settings(
                  //               uid: widget.uid,
                  //             )));
                },
              ),
              Divider(
                height: 8,
                color: Colors.black38,
              ),
              ListTile(
                title: Text(
                  '${DemoLocalizations.of(context).addworker}',
                  // '${DemoLocalizations.of(context).alllines}',
                  textAlign: TextAlign.center,
                ),
                trailing: Icon(Icons.group_work),
                onTap: () {
                  try {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddBarbers(
                                  uid: widget.uid,
                                )));
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              // Divider(
              //   height: 8,
              //   color: Colors.black38,
              // ),

              // ListTile(
              //   title: Text(
              //     '${DemoLocalizations.of(context).payments}',
              //     textAlign: TextAlign.center,
              //   ),
              //   trailing: Icon(Icons.payment),
              //   onTap: () {
              //     try {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => PaymentsData(
              //                     uid: widget.uid,
              //                     snapshots: widget.data5,
              //                     // statusGrand: widget.statusGrand,
              //                     //       country: widget.country,
              //                   )));
              //     } catch (e) {
              //       print(e);
              //     }
              //     // Navigator.push(
              //     //     context,
              //     //     MaterialPageRoute(
              //     //         builder: (context) => Settings(
              //     //               uid: widget.uid,
              //     //             )));
              //   },
              // ),
              Divider(
                height: 8,
                color: Colors.black38,
              ),
              ListTile(
                title: Text(
                  "${DemoLocalizations.of(context).invitefriend}",
                  textAlign: TextAlign.center,
                ),
                trailing: Icon(Icons.people_outline),
                onTap: urlshare.isEmpty
                    ? null
                    : () {
                        // A builder is used to retrieve the context immediately
                        // surrounding the RaisedButton.
                        //
                        // The context's `findRenderObject` returns the first
                        // RenderObject in its descendent tree when it's not
                        // a RenderObjectWidget. The RaisedButton's RenderObject
                        // has its position and size after it's built.
                        final RenderBox box = context.findRenderObject();
                        Share.share(urlshare,
                            subject: subject,
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size);
                      },
              ),
              Divider(
                height: 8,
                color: Colors.black38,
              ),
              ListTile(
                title: Text(
                  '${DemoLocalizations.of(context).reviewsapp}',
                  textAlign: TextAlign.center,
                ),
                trailing: Icon(Icons.rate_review),
                onTap: () {
                  try {
                    AppReview.requestReview.then((onValue) {
                      print(onValue);
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              Divider(
                height: 8,
                color: Colors.black38,
              ),
              ListTile(
                title: Text(
                  '${DemoLocalizations.of(context).settings}',
                  textAlign: TextAlign.center,
                ),
                trailing: Icon(Icons.settings),
                onTap: () async {
                  PackageInfo packageInfo = await PackageInfo.fromPlatform();

                  try {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Settings(
                            uid: widget.uid,
                            packageInfo: packageInfo,
                            admin: "admin",
                          );
                        });
                  } catch (e) {
                    print(e);
                  }
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => Settings(
                  //               uid: widget.uid,
                  //             )));
                },
              ),
              ListTile(
                title: Text(
                  '${DemoLocalizations.of(context).images}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue[700]),
                ),
                trailing: Icon(
                  Icons.add_a_photo,
                  color: Colors.blue[700],
                ),
                onTap: () {
                  try {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Uploader(
                                  uid: widget.uid,
                                  data5: widget.data5,
                                )));
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ]),
          ),
          ShowImages(
            uid: widget.uid,
            adminuid: widget.uid,
          )
        ],
      )),
    );
  }
}
