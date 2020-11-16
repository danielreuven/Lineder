import 'dart:async';
import 'dart:io';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lineder/admin/allclient/allclients.dart';
import 'package:lineder/animation/loadingscircular.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Uploader extends StatefulWidget {
  final uid;
  final data5;
  final statusGrand;
  final country;

  Uploader({
    this.uid,
    this.data5,
    this.statusGrand,
    this.country,
  });

  _Uploader createState() => _Uploader();
}

class _Uploader extends State<Uploader> {
  File file;

  Map<String, double> currentLocation = Map();
  TextEditingController descriptionController = TextEditingController();

  bool uploading = false;

  @override
  initState() {
    adre = widget.data5['address'];
    super.initState();
    file != null ? uploadImage(file) : Container();
  }

  //method to get Location and save into variables

  String adre = '';
  String tagsname = '';
  var tagsuid;
  final db = Firestore.instance;
  Future _getClients() async {
    QuerySnapshot q = await Firestore.instance
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("AdminAllClients")
        .getDocuments();

    return q.documents;
  }

// ArticleSearch
  Future _getUserData(userAdmin) async {
    final userDataQuery = await Firestore.instance
        .collection("CustomerUsers")
        .document(userAdmin)
        .get();

    return userDataQuery.data;
  }

  Widget secondpage() {
    return Column(
      children: <Widget>[
        uploading
            ? LinearProgressIndicator()
            : Padding(padding: EdgeInsets.only(top: 0.0)),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
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
            Container(
              width: 250.0,
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    hintText: '${DemoLocalizations.of(context).writesometing}',
                    border: InputBorder.none),
              ),
            ),
            Container(
              height: 45.0,
              width: 45.0,
              child: AspectRatio(
                aspectRatio: 487 / 451,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter,
                                  image: FileImage(file),
                                )),
                              ),
                              Positioned(
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Colors.blue,
                                  onPressed: () => Navigator.pop(context),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                    textDirection: TextDirection.ltr,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                        // actions: <Widget>[
                        //   // usually buttons at the bottom of the dialog
                        //   new FlatButton(
                        //     child: new Icon(Icons.close),
                        //     onPressed: () {
                        //       Navigator.of(context).pop();
                        //     },
                        //   ),
                        // ],
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.fill,
                      alignment: FractionalOffset.topCenter,
                      image: FileImage(file),
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(),
        ListTile(
          leading: IconButton(
              onPressed: () {
                setState(() {
                  adre = widget.data5['address'];
                });
              },
              icon: Icon(Icons.pin_drop)),
          title: Container(width: 250.0, child: Text("$adre")),
          trailing: IconButton(
              onPressed: () {
                setState(() {
                  adre = '';
                });
              },
              icon: Icon(Icons.close)),
        ),
        // Divider(),
        // ListTile(
        //   leading: Icon(FontAwesomeIcons.tags),
        //   title: Container(width: 250.0, child: Text("$tagsname")),
        //   trailing: IconButton(
        //       onPressed: () {
        //         setState(() {
        //           tagsname = '';
        //         });
        //       },
        //       icon: Icon(Icons.close)),
        // ),
        // FutureBuilder(
        //     future: _getClients(),
        //     builder: (context, snapshots) {
        //       if (!snapshots.hasData) {
        //         return Container();
        //       }
        //       return Container(
        //         height: 30,
        //         // color: Colors.red,
        //         child: ListView.builder(
        //           itemCount: snapshots.data.length,
        //           scrollDirection: Axis.horizontal,
        //           itemBuilder: (_, index) {
        //             return FutureBuilder(
        //                 future:
        //                     _getUserData(snapshots.data[index].data['user']),
        //                 builder: (context, snapshot) {
        //                   if (!snapshot.hasData) {
        //                     return Container();
        //                   }

        //                   return Row(
        //                     children: <Widget>[
        //                       // index == 4
        //                       //     ? RaisedButton(
        //                       //         shape: RoundedRectangleBorder(
        //                       //             borderRadius:
        //                       //                 BorderRadius.circular(10)),
        //                       //         color: Colors.lightBlue,
        //                       //         onPressed: () {
        //                       //           showSearch(
        //                       //             context: context,
        //                       //             delegate: ArticleSearch(
        //                       //               snapshots,
        //                       //               snapshot,
        //                       //               widget.uid,
        //                       //             ),
        //                       //           );
        //                       //         },
        //                       //         child: Text("search"),
        //                       //       )
        //                       //     :
        //                       RaisedButton(
        //                           // elevation: 4.0,
        //                           color: Colors.lightBlue[300],
        //                           shape: RoundedRectangleBorder(
        //                               borderRadius: BorderRadius.circular(10)),
        //                           onPressed: () {
        //                             setState(() {
        //                               // namee = '';
        //                               tagsname = snapshot.data['userName'];

        //                               tagsuid =
        //                                   snapshots.data[index].data['user'];
        //                             });
        //                           },
        //                           child: Text("${snapshot.data['userName']}"))
        //                     ],
        //                   );
        //                 });
        //           },
        //         ),
        //       );
        //     })
      ],
    );
  }

  Widget build(BuildContext context) {
    return file == null
        ? Scaffold(
            body: Container(
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Color(0xFFfbab66),
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                        BoxShadow(
                          color: Color(0xFFf7418c),
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                      ],
                      gradient: new LinearGradient(
                          colors: [
                            // Theme.Colors.loginGradientEnd,
                            // Theme.Colors.loginGradientStart
                            Color(0xFFf7418c),
                            Color(0xFFfbab66)
                          ],
                          begin: const FractionalOffset(0.2, 0.2),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 60.0),
                      child: InkWell(
                        onTap: () async {
                          // Navigator.pop(context);
                          File imageFile = await ImagePicker.pickImage(
                            source: ImageSource.camera,
                          );
                          setState(() {
                            file = imageFile;
                            file != null ? uploadImage(file) : Container();
                          });
                        },
                        child: Text(
                          '${DemoLocalizations.of(context).camera}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontFamily: "WorkSansBold"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Color(0xFFfbab66),
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                        BoxShadow(
                          color: Color(0xFFf7418c),
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                      ],
                      gradient: new LinearGradient(
                          colors: [
                            // Theme.Colors.loginGradientEnd,
                            // Theme.Colors.loginGradientStart
                            Color(0xFFf7418c),
                            Color(0xFFfbab66)
                          ],
                          begin: const FractionalOffset(0.2, 0.2),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 60.0),
                      child: InkWell(
                        onTap: () async {
                          File imageFile = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            file = imageFile;
                            file != null ? uploadImage(file) : Container();
                          });
                        },
                        child: Text(
                          '${DemoLocalizations.of(context).gallery}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontFamily: "WorkSansBold"),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
          )
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              backgroundColor: Colors.white70,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: clearImage),
              title: Text(
                '${DemoLocalizations.of(context).sharepost}',
                style: const TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                uploading == false && dowonlbool == true
                    ? FlatButton(onPressed: postImage, child: Icon(Icons.check))
                    : Container(
                        child: Center(child: ColorLoader3()),
                      ),
              ],
            ),
            body: ListView(
              children: <Widget>[
                secondpage(),

                // Divider(), //scroll view where we will show location to users
                // (address == null)
                //     ? Container()
                //     : SingleChildScrollView(
                //         scrollDirection: Axis.horizontal,
                //         padding: EdgeInsets.only(right: 5.0, left: 5.0),
                //         child: Row(
                //           children: <Widget>[
                //             // buildLocationButton(address.featureName),
                //             // buildLocationButton(address.subLocality),
                //             // buildLocationButton(address.locality),
                //             // buildLocationButton(address.subAdminArea),
                //             // buildLocationButton(address.adminArea),
                //             // buildLocationButton(address.countryName),
                //           ],
                //         ),
                //       ),
                // (address == null) ? Container() : Divider(),
              ],
            ));
  }

  // _selectImage(BuildContext parentContext) async {
  //   return showDialog<Null>(
  //     context: parentContext,
  //     barrierDismissible: false, // user must tap button!

  //     builder: (BuildContext context) {
  //       return SimpleDialog(
  //         title: const Text('Create a Post'),
  //         children: <Widget>[
  //           SimpleDialogOption(
  //               child: const Text('Take a photo'),
  //               onPressed: () async {
  //                 Navigator.pop(context);
  //                 File imageFile = await ImagePicker.pickImage(
  //                     source: ImageSource.camera,
  //                     maxWidth: 1920,
  //                     maxHeight: 1350);
  //                 setState(() {
  //                   file = imageFile;
  //                 });
  //               }),
  //           SimpleDialogOption(
  //               child: const Text('Choose from Gallery'),
  //               onPressed: () async {
  //                 Navigator.of(context).pop();
  //                 File imageFile =
  //                     await ImagePicker.pickImage(source: ImageSource.gallery);
  //                 setState(() {
  //                   file = imageFile;
  //                 });
  //               }),
  //           SimpleDialogOption(
  //             child: const Text("Cancel"),
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

//   void compressImage() async {
//     print('starting compression');
//     final tempDir = await getTemporaryDirectory();
//     final path = tempDir.path;
//     int rand = Math.Random().nextInt(10000);

//     Im.Image image = Im.decodeImage(file.readAsBytesSync());
//     // Im.copyResize(image, 500);

//     //  image.format = Im.Image.RGBA;
// //    Im.Image newim = Im.remapColors(image, alpha: Im.LUMINANCE);

//     var newim2 = File('$path/img_$rand.jpg')
//       ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

//     setState(() {
//       file = newim2;
//     });
//     print('done');
//   }

  void clearImage() {
    setState(() {
      file = null;
      dowonlbool = false;
    });
  }

  void postImage() {
    setState(() {
      uploading = true;
    });
    // compressImage();
    // uploadImage(file).then((String data) {
    //   postToFireStore(
    //     // imagePost: data,
    //     description: descriptionController.text,
    //   );
    // });
    postToFireStore(
      // imagePost: data,
      description: descriptionController.text,
    );
    // then((_) {
    //   setState(() {
    //     file = null;
    //     // uploading = false;
    //     Navigator.pop(context);
    //   });
    // });
  }
  var downloadUrl;
  bool dowonlbool = false;
  Future<String> uploadImage(var imageFile) async {
    final FirebaseStorage _store =
        FirebaseStorage(storageBucket: 'gs://danielhaircutnew.appspot.com');
    String filePath = "${widget.uid}/postAdmin/post_${DateTime.now()}.png";
    StorageUploadTask _uploadTaskNew;

    setState(() {
      _uploadTaskNew = _store.ref().child(filePath).putFile(imageFile);
    });
    downloadUrl = await (await _uploadTaskNew.onComplete).ref.getDownloadURL();
    _uploadTaskNew.onComplete.then((s) {
      setState(() {
        dowonlbool = true;
      });
    });
    return downloadUrl;
  }

  void postToFireStore({description}) async {
    String productId = DateTime.now().millisecondsSinceEpoch.toString();
    // var reference = Firestore.instance.collection('insta_posts');
    db
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("posts")
        .document("$productId")
        .setData({
      "location": "$adre",
      "bookmark": {},
      // "likes": {},
      "productId": "$productId",
      "userProfileImg": widget.data5['image'],
      "imagePost": downloadUrl,
      "description": description,
      "ownerId": widget.uid,
      "timestamp": FieldValue.serverTimestamp(),
    }).whenComplete(() {
      if (tagsname.isNotEmpty) {
        db
            .collection("AdminUsers")
            .document(widget.uid)
            .collection("posts")
            .document("$productId")
            .updateData({
          "tags": "$tagsname",
          "tagsUid": "$tagsuid",
        });
      }
    }).then((_) {
      setState(() {
        file = null;
        // uploading = false;
        Navigator.pop(context);
      });
    });
  }
}
