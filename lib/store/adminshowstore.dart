import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lineder/animation/loadingscircular.dart';
import 'package:lineder/animation/splashicon.dart';
import 'package:lineder/helpers/ensure_visible.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:lineder/store/showproduct.dart';

class AdminShowStore extends StatefulWidget {
  final uid;

  const AdminShowStore({Key key, this.uid}) : super(key: key);
  @override
  _AdminShowStoreState createState() => _AdminShowStoreState();
}

class _AdminShowStoreState extends State<AdminShowStore> {
  Future _getstore() async {
    Query q = Firestore.instance
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("store");

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("החנות שלי"),
      // ),
      body: SingleChildScrollView(
        // scrollDirection: Axis.vertical,
        child: FutureBuilder(
            future: _getstore(),
            builder: (context, snapshots) {
              if (!snapshots.hasData) {
                return Container();
              }
              return Container(
                height: MediaQuery.of(context).size.height + 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      textDirection: TextDirection.rtl,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${DemoLocalizations.of(context).mystore}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    snapshots.data.length < 10
                        ? RaisedButton(
                            color: Colors.lightBlue[200],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.only(left: 100, right: 100),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdminStoreAddProduct(
                                            uid: widget.uid,
                                            language:
                                                '${DemoLocalizations.of(context).language}',
                                          )));
                            },
                            child: Text("הוסף מוצר"),
                          )
                        : Container(),
                    Expanded(
                      child: GridView.builder(
                        // padding: EdgeInsets.all(5.0),
                        itemCount: snapshots.data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, crossAxisSpacing: 0.8),
                        itemBuilder: (context, index) {
                          var document = snapshots.data[index];
                          var heroTag = document['imagePost'];
                          return GestureDetector(
                            onTap: () {
                              try {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ShowProduct(
                                          uid: widget.uid,
                                          product: document['productId'],
                                          uidAdmin: widget.uid,
                                          imagePost: document['imagePost'],
                                          available: document['available'],
                                          price: document['price'],
                                          heroTag: heroTag);
                                    });
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         ));
                              } catch (e) {
                                print(e);
                              }
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: ((context) => ShowProduct(
                              //               uid: widget.uid,
                              //               product: document['productId'],
                              //               uidAdmin: widget.uid,
                              //               imagePost: document['imagePost'],
                              //               available: document['available'],
                              //               price: document['price'],
                              //             ))));
                            },
                            child: GridTile(
                              footer: AppBar(
                                backgroundColor: Colors.black38,
                                leading: Text(
                                    "${document['cur']} ${document['price']}"),
                                title: Text(document['catalog']),
                              ),
                              child: Hero(
                                tag: heroTag,
                                child: Container(
                                  // decoration: BoxDecoration(
                                  //     image: DecorationImage(
                                  //         image: CachedNetworkImageProvider(
                                  //             document['imagePost']),
                                  //         fit: BoxFit.cover)),
                                  child: CachedNetworkImage(
                                    imageUrl: heroTag,
                                    // placeholder: (context, url) =>
                                    //     CircularProgressIndicator(strokeWidth: 1.0,),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

String aaa = 'Catalog';

class ArticleSearch extends SearchDelegate {
  final uid;
  final String language;
  ArticleSearch(this.uid, this.language);
  List<String> catalogen = ['wax', 'lotion', 'cream', 'nail', 'eyes'];
  List<String> cataloghe = ['ווקס', 'קרם', 'לק', 'ריסים'];
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
    List<String> _results = [];
    if (language == 'he') {
      for (int i = 0; i < cataloghe.length; i++) {
        if (cataloghe[i].contains(query)) {
          _results.add(cataloghe[i]);
        }
      }
    } else {
      for (int i = 0; i < catalogen.length; i++) {
        if (catalogen[i].contains(query)) {
          _results.add(catalogen[i]);
        }
      }
    }

    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final doc = _results[index];
        return Card(
          color: Colors.lightBlue[200],
          child: ListTile(
            onTap: () {
              Navigator.pop(context);
              aaa = _results[index];
            },
            title: Text(
              doc,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> _results = [];
    if (language == 'he') {
      for (int i = 0; i < cataloghe.length; i++) {
        if (cataloghe[i].contains(query)) {
          _results.add(cataloghe[i]);
        }
      }
    } else {
      for (int i = 0; i < catalogen.length; i++) {
        if (catalogen[i].contains(query)) {
          _results.add(catalogen[i]);
        }
      }
    }
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final doc = _results[index];
        return Card(
          color: Colors.lightBlue[200],
          child: ListTile(
            onTap: () {
              Navigator.pop(context);
              aaa = _results[index];
            },
            title: Text(
              doc,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

class AdminStoreAddProduct extends StatefulWidget {
  final uid;
  final language;

  const AdminStoreAddProduct({Key key, this.uid, this.language})
      : super(key: key);
  @override
  _AdminStoreAddProductState createState() => _AdminStoreAddProductState();
}

class _AdminStoreAddProductState extends State<AdminStoreAddProduct> {
  String valueCur = '';
  int _n = 0;
  _chooceCu(cur) {
    if (cur != null) {
      setState(() {
        valueCur = cur;
      });
    }
  }

  void add() {
    setState(() {
      if (_n != 50) _n++;
    });
  }

  void minus() {
    setState(() {
      if (_n != 0) _n--;
    });
  }

  Widget sizeH(numb) {
    return SizedBox(
      height: numb,
    );
  }

  var downloadUrl;
  bool dowonlbool = false;
  Future<String> uploadImage(var imageFile) async {
    var productId =
        DateTime.now().millisecondsSinceEpoch.toString() + widget.uid;
    final FirebaseStorage _store =
        FirebaseStorage(storageBucket: 'gs://danielhaircutnew.appspot.com');
    String filePath =
        "${widget.uid}/productAdmin/product_${DateTime.now()}.png";
    StorageUploadTask _uploadTaskNew;

    setState(() {
      _uploadTaskNew = _store.ref().child(filePath).putFile(imageFile);
    });
    downloadUrl = await (await _uploadTaskNew.onComplete).ref.getDownloadURL();
    _uploadTaskNew.onComplete.then((s) {
      Firestore.instance
          .collection("AdminUsers")
          .document(widget.uid)
          .collection("store")
          .document(productId)
          .setData({
        "ownerId": widget.uid,
        "productId": productId,
        "description": valueDesc,
        "price": valuePrice,
        "cur": valueCur,
        "available": _n,
        "catalog": "$aaa",
        "imagePost": downloadUrl,
        "addCard": {},
        "showHeart": {},
        "timestamp": FieldValue.serverTimestamp(),
      }).then((onValue) {
        Navigator.pop(context);
      });

      // setState(() {
      //   dowonlbool = true;
      // });
    });
    return downloadUrl;
  }

  File file;
  Widget contacameraorg() {
    return Scaffold(
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
                      showscaff = false;
                      // file != null ? uploadImage(file) : Container();
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
                      showscaff = false;
                      // file != null ? uploadImage(file) : Container();
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
    );
  }

  Color bluel = Colors.lightBlue[200];
  // List nameimage = ['Profile', 'Font', 'Back'];
  bool showscaff = true;
  bool loadingbool = false;
  int valuePrice = 0;
  String valueDesc = '';
  String _currencySymbol = '';
  void _showBottomSheet() {
    setState(() {
      _showPersBottomSheetCallBack = null;
    });

    _scaffoldKey.currentState
        .showBottomSheet((context) {
          return Container(
            height: 200,
            color: Colors.cyan,
            child: ListView(
              children: <Widget>[
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            _currencySymbol = '\$';
                            _chooceCu(_currencySymbol);
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Dollar \$'),
                      ),
                      RaisedButton(
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            _currencySymbol = '\u20ac';
                            _chooceCu(_currencySymbol);
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Euro \u20ac'),
                      ),
                      RaisedButton(
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            _currencySymbol = '£';
                            _chooceCu(_currencySymbol);
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Pound £'),
                      ),
                      RaisedButton(
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            _currencySymbol = '\u20aa';

                            _chooceCu(_currencySymbol);
                          });
                          Navigator.pop(context);
                        },
                        child: Text('שקל \u20aa'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showPersBottomSheetCallBack = _showBottomSheet;
            });
          }
        });
  }

  VoidCallback _showPersBottomSheetCallBack;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget _textFormPrice() {
    // _currencySymbol = '${DemoLocalizations.of(context).choice}';
    return ListTile(
      leading: InkWell(
          onTap: _showBottomSheet,
          child: PuleAnimation(
              child: Text(
            "${_currencySymbol.isEmpty ? DemoLocalizations.of(context).choice : _currencySymbol}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ))),
      title: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: '${DemoLocalizations.of(context).price}',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          // suffixIcon: GestureDetector(
          //   onTap: () {
          //     setState(() {});
          //   },
          //   child: Icon(Icons.timelapse),
          // ),
        ),
        onChanged: (String value) {
          if (value == null) {
            return null;
          }
          final n = num.tryParse(value);

          valuePrice = n;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EnsureVisibleWhenFocused(
      focusNode: FocusNode(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: showscaff == true
            ? contacameraorg()
            : Scaffold(
                key: _scaffoldKey,
                body: SingleChildScrollView(
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Card(
                            color: bluel,
                            child: ListTile(
                              trailing: Icon(Icons.search),
                              onTap: () {
                                showSearch(
                                  context: context,
                                  delegate: ArticleSearch(widget.uid,
                                      '${DemoLocalizations.of(context).language}'),
                                );
                              },
                              title: Text(
                                '$aaa',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          _textFormPrice(),
                          // InkWell(
                          //   onTap: _showBottomSheet,
                          //   child: PuleAnimation(
                          //       child: Text(
                          //     "${_currencySymbol.isEmpty ? DemoLocalizations.of(context).choice : _currencySymbol}",
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.bold, fontSize: 20),
                          //   )),
                          // ),

                          SizedBox(
                            height: 8.0,
                          ),
                          // Divider(
                          //   height: 8.0,
                          //   color: Colors.grey,
                          // ),
                          TextField(
                            textDirection:
                                '${DemoLocalizations.of(context).language}' ==
                                        'he'
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                                hintText:
                                    '${DemoLocalizations.of(context).description}'),
                            onChanged: (value) {
                              valueDesc = value;
                            },
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new IconButton(
                                onPressed: add,
                                icon: new Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                                color: Colors.white,
                              ),
                              new Text(
                                '$_n\n${DemoLocalizations.of(context).available}',
                                style: new TextStyle(fontSize: 20.0),
                                textAlign: TextAlign.center,
                              ),
                              IconButton(
                                onPressed: minus,
                                icon: new Icon(
                                    const IconData(0xe15b,
                                        fontFamily: 'MaterialIcons'),
                                    color: Colors.black),
                                color: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            textDirection: TextDirection.ltr,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                decoration: file != null
                                    ? BoxDecoration(
                                        image: DecorationImage(
                                            image: FileImage(file),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(10))
                                    : BoxDecoration(
                                        color: bluel,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                height: MediaQuery.of(context).size.height / 2,
                                width: MediaQuery.of(context).size.width / 2,
                              ),
                              loadingbool == false
                                  ? RaisedButton(
                                      color: bluel,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                              color: Colors.blue[800])),
                                      padding: EdgeInsets.all(40),
                                      onPressed: () {
                                        if (aaa != 'Catalog' &&
                                            valuePrice > 10 &&
                                            valueDesc.isNotEmpty &&
                                            valueCur.isNotEmpty &&
                                            _n != 0 &&
                                            file != null) {
                                          uploadImage(file);
                                          setState(() {
                                            loadingbool = true;
                                          });
                                        }
                                      },
                                      child: Text(
                                          "${DemoLocalizations.of(context).saved}"),
                                    )
                                  : ColorLoader3(),
                            ],
                          ),
                          // Container(
                          //   height: 150,
                          //   child: ListView.separated(
                          //     separatorBuilder: (context, index) => SizedBox(
                          //           width: 5.0,
                          //         ),
                          //     addSemanticIndexes: true,
                          //     scrollDirection: Axis.horizontal,
                          //     padding: EdgeInsets.all(12),
                          //     itemCount: 1,
                          //     itemBuilder: (context, index) {
                          //       return Container(
                          //         decoration: file != null
                          //             ? BoxDecoration(
                          //                 image: DecorationImage(
                          //                     image: FileImage(file),
                          //                     fit: BoxFit.cover),
                          //                 borderRadius:
                          //                     BorderRadius.circular(10))
                          //             : BoxDecoration(
                          //                 color: bluel,
                          //                 borderRadius:
                          //                     BorderRadius.circular(10)),
                          //         height: 150,
                          //         width: 100,
                          //         // child: Column(
                          //         //   children: <Widget>[
                          //         //     Text(nameimage[index]),
                          //         //     IconButton(
                          //         //       onPressed: () {
                          //         //         setState(() {
                          //         //           showscaff = true;
                          //         //         });
                          //         //         // try {
                          //         //         //   showDialog(
                          //         //         //       context: context,
                          //         //         //       builder: (context) {
                          //         //         //         return contacameraorg();
                          //         //         //       });
                          //         //         // } catch (e) {
                          //         //         //   print(e);
                          //         //         // }
                          //         //       },
                          //         //       icon: Icon(Icons.add_a_photo),
                          //         //     )
                          //         //   ],
                          //         // ),
                          //       );
                          //     },
                          //   ),
                          // ),
                        ],
                      )),
                ),
              ),
      ),
    );
  }
}
