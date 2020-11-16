import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDialog extends StatelessWidget {
  final String title, description;
  final String image;
  final String phone;
  final user;
  final uid;
  final String namecollection;
  CustomDialog(
      {@required this.title,
      @required this.description,
      this.image,
      this.phone,
      this.user,
      this.uid,
      this.namecollection});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Future _getProductsClients() async {
    QuerySnapshot q = await Firestore.instance
        .collection("$namecollection")
        .document(user)
        .collection("listclient")
        .where("adminUser", isEqualTo: uid)
        .getDocuments();

    return q.documents;
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: Consts.avatarRadius + Consts.padding,
              // bottom: Consts.padding,
              // left: Consts.padding,
              // right: Consts.padding,
            ),
            margin: EdgeInsets.only(top: Consts.avatarRadius),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Consts.padding),
                  topRight: Radius.circular(Consts.padding)),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue,
                  blurRadius: 10,
                  // blurRadius: 200.0,
                  spreadRadius: 30.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [Colors.blueGrey, Colors.grey[200]])),
                      height: 50,
                      child: IconButton(
                        onPressed: () async {
                          var url = "tel:" + phone;

                          if (await canLaunch(url))
                            launch(url);
                          else
                            print("URL can Not be");
                          print('open click');
                        },
                        icon: Icon(
                          Icons.phone,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  description != 'null' ? description : "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // To close the dialog
                    },
                    child: Icon(Icons.check),
                  ),
                ),
                FutureBuilder(
                    future: _getProductsClients(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      return Container(
                        height: MediaQuery.of(context).size.height / 4,
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            final document = snapshot.data[index].data;
                            return ListTile(
                              title: Text(
                                  "${DateFormat('MMMEd', DemoLocalizations.of(context).language).format(document['timentpS'].toDate())}"),
                              subtitle: Text("${document['nameBarber']}"),
                            );
                          },
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: CircleAvatar(
            // backgroundColor: Colors.blueAccent,
            backgroundImage: CachedNetworkImageProvider(
              "${image != null ? image : "https://images.unsplash.com/photo-1548586196-aa5803b77379?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=967&q=80"}",
            ),
            radius: Consts.avatarRadius,
          ),
        ),
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
