import 'package:lineder/helpers/locale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBarbers extends StatefulWidget {
  final uid;

  const AddBarbers({Key key, this.uid}) : super(key: key);
  @override
  _AddBarbersState createState() => _AddBarbersState();
}

class _AddBarbersState extends State<AddBarbers> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  VoidCallback _showPersBottomSheetCallBack;
  final Map<String, dynamic> _formData = {
    'name': null,
    'email': null,
  };

  Future _getProducts() async {
    QuerySnapshot q = await Firestore.instance
        // .collection(widget.country)
        // .document('${widget.uid}')
        // .collection("${widget.statusGrand}")
        // .document(widget.uid)
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("worker")
        .orderBy("timestamp", descending: true)
        .getDocuments();

    return q.documents;
  }

  @override
  void initState() {
    super.initState();
    _showPersBottomSheetCallBack = _showBottomSheet;
    _getProductsFuture = _getProducts();
  }

  Future _getProductsFuture;
  Widget _textFormName() {
    return ListTile(
      leading: Icon(Icons.work),
      title: TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: '${DemoLocalizations.of(context).fullname}',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          // suffixIcon: GestureDetector(
          //   onTap: () {
          //     setState(() {});
          //   },
          //   child: Icon(Icons.timelapse),
          // ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return '${DemoLocalizations.of(context).fullname}';
          }
          return null;
        },
        onSaved: (String value) {
          setState(() {
            _formData['name'] = value;
          });
        },
      ),
    );
  }

  Widget _textFormEmail() {
    return ListTile(
      leading: Icon(Icons.timelapse),
      title: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: '${DemoLocalizations.of(context).email}',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          // suffixIcon: GestureDetector(
          //   onTap: () {
          //     setState(() {});
          //   },
          //   child: Icon(Icons.timelapse),
          // ),
        ),
        validator: (value) {
          if (value.isEmpty ||
              !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
            return '${DemoLocalizations.of(context).emailvalidator}';
          }
          return null;
        },
        onSaved: (String value) {
          setState(() {
            _formData['email'] = value;
          });
        },
      ),
    );
  }

  void _showBottomSheet() {
    setState(() {
      _showPersBottomSheetCallBack = null;
    });

    _scaffoldKey.currentState
        .showBottomSheet((context) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 100,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    _textFormName(),
                    _textFormEmail(),
                    RaisedButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.blueGrey[600],
                      textColor: Colors.white,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          print(_formData['email']);
                          String productId =
                              DateTime.now().millisecondsSinceEpoch.toString();

                          Firestore.instance
                              // .collection(widget.country)
                              // .document('${widget.uid}')
                              // .collection("${widget.statusGrand}")
                              // .document(widget.uid)
                              .collection("AdminUsers")
                              .document(widget.uid)
                              .collection("worker")
                              .document(productId)
                              .setData({
                            "adminUser": widget.uid,
                            "name": "${_formData['name']}",
                            "email": "${_formData['email']}",
                            "productId": "$productId",
                            "timestamp": FieldValue.serverTimestamp(),
                          });
                        }

                        Navigator.of(context).pop();
                      },
                      child: Text("שמור "),
                    ),
                  ],
                ),
              ),
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

  _delete(productId) {
    Firestore.instance
        // .collection(widget.country)
        // .document('${widget.uid}')
        // .collection("${widget.statusGrand}")
        // .document(widget.uid)
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("worker")
        .document(productId)
        .delete();
  }

  bool stat = false;
  void status() {
    setState(() {
      stat = !stat;

      print(stat);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      // floatingActionButton: FloatingActionButton(
      //   // mini: true,
      //   // isExtended: true,
      //   onPressed: _showBottomSheet,
      //   child: Icon(Icons.add_circle_outline),
      // ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${DemoLocalizations.of(context).addworker}',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          FutureBuilder(
              future: _getProductsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return snapshot.data.length < 6
                    ? IconButton(
                        onPressed: _showBottomSheet,
                        icon: Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      )
                    : Container();
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder(
              future: _getProductsFuture,
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return Container();
                }
                return ListView.builder(
                  itemCount: snapshots.data.length,
                  itemBuilder: (_, index) {
                    var document = snapshots.data[index].data;
                    return Card(
                      elevation: 4.0,
                      color: Colors.white,
                      child: ListTile(
                        leading: IconButton(
                          onPressed: () {
                            _delete(document['productId']);
                            status();
                          },
                          icon: Icon(Icons.delete),
                        ),
                        title: Text("${document['name']} "),
                        subtitle: Text("${document['email']}  "),
                        trailing: Text("${index + 1}"),
                      ),
                    );
                  },
                );
              }),
        ),
      ),
    );
  }
}
