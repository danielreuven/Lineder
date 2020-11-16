import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lineder/helpers/loadingpage.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:lineder/user/propile/showprofile.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';

class SearchBlocs extends StatefulWidget {
  final uid;

  SearchBlocs({
    this.uid,
  });
  @override
  _SearchBlocsState createState() => _SearchBlocsState();
}

class _SearchBlocsState extends State<SearchBlocs>
    with TickerProviderStateMixin {
  Stream<QuerySnapshot> _iceCreamStores;
  @override
  void initState() {
    super.initState();
    _mapController = Completer();
    _pageController = PageController();
    sub = db
        .collection("CustomerUsers")
        .document(widget.uid)
        .snapshots()
        .listen((snap) {
      setState(() {
        data = snap.data;

        _iceCreamStores = data['statusGrand'] != "all"
            ? Firestore.instance
                .collection("AdminUsers")
                .orderBy("reviewsresult", descending: true)
                .where("statusGrand", isEqualTo: data['statusGrand'])
                .where("available", isEqualTo: "available")
                .snapshots()
            : Firestore.instance
                .collection("AdminUsers")
                .where("available", isEqualTo: "available")
                .orderBy("reviewsresult", descending: true)
                .snapshots();
      });
    });
  }

  _acceptlocation() {
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        currentocation = currloc;
        // mapTogel = true;
      });
    });
  }

  @override
  void dispose() {
    sub.pause();

    _pageController?.dispose();
    super.dispose();
  }

  final db = Firestore.instance;
  StreamSubscription sub;

  Map data;

  var statusGrand;
  var statusShow;
  var statusGrandAdmin;
  var statusShowAdmin;

  _updateGrand(statusGrand) {
    Firestore.instance
        .collection("CustomerUsers")
        .document("${widget.uid}")
        .updateData({
      "statusGrand": "$statusGrand",
    });
  }

  PageController _pageController;
  void _onSignInButtonPress() {
    _pageController.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  Widget _buildsearch(snapshot) {
    return Container(
      // height: MediaQuery.of(context).size.height,
      child: _it.length != 0
          ? GridView.builder(
              itemCount: _it.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 1.4, crossAxisCount: 2),
              itemBuilder: (_, index) {
                final documents = _it[index];

                return Material(
                  child: GridTile(
                      footer: Card(
                        color: Colors.black54,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconTheme(
                              data: IconThemeData(
                                color: Colors.amber,
                                size: 12,
                              ),
                              child: SmoothStarRating(
                                  allowHalfRating: true,
                                  starCount: 5,
                                  rating: documents['reviewsresult'] > 0.5
                                      ? documents['reviewsresult']
                                      : 0,
                                  size: 12.0,
                                  color: Colors.yellow[800],
                                  borderColor: Colors.white,
                                  spacing: 0.0),
                            ),
                            Text(
                              " ${documents['statusGrand'] == "Barber" ? DemoLocalizations.of(context).barbershop : DemoLocalizations.of(context).cosmetics}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      header: Card(
                        child: Column(
                          children: <Widget>[
                            Text(
                              documents['userBrand'],
                              maxLines: 1,
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              documents['address'],
                              maxLines: 1,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        color: Colors.black54,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShowProfile(
                                    adminuid: documents['adminUser'],
                                    adminImage: documents['photoUrl'],
                                    uid: widget.uid,
                                    // snapshots: documents,
                                  )));
                        },
                        child: Container(
                          // width: 40.0,
                          // height: 40.0,
                          // decoration: new BoxDecoration(
                          // shape: BoxShape.rectangle,
                          // shape: BoxShape.circle,
                          // image: new DecorationImage(
                          //   fit: BoxFit.fill,
                          //   image: new CachedNetworkImageProvider(documents[
                          //               'photoUrl'] !=
                          //           null
                          //       ? documents['photoUrl']
                          //       : "https://images.unsplash.com/photo-1548586196-aa5803b77379?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=967&q=80"),
                          // ),
                          // ),
                          child: CachedNetworkImage(
                            imageUrl: "${documents['photoUrl']}",
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                            fit: BoxFit.cover,
                            height: 40,
                            width: 40,
                          ),
                        ),
                      )),
                );
              },
            )
          : Center(
              child: Text("${DemoLocalizations.of(context).noresults}"),
            ),
    );
  }

  var controller;
  Widget _buildMaps(snapshot) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: StoreMap(
              documents: snapshot.data.documents,
              initialPosition: currentocation == null
                  ? LatLng(32.073582, 34.788052)
                  : LatLng(currentocation.latitude, currentocation.longitude),
              mapController: _mapController,
              uid: widget.uid,
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _it.length,
                itemBuilder: (context, index) {
                  final document = _it[index];
                  return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                              flex: 2,
                              child: Text(
                                document["userBrand"],
                                overflow: TextOverflow.ellipsis,
                              )),
                          Text(
                            " ${document['statusGrand'] == "Barber" ? DemoLocalizations.of(context).barbershop : DemoLocalizations.of(context).cosmetics}",
                            // style: TextStyle(color: Colors.white),
                          ),
                          _mapController.isCompleted
                              ? IconButton(
                                  onPressed: () async {
                                    controller = await _mapController.future;

                                    await controller.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            target: LatLng(
                                                document['location'].latitude,
                                                document['location'].longitude),
                                            zoom: 12),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.location_on,
                                    size: 30,
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                            child: Text(
                              document["address"],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconTheme(
                            data: IconThemeData(
                              color: Colors.amber,
                              size: 12,
                            ),
                            child: SmoothStarRating(
                                allowHalfRating: true,
                                starCount: 5,
                                rating: document['reviewsresult'] > 0.5
                                    ? document['reviewsresult']
                                    : 0,
                                size: 12.0,
                                color: Colors.yellow[800],
                                borderColor: Colors.black,
                                spacing: 0.0),
                          ),
                        ],
                      ),
                      leading: Container(
                        // width: 40.0,
                        // height: 40.0,
                        // decoration: new BoxDecoration(
                        //   shape: BoxShape.circle,
                        //   image: new DecorationImage(
                        //     fit: BoxFit.fill,
                        //     image: new CachedNetworkImageProvider(
                        //         "${document['photoUrl']}"),
                        //   ),
                        // ),
                        child: CachedNetworkImage(
                          imageUrl: "${document['photoUrl']}",
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowProfile(
                                      adminuid: document['adminUser'],
                                      uid: widget.uid,
                                      snapshots: document,
                                      adminImage: document['photoUrl'],
                                    )));
                        // _action1(document);
                      });
                }),
          ),
        ],
      ),
    );
  }

  // _buildMaplist(snapshot) {
  //   return Container(
  //       child: Column(
  //     children: <Widget>[
  //       Container(
  //         height: MediaQuery.of(context).size.height / 3,
  //         child: StoreMap(
  //           documents: snapshot.data.documents,
  //           initialPosition: currentocation == null
  //               ? LatLng(32.073582, 34.788052)
  //               : LatLng(currentocation.latitude, currentocation.longitude),
  //           mapController: _mapController,
  //           uid: widget.uid,
  //         ),
  //       ),
  //       Expanded(
  //         child: ListView(
  //           children: _getItems(snapshot),
  //         ),
  //       )
  //     ],
  //   ));
  // }

  Color left = Colors.white;
  Color right = Colors.black;

  Widget searchfor() {
    return FlatButton.icon(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        statusGrand = 'Barber';
                        _updateGrand(statusGrand);

                        Navigator.of(context).pop();
                      });
                    },
                    child: Text('${DemoLocalizations.of(context).barbershop}'),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        statusGrand = 'Cosmetic';

                        _updateGrand(statusGrand);

                        Navigator.of(context).pop();
                      });
                    },
                    child: Text('${DemoLocalizations.of(context).cosmetics}'),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        statusGrand = 'all';
                        _updateGrand(statusGrand);

                        Navigator.of(context).pop();
                      });
                    },
                    child: Text('${DemoLocalizations.of(context).all}'),
                  )
                ],
              );
            });
      },
      icon: Icon(Icons.arrow_drop_down),
      label: Text(
          " ${DemoLocalizations.of(context).searchby} ${data['statusGrand'] != "all" ? data['statusGrand'] == "Barber" ? DemoLocalizations.of(context).barbershop : DemoLocalizations.of(context).cosmetics : DemoLocalizations.of(context).all}"),
    );
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Icon(
                  Icons.list,
                  color: right,
                )),
          ),
          Expanded(
            child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Icon(Icons.map, color: left)),
          ),
        ],
      ),
    );
  }

  static double _degreesToRadians(degrees) {
    return degrees * pi / 180;
  }

  static double distanceInKmBetweenEarthCoordinates(lat1, lon1, lat2, lon2) {
    var earthRadiusKm = 6371;

    var dLat = _degreesToRadians(lat2 - lat1);
    var dLon = _degreesToRadians(lon2 - lon1);

    lat1 = _degreesToRadians(lat1);
    lat2 = _degreesToRadians(lat2);

    var a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    // print(earthRadiusKm * c);
    return earthRadiusKm * c;
  }

  Completer<GoogleMapController> _mapController;
  List _it;
  _getI(AsyncSnapshot snapshot, currentloca) {
    _it = [];
    for (var index = 0; index < snapshot.data.documents.length; index++) {
      final document = snapshot.data.documents[index];
      double distance = distanceInKmBetweenEarthCoordinates(
          currentloca.latitude,
          currentloca.longitude,
          document['location'].latitude,
          document['location'].longitude);
      if (distance <= 40) {
        _it.add(document);
      }
    }
    // print(_it);
  }

  // _getItems(AsyncSnapshot snapshot) {
  //   List<Widget> _items = [];

  //   for (int index = 0; index < snapshot.data.documents.length; index++) {
  //     final document = snapshot.data.documents[index];
  //     double distance = distanceInKmBetweenEarthCoordinates(
  //         currentocation.latitude,
  //         currentocation.longitude,
  //         document['location'].latitude,
  //         document['location'].longitude);

  //     if (distance <= 500) {
  //       _items.add(ListTile(
  //           title: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: <Widget>[
  //               Flexible(
  //                   flex: 2,
  //                   child: Text(
  //                     document["userBrand"],
  //                     overflow: TextOverflow.ellipsis,
  //                   )),
  //               Text(
  //                 " ${document['statusGrand'] == "Barber" ? DemoLocalizations.of(context).barbershop : DemoLocalizations.of(context).cosmetics}",
  //                 // style: TextStyle(color: Colors.white),
  //               ),
  //               IconButton(
  //                 onPressed: () async {
  //                   final controller = await _mapController.future;
  //                   await controller.animateCamera(
  //                     CameraUpdate.newCameraPosition(
  //                       CameraPosition(
  //                           target: LatLng(document['location'].latitude,
  //                               document['location'].longitude),
  //                           zoom: 12),
  //                     ),
  //                   );
  //                 },
  //                 icon: Icon(
  //                   Icons.location_on,
  //                   size: 30,
  //                 ),
  //               )
  //             ],
  //           ),
  //           subtitle: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: <Widget>[
  //               Flexible(
  //                 flex: 2,
  //                 child: Text(
  //                   document["address"],
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ),
  //               IconTheme(
  //                 data: IconThemeData(
  //                   color: Colors.amber,
  //                   size: 12,
  //                 ),
  //                 child: SmoothStarRating(
  //                     allowHalfRating: true,
  //                     starCount: 5,
  //                     rating: document['reviewsresult'] > 0.5
  //                         ? document['reviewsresult']
  //                         : 0,
  //                     size: 12.0,
  //                     color: Colors.yellow[800],
  //                     borderColor: Colors.black,
  //                     spacing: 0.0),
  //               ),
  //             ],
  //           ),
  //           leading: Container(
  //             width: 40.0,
  //             height: 40.0,
  //             decoration: new BoxDecoration(
  //               shape: BoxShape.circle,
  //               image: new DecorationImage(
  //                 fit: BoxFit.fill,
  //                 image:
  //                     new CachedNetworkImageProvider("${document['photoUrl']}"),
  //               ),
  //             ),
  //           ),
  //           onTap: () {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => ShowProfile(
  //                           adminuid: document['adminUser'],
  //                           uid: widget.uid,
  //                           snapshots: document,
  //                           adminImage: document['photoUrl'],
  //                         )));
  //             // _action1(document);
  //           }));
  //     }

  //     return _items;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${DemoLocalizations.of(context).search}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          leading: Container(),
          actions: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _iceCreamStores,
                builder: (context, snapshots) {
                  if (!snapshots.hasData) {
                    return Container();
                  }
                  currentocation != null
                      ? _getI(snapshots, currentocation)
                      : Container();
                  return IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      currentocation != null
                          ? showSearch(
                              context: context,
                              delegate: ArticleSearch(snapshots, widget.uid,
                                  currentocation, data, _it),
                            )
                          : Container();
                    },
                  );
                }),
          ],
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: StreamBuilder<QuerySnapshot>(
              stream: _iceCreamStores,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return ShimmerList();
                }
                currentocation != null
                    ? _getI(snapshot, currentocation)
                    : Container();
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      searchfor(), //sreach by
                      _buildMenuBar(context), //list or map
                      Expanded(
                        flex: 2,
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (i) {
                            if (i == 1) {
                              setState(() {
                                right = Colors.white;
                                left = Colors.black;
                              });
                            } else if (i == 0) {
                              setState(() {
                                right = Colors.black;
                                left = Colors.white;
                              });
                            }
                          },
                          children: <Widget>[
                            currentocation != null
                                ? _buildsearch(snapshot)
                                : Container(
                                    child: Center(
                                      child: RaisedButton(
                                          onPressed: () {
                                            _acceptlocation();
                                          },
                                          child: Text("חייב לאשר מיקום")),
                                    ),
                                  ),
                            currentocation != null
                                ? _buildMaps(snapshot)
                                : Container(
                                    child: Center(
                                      child: RaisedButton(
                                        onPressed: () {
                                          _acceptlocation();
                                        },
                                        child: Text("חייב לאשר מיקום"),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class ArticleSearch extends SearchDelegate {
  final snapshots;
  final uid;
  final currentocation;
  final data5;
  final item;
  //  = Firestore.instance
  //     .collection("AdminUsers")
  //     .orderBy("userName")
  //     .snapshots();

  ArticleSearch(
      this.snapshots, this.uid, this.currentocation, this.data5, this.item);

  // final Stream<UnmodifiableListView<Article>> articles;
  // ArticleSearch(this.articles);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var statusGrandAdmin;
    var statusShowAdmin;

    Stream<QuerySnapshot> _iceSnap = Firestore.instance
        .collection("AdminUsers")
        // .where("userName", isGreaterThanOrEqualTo: documetss)
        .orderBy("userBrand", descending: true)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: _iceSnap,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          List<DocumentSnapshot> _results = [];

          for (int i = 0; i < snapshot.data.documents.length; i++) {
            if (snapshot.data.documents[i].data["userBrand"]
                .toLowerCase()
                .contains(query)) {
              _results.add(snapshot.data.documents[i]);
            }
          }
          return ListView.builder(
            itemCount: _results.length,
            itemBuilder: (context, index) {
              final document = _results[index];

              statusGrandAdmin = document['statusGrand'];
              if (statusGrandAdmin == "Barber") {
                statusShowAdmin = "${DemoLocalizations.of(context).barbershop}";
              } else if (statusGrandAdmin == "Cosmetic") {
                statusShowAdmin = "${DemoLocalizations.of(context).cosmetics}";
              }

              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(flex: 2, child: Text(document['userBrand'])),
                    Flexible(flex: 2, child: Text(statusShowAdmin)),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(flex: 2, child: Text(document['userName'])),
                    Flexible(
                      flex: 2,
                      child: IconTheme(
                        data: IconThemeData(
                          color: Colors.amber,
                          size: 12,
                        ),
                        child: SmoothStarRating(
                            allowHalfRating: true,
                            starCount: 5,
                            rating: document['reviewsresult'] > 0.5
                                ? document['reviewsresult']
                                : 0,
                            size: 12.0,
                            color: Colors.yellow[800],
                            borderColor: Colors.black,
                            spacing: 0.0),
                      ),
                    ),
                  ],
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShowProfile(
                          adminuid: document['adminUser'],
                          adminImage: document['photoUrl'],
                          uid: uid,
                          // snapshots: documents,
                        ))),
              );
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Container container(String offerorhis) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.grey[200], Colors.blueGrey])),
        child: Text(
          "$offerorhis",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      );
    }

    Future _getUserData(userAdmin) async {
      final userDataQuery = await Firestore.instance
          .collection("AdminUsers")
          .document(userAdmin)
          .get();

      return userDataQuery.data;
    }

    var statusGrandAdmin;
    var statusShowAdmin;
    // var searchchoice = 'reviewsresult';
    List updatehistory = [];
    updatehistory.addAll(data5['historysearch']);

    ///order by location!!!!!

    // Stream<QuerySnapshot> _iceSnap = Firestore.instance
    //     .collection("AdminUsers")
    //     .orderBy("$searchchoice", descending: true)
    //     .snapshots();

    List<DocumentSnapshot> _results = [];
    for (int i = 0; i < item.length; i++) {
      if (item[i].data["userBrand"].toLowerCase().contains(query)) {
        _results.add(item[i]);
      }
    }
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            container("${DemoLocalizations.of(context).offers}"),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: ListView.builder(
                itemCount: _results.length < 6 ? _results.length : 6,
                itemBuilder: (context, index) {
                  final document = _results[index];

                  statusGrandAdmin = document['statusGrand'];
                  if (statusGrandAdmin == "Barber") {
                    statusShowAdmin =
                        "${DemoLocalizations.of(context).barbershop}";
                  } else if (statusGrandAdmin == "Cosmetic") {
                    statusShowAdmin =
                        "${DemoLocalizations.of(context).cosmetics}";
                  }

                  return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(flex: 2, child: Text(document['userBrand'])),
                          Flexible(flex: 2, child: Text(statusShowAdmin)),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(flex: 2, child: Text(document['userName'])),
                          Flexible(
                            flex: 2,
                            child: IconTheme(
                              data: IconThemeData(
                                color: Colors.amber,
                                size: 12,
                              ),
                              child: SmoothStarRating(
                                  allowHalfRating: true,
                                  starCount: 5,
                                  rating: document['reviewsresult'] > 0.5
                                      ? document['reviewsresult']
                                      : 0,
                                  size: 12.0,
                                  color: Colors.yellow[800],
                                  borderColor: Colors.black,
                                  spacing: 0.0),
                            ),
                          ),
                        ],
                      ),
                      onTap: () async {
                        updatehistory.add(document['user']);

                        if (updatehistory.length > 5) {
                          updatehistory.removeAt(0);
                        }

                        await Firestore.instance
                            .collection("CustomerUsers")
                            .document(uid)
                            .updateData({"historysearch": updatehistory});

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ShowProfile(
                                  adminuid: document['adminUser'],
                                  adminImage: document['photoUrl'],
                                  uid: uid,
                                  // snapshots: documents,
                                )));
                      });
                },
              ),
            ),
            container("${DemoLocalizations.of(context).history}"),
            Divider(
              height: 5.0,
              color: Colors.grey[200],
            ),
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    height: 5.0,
                    color: Colors.grey[200],
                  ),
                  itemCount: data5['historysearch'].length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: _getUserData(updatehistory[index]),
                      builder: (context, snapsho) {
                        if (!snapsho.hasData) {
                          return Container();
                        }
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ShowProfile(
                                      adminuid: snapsho.data['user'],
                                      adminImage: snapsho.data['photoUrl'],
                                      uid: uid,
                                      // snapshots: documents,
                                    )));
                          },
                          title: Text(
                            "${snapsho.data['userBrand']}",
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            "${snapsho.data['userName']}",
                            textAlign: TextAlign.center,
                          ),
                          // trailing: IconButton(
                          //   onPressed: () {
                          //     updatehistory.removeAt(index);

                          //     Firestore.instance
                          //         .collection("CustomerUsers")
                          //         .document(uid)
                          //         .updateData(
                          //             {"historysearch": updatehistory});
                          //     satus();
                          //   },
                          //   icon: Icon(Icons.close),
                          // ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool mapTogel = false;

var currentocation;

class StoreMap extends StatelessWidget {
  StoreMap(
      {Key key,
      @required this.documents,
      @required this.initialPosition,
      @required this.mapController,
      this.uid})
      : super(key: key);

  final List<DocumentSnapshot> documents;
  LatLng initialPosition;
  final Completer<GoogleMapController> mapController;
  final uid;

  //  LatLng _center = const LatLng(45.521563, -122.677433);
  // LatLng centerPosition;
  // void _onCameraMove(CameraPosition position) {
  //   centerPosition = position.target;
  // }

  @override
  Widget build(BuildContext context) {
    return currentocation != null
        ? GoogleMap(
            rotateGesturesEnabled: true,
            cameraTargetBounds: CameraTargetBounds.unbounded,
            myLocationEnabled: true,
            //  myLocationButtonEnabled: true,
            // onCameraMove: ,
            // mapType: MapType.normal,

            initialCameraPosition:
                CameraPosition(target: initialPosition, zoom: 12),
            markers: documents
                .map((document) => Marker(
                      markerId: MarkerId(document['userBrand']),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          document['statusGrand'] == "Barber"
                              ? BitmapDescriptor.hueBlue
                              : BitmapDescriptor.hueRose),
                      position: LatLng(document['location'].latitude,
                          document['location'].longitude),
                      infoWindow: InfoWindow(
                        title: document['userName'],
                        snippet: document['userBrand'],
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowProfile(
                                        adminuid: document['adminUser'],
                                        uid: uid,
                                        snapshots: document,
                                        adminImage: document['photoUrl'],
                                      )));
                        },
                      ),
                    ))
                .toSet(),
            onCameraMove: (CameraPosition position) {
              initialPosition = position.target;
              // print(" position    $initialPosition");
              currentocation = initialPosition;
              // print(" position  $currentocation");
            },
            onMapCreated: (mapController) {
              this.mapController.isCompleted
                  ? print("yes")
                  : this.mapController.complete(mapController);
            },
          )
        : Center(
            child: Text(
              "${DemoLocalizations.of(context).loading}",
              style: TextStyle(fontSize: 20),
            ),
          );
  }
}
