import 'dart:async';

import 'package:lineder/admin/areaperson/showiamges.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:lineder/user/propile/follow.dart';
import 'package:lineder/user/propile/frequest.dart';
import 'package:lineder/user/propile/review.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowProfile extends StatefulWidget {
  final snapshots;
  final adminImage;
  final String uid;
  final adminuid;

  ShowProfile({
    this.snapshots,
    this.uid,
    this.adminuid,
    this.adminImage,
  });
  @override
  _ShowProfileState createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var rating = 0.0;
  var result;
  String text = '';
  String subject = 'Lineder';
  // void _showBottomSheet() {
  //   setState(() {
  //     _showPersBottomSheetCallBack = null;
  //   });

  //   _scaffoldKey.currentState
  //       .showBottomSheet((context) {
  //         return _share();
  //       })
  //       .closed
  //       .whenComplete(() {
  //         if (mounted) {
  //           setState(() {
  //             _showPersBottomSheetCallBack = _showBottomSheet;
  //           });
  //         }
  //       });
  // }

  // _share() {
  //   return Container(
  //     height: 300,
  //     color: Colors.green,
  //     child: Padding(
  //       padding: const EdgeInsets.all(24.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           TextField(
  //             decoration: const InputDecoration(
  //               labelText: 'Share text:',
  //               hintText: 'Enter some text and/or link to share',
  //             ),
  //             maxLines: 2,
  //             onChanged: (String value) => setState(() {
  //                   text = value;
  //                 }),
  //           ),
  //           TextField(
  //             decoration: const InputDecoration(
  //               labelText: 'Share subject:',
  //               hintText: 'Enter subject to share (optional)',
  //             ),
  //             maxLines: 2,
  //             onChanged: (String value) => setState(() {
  //                   subject = value;
  //                 }),
  //           ),
  //           const Padding(padding: EdgeInsets.only(top: 24.0)),
  //           Builder(
  //             builder: (BuildContext context) {
  //               return RaisedButton(
  //                 child: const Text('Share'),
  //                 onPressed: text.isEmpty
  //                     ? null
  //                     : () {
  //                         // A builder is used to retrieve the context immediately
  //                         // surrounding the RaisedButton.
  //                         //
  //                         // The context's `findRenderObject` returns the first
  //                         // RenderObject in its descendent tree when it's not
  //                         // a RenderObjectWidget. The RaisedButton's RenderObject
  //                         // has its position and size after it's built.
  //                         final RenderBox box = context.findRenderObject();
  //                         Share.share(text,
  //                             subject: subject,
  //                             sharePositionOrigin:
  //                                 box.localToGlobal(Offset.zero) & box.size);
  //                       },
  //               );
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future _getProductsStar() async {
    QuerySnapshot q = await Firestore.instance
        .collection("AdminUsers")
        .document(widget.adminuid)
        .collection("reviews")
        .getDocuments();

    return q.documents;
  }

  Future onRefresh() async {
    await Future.delayed(Duration(microseconds: 200));
    setState(() {
      _getProductsStar();
      // _getfollow();
    });
    return null;
  }

  bool isFollowing = false;
  bool followButtonClicked = false;
  bool isRequest = false;
  // AnimationController controller;
  // Animation<double> animation;
  Future _getUserDataFuture;
  Future _getListKindsFuture;
  @override
  void initState() {
    super.initState();
    // controller =
    //     AnimationController(duration: const Duration(seconds: 2), vsync: this);
    // animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    // controller.forward();
    _getUserDataFuture = _getUserData();
    _getListKindsFuture = _getListKinds();
    sub = db
        .collection("CustomerUsers")
        .document(widget.uid)
        .snapshots()
        .listen((snap) {
      setState(() {
        data = snap.data;
      });
    });
    subAdmin = db
        .collection("AdminUsers")
        .document(widget.adminuid)
        .snapshots()
        .listen((snap) {
      setState(() {
        data1 = snap.data;
      });
    });
    onRefresh();
    // _showPersBottomSheetCallBack = _showBottomSheet;
  }

  @override
  void dispose() {
    sub.cancel();
    // controller.dispose();
    subAdmin.cancel();

    super.dispose();
  }

  final db = Firestore.instance;
  StreamSubscription sub;
  StreamSubscription subAdmin;

  Map data;
  Map data1;
  // int _countFollowings(Map followings) {
  //   int count = 0;

  //   void countValues(key, value) {
  //     if (value) {
  //       count += 1;
  //     }
  //   }

  //   // hacky fix to enable a user's post to appear in their feed without skewing the follower/following count
  //   if (followings[widget.uid] == null) count -= 1;

  //   followings.forEach(countValues);

  //   return count;
  // }

  // Text buildStatColumn(int number) {
  //   return Text(
  //     number != -1 ? number.toString() : "0",
  //     style: TextStyle(
  //         fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white),
  //   );
  // }

  Future _getUserData() async {
    final userDataQuery = await Firestore.instance
        .collection("AdminUsers")
        .document(widget.adminuid)
        .get();

    return userDataQuery.data;
  }

  // Future _getImages() async {
  //   QuerySnapshot q = await Firestore.instance
  //       .collection("AdminUsers")
  //       .document(widget.adminuid)
  //       .collection("post")
  //       .getDocuments();

  //   return q.documents;
  // }

  var statusGrand;

  var statusShowAdmin;
  // Future _getfollow() async {
  //   QuerySnapshot q = await db
  //       .collection("AdminUsers")
  //       .document(widget.uid)
  //       .collection("followers")
  //       .getDocuments();

  //   return q.documents;
  // }

  // Widget _buildStatContainer() {
  //   return FutureBuilder(
  //       future: _getfollow(),
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData) {
  //           return Container();
  //         }
  //         return Container(
  //           height: 60.0,
  //           margin: EdgeInsets.only(top: 8.0),
  //           // decoration: BoxDecoration(
  //           //   // color: Color(0xFFEFF4F7),
  //           // ),
  //           child: _buildStatItem("עוקבים", snapshot),
  //         );
  //       });
  // }

  // Widget _buildStatItem(String label, snaphsots) {
  //   TextStyle _statLabelTextStyle = TextStyle(
  //     fontFamily: 'Roboto',
  //     color: Colors.white70,
  //     fontSize: 16.0,
  //     fontWeight: FontWeight.w200,
  //   );

  //   TextStyle _statCountTextStyle = TextStyle(
  //     color: Colors.white70,
  //     fontSize: 24.0,
  //     fontWeight: FontWeight.bold,
  //   );

  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       InkWell(
  //         onTap: () {
  //           ////navigator all following //incule snapshot
  //         },
  //         child: Text(
  //           "${snaphsots.data.length}",
  //           style: _statCountTextStyle,
  //         ),
  //       ),
  //       Text(
  //         label,
  //         style: _statLabelTextStyle,
  //       ),
  //     ],
  //   );
  // }
  // _showimages() {
  //   return FutureBuilder(
  //       future: _getImages(),
  //       builder: (context, snapshots) {
  //         if (!snapshots.hasData) {
  //           return SliverPadding(
  //             padding: EdgeInsets.all(10),
  //           );
  //         }
  //         return SliverList(
  //           delegate: SliverChildBuilderDelegate((context, index) {
  //             return Text("ddssssssssssss");
  //           }, childCount: snapshots.data.length),
  //         );
  //       });
  // }

  Future _getListKinds() async {
    Query q = db
        .collection("AdminUsers")
        .document(widget.adminuid)
        .collection("kind");

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  var urlshare =
      "https://play.google.com/store/apps/details?id=com.daniel.lineder";
  // final _scaffoldKey = new GlobalKey<ScaffoldState>();
  // VoidCallback _showPersBottomSheetCallBack;
  @override
  Widget build(BuildContext context) {
    // controller.dispose();
    var deco = BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.black,
          Colors.grey[600],
        ],
      ),
    );
    var scaffold = Scaffold(
        key: _scaffoldKey,
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: FutureBuilder(
              future: _getUserDataFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                if (snapshot.data['statusGrand'] == "Barber") {
                  statusShowAdmin =
                      "${DemoLocalizations.of(context).barbershop}";
                } else {
                  statusShowAdmin =
                      "${DemoLocalizations.of(context).cosmetics}";
                }

                return CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      bottom: AppBar(
                        backgroundColor: Colors.black45,
                        leading: Text(
                          statusShowAdmin,
                          textAlign: TextAlign.center,
                        ),
                        title: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "${snapshot.data['userName']}",
                                    // "${widget.snapshots/da}"
                                    // "${data1['userName'] != null ? data1['userName'] : ""}",
                                    style: TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "${snapshot.data['userBrand']}",
                                    // "${data1['userBrand'] != null ? data1['userBrand'] : ""}",
                                    style: TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 10,
                            ),
                            child: Column(
                              children: <Widget>[
                                IconTheme(
                                  data: IconThemeData(
                                    color: Colors.amber,
                                    size: 12,
                                  ),
                                  child: SmoothStarRating(
                                      allowHalfRating: true,
                                      starCount: 5,
                                      rating:
                                          snapshot.data['reviewsresult'] > 0.5
                                              ? snapshot.data['reviewsresult']
                                              : 0,
                                      size: 12.0,
                                      color: Colors.yellow[800],
                                      borderColor: Colors.black,
                                      spacing: 0.0),
                                ),
                                InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return ReviewsAdmin(
                                              snapshots: data1,
                                              uid: widget.uid,
                                              adminUid: widget.adminuid,
                                            );
                                          });
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             ReviewsAdmin(
                                      //               snapshots: data1,
                                      //               uid: widget.uid,
                                      //             )));
                                    },
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.white54,
                      expandedHeight: 200.0,
                      actions: <Widget>[
                        IconButton(
                          // onPressed: () {
                          //   _showBottomSheet();
                          //   // Navigator.push(
                          //   //     context,
                          //   //     MaterialPageRoute(
                          //   //         builder: (context) => MultiProv(
                          //   //               snapshots: widget.snapshots,
                          //   //               uid: widget.uid,
                          //   //             )));
                          // },
                          onPressed: urlshare.isEmpty
                              ? null
                              : () {
                                  // A builder is used to retrieve the context immediately
                                  // surrounding the RaisedButton.
                                  //
                                  // The context's `findRenderObject` returns the first
                                  // RenderObject in its descendent tree when it's not
                                  // a RenderObjectWidget. The RaisedButton's RenderObject
                                  // has its position and size after it's built.
                                  final RenderBox box =
                                      context.findRenderObject();
                                  Share.share(urlshare,
                                      subject: subject,
                                      sharePositionOrigin:
                                          box.localToGlobal(Offset.zero) &
                                              box.size);
                                },
                          icon: Icon(Icons.share),
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: EdgeInsets.only(top: 50, left: 50),
                        background: Container(
                          // decoration: new BoxDecoration(
                          //   // shape: BoxShape.circle,
                          //   image: new DecorationImage(
                          //     fit: BoxFit.fill,
                          //     image: new CachedNetworkImageProvider(widget
                          //                 .adminImage !=
                          //             null
                          //         ? widget.adminImage
                          //         : "https://images.unsplash.com/photo-1548586196-aa5803b77379?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=967&q=80"),
                          //   ),
                          // ),
                          child: CachedNetworkImage(
                            imageUrl: "${widget.adminImage}",
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          decoration: deco,
                          child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: data['userName'] != " " &&
                                      data['phone'] != " "
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        InkWell(
                                            onTap: () {},
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                  height: 30,
                                                  width: 90,
                                                  child: RequstU(
                                                    adminUser: widget.adminuid,
                                                    snapshots: data1,
                                                    uid: widget.uid,
                                                  )),
                                            )),
                                        SizedBox(
                                          width: 3.0,
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            height: 65,
                                            width: 180,
                                            // height: MediaQuery.of(context).size.width - 330,
                                            // width: MediaQuery.of(context).size.width - 270,
                                            child: Followers(
                                              adminUser: widget.adminuid,
                                              snapshots: data1,
                                              uid: widget.uid,
                                              status: true,
                                            ),
                                          ),
                                        ),

                                        // _buildStatContainer(),
                                        // buildStatColumn(
                                        //     _countFollowings(follow)),
                                      ],
                                    )
                                  : Text(
                                      "${DemoLocalizations.of(context).friendrequestmust}",
                                      style: TextStyle(color: Colors.white),
                                    )),
                        ),
                        Container(
                          decoration: deco,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                "\n${snapshot.data['address'] != null ? snapshot.data['address'] : ""}",
                                style: TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                onPressed: () async {
                                  var url = "tel:" + snapshot.data['phone'];

                                  if (await canLaunch(url))
                                    launch(url);
                                  else
                                    print("URL can Not be");
                                  print('open click');
                                },
                                icon: Icon(
                                  Icons.phone_forwarded,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${DemoLocalizations.of(context).dayswork}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              snapshot.data['su'] == true
                                  ? FlatButton.icon(
                                      onPressed: () {},
                                      label: Text(
                                          "${DemoLocalizations.of(context).su}"),
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    )
                                  : Container(),
                              snapshot.data['mo'] == true
                                  ? FlatButton.icon(
                                      onPressed: () {},
                                      label: Text(
                                          "${DemoLocalizations.of(context).mo}"),
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    )
                                  : Container(),
                              snapshot.data['tu'] == true
                                  ? FlatButton.icon(
                                      onPressed: () {},
                                      label: Text(
                                          "${DemoLocalizations.of(context).tu}"),
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    )
                                  : Container(),
                              snapshot.data['we'] == true
                                  ? FlatButton.icon(
                                      onPressed: () {},
                                      label: Text(
                                          "${DemoLocalizations.of(context).we}"),
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    )
                                  : Container(),
                              snapshot.data['th'] == true
                                  ? FlatButton.icon(
                                      onPressed: () {},
                                      label: Text(
                                          "${DemoLocalizations.of(context).th}"),
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    )
                                  : Container(),
                              snapshot.data['fr'] == true
                                  ? FlatButton.icon(
                                      onPressed: () {},
                                      label: Text(
                                          "${DemoLocalizations.of(context).fr}"),
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    )
                                  : Container(),
                              snapshot.data['sa'] == true
                                  ? FlatButton.icon(
                                      onPressed: () {},
                                      label: Text(
                                          "${DemoLocalizations.of(context).sa}"),
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${DemoLocalizations.of(context).extra}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              snapshot.data['parking'] == true
                                  ? FlatButton.icon(
                                      onPressed: () {},
                                      label: Text(
                                          "${DemoLocalizations.of(context).parking}"),
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    )
                                  : Container(),
                              snapshot.data['hairWash'] == true
                                  ? FlatButton.icon(
                                      onPressed: () {},
                                      label: Text(
                                          "${DemoLocalizations.of(context).hairWash}"),
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    )
                                  : Container(),
                              snapshot.data['hairDonation'] == true
                                  ? FlatButton.icon(
                                      onPressed: () {},
                                      label: Text(
                                          "${DemoLocalizations.of(context).hairDonation}"),
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Divider(
                          height: 20,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                "${DemoLocalizations.of(context).categories}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${DemoLocalizations.of(context).images}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    FutureBuilder(
                      future: _getListKindsFuture,
                      builder: (context, snapshots) {
                        if (!snapshots.hasData) {
                          return SliverPadding(
                            padding: EdgeInsets.all(10),
                          );
                        }
                        return SliverList(
                          delegate: SliverChildBuilderDelegate((_, index) {
                            return Card(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                      " ${snapshots.data[index].data['kind']}"),
                                  Text(
                                      "${snapshots.data[index].data['currency']}${snapshots.data[index].data['price']}"),
                                ],
                              ),
                            );
                          },
                              childCount: 6 > snapshots.data.length
                                  ? snapshots.data.length
                                  : 5),
                        );
                      },
                    ),

                    ShowImages(
                      uid: widget.uid,
                      adminuid: widget.adminuid,
                      // collectionAorU: ,
                    ),
                    // _showimages(),
                    // SliverList(
                    //   delegate: SliverChildListDelegate([
                    //     Padding(
                    //       padding: const EdgeInsets.all(12.0),
                    //       child: Text(
                    //         "תמונות\ndddddd\nddddd\nddddddddddddddddddddddd\nasssssssssdddd\nddddd\nddddddddddddddddddddddd\nassssssssssdddd\nddddd\nddddddd\nddddd\nddddddddddddddddddddddd\nassssssssssdddd\nddddd\nddddddddddddddddddddddd\nassssssssssdddddddddddddddddddd\nassssssssssdddd\nddddd\nddddddddddddddddddddddd\nassssssssssdddd\nddddd\nddddddddddddddddddddddd\nasssssssssss",
                    //         style: TextStyle(
                    //             fontSize: 18, fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //   ]),
                    // )
                  ],
                );
              }),
        ));
    return scaffold;
  }
}

class StarDisplay extends StatelessWidget {
  final double value;
  const StarDisplay({Key key, this.value = 0})
      : assert(value != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
        );
      }),
    );
  }
}

// class StarRating extends StatelessWidget {
//   final void Function(int index) onChanged;
//   // final int value;
//   final int value;
//   final IconData filledStar;
//   final IconData unfilledStar;
//   const StarRating({
//     Key key,
//     this.onChanged,
//     this.value = 0,
//     this.filledStar,
//     this.unfilledStar,
//   })  : assert(value != null),
//         super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final color = Theme.of(context).accentColor;
//     final size = 18.0;
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: List.generate(5, (index) {
//         return IconButton(
//           onPressed: onChanged != null
//               ? () {
//                   onChanged(value == index + 1 ? index : index + 1);
//                 }
//               : null,
//           color: index < value ? color : null,
//           iconSize: size,
//           icon: Icon(
//             index < value
//                 ? filledStar ?? Icons.star
//                 : unfilledStar ?? Icons.star_border,
//           ),
//           padding: EdgeInsets.zero,
//           tooltip: "${index + 1} of 5",
//         );
//       }),
//     );
//   }
// }

// class StatefulStarRating extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     int rating = 0;
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return StarRating(
//           onChanged: (index) {
//             setState(() {
//               rating = index;
//               print(rating);
//             });
//           },
//           value: rating,
//         );
//       },
//     );
//   }
// }
