import 'package:flutter/material.dart';
import 'package:lineder/store/showproduct.dart';
import 'package:lineder/store/storeheart.dart';

class ArticleSearch extends SearchDelegate {
  final uid;
  final List catalog;

  ArticleSearch(this.uid, this.catalog);

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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List _results = [];
    for (int i = 0; i < catalog.length; i++) {
      if (catalog[i].data["catalog"].contains(query)) {
        _results.add(catalog[i]);
      }
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 0.4),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final document = _results[index];
        return InkWell(
          onTap: () {
            try {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ShowProduct(
                      uid: uid,
                      product: document['productId'],
                      uidAdmin: document['ownerId'],
                      imagePost: document['imagePost'],
                      available: document['available'],
                      price: document['price'],
                    );
                  });
            } catch (e) {
              print(e);
            }
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: ((context) => ShowProduct(
            //               uid: widget.uid,
            //               product: document['productId'],
            //               uidAdmin: document['ownerId'],
            //             ))));
          },
          child: GridTile(
            header: StoreHeart(
              uid: uid,
              adminUser: document['ownerId'],
              // snapshots: document['showHeart'],
              productId: document['productId'],
            ),
            footer: AppBar(
              backgroundColor: Colors.black38,
              leading: Text("${document['cur']} ${document['price']}"),
              title: Text(document['catalog']),
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  image: DecorationImage(
                      image: NetworkImage(document['imagePost']),
                      fit: BoxFit.cover)),
            ),
          ),
        );
      },
    );
  }
}
