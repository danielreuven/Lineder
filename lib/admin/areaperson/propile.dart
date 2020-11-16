import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lineder/admin/areaperson/addadress.dart';
import 'package:lineder/admin/areaperson/imageuplode/models/image_picker_handler.dart';
import 'package:lineder/helpers/locale.dart';

class PropileA extends StatefulWidget {
  PropileA({this.uid, this.userorAdmin, this.namesStorage});
  final uid;

  final String userorAdmin;
  final String namesStorage;

  @override
  _PropileAState createState() => _PropileAState();
}

class _PropileAState extends State<PropileA>
    with TickerProviderStateMixin, ImagePickerListener {
  Firestore _firestore = Firestore.instance;

  VoidCallback voidCallback;
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    // _getProducts();
    // sub = db
    //     .collection("AdminUsers")
    //     .document(widget.uid)
    //     .snapshots()
    //     .listen((snap) {
    //   setState(() {
    //     data = snap.data;
    //   });
    // });
  }

  // final db = Firestore.instance;
  // StreamSubscription sub;

  // Map data;
  @override
  void dispose() {
    _controller.dispose();
    // sub.cancel();
    super.dispose();
  }

////////////////////////database string name user ///////////////
  ///

  String inputNametext = '';
  String inputBarndtext = '';
  String inputBio = '';

  updProducts() {
    if (inputNametext.isNotEmpty) {
      _firestore
          .collection("${widget.userorAdmin}")
          .document("${widget.uid}")
          .updateData({
        "userName": "$inputNametext",
      });
    }
    if (phonecountry.isNotEmpty) {
      _firestore
          .collection("${widget.userorAdmin}")
          .document("${widget.uid}")
          .updateData({
        "phone": "$phonecountry",
      }).whenComplete(() {
        print("update phone");
      });
    }
    if (inputBio.isNotEmpty) {
      _firestore
          .collection("${widget.userorAdmin}")
          .document("${widget.uid}")
          .updateData({
        "bio": "$inputBio",
      }).whenComplete(() {
        print("update bio");
      });
    }

    if (inputBarndtext.isNotEmpty) {
      _firestore
          .collection("${widget.userorAdmin}")
          .document("${widget.uid}")
          .updateData({
        "userBrand": "$inputBarndtext",
      });
    }
  }

  updateAlluser() {
    if (inputNametext.isNotEmpty) {
      _firestore.collection("AllUsers").document("${widget.uid}").updateData({
        "userName": "$inputNametext",
      });
    }
    if (phonecountry.isNotEmpty) {
      _firestore.collection("AllUsers").document("${widget.uid}").updateData({
        "phone": "$phonecountry",
      }).whenComplete(() {
        print("update phone");
      });
    }
    if (inputBio.isNotEmpty) {
      _firestore.collection("AllUsers").document("${widget.uid}").updateData({
        "bio": "$inputBio",
      }).whenComplete(() {
        print("update bio");
      });
    }

    if (inputBarndtext.isNotEmpty) {
      _firestore.collection("AllUsers").document("${widget.uid}").updateData({
        "userBrand": "$inputBarndtext",
      });
    }
  }

  void _onChange(String value) {
    setState(() {
      inputNametext = value;
    });
  }

  void _onChangeBrand(String valuee) {
    setState(() {
      inputBarndtext = valuee;
    });
  }

  void _onChangeBio(String value) {
    setState(() {
      inputBio = value;
    });
  }

  Future _getProducts() async {
    final userDataQuery = await Firestore.instance
        .collection("${widget.userorAdmin}")
        .document(widget.uid)
        .get();

    return userDataQuery.data;
  }

  // Future onRefresh() async {
  //   await Future.delayed(Duration(microseconds: 200));
  //   setState(() {
  //     _getProducts();
  //   });
  //   return null;
  // }

  bool nameBool = false;
  bool selectSave = false;
  bool bioBool = false;
  Widget _voidTextFBio(context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
      child: Container(
        height: 60,
        color: Colors.white24,
        child: TextField(
            // dragStartBehavior: DragStartBehavior.start,
            autofocus: true,
            cursorWidth: 6.0,
            keyboardType: TextInputType.text,
            cursorRadius: Radius.circular(30),
            cursorColor: Colors.purple,
            // maxLengthEnforced: true,
            maxLength: 60,
            decoration: InputDecoration(
                hintText: '${DemoLocalizations.of(context).bio}',
                icon: IconButton(
                  onPressed: () {
                    setState(() {
                      bioBool = false;
                      selectSave = false;
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
              updProducts();
              updateAlluser();
            })),
      ),
    );
  }

///////////////Widget Input Name //////////
  Widget _voidTextFName(context) {
    return Container(
      child: TextField(
          // dragStartBehavior: DragStartBehavior.start,
          autofocus: true,
          cursorWidth: 6.0,
          keyboardType: TextInputType.text,
          cursorRadius: Radius.circular(30),
          cursorColor: Colors.purple,
          // maxLengthEnforced: true,
          maxLength: 40,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(20),
              labelText: "${DemoLocalizations.of(context).fullname}",
              icon: IconButton(
                onPressed: () {
                  setState(() {
                    nameBool = false;
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
            _onChange(value);
          },
          onSubmitted: ((e) {
            nameBool = false;
            updateAlluser();
            updProducts();
          })),
    );
  }

  bool selectPhoneFiled = false;

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

  String phonecountry = '';
  Widget phoneFiled(context) {
    return Container(
      child: Row(
        textDirection: TextDirection.ltr,
        children: <Widget>[
          Container(width: 80, child: phonecunntry()),
          Container(
            width: 200,
            child: TextField(
                textDirection: TextDirection.ltr,
                autofocus: true,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    labelText: "${DemoLocalizations.of(context).phone}",
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
                },
                onSubmitted: ((e) {
                  selectPhoneFiled = false;
                  updateAlluser();
                  updProducts();
                })),
          ),
        ],
      ),
    );
  }

  bool selectBrandFiled = false;
  bool selecSa = false;
  var statusGrand;

  Widget brandFiled(context) {
    return Container(
      child: TextField(
          // dragStartBehavior: DragStartBehavior.start,
          autofocus: true,
          cursorWidth: 6.0,
          keyboardType: TextInputType.text,
          cursorRadius: Radius.circular(30),
          cursorColor: Colors.purple,
          maxLength: 20,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(20),
              labelText: '${DemoLocalizations.of(context).businessname}',
              icon: IconButton(
                onPressed: () {
                  setState(() {
                    selectBrandFiled = false;
                    selectSave = false;
                  });
                  // print(nameBool);
                },
                icon: Icon(
                  Icons.swap_vertical_circle,
                  color: Colors.black54,
                ),
              )),
          onChanged: (String valuee) {
            _onChangeBrand(valuee);
            print(valuee);
          },
          onSubmitted: ((e) {
            selectBrandFiled = false;
            updateAlluser();
            updProducts();
          })),
    );
  }

///////////////////galery
  // File _imageGal;
  // var imageGal;
  // Future imageGallery() async {
  //   imageGal = await ImagePicker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     _imageGal = imageGal;
  //     print("image Path $imageGal");
  //   });
  // }

  // var imagesUrl;
  // String fileName;
  // Future uplodPic(BuildContext context) async {
  //   var randomno = Random(10);
  //   fileName = basename(_imageGal.path);
  //   StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(
  //       '${widget.uid}/profilesAdmin/${randomno.nextInt(5000).toString()}.jpg');

  //   StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageGal);
  //   StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  //   imagesUrl = await taskSnapshot.ref.getDownloadURL();
  //   setState(() {
  //     Firestore.instance
  //         .collection("AdminUsers")
  //         .document('${widget.uid}')
  //         .updateData({"photoUrl": "$imagesUrl"});
  //     Firestore.instance
  //         .collection("AllUsers")
  //         .document('${widget.uid}')
  //         .updateData({"photoUrl": "$imagesUrl"});

  //     print("Propile picture");
  //     Scaffold.of(context).showSnackBar(SnackBar(
  //       content: Text("Propile picture Uploaded"),
  //     ));
  //   });
  // }

  /////////////////camera
  // File _imageCam;
  // var imageCam;
  // Future imageCamera() async {
  //   imageCam = await ImagePicker.pickImage(
  //     source: ImageSource.camera,
  //   );
  //   setState(() {
  //     _imageCam = imageCam;
  //     print("image Path $imageCam");
  //   });
  // }
  // void snackBar(BuildContext context) {
  //   var snakbar = SnackBar(
  //     content: Text(" Save Your Image? "),
  //     action: SnackBarAction(
  //       label: "SAVE",
  //       onPressed: () {
  //         uplodPic(context);
  //       },
  //     ),
  //   );
  //   Scaffold.of(context).showSnackBar(snakbar);
  // }

  String firebasename = "";
  String firebasenamet = "";
  Future<String> uploadImage() async {
    final FirebaseStorage _store =
        FirebaseStorage(storageBucket: 'gs://danielhaircutnew.appspot.com');
    String filePath =
        "${widget.uid}/${widget.namesStorage}/profile_${DateTime.now()}.png";
    StorageUploadTask _uploadTaskNew;
    print(filePath);

    setState(() {
      _uploadTaskNew = _store.ref().child(filePath).putFile(_image);
    });

    String downloadUrl =
        await (await _uploadTaskNew.onComplete).ref.getDownloadURL();
    Firestore.instance
        .collection("${widget.userorAdmin}")
        .document('${widget.uid}')
        .updateData({"photoUrl": "$downloadUrl"});
    Firestore.instance
        .collection("AllUsers")
        .document('${widget.uid}')
        .updateData({"photoUrl": "$downloadUrl"}).whenComplete(() {
      print(downloadUrl);
    });

    return downloadUrl;
  }

  // bool sanVal = false;
  // bool monVal = false;
  // bool tuVal = false;
  // bool wedVal = false;
  // bool thuVal = false;
  // bool friVal = false;
  // bool satVal = false;
  // final _scaffoldKey = new GlobalKey<ScaffoldState>();
  // VoidCallback _showPersBottomSheetCallBackDays;
  // VoidCallback _closearrow;
  // void _closeContaner() {
  //   setState(() {
  //     _closearrow = null;

  //     print("closse");
  //   });
  //   _scaffoldKey.currentState.showBottomSheet((context) {
  //     return;
  //   });
  // }

  // var name;
  // var nameBrand;
  // var photo;
  // var bio;
  // var address;
  // var phone;
  // var email;
  String statusSize;
  // var statuslocation = 'ישראל';

  _updateGrand(statusSize) {
    _firestore
        .collection("${widget.userorAdmin}")
        .document("${widget.uid}")
        .updateData({
      "statusSize": "$statusSize",
    });
    _firestore
        // .collection(widget.country)
        // .document('${widget.uid}')
        .collection("AllUsers")
        .document("${widget.uid}")
        .updateData({
      "statusSize": "$statusSize",
    });
  }

  // List days = [];
  _updateDays(snapshots, String day) {
    if (snapshots['$day'] == false) {
      setState(() {
        _firestore
            .collection("AdminUsers")
            .document("${widget.uid}")
            .updateData({
          "$day": true,
        }).catchError((e) {
          print(e);
        });
      });
    } else {
      setState(() {
        _firestore
            .collection("AdminUsers")
            .document("${widget.uid}")
            .updateData({
          "$day": false,
        }).catchError((e) {
          print(e);
        });
      });
    }
  }

  showModel(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  setState(() {
                    statusSize = '${DemoLocalizations.of(context).man}';
                    _updateGrand(statusSize);
                    Navigator.of(context).pop();
                  });
                },
                child: Text('${DemoLocalizations.of(context).man}'),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    statusSize = '${DemoLocalizations.of(context).woman}';
                    _updateGrand(statusSize);
                    Navigator.of(context).pop();
                  });
                },
                child: Text('${DemoLocalizations.of(context).woman}'),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    statusSize =
                        '${DemoLocalizations.of(context).prefernottosay}';
                    _updateGrand(statusSize);
                    Navigator.of(context).pop();
                  });
                },
                child: Text('${DemoLocalizations.of(context).prefernottosay}'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var heig = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0.0,
      //   backgroundColor: Colors.white,
      //   leading: IconButton(
      //     onPressed: (){
      //       Navigator.pop(context);
      //     },
      //     icon: Icon(
      //       Icons.arrow_back_ios,
      //       color: Colors.black,
      //     ),
      //   ),
      // ),
      // appBar: Platform.isIOS
      //     ? AppBar(
      //         elevation: 0.0,
      //         backgroundColor: Colors.white,
      //         leading: IconButton(
      //           onPressed: () => Navigator.pop(context),
      //           icon: Icon(
      //             Icons.arrow_back_ios,
      //             color: Colors.black,
      //           ),
      //         ),
      //       )
      //     : PreferredSize(
      //         preferredSize: Size(0, 0),
      //         child: Container(),
      //       ),
      // key: _scaffoldKey,
      body: FutureBuilder(
          future: _getProducts(),
          builder: (BuildContext context, snapshots) {
            if (!snapshots.hasData) {
              return Center(
                child: Text("${DemoLocalizations.of(context).loading}"),
              );
            }
            String statusGshow = '${snapshots.data['statusGrand']}';
            if (statusGshow == 'Barber') {
              statusGshow = "${DemoLocalizations.of(context).barbershop}";
            } else {
              statusGshow = "${DemoLocalizations.of(context).cosmetics}";
            }
            // print(snapshots.data);
            return Container(
              height: heig,
              // color: Colors.black,
              child: ListView(
                children: <Widget>[
                  InkWell(
                    onTap: () => imagePicker.showDialog(context),
                    child: Container(
                      height: 150,
                      // color: Colors.blue,
                      decoration: _image == null
                          ? BoxDecoration(
                              image: snapshots.data['photoUrl'] == null
                                  ? DecorationImage(
                                      image: AssetImage("images/lineder.png"),
                                    )
                                  : DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          "${snapshots.data['photoUrl']}"),
                                      fit: BoxFit.cover))
                          : BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(_image), fit: BoxFit.cover)),
                    ),
                  ),
                  _image != null
                      ? Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blueGrey),
                          child: IconButton(
                            onPressed: () {
                              uploadImage();

                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.save),
                          ),
                        )
                      : Container(),
                  Divider(
                    height: 8.0,
                    color: Colors.black,
                  ),
                  nameBool == false
                      ? ListTile(
                          title: Text(
                            '${DemoLocalizations.of(context).fullname}',
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            "${snapshots.data['userName']}",
                            // maxLines: 1,
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
                  "${widget.userorAdmin}" == 'AdminUsers'
                      ? selectBrandFiled == false
                          ? ListTile(
                              title: Text(
                                '${DemoLocalizations.of(context).businessname}',
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Text(
                                "${snapshots.data['userBrand']}",
                                // maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    selectBrandFiled = true;
                                  });
                                },
                              ),
                            )
                          : brandFiled(context)
                      : Container(),
                  selectPhoneFiled == false
                      ? ListTile(
                          title: Text(
                            '${DemoLocalizations.of(context).phone}',
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            "${snapshots.data['phone']}",
                            // maxLines: 1,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
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
                            '${DemoLocalizations.of(context).bio}',
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            "${snapshots.data['bio']}",
                            // maxLines: 1,
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
                    onTap: () {
                      showModel(context);
                    },
                    title: Text(
                      '${DemoLocalizations.of(context).gender}',
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      "${snapshots.data['statusSize']}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      '${DemoLocalizations.of(context).privateinformation}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "${snapshots.data['userEmail']}",
                    textAlign: TextAlign.center,
                  ),
                  "${widget.userorAdmin}" == 'AdminUsers'
                      ? ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddAdressM(
                                          uid: widget.uid,
                                        )));
                          },
                          title: Text(
                            '${DemoLocalizations.of(context).location}',
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            " ${snapshots.data['address']}",
                            // maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                          trailing: Icon(Icons.location_city),
                        )
                      : Container(),
                  "${widget.userorAdmin}" == 'AdminUsers'
                      ? ExpansionTile(
                          title:
                              Text('${DemoLocalizations.of(context).dayswork}'),
                          children: <Widget>[
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: <Widget>[
                                  RaisedButton.icon(
                                    onPressed: () {
                                      var su = 'su';

                                      _updateDays(snapshots.data, su);
                                    },
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: snapshots.data['su'] == true
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                    label: Text(
                                        '${DemoLocalizations.of(context).su}'),
                                  ),
                                  RaisedButton.icon(
                                    onPressed: () {
                                      var mo = 'mo';

                                      _updateDays(snapshots.data, mo);
                                    },
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: snapshots.data['mo'] == true
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                    label: Text(
                                        '${DemoLocalizations.of(context).mo}'),
                                  ),
                                  RaisedButton.icon(
                                    onPressed: () {
                                      var tu = 'tu';

                                      _updateDays(snapshots.data, tu);
                                    },
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: snapshots.data['tu'] == true
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                    label: Text(
                                        '${DemoLocalizations.of(context).tu}'),
                                  ),
                                  RaisedButton.icon(
                                    onPressed: () {
                                      var we = 'we';

                                      _updateDays(snapshots.data, we);
                                    },
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: snapshots.data['we'] == true
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                    label: Text(
                                        '${DemoLocalizations.of(context).we}'),
                                  ),
                                  RaisedButton.icon(
                                    onPressed: () {
                                      var th = 'th';

                                      _updateDays(snapshots.data, th);
                                    },
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: snapshots.data['th'] == true
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                    label: Text(
                                        '${DemoLocalizations.of(context).th}'),
                                  ),
                                  RaisedButton.icon(
                                    onPressed: () {
                                      var fr = 'fr';

                                      _updateDays(snapshots.data, fr);
                                    },
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: snapshots.data['fr'] == true
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                    label: Text(
                                        '${DemoLocalizations.of(context).fr}'),
                                  ),
                                  RaisedButton.icon(
                                    onPressed: () {
                                      var sa = 'sa';

                                      _updateDays(snapshots.data, sa);
                                    },
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: snapshots.data['sa'] == true
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                    label: Text(
                                        '${DemoLocalizations.of(context).sa}'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  "${widget.userorAdmin}" == 'AdminUsers'
                      ? ExpansionTile(
                          title: Text('${DemoLocalizations.of(context).extra}'),
                          children: <Widget>[
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: <Widget>[
                                  FlatButton.icon(
                                    onPressed: () {
                                      var hairDonation = 'hairDonation';

                                      _updateDays(snapshots.data, hairDonation);
                                    },
                                    icon: Icon(
                                      Icons.check_circle,
                                      color:
                                          snapshots.data['hairDonation'] == true
                                              ? Colors.green
                                              : Colors.black,
                                    ),
                                    label: Text(
                                        '${DemoLocalizations.of(context).hairDonation}'),
                                  ),
                                  FlatButton.icon(
                                    onPressed: () {
                                      var hairWash = 'hairWash';

                                      _updateDays(snapshots.data, hairWash);
                                    },
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: snapshots.data['hairWash'] == true
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                    label: Text(
                                        '${DemoLocalizations.of(context).hairWash}'),
                                  ),
                                  FlatButton.icon(
                                    onPressed: () {
                                      var parking = 'parking';

                                      _updateDays(snapshots.data, parking);
                                    },
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: snapshots.data['parking'] == true
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                    label: Text(
                                        '${DemoLocalizations.of(context).parking}'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  "${widget.userorAdmin}" == 'AdminUsers'
                      ? ListTile(
                          title: Text(
                            "${DemoLocalizations.of(context).typeofbusiness}",
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            " $statusGshow",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                          trailing: Icon(
                            Icons.arrow_drop_down,
                            size: 30,
                          ),
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          String barber = 'Barber';
                                          setState(() {
                                            statusGrand = barber;
                                            // statusGshow =
                                            //     "${DemoLocalizations.of(context).barbershop}";
                                            Firestore.instance
                                                .collection("AdminUsers")
                                                .document(widget.uid)
                                                .updateData({
                                              "statusGrand": "$statusGrand",
                                            }).then((val) {
                                              Navigator.of(context).pop();
                                            });
                                            // _updateGrand(statusGrand);
                                          });
                                        },
                                        child: Text(
                                            "${DemoLocalizations.of(context).barbershop}"),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          String cosmatic = 'Cosmetic';
                                          setState(() {
                                            statusGrand = cosmatic;
                                            Firestore.instance
                                                .collection("AdminUsers")
                                                .document(widget.uid)
                                                .updateData({
                                              "statusGrand": "$statusGrand",
                                            }).then((val) {
                                              Navigator.of(context).pop();
                                            });
                                            // statusGshow =
                                            //     "${DemoLocalizations.of(context).cosmetics}";

                                            // _updateGrand(statusGrand);
                                          });
                                        },
                                        child: Text(
                                            "${DemoLocalizations.of(context).cosmetics}"),
                                      ),
                                    ],
                                  );
                                });
                          },
                        )
                      : Container(),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            );
          }),
    );
  }

  @override
  userImage(File _image) {
    setState(() {
      this._image = _image;
    });
  }
}
