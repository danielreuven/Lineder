import 'package:lineder/admin/areaperson/showpost.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowImages extends StatefulWidget {
  final String uid;
  final String adminuid;
  final String collectionAorU;
  ShowImages({this.uid, this.adminuid, this.collectionAorU});
  @override
  _ShowImagesState createState() => _ShowImagesState();
}

class _ShowImagesState extends State<ShowImages> {
  String collectionAorU = "CustomerUsers";
  Firestore _firestore = Firestore.instance;
  Future _getPosts() async {
    QuerySnapshot q = await _firestore
        .collection("AdminUsers")
        .document(widget.adminuid)
        .collection("posts")
        .getDocuments();

    return q.documents;
  }

  Future _getNameFromUser(user) async {
    Query q = Firestore.instance
        .collection("AdminUsers")
        .where("user", isEqualTo: user);

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  var namee;
  var photo;
  var namebrand;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getPosts(),
        builder: (context, snapshots) {
          if (!snapshots.hasData) {
            return SliverPadding(
              padding: EdgeInsets.all(10),
            );
          }
          // return GridView.builder(
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 3,
          //     crossAxisSpacing: 0.5,
          //     childAspectRatio: 1.4,
          //   ),
          //   itemCount: snapshots.data.length,
          //   itemBuilder: (context, index) {
          //     final document = snapshots.data[index].data;
          //     return FutureBuilder(
          //         future: _getNameFromUser(document['ownerId']),
          //         builder: (context, snapshot) {
          //              if (!snapshot.hasData) {
          //                     return Container();
          //                   }
          //                   snapshot.data.forEach((doc) {
          //                     namee = doc['userName'];
          //                     photo = doc['photoUrl'];
          //                     namebrand = doc['userBrand'];
          //                   });
          //           return InkWell(
          //             onTap: () {
          //               Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                       builder: (context) => ImagePosts(
          //                             uid: widget.uid,
          //                             snapshots: document,
          //                             image: document['imagePost'],
          //                             namee:namee,
          //                             photo:photo,
          //                             namebrand:namebrand,
          //                             collectionAorU: collectionAorU,
          //                           )));
          //             },
          //             child: Container(
          //               // width: 40.0,
          //               // height: 40.0,
          //               decoration: new BoxDecoration(
          //                 // shape: BoxShape.circle,
          //                 image: new DecorationImage(
          //                   fit: BoxFit.fill,
          //                   image: new CachedNetworkImageProvider(
          //                       "${document['imagePost']}"),
          //                 ),
          //               ),
          //             ),
          //           );
          //         });
          //   },
          // );
          //  snapshots.data.forEach((doc) {
          //     imagess.add(doc['imagePost']);
          //   });

          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 0.5,
              childAspectRatio: 1.4,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final document = snapshots.data[index].data;
              return FutureBuilder(
                  future: _getNameFromUser(document['ownerId']),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    snapshot.data.forEach((doc) {
                      namee = doc['userName'];
                      photo = doc['photoUrl'];
                      namebrand = doc['userBrand'];
                    });
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImagePosts(
                                      uid: widget.uid,
                                      snapshots: document,
                                      image: document['imagePost'],
                                      namee: namee,
                                      photo: photo,
                                      namebrand: namebrand,
                                      collectionAorU: collectionAorU,
                                    )));
                      },
                      child: Container(
                          // height: 80,
                          // width: 50,
                          child: CachedNetworkImage(
                        imageUrl: "${document['imagePost']}",
                        fit: BoxFit.cover,
                      )),
                    );
                  });

              // Card(
              //     child: Image.network(
              //         "${snapshots.data[index].data['imagePost']}")));
            }, childCount: snapshots.data.length),
          );
        });
  }
}
