import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class AddAdressM extends StatefulWidget {
  AddAdressM({
    this.uid,
  });
  final uid;

  @override
  _AddAdressMState createState() => _AddAdressMState();
}

const kGoogleApiKey = "AIzaSyDkPx1dn0md8vpOf13eYnog01-7dsmY78c";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class _AddAdressMState extends State<AddAdressM> {
  // GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  GoogleMapController mapController;
  Geoflutterfire geo = Geoflutterfire();

  String searchAddr;
  var result;
  var firLocation;
  var secLoation;

  void saveLocation() {
    setState(() {
      Firestore.instance
          .collection("AdminUsers")
          .document('${widget.uid}')
          .updateData({
        "address": "${detail.result.formattedAddress}",
        "location": GeoPoint(lat, lng)
      });
      Firestore.instance
          .collection("AllUsers")
          .document('${widget.uid}')
          .updateData({
        "address": "${detail.result.formattedAddress}",
        "location": GeoPoint(lat, lng)
      });

      print("Address Add");
    });
    Navigator.pop(context);
  }

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
      setState(() {});
      // print(p.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("חיפוש כתובת",style: TextStyle(color: Colors.black),),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                Prediction p = await PlacesAutocomplete.show(
                    context: context, apiKey: kGoogleApiKey);

                displayPrediction(p);
              },
              icon: Icon(Icons.search),
            )
          ],
        ),
        body: Container(
            alignment: Alignment.center,
            child: Center(
              child: Column(
                children: <Widget>[
                  Card(
                    child: Text(
                      "${detail != null ? detail.result.formattedAddress : ""}",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  detail != null
                      ? RaisedButton(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: saveLocation,
                          child: Icon(Icons.save),
                        )
                      : Container(),
                ],
              ),
            )
            //  RaisedButton(
            //   onPressed: () async {
            //     // show input autocomplete with selected mode
            //     // then get the Prediction selected
            //     Prediction p = await PlacesAutocomplete.show(
            //         context: context, apiKey: kGoogleApiKey);
            //     displayPrediction(p);
            //   },
            //   child: Text('Find address'),
            // )

            ));
    // return Scaffold(
    //   body: Stack(
    //     children: <Widget>[
    //       GoogleMap(
    //         onMapCreated: onMapCreated,
    //         initialCameraPosition:
    //             CameraPosition(target: LatLng(32.028320, 34.781879), zoom: 10.0),
    //         markers: Set<Marker>.of(markers.values),
    //       ),
    //       Positioned(
    //         top: 30.0,
    //         right: 15.0,
    //         left: 15.0,
    //         child: Column(
    //           children: <Widget>[
    //             Container(
    //               height: 50.0,
    //               width: double.infinity,
    //               decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(10.0),
    //                   color: Colors.white),
    //               child: TextField(
    //                 decoration: InputDecoration(
    //                     hintText: 'Enter Address',
    //                     border: InputBorder.none,
    //                     contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
    //                     suffixIcon: IconButton(
    //                         icon: Icon(Icons.search),
    //                         onPressed: () {
    //                           if (searchAddr.isNotEmpty) {
    //                             searchandNavigate();
    //                             _add();
    //                           } else {
    //                             return;
    //                           }
    //                         },
    //                         iconSize: 30.0)),
    //                 onChanged: (val) {
    //                   setState(() {
    //                     searchAddr = val;
    //                     print(searchAddr);

    //                     // searchandNavigate();
    //                   });
    //                 },
    //               ),
    //             ),
    //             SizedBox(
    //               height: 5.0,
    //             ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.end,
    //               children: <Widget>[
    //                 CircleAvatar(
    //                   minRadius: 35,
    //                   maxRadius: 35,
    //                   backgroundColor: Colors.blue,
    //                   child: FlatButton(
    //                     onPressed: () {
    //                       if (searchAddr.isNotEmpty) {
    //                         saveLocation();
    //                         Navigator.pop(context);
    //                       } else {
    //                         return;
    //                       }
    //                     },
    //                     child: Text(
    //                       "SAVE",
    //                       style: TextStyle(fontSize: 12, color: Colors.white),
    //                       textAlign: TextAlign.center,
    //                     ),
    //                   ),
    //                 ),
    //                 CircleAvatar(
    //                   minRadius: 35,
    //                   maxRadius: 35,
    //                   backgroundColor: Colors.red,
    //                   child: FlatButton(
    //                     onPressed: () {
    //                       if (searchAddr.isNotEmpty) {
    //                         _add();
    //                       } else {
    //                         return;
    //                       }
    //                     },
    //                     child: Text(
    //                       "MARKER",
    //                       style: TextStyle(fontSize: 9, color: Colors.white),
    //                       textAlign: TextAlign.center,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             )

    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  // void _add() {
  //   // var markerIdVal = MyWayToGenerateId();
  //   final MarkerId markerId = MarkerId("value");

  //   // creating a new MARKER
  //   final Marker marker = Marker(
  //     markerId: markerId,
  //     position: LatLng(
  //       firLocation,
  //       secLoation,
  //     ),
  //     infoWindow: InfoWindow(title: "dd", snippet: '*'),
  //     onTap: () {
  //       // _onMarkerTapped(markerId);
  //     },
  //   );

  //   setState(() {
  //     // adding a new marker to map
  //     markers[markerId] = marker;
  //   });
  // }
  // List<Marker> allMarker;
  // var _pinkHue = 350.0;
  // addToList() async {
  //   setState(() {
  //     allMarker.add(Marker(
  //       markerId: MarkerId("value"),
  //       position: LatLng(firLocation, secLoation),
  //       icon: BitmapDescriptor.defaultMarkerWithHue(_pinkHue),

  //     ),);
  //   });
  // }

  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
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
}
