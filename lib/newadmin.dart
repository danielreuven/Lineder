import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:lineder/admin/homepage/dcardmodel.dart';
import 'package:lineder/helpers/ensure_visible.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:stripe_payment/stripe_payment.dart';

class NewAdmin extends StatefulWidget {
  String uid;
  String email;
  String displayName;

  String photoUrl;
  final token;
  final platporm;
  final timetoken;
  final country;
  final currentocation;
  final method;
  NewAdmin(
      {this.uid,
      this.email,
      this.displayName,
      this.photoUrl,
      this.token,
      this.platporm,
      this.timetoken,
      this.country,
      this.currentocation,
      this.method});
  @override
  _NewAdminState createState() => _NewAdminState();
}

const kGoogleApiKey = "AIzaSyDkPx1dn0md8vpOf13eYnog01-7dsmY78c";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class _NewAdminState extends State<NewAdmin> {
  final _formKey = GlobalKey<FormState>();

  // Firestore _firestore = Firestore.instance;
  final Map<String, dynamic> _formData = {
    'name': null,
    'brand': null,
    // 'phone': null,
  };

  // var n;
  // String numberValidator(String value) {
  //   if (value == null) {
  //     return null;
  //   }

  //   _formData['phone'] = num.tryParse(value);
  //   if (_formData['phone'] == null) {
  //     return '"$value" is not a valid number';
  //   }
  //   return null;
  // }

  Widget _textFormName() {
    return ListTile(
      leading: const Icon(Icons.person),
      title: new TextFormField(
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          contentPadding: EdgeInsets.all(20),
          hintText: "${DemoLocalizations.of(context).fullname}",
        ),
        validator: (value) {
          if (value.isEmpty) {
            return "${DemoLocalizations.of(context).invalidname}";
          }
          return null;
        },
        onSaved: (String value) {
          setState(() {
            _formData['name'] = value.toLowerCase();
          });
        },
        maxLength: 15,
      ),
    );
  }

  Widget _textFormBrand() {
    return ListTile(
      leading: const Icon(Icons.person),
      title: new TextFormField(
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          contentPadding: EdgeInsets.all(20),
          hintText: "${DemoLocalizations.of(context).businessname}",
        ),
        validator: (value) {
          if (value.isEmpty) {
            return "${DemoLocalizations.of(context).invalidname}";
          }
          return null;
        },
        onSaved: (String value) {
          _formData['brand'] = value.toLowerCase();
        },
        maxLength: 15,
      ),
    );
  }

  String phonecunttry = '+972';
  void _onCountryChange(CountryCode countryCode) {
    phonecunttry = countryCode.toString();
    print(phonecunttry);

    print("New Country selected: " + countryCode.toString());
  }

  Widget phonecunntry() {
    return new CountryCodePicker(
      onChanged: _onCountryChange,
      initialSelection: 'il',
      favorite: ['+972', 'il'],
      showCountryOnly: true,
      showOnlyCountryWhenClosed: false,
      alignLeft: false,
    );
  }

  Widget _textFormPhone() {
    return Row(
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            // height: 50,
            width: 70,
            color: Colors.black12,
            child: phonecunntry()),
        Container(
          width: 200,
          child: new TextFormField(
            textDirection: TextDirection.ltr,
            keyboardType: TextInputType.phone,
            decoration: new InputDecoration(
              contentPadding: EdgeInsets.all(20),
              hintText: "${DemoLocalizations.of(context).phone}",
            ),
            validator: (value) {
              if (value.isEmpty || 8 >= value.length) {
                return "${DemoLocalizations.of(context).invalidnumber}";
              }
              return null;
            },
            onSaved: (String value) {
              _formData['phone'] = phonecunttry + value;
              print(_formData['phone']);
              //  _formData['phone'] = value;
              // numberValidator(value);
            },
            maxLength: 15,
          ),
        ),
      ],
    );
  }

  String statusGrand = '';
  String statusGshow = '';
  String barber = 'Barber';
  String cosmatic = 'Cosmetic';
  String barberShow = 'מספרה';
  String cosmaticShow = 'קוסמטיקה';

  String number = '4242424242424242';
  // int exp_month = 08; //August
  // int exp_year = 19; //2019
  int cvc = 242;

  Future<Map> _createCustomer() async {
    Response response = await http.post(
      "https://us-central1-danielhaircutnew.cloudfunctions.net/createCustomer",
      body: json.encode(
        {
          "uid": widget.uid,
          "number": cardNumber,
          "exp_month": expiryDate.substring(0, 2),
          "exp_year": expiryDate.substring(3),
          "cvc": cvvCode,
          "age": 28
        },
      ),
    );

    print(response.body.toString());
    return json.decode(response.body.toString());
  }

  Future<Map> _subSec(String customer_id) async {
    String plan_id =
        "plan_FeMWufpWDXMSlL"; //ID Dollar plan_FeMWufpWDXMSlL  //test_subscription_monthly
    Response response = await http.post(
      "https://us-central1-danielhaircutnew.cloudfunctions.net/subscribeCustomer",
      body: json.encode(
        {
          "plan_id": plan_id,
          "customer_id": customer_id,
          "trial_period_days": 0,
        },
      ),
    );

    return {
      "id": (json.decode(response.body.toString()))["id"],
      "trial_start": (json.decode(response.body.toString()))["trial_start"],
      "trial_end": (json.decode(response.body.toString()))["trial_end"],
    };
  }

  String cardNumber = '';

  String expiryDate = '';

  String cardHolderName = '';

  String cvvCode = '';

  bool isCvvFocused = false;

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
      print(cardNumber);
      print(expiryDate);
      print(cardHolderName);
      print(cvvCode);
    });
  }

  // bool showbool = false;
  PlacesDetailsResponse detail;
  double lat;
  double lng;
  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      detail = await _places.getDetailsByPlaceId(
        p.placeId,
        language: "he",
      );

      // var placeId = p.placeId;
      lat = detail.result.geometry.location.lat;
      lng = detail.result.geometry.location.lng;

      // var address = await Geocoder.local.findAddressesFromQuery(p.description);

      print(lat);
      print(lng);
      //  print(detail);
      //   print(detail.result);
      //    print(detail.result.adrAddress);
      print(detail.result.formattedAddress);
      setState(() {
        _add();
      });
      // print(p.description);
    }
  }

  Widget _textForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(children: <Widget>[
            _textFormName(),
            _textFormBrand(),
            // _textFormPhone(),
            ListTile(
              title: Text(
                "${DemoLocalizations.of(context).typeofbusiness}",
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                " $statusGshow",
                // maxLines: 1,
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
                              setState(() {
                                statusGrand = barber;
                                statusGshow =
                                    "${DemoLocalizations.of(context).barbershop}";

                                // _updateGrand(statusGrand);
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text(
                                "${DemoLocalizations.of(context).barbershop}"),
                          ),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                statusGrand = cosmatic;
                                statusGshow =
                                    "${DemoLocalizations.of(context).cosmetics}";
                                // _updateGrand(statusGrand);
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text(
                                "${DemoLocalizations.of(context).cosmetics}"),
                          ),
                        ],
                      );
                    });
              },
            ),
            Divider(
              height: 5.0,
              color: Colors.grey,
            ),
            ListTile(
              leading: const Icon(Icons.my_location),
              title: Text(
                detail != null
                    ? "${detail.result.formattedAddress}"
                    : "${DemoLocalizations.of(context).addlocation}",
                textAlign: TextAlign.center,
              ),
            ),

            _maps(),

            Divider(
              height: 25.0,
              color: Colors.grey,
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blueGrey, Colors.grey[100]])),
              child: ListTile(
                trailing: Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                ),
                title: Text(
                  "${DemoLocalizations.of(context).betaversion}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                // subtitle: Column(
                //   children: <Widget>[
                //     Text("כדי להמשיך הכנס/י פרטי תשלום"),
                //     Text("השירות ניתן לביטול")
                //   ],
                // ),
                // onTap: () {
                //   showDialog(
                //       context: context,
                //       builder: (context) {
                //         return Scaffold(
                //           body: SafeArea(
                //             child: Column(
                //               children: <Widget>[
                //                 CreditCardWidget(
                //                   cardNumber: cardNumber,
                //                   expiryDate: expiryDate,
                //                   cardHolderName: cardHolderName,
                //                   cvvCode: cvvCode,
                //                   showBackView: isCvvFocused,
                //                 ),
                //                 Expanded(
                //                   child: SingleChildScrollView(
                //                     child: CreditCardForm(
                //                       onCreditCardModelChange:
                //                           onCreditCardModelChange,
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         );
                //       });
                //   // Navigator.push(
                //   //     context,
                //   //     MaterialPageRoute(
                //   //         builder: (context) => AddCreditCardForCustomer(
                //   //               uid: widget.uid,
                //   //               // statusGrand: statusGrand,
                //   //               // country: widget.country,
                //   //             )));
                //   // _createCustomer();
                //   // _getTokenPayments();
                // },
              ),
            ),
            RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.blueGrey[600],
              textColor: Colors.white,
              onPressed: () async {
                if (_formKey.currentState.validate() &&
                    detail != null &&
                    statusGrand.isNotEmpty) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  _formKey.currentState.save();
                  var productId =
                      DateTime.now().millisecondsSinceEpoch.toString();

                  // Map customermap = await _createCustomer();
                  // Map response = await _subSec(customermap["customer_id"]);

                  await Firestore.instance
                      .collection("AdminUsers")
                      .document('${widget.uid}')
                      .setData({
                    // "stripe_subscription_id": response["id"],
                    // "stripe_source_id": customermap["source_id"],
                    // "stripe_customer_id": customermap["customer_id"],
                    // "stripe_trial_start": DateTime.fromMillisecondsSinceEpoch(
                    //     (response["trial_start"] * 1000)),
                    // "stripe_trial_end": DateTime.fromMillisecondsSinceEpoch(
                    //     (response["trial_end"] * 1000)),
                    "user": "${widget.uid}",
                    "adminUser": "${widget.uid}",
                    "productId": "$productId",
                    "userName": "${_formData['name']}",
                    "userEmail": "${widget.email}",
                    "phone": phoneNo,
                    // "phone": "${_formData['phone']}",
                    "userBrand": _formData['brand'],
                    "image": widget.photoUrl,
                    "photoUrl": widget.photoUrl,
                    "followers": {},
                    "request": {},
                    "freinds": {},
                    "reviews": {},
                    "bio": "",
                    "address": "${detail.result.formattedAddress}",
                    "location": GeoPoint(lat, lng),
                    "reviewsAvarge": 0,
                    "reviewsAvargeCnt": 0,
                    "reviewsresult": 0,
                    "su": false,
                    "mo": false,
                    "tu": false,
                    "we": false,
                    "th": false,
                    "fr": false,
                    "sa": false,
                    "parking": false,
                    "hairDonation": false,
                    "hairWash": false,
                    "token": widget.token,
                    "stripetoken": token,
                    "statusGrand": "$statusGrand",
                    "statusSize": " ",
                    "available": "available",
                    "method": widget.method,
                  });
                  await Firestore.instance
                      .collection("AllUsers")
                      .document(widget.uid)
                      .setData({
                    "user": widget.uid,
                    "userName": _formData['name'],
                    "userEmail": widget.email,
                    "phone": phoneNo,
                    // "phone": _formData['phone'],
                    "photoUrl": widget.photoUrl,
                    "bio": "",
                    "address": "$searchA",
                    "statusSize":
                        "${DemoLocalizations.of(context).prefernottosay}",
                    "method": widget.method,
                  });
                  // await Firestore.instance
                  //     .collection("AllUsers")
                  //     .document(widget.uid)
                  //     .setData({
                  //   "user": "${widget.uid}",
                  //   // "productId": "$productId",
                  //   "userName": "${_formData['name']}",
                  //   "userEmail": "${widget.email}",
                  //   "phone": "${_formData['phone']}",
                  //   "userBrand": _formData['brand'],
                  //   "image": widget.photoUrl,
                  //   "photoUrl": widget.photoUrl,
                  //   "bio": "",
                  //   "address": "$searchA",
                  //   "location": GeoPoint(firLocation, secLoation),
                  //   "statusSize":
                  //       "${DemoLocalizations.of(context).prefernottosay}",
                  //   "available": "available",
                  //   "method": widget.method,
                  // });
                  await Firestore.instance
                      .collection("AdminUsers")
                      .document('${widget.uid}')
                      .collection("worker")
                      .document(widget.uid)
                      .setData({
                    "name": "${_formData['name']}",
                    'email': "${widget.email}",
                    "timestamp": FieldValue.serverTimestamp(),
                  });

                  ///
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeAdminTabs(
                                uid: widget.uid,
                              )));
                } else {
                  print("no data");
                }
              },
              child: Text("${DemoLocalizations.of(context).saved}"),
            ),

            SizedBox(
              height: 15.0,
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 20),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(10),
            //     child: Container(
            //       height: 35,
            //       width: 240,
            //       color: Colors.grey[200],
            //       child: Text(
            //         searchA != null && firLocation != null
            //             ? "$searchA"
            //             : "Please add location",
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //   ),
            // ),
          ]),
        ),
      ),
    );
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  void _add() {
    final MarkerId markerId = MarkerId("value");

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, lng),
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  Widget _maps() {
    return Stack(
      children: <Widget>[
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width - 50,
          child: GoogleMap(
            // myLocationEnabled: true,
            markers: Set<Marker>.of(markers.values),
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
                target: detail == null
                    ? widget.currentocation != null
                        ? LatLng(widget.currentocation.latitude,
                            widget.currentocation.longitude)
                        : LatLng(32.028320, 34.781879)
                    : LatLng(lat, lng),
                zoom: 10.0),
          ),
        ),
        Positioned(
          top: 7.0,
          right: 15.0,
          left: 15.0,
          child: Column(
            children: <Widget>[
              Container(
                height: 40.0,
                width: double.maxFinite,
                // width: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: FlatButton.icon(
                  label: Text(
                    "${DemoLocalizations.of(context).searchaddress}",
                    textAlign: TextAlign.center,
                  ),
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    Prediction p = await PlacesAutocomplete.show(
                        context: context, apiKey: kGoogleApiKey);
                    displayPrediction(p);
                    // showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return
                    //     });
                  },
                ),
                // child: TextField(
                //   decoration: InputDecoration(
                //       hintText: '  חפש כתובת  ',
                //       border: InputBorder.none,
                //       contentPadding: EdgeInsets.only(left: 15.0, top: 10.0),
                //       suffixIcon: IconButton(
                //           icon: Icon(Icons.search),
                //           onPressed: () {
                //             // if (searchA.isNotEmpty) {
                //             //   searchandNavigate();
                //             // } else {
                //             //   return;
                //             // }
                //           },
                //           iconSize: 30.0)),
                //   onChanged: (val) {
                //     setState(() {
                //       searchA = val;
                //       print(searchA);

                //       searchandNavigate();
                //     });
                //   },
                // ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[],
              )
            ],
          ),
        ),
      ],
    );
  }

  GoogleMapController mapController;

  String searchA;
  var result;
  var firLocation;
  var secLoation;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  FocusNode myFocusNode;
  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchA).then((result) {
      print(result[0].position.latitude);
      print(result[0].position.longitude);
      firLocation = result[0].position.latitude;
      secLoation = result[0].position.longitude;

      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 18.0)));
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.uid);
    myFocusNode = FocusNode();
    StripeSource.setPublishableKey(
        "pk_test_1ir2YEmaw58Xkin6zdT42kaM00kqZVFSqA");
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  String token;

  // _getTokenPayments() async {
  //   token = await StripeSource.addSource();

  //   print(token);
  // }
  // final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user)async {
  //   print('verified');
  // };
  String phoneNo;
  String smsCode;
  String verificationId;
  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('Signed in');
      });
    };

    final PhoneVerificationCompleted verifiedSuccess = (var user) {
      print('verified');
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 3),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("${DemoLocalizations.of(context).entercode}"),
            content: TextField(
              textDirection: TextDirection.ltr,
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  signIn();
                  // FirebaseAuth.instance.currentUser().then((user) {
                  //   if (user != null) {
                  //     print("user!=null");

                  //     // Navigator.of(context).pushReplacementNamed('/homepage');
                  //   } else {
                  //     Navigator.of(context).pop();
                  //     print("sign inn phone");
                  //   }
                  // });
                },
              )
            ],
          );
        });
  }

  void showInSnack(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  bool phoneOk = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  signIn() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    FirebaseUser user =
        await _auth.signInWithCredential(credential).then((userr) async {
      // final FirebaseUser currentUser = await _auth.currentUser();
      // if (PhoneAuthProvider.providerId == currentUser.uid) {
      //   print(currentUser.uid);
      //   print(userr.uid);
      //   showInSnack("${DemoLocalizations.of(context).invalidcode}");
      // } else {
      setState(() {
        phoneOk = true;
      });
      print("Yes sign in Ok");
      // }
    }).catchError((e) {
      showInSnack("${DemoLocalizations.of(context).invalidcode}");
      print(e);
    });
    //     .then((user) {
    //   Navigator.of(context).pushReplacementNamed('/homepage');
    // }).catchError((e) {
    //   print(e);
    // });
  }

  _phoneverfy() {
    return Container(
        padding: EdgeInsets.all(25.0),
        // height: 30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              textDirection: TextDirection.ltr,
              decoration: new InputDecoration(
                labelText: '${DemoLocalizations.of(context).phone}',
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              onChanged: (value) {
                this.phoneNo = value;
              },
              // validator: (val) {
              //   if (val.length < 8) {
              //     return 'Invalid Phone';
              //   } else {
              //     return null;
              //   }
              // },
              keyboardType: TextInputType.phone,
            ),
            // TextField(
            //   textDirection: TextDirection.ltr,
            //   decoration: InputDecoration(hintText: 'Enter Phone number'),
            //   onChanged: (value) {
            //     this.phoneNo = value;
            //   },
            // ),
            SizedBox(height: 10.0),
            RaisedButton(
                onPressed: verifyPhone,
                child: Text('${DemoLocalizations.of(context).accept}'),
                textColor: Colors.white,
                elevation: 7.0,
                color: Colors.blue)
          ],
        ));
  }

  // FirebaseUser _previousUser;
  // FirebaseUser _currentUser;
  // void _deletePreviousUser() async {
  //   if (_previousUser != null) {
  //     await _previousUser.delete();
  //     final latestUser = await _auth.currentUser();
  //     setState(() {
  //       _previousUser = _currentUser;
  //       _currentUser = latestUser;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text("${DemoLocalizations.of(context).onemoment}"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.blueGrey, Colors.grey[300]])),
        ),
      ),
      body: EnsureVisibleWhenFocused(
        focusNode: myFocusNode,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: phoneOk == false
                ? _phoneverfy()
                : Container(
                    // height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: <Widget>[
                        _textForm(),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
