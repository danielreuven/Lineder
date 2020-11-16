import 'package:lineder/helpers/locale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestClinets extends StatefulWidget {
  final uid;

  const RequestClinets({Key key, this.uid}) : super(key: key);
  @override
  _RequestClinetsState createState() => _RequestClinetsState();
}

class _RequestClinetsState extends State<RequestClinets> {
  Firestore _firestore = Firestore.instance;
  // Future _getListUser() async {
  //   Query q = _firestore
  //       .collection("CustomerUsers")
  //       .document(widget.uid)
  //       .collection("AdminClientsRequst");

  //   QuerySnapshot querySnapshot = await q.getDocuments();
  //   return querySnapshot.documents;
  // }

  Future _getUserData(userAdmin) async {
    final userDataQuery = await Firestore.instance
        .collection("AdminUsers")
        .document(userAdmin)
        .get();

    return userDataQuery.data;
  }

  var statusGrand;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${DemoLocalizations.of(context).requestclients}',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection("CustomerUsers")
              .document(widget.uid)
              .collection("AdminClientsRequst")
              .snapshots(),
          builder: (context, snapshots) {
            if (!snapshots.hasData) {
              return Container();
            }
            return ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                    height: 5.0,
                  ),
              itemCount: snapshots.data.documents.length,
              itemBuilder: (_, index) {
                return FutureBuilder(
                    future: _getUserData(
                        snapshots.data.documents[index].data['adminSuser']),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      if (snapshot.data['statusGrand'] == 'Cosmetic') {
                        statusGrand =
                            '${DemoLocalizations.of(context).cosmetics}';
                      } else {
                        statusGrand =
                            '${DemoLocalizations.of(context).barbershop}';
                      }
                      return Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.grey, Colors.white70])),
                        child: ListTile(
                          title: Text("${snapshot.data['userBrand']}"),
                          subtitle: Text("$statusGrand"),
                        ),
                      );
                    });
              },
            );
          }),
    );
  }
}
