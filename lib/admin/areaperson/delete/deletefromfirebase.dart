import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class DeleteUserFromFirebase extends StatefulWidget {
  final uid;

  const DeleteUserFromFirebase({Key key, this.uid}) : super(key: key);
  @override
  _DeleteUserFromFirebaseState createState() => _DeleteUserFromFirebaseState();
}

class _DeleteUserFromFirebaseState extends State<DeleteUserFromFirebase> {
//delete clientss 
// https://us-central1-danielhaircutnew.cloudfunctions.net/deleteClientFirebase
_delete() async {
  Response response = await http.post("https://us-central1-danielhaircutnew.cloudfunctions.net/deleteUserFirebase", body: json.encode({
    "uid": widget.uid
  }),);

  print(response.body.toString());
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              onTap: _delete,
              title: Text("ddddd"),
            )
          ],
        ),
      ),
    );
  }
}
