import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lineder/helpers/locale.dart';

class ImagePosts extends StatefulWidget {
  final uid;
  final snapshots;
  final image;
  final namee;
  final namebrand;
  final photo;
  final String collectionAorU;
  ImagePosts(
      {this.uid,
      this.snapshots,
      this.image,
      this.collectionAorU,
      this.namee,
      this.photo,
      this.namebrand});
  @override
  _ImagePostsState createState() => _ImagePostsState();
}

class _ImagePostsState extends State<ImagePosts> {
  Firestore _firestore = Firestore.instance;
  Container loadingPlaceHolder = Container(
    height: 400.0,
    child: Center(child: CircularProgressIndicator()),
  );

  TextStyle boldStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  buildPostHeader({String ownerId}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider("${widget.photo}"),
        backgroundColor: Colors.grey,
      ),
      title: GestureDetector(
        child: Text(widget.namee, style: boldStyle),
        onTap: () {
          // openProfile(context, ownerId);
        },
      ),
      subtitle: Text("${widget.snapshots['location']}"),
      trailing: IconButton(
        
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          
          Icons.arrow_forward_ios,
          color: Colors.black,
          // textDirection: TextDirection.ltr,
        ),
      ),
      // trailing: IconButton(
      //     color: showSmiles == true ? Colors.yellow[800] : Colors.grey,
      //     onPressed: () {
      //       _buildsmiles(
      //           widget.snapshots['productId'], widget.snapshots['ownerId']);
      //     },
      //     icon: const Icon(Icons.tag_faces)),
    );
  }

  Widget buildLikeableImage() {
    return Container(
      height: 400,
      child: CachedNetworkImage(
        imageUrl: widget.image,
        height: double.maxFinite,
        width: double.maxFinite,
        fit: BoxFit.cover,
        placeholder: (context, url) => loadingPlaceHolder,
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  _buildbookmark(productId, ownerId) {
    if (showHeart == false) {
      setState(() {
        this.showHeart = true;
      });
      _firestore
          .collection("AdminUsers")
          .document(ownerId)
          .collection("posts")
          .document(productId)
          .updateData({'bookmark.${widget.uid}': true});
      _firestore
          .collection("CustomerUsers")
          .document("${widget.uid}")
          .collection("bookmark")
          .document(productId)
          .setData({
        "ownerId": "$ownerId",
        "productId": "$productId",
        "user": "${widget.uid}",
        "imagePost": widget.snapshots['imagePost'],
        "timestamp": FieldValue.serverTimestamp(),
      });
    } else {
      setState(() {
        this.showHeart = false;
      });
      _firestore
          .collection("AdminUsers")
          .document(ownerId)
          .collection("posts")
          .document(productId)
          .updateData({'bookmark.${widget.uid}': false});
      _firestore
          .collection("CustomerUsers")
          .document(widget.uid)
          .collection("bookmark")
          .document(productId)
          .delete();
    }
  }

  // _buildsmiles(productId, ownerId) {
  //   if (showSmiles == false) {
  //     setState(() {
  //       this.showSmiles = true;
  //     });
  //     _firestore
  //         .collection("AdminUsers")
  //         .document(ownerId)
  //         .collection("posts")
  //         .document(productId)
  //         .updateData({'likes.${widget.uid}': true});
  //   } else {
  //     setState(() {
  //       this.showSmiles = false;
  //     });
  //     _firestore
  //         .collection("AdminUsers")
  //         .document(ownerId)
  //         .collection("posts")
  //         .document(productId)
  //         .updateData({'likes.${widget.uid}': false});
  //   }
  // }

  @override
  initState() {
    widget.snapshots['bookmark'][widget.uid] == true
        ? showHeart = true
        : print("no ");
    // widget.snapshots['likes'][widget.uid] == true
    //     ? showSmiles = true
    //     : print("no ");
    super.initState();
  }

  // @override
  // void dispose() {
  //   sub.cancel();

  //   super.dispose();
  // }

  bool showHeart = false;
  bool showSmiles = false;
  _deletepost(String productId, String user, String imagePost) async {
    await _firestore
        .collection("AdminUsers")
        .document(user)
        .collection("posts")
        .document("$productId")
        .delete();

    FirebaseStorage _storage = FirebaseStorage.instance;
    StorageReference _ref = await _storage.getReferenceFromUrl(imagePost);
    await _ref.delete();
    print("image deleted");

    // final FirebaseStorage _store =
    //     FirebaseStorage(storageBucket: 'gs://danielhaircutnew.appspot.com');
  }

  // static void deleteFireBaseStorageItem(String fileUrl) {
  //   String filePath = fileUrl.replaceAll(
  //        RegExp(
  //           r'https://firebasestorage.googleapis.com/v0/b/gs://danielhaircutnew.appspot.com/o/'),
  //       '');

  //   filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');

  //   filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');

  //   StorageReference storageReferance = FirebaseStorage.instance.ref();

  //   storageReferance
  //       .child(filePath)
  //       .delete()
  //       .then((_) => print('Successfully deleted $filePath storage item'));
  // }

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnackBar(String value, productId, user, imagePost) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      action: SnackBarAction(
        label: "${DemoLocalizations.of(context).yes}",
        onPressed: () {
          _deletepost(productId, user, imagePost);
          // deleteFireBaseStorageItem(imagePost);
          // status();
          Navigator.pop(context);
        },
      ),
    ));
  }

  // int _countFollowings(Map likes) {
  //   int count = 0;

  //   void countValues(key, value) {
  //     if (value) {
  //       count += 1;
  //     }
  //   }

  //   // hacky fix to enable a user's post to appear in their feed without skewing the follower/following count
  //   // if (likes[widget.uid] == null) count -= 1;

  //   likes.forEach(countValues);

  //   return count;
  // }

  Column buildStatColumn(String label, int number) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          number == -1 ? "0" : number.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
            margin: const EdgeInsets.only(top: 4.0),
            child: Text(
              label,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body:
          // StreamBuilder<QuerySnapshot>(
          //     stream: Firestore.instance
          //         .collection("AdminUsers")
          //         .document(widget.snapshots['ownerId'])
          //         .collection("bookmark")
          //         .snapshots(),
          //     builder: (context, snapshot) {
          //       if (!snapshot.hasData) {
          //         return Container();
          //       }
          // snapshot.data.documents.forEach((doc) {
          // doc['bookmark'][widget.uid] != null
          //     ? doc['bookmark'][widget.uid] == true
          //         ? showHeart = true
          //         : print("no ")
          //     : print("nodata");

          // doc['productId'] == null ? showHeart = false : showHeart = true;
          // });

          // snapshot.data.forEatch((doc) {
          //   doc['productId'] == null ? showHeart = false : showHeart = true;
          // });
          Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          buildPostHeader(ownerId: widget.uid),
          buildLikeableImage(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.namebrand,
                style: boldStyle,
              ),
              widget.uid != widget.snapshots['ownerId']
                  ? IconButton(
                      icon: Icon(
                        showHeart == true
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        // FontAwesomeIcons.bookMedical,
                        size: 30.0,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        _buildbookmark(widget.snapshots['productId'],
                            widget.snapshots['ownerId']);
                      })
                  : IconButton(
                      onPressed: () {
                        showInSnackBar(
                            "למחוק תמונה",
                            widget.snapshots['productId'],
                            widget.snapshots['ownerId'],
                            widget.snapshots['imagePost']);
                      },
                      icon: Icon(Icons.delete),
                    ),
            ],
          ),
          Material(
            // color: Colors.grey[300],
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Container(
                //   margin: const EdgeInsets.only(left: 20.0),
                //   child:
                //       // Text(
                //       //   "חיוכים ${widget.snapshots['likes']}",
                //       //   // "${widget.namee}:  ",
                //       //   style: boldStyle,
                //       // )
                //       buildStatColumn("חיוכים",
                //           _countFollowings(widget.snapshots['likes'])),
                // ),
                Flexible(
                    flex: 2,
                    child: Text(
                      "  ${widget.snapshots['description']}",
                      overflow: TextOverflow.clip,
                      maxLines: 3,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
