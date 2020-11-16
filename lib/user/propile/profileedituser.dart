import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lineder/admin/areaperson/imageuplode/models/image_picker_handler.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:path/path.dart';

class EditProfileUser extends StatefulWidget {
  final String uid;

  EditProfileUser({
    this.uid,
  });
  @override
  _EditProfileUserState createState() => _EditProfileUserState();
}

class _EditProfileUserState extends State<EditProfileUser>
    with TickerProviderStateMixin, ImagePickerListener {
  VoidCallback voidCallback;
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  String inputNametext = '';
  String inputBio = '';
  String phonecountry = '';

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    _getProducts();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  updateAlluser() {
    if (inputNametext.isNotEmpty) {
      _firestore
          .collection("CustomerUsers")
          .document("${widget.uid}")
          .updateData({
        // "productId": "${widget.productId}",
        "userName": "$inputNametext",
        // "userEmail": "${widget.email}",
        // "user": "${widget.uid}",
      });
    }
    if (inputBio.isNotEmpty) {
      _firestore
          .collection("CustomerUsers")
          .document("${widget.uid}")
          .updateData({
        // "productId": "${widget.productId}",
        "bio": "$inputBio",
        // "userEmail": "${widget.email}",
        // "user": "${widget.uid}",
      });
    }
    if (phonecountry.isNotEmpty) {
      _firestore
          .collection("CustomerUsers")
          .document("${widget.uid}")
          .updateData({
        // "productId": "${widget.productId}",
        // "userEmail": "${widget.email}",
        // "user": "${widget.uid}",
        "phone": "$phonecountry",
      }).whenComplete(() {
        print("update");
      });
    }
  }

  void _onChange(String value) {
    setState(() {
      inputNametext = value;
    });
  }

  void _onChangeBio(String value) {
    setState(() {
      inputBio = value;
    });
  }

  Future onRefresh() async {
    await Future.delayed(Duration(microseconds: 200));
    setState(() {
      _getProducts();
    });
    return null;
  }

  bool nameBool = false;
  bool selectSave = false;

///////////////Widget Input Name //////////
  Widget _voidTextFName(context) {
    return Container(
      // height: 50,
      // color: Colors.white24,
      child: TextField(
          dragStartBehavior: DragStartBehavior.start,
          autofocus: true,
          cursorWidth: 6.0,
          keyboardType: TextInputType.text,
          cursorRadius: Radius.circular(30),
          cursorColor: Colors.purple,
          // maxLengthEnforced: true,
          // maxLength: 20,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(20),
              labelText: "${DemoLocalizations.of(context).fullname}",
              icon: IconButton(
                onPressed: () {
                  setState(() {
                    nameBool = false;
                  });
                  // print(nameBool);
                },
                icon: Icon(
                  Icons.swap_vertical_circle,
                  color: Colors.black54,
                ),
              )),
          onChanged: (String value) {
            _onChange(value);
          },
          onSubmitted: ((e) {
            nameBool = false;
            updateAlluser();
          })),
    );
  }

  bool bioBool = false;
  Widget _voidTextFBio(context) {
    return Container(
      // height: 50,
      // color: Colors.white24,
      child: TextField(
          dragStartBehavior: DragStartBehavior.start,
          autofocus: true,
          cursorWidth: 6.0,
          keyboardType: TextInputType.text,
          cursorRadius: Radius.circular(30),
          cursorColor: Colors.purple,
          // maxLengthEnforced: true,
          maxLength: 50,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(20),
              labelText: "${DemoLocalizations.of(context).bio}",
              icon: IconButton(
                onPressed: () {
                  setState(() {
                    bioBool = false;
                    // selectSave = false;
                  });
                  // print(nameBool);
                },
                icon: Icon(
                  Icons.swap_vertical_circle,
                  color: Colors.black54,
                ),
              )),
          onChanged: (String value) {
            _onChangeBio(value);
          },
          onSubmitted: ((e) {
            bioBool = false;
            updateAlluser();
          })),
    );
  }

  bool selectPhoneFiled = false;
  var n;
  String numberValidator(String value) {
    if (value == null) {
      return null;
    }

    n = num.tryParse(value);

    print(n);
    if (n == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }

  Widget phoneFiled(context) {
    return Container(
      // height: 50,
      // width: 200,
      // color: Colors.white54,
      child: Row(
        textDirection: TextDirection.ltr,
        children: <Widget>[
          Container(
              // height: 50,
              width: 100,
              // color: Colors.blue,
              child: phonecunntry()),
          Container(
            // height: 50,
            width: 200,
            // color: Colors.red,
            child: TextField(
                textDirection: TextDirection.ltr,
                autofocus: true,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: "${DemoLocalizations.of(context).phone}",
                    icon: IconButton(
                      onPressed: () {
                        setState(() {
                          selectPhoneFiled = false;
                          selectSave = false;
                        });
                      },
                      icon: Icon(
                        Icons.swap_vertical_circle,
                        color: Colors.black54,
                      ),
                    )),
                keyboardType: TextInputType.number,
                maxLength: 15,
                onChanged: (String value) {
                  phonecountry = phonecunttry + value;
                  print(phonecountry);
                  // numberValidator(value);
                  // print(value);
                },
                onSubmitted: ((e) {
                  selectPhoneFiled = false;
                  updateAlluser();
                })),
          ),
        ],
      ),
    );
  }

  bool selecSa = false;
  Firestore _firestore = Firestore.instance;
  Future _getProducts() async {
    Query q = _firestore
        .collection("CustomerUsers")
        .where("user", isEqualTo: widget.uid);

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
    // setState(() {
    //   _loadingProducts = false;
    // });
  }

  Future<String> uploadImage() async {
    final FirebaseStorage _store =
        FirebaseStorage(storageBucket: 'gs://danielhaircutnew.appspot.com');
    String filePath =
        "${widget.uid}/profileClient/profile_${DateTime.now()}.png";
    StorageUploadTask _uploadTaskNew;
    setState(() {
      _uploadTaskNew = _store.ref().child(filePath).putFile(_image);
    });
    String downloadUrl =
        await (await _uploadTaskNew.onComplete).ref.getDownloadURL();

    // Firestore.instance
    //     .collection("AdminUsers")
    //     .document('${widget.uid}')
    //     .updateData({"image": "$downloadUrl"});
    Firestore.instance
        .collection("CustomerUsers")
        .document('${widget.uid}')
        .updateData({"photoUrl": "$downloadUrl"}).whenComplete(() {
      print(downloadUrl);
    });

    return downloadUrl;
  }

  File _imageGal;
  var imageGal;
  Future imageGallery() async {
    imageGal = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageGal = imageGal;
      print("image Path $imageGal");
    });
  }

  var imagesUrl;
  String fileName;
  Future uplodPic(BuildContext context) async {
    var randomno = Random(10);
    fileName = basename(_imageGal.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profilesAdmin/${randomno.nextInt(5000).toString()}.jpg');

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageGal);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    imagesUrl = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      Firestore.instance
          .collection("CustomerUsers")
          .document('${widget.uid}')
          .updateData({"photoUrl": "$imagesUrl"});
      // Firestore.instance
      //     .collection("AllUsers")
      //     .document('${widget.uid}')
      //     .updateData({"image": "$imagesUrl"});

      print("Propile picture");
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Propile picture Uploaded"),
      ));
    });
  }

  /////////////////camera
  File _imageCam;
  var imageCam;
  Future imageCamera() async {
    imageCam = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _imageCam = imageCam;
      print("image Path $imageCam");
    });
  }

  var imagesUrlCamera;
  String fileNameC;
  Future uplodCamera(BuildContext context) async {
    var randomno = Random(20);
    fileNameC = basename(_imageCam.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profilesUsers/${randomno.nextInt(5000).toString()}.jpg');
// 'profiles/${randomno.nextInt(5000).toString()}.jpg'
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageCam);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    imagesUrlCamera = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      Firestore.instance
          .collection("CustomerUsers")
          .document('${widget.uid}')
          .updateData({"photoUrl": "$imagesUrlCamera"});
      // Firestore.instance
      //     .collection("AllUsers")
      //     .document('${widget.uid}')
      //     .updateData({"image": "$imagesUrlCamera"});

      print("Propile picture");
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Propile picture Uploaded"),
      ));
    });
  }

  String phonecunttry = '+972';
  void _onCountryChange(CountryCode countryCode) {
    phonecunttry = countryCode.toString();
    print(phonecunttry);

    print("New Country selected: " + countryCode.toString());
  }

  Widget phonecunntry() {
    return Center(
      child: new CountryCodePicker(
        onChanged: _onCountryChange,
        initialSelection: 'IL',
        favorite: ['+972', 'IL'],
        showCountryOnly: false,
        showOnlyCountryWhenClosed: false,
        alignLeft: false,
      ),
    );
  }

  var name;
  var photo;
  var bio;
  var phone;
  var email;
  var statusSize;
  var statuslocation = 'ישראל';

  _updateGrand(statusSize) {
    _firestore
        .collection("CustomerUsers")
        .document("${widget.uid}")
        .updateData({
      "statusSize": "$statusSize",
    });
  }

  Future _getUserData() async {
    final userDataQuery = await Firestore.instance
        .collection("CustomerUsers")
        .document(widget.uid)
        .get();

    return userDataQuery.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
            )
          : PreferredSize(
              preferredSize: Size(0, 0),
              child: Container(),
            ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          // width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
              future: _getUserData(),
              builder: (BuildContext context, snapshots) {
                if (!snapshots.hasData) {
                  return Center(
                    child: Text(
                      "${DemoLocalizations.of(context).loading}",
                    ),
                  );
                }
                // snapshots.data.forEach((doc) {
                //   name = doc['userName'];
                //   photo = doc['photoUrl'];
                //   bio = doc['bio'];
                //   phone = doc['phone'];
                //   email = doc['userEmail'];
                //   statusSize = doc['statusSize'];

                //   ///לשנות
                //   // statuslocation = 'ישראל';
                // });
                return ListView(
                  children: <Widget>[
                    // _image == null
                    //     ?
                    InkWell(
                        onTap: () => imagePicker.showDialog(context),
                        child: Container(
                          height: 150.0,
                          decoration: new BoxDecoration(
                            // shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: _image == null
                                  ? new CachedNetworkImageProvider(snapshots
                                              .data['photoUrl'] !=
                                          null
                                      ? "${snapshots.data['photoUrl']}"
                                      : "https://images.unsplash.com/photo-1548586196-aa5803b77379?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=967&q=80")
                                  : FileImage(_image),
                            ),
                          ),
                          child: _image != null
                              ? IconButton(
                                  onPressed: () {
                                    // setState(() {});
                                    // if (_imageGal != null) {
                                    //   uplodPic(context);
                                    // }
                                    // if (_imageCam != null) {
                                    //   uplodCamera(context);
                                    // }
                                    uploadImage();

                                    Duration(seconds: 5);
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    Icons.save,
                                    size: 34,
                                  ),
                                )
                              : Text(""),
                        )),
                    nameBool == false
                        ? ListTile(
                            title: Text(
                              "${DemoLocalizations.of(context).fullname}",
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              " ${snapshots.data['userName'] != "null" ? snapshots.data['userName'] : "הזן שם"}",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  nameBool = true;
                                });
                              },
                            ),
                          )
                        : _voidTextFName(context),
                    selectPhoneFiled == false
                        ? ListTile(
                            title: Text(
                              "${DemoLocalizations.of(context).phone}",
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              " ${snapshots.data['phone'] != "null" ? snapshots.data['phone'] : "הזן פלאפון"}",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  selectPhoneFiled = true;
                                });
                              },
                            ),
                          )
                        : phoneFiled(context),
                    bioBool == false
                        ? ListTile(
                            title: Text(
                              "${DemoLocalizations.of(context).bio}",
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              " ${snapshots.data['bio'] != "null" ? snapshots.data['bio'] : ""}",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  bioBool = true;
                                });
                              },
                            ),
                          )
                        : _voidTextFBio(context),
                    ListTile(
                      title: Text(
                        "${DemoLocalizations.of(context).gender}",
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        " ${snapshots.data['statusSize'] != "null" ? snapshots.data['statusSize'] : ""}",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          size: 30,
                        ),
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
                                          statusSize =
                                              "${DemoLocalizations.of(context).man}";
                                          _updateGrand(statusSize);
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Text(
                                          DemoLocalizations.of(context).man),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          statusSize =
                                              "${DemoLocalizations.of(context).woman}";
                                          _updateGrand(statusSize);
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Text(
                                          DemoLocalizations.of(context).woman),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          statusSize =
                                              "${DemoLocalizations.of(context).prefernottosay}";
                                          _updateGrand(statusSize);
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Text(DemoLocalizations.of(context)
                                          .prefernottosay),
                                    )
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "${DemoLocalizations.of(context).privateinformation}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "${DemoLocalizations.of(context).email}",
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        " ${snapshots.data['userEmail']}",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      trailing: Icon(Icons.account_circle),
                    ),
                    ListTile(
                      title: Text(
                        "${DemoLocalizations.of(context).location}",
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        " $statuslocation",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      trailing: Icon(Icons.location_city),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }

  @override
  userImage(File _image) {
    setState(() {
      this._image = _image;
    });
  }
}
