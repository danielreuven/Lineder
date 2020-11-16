import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyFollowers extends StatefulWidget {
  final uid;

  const MyFollowers({this.uid});
  @override
  _MyFollowersState createState() => _MyFollowersState();
}

class _MyFollowersState extends State<MyFollowers> {
  Future _getFollowers() async {
    Query q = Firestore.instance
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("following");
    // .orderBy("timeFull", descending: true);

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  Future _getUserData(userAdmin) async {
    final userDataQuery = await Firestore.instance
        .collection("AdminUsers")
        .document(userAdmin)
        .get();

    return userDataQuery.data;
  }

  List myprodcuts = [];
  Stream<QuerySnapshot> _clients;
  Future<QuerySnapshot> daniel;
  @override
  void initState() {
    super.initState();

    _clients = Firestore.instance
        .collection("CustomerUsers")
        .document(widget.uid)
        .collection("following")
        .snapshots();
    _clients.listen((snap) {
      setState(() {
        for (var i = 0; i < snap.documents.length; i++) {
          daniel = Firestore.instance
              .collection("AdminUsers")
              .document("${snap.documents[i]['adminUser']}")
              .collection("posts")
              .getDocuments();

          daniel.then((snaps) {
            setState(() {
              for (var j = 0; j < snaps.documents.length; j++) {
                // DateTime date =snaps.documents[j]['timestamp'].toDate();

                myprodcuts.add(snaps.documents[j]);
                print(myprodcuts.length);
              }
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // var height =MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed"),
      ),
      body: 
       Container(
            // color: Colors.red,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: myprodcuts.length,
              // reverse: true,
              itemBuilder: (context, index) {
                
                var document = myprodcuts[index];
                return FutureBuilder(
                    future: _getUserData(document['ownerId']),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      return Container(
                        height: MediaQuery.of(context).size.height-50,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("${snapshot.data['userName']}"),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.arrow_forward_ios),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height-160,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        "${document['imagePost']}",
                                      ),
                                      fit: BoxFit.cover)),
                            ),
                            Container(
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                      "${snapshot.data['userBrand']}  ${document['description']}"),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.bookmark),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                      // return ListTile(
                      //   title: Text("${snapshot.data['userName']}"),
                      //   subtitle: Text("${document['location']}"),
                      // );
                    });
              },
            )),
    
    );
  }
}
