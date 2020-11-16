import 'package:lineder/admin/areaperson/recod/record.dart';
import 'package:lineder/admin/areaperson/schedule.dart';
import 'package:lineder/admin/areaperson/time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PropileImage extends StatefulWidget {
  PropileImage({
    this.uid,
    this.email,
    this.displayName,
    this.productId,
  });
  String uid;
  String email;
  String displayName;
  String productId;
  @override
  _PropileImageState createState() => _PropileImageState();
}

class _PropileImageState extends State<PropileImage> {
  Firestore _firestore = Firestore.instance;
  Future _getProducts() async {
    Query q = _firestore
        .collection("AdminUsers")
        .where("adminUser", isEqualTo: widget.uid);

    QuerySnapshot querySnapshot = await q.getDocuments();
    return querySnapshot.documents;
    // setState(() {
    //   _loadingProducts = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
          future: _getProducts(),
          builder: (BuildContext context, snapshots) {
            if (!snapshots.hasData) {
              return Center(
                child: Text("loading"),
              );
            }

            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (BuildContext context, index) {
                  return Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                              radius: 50,
                              child: ClipOval(
                                child: SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: Image.network(
                                    "${snapshots.data[index].data['image']}",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )),
                          SizedBox(
                            width: 15.0,
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.blueGrey[600],
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RecordAdmin(
                                                      uid: widget.uid,
                                              
                                                    )));
                                      },
                                      icon: Icon(
                                        Icons.recent_actors,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.blueGrey[600],
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ScheduleTime(
                                                      uid: widget.uid,
                                                    )));
                                      },
                                      icon: Icon(
                                        Icons.streetview,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.blueGrey[600],
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => TimeArea(
                                                      uid: widget.uid,
                                                    )));
                                      },
                                      icon: Icon(
                                        Icons.add_alarm,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Flexible(
                                flex: 2,
                                child: Text(
                                  snapshots.data[index].data['userName'] == null
                                      ? "${widget.displayName}"
                                      : "${snapshots.data[index].data['userName']}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue[800],
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
