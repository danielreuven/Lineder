import 'package:lineder/animation/splashicon.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddKind extends StatefulWidget {
  final uid;

  AddKind({
    this.uid,
  });
  @override
  _AddKindState createState() => _AddKindState();
}

class _AddKindState extends State<AddKind> {
  Future _getProductsFuture;

  @override
  void initState() {
    _getProductsFuture = _getProducts();

    super.initState();
  }

  Future _getProducts() async {
    QuerySnapshot q = await Firestore.instance
        // .collection(widget.country)
        // .document('${widget.uid}')
        // .collection("${widget.statusGrand}")
        // .document(widget.uid)
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("kind")
        .getDocuments();

    return q.documents;
  }

  _delete(productId) {
    Firestore.instance
        // .collection(widget.country)
        // .document('${widget.uid}')
        // .collection("${widget.statusGrand}")
        // .document(widget.uid)
        .collection("AdminUsers")
        .document(widget.uid)
        .collection("kind")
        .document(productId)
        .delete();
  }

  bool stat = false;
  void status() {
    setState(() {
      stat = !stat;
      _getProductsFuture = _getProducts();
      print(stat);
    });
  }

  var lengugte;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
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
          '${DemoLocalizations.of(context).kinds}',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // _showBottomSheet
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FormKinds(
                            uid: widget.uid,
                          )));
            },
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
          )
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
                    return Card(
                      elevation: 4.0,
                      color: Colors.white,
                      child: ListTile(
                        leading: IconButton(
                          onPressed: () {
                            _delete(snapshots.data[index].data['productId']);
                            status();
                          },
                          icon: Icon(Icons.delete),
                        ),
                        title: Text(" ${snapshots.data[index].data['kind']} "),
                        trailing:
                            Text("${snapshots.data[index].data['currency']}"
                                "${snapshots.data[index].data['price']}"),
                        subtitle: Row(
                          children: <Widget>[
                            Icon(Icons.schedule),
                            Text("${snapshots.data[index].data['duration']}  "),
                          ],
                        ),
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

class FormKinds extends StatefulWidget {
  final uid;

  FormKinds({Key key, this.uid}) : super(key: key);

  @override
  _FormKindsState createState() => _FormKindsState();
}

class _FormKindsState extends State<FormKinds> {
  VoidCallback _showPersBottomSheetCallBack;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _showPersBottomSheetCallBack = _showBottomSheet;

    super.initState();
  }

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
                            _formData['currency'] = _currencySymbol;
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
                            _formData['currency'] = _currencySymbol;
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
                            _formData['currency'] = _currencySymbol;
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
                            _formData['currency'] = _currencySymbol;
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

  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'kind': null,
    'duration': null,
    'price': null,
    'currency': null,
  };

  String _currencySymbol = '';

  Widget _textFormKind() {
    return ListTile(
      leading: Icon(Icons.work),
      title: TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: '${DemoLocalizations.of(context).choicekind}',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return '${DemoLocalizations.of(context).choicekind}';
          }
          return null;
        },
        onSaved: (String value) {
          _formData['kind'] = value;
        },
      ),
    );
  }

  List curr = [
    {
      "shekel": "\u20aa",
      "Dollar": "\$",
      "russia": "руб.",
      "englin": "£",
      "eur": "\u20ac"
    }
  ];

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
      title: TextFormField(
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
        validator: (value) {
          if (value.isEmpty) {
            return '${DemoLocalizations.of(context).price}';
          }
          return null;
        },
        onSaved: (String value) {
          _formData['price'] = num.tryParse(value);
        },
      ),
    );
  }

  Widget _textFormDura() {
    return ListTile(
      leading: Icon(Icons.timelapse),
      title: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: '${DemoLocalizations.of(context).duration}',
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
          if (value.isEmpty || value.length > 3) {
            return '${DemoLocalizations.of(context).duration}';
          }
          return null;
        },
        onSaved: (String value) {
          _formData['duration'] = num.tryParse(value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 100,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                _textFormKind(),
                _textFormDura(),
                _textFormPrice(),
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.blueGrey[600],
                  textColor: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      if (_formData['duration'] > 120 ||
                          10 > _formData['duration'] ||
                          _formData['currency'] == null) return;
                      print(_formData['currency']);
                      String productId =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      Firestore.instance
                          .collection("AdminUsers")
                          .document(widget.uid)
                          .collection("kind")
                          .document(productId)
                          .setData({
                        "adminUser": widget.uid,
                        "kind": "${_formData['kind']}",
                        "duration": _formData['duration'],
                        "price": _formData['price'],
                        "currency": _formData['currency'],
                        "productId": "$productId",
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text("שמור פרטים"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
