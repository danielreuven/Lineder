import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lineder/helpers/locale.dart';

class ShowDaysRecord extends StatefulWidget {
  final uid;
  final snapshot;

  const ShowDaysRecord({Key key, this.uid, this.snapshot}) : super(key: key);
  @override
  _ShowDaysRecordState createState() => _ShowDaysRecordState();
}

class _ShowDaysRecordState extends State<ShowDaysRecord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[600],
          onPressed: () => Navigator.pop(context),
          mini: true,
          child: Icon(Icons.arrow_back_ios),
          // child: Icon(FontAwesomeIcons.solidFileExcel),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: widget.snapshot['dayswork'].length,
            itemBuilder: (context, index) {
              return Table(
                border: TableBorder.all(width: 1.0, color: Colors.grey),
                defaultColumnWidth: FlexColumnWidth(40.0),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  //daysworkd
                  TableRow(children: [
                    Text(
                      "${widget.snapshot['dayswork'][index]['day']}",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      " ${widget.snapshot['dayswork'][index]['sumprice']}${widget.snapshot['currency']}\n-${widget.snapshot['dayswork'][index]['cancelsumprice'] != null ? widget.snapshot['dayswork'][index]['cancelsumprice'] : ""}",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${widget.snapshot['dayswork'][index]['sumhours']}\n-${widget.snapshot['dayswork'][index]['cancelsumhours'] != null ? widget.snapshot['dayswork'][index]['cancelsumhours'] : ""}",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      " ${DemoLocalizations.of(context).lines} ${widget.snapshot['dayswork'][index]['nameclients'].length}\n${widget.snapshot['dayswork'][index]['cancelnameclients'] != null ? -widget.snapshot['dayswork'][index]['cancelnameclients'].length : ""}",
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.grey[300],
                          onPressed: () {
                            try {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actions: <Widget>[
                                        IconButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          icon: Icon(Icons.check),
                                        )
                                      ],
                                      content: Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: ListView.builder(
                                          itemCount: widget
                                              .snapshot['dayswork'][index]
                                                  ['nameclients']
                                              .length,
                                          itemBuilder: (context, indexx) {
                                            return Card(
                                              elevation: 4.0,
                                              color: Colors.grey[100],
                                              child: Text(
                                                "${widget.snapshot['dayswork'][index]['nameclients'][indexx]}",
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  });
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text(
                            "${DemoLocalizations.of(context).clients}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        RaisedButton(
                          color: Colors.red[100],
                          onPressed: () {
                            try {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actions: <Widget>[
                                        IconButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          icon: Icon(Icons.check),
                                        )
                                      ],
                                      content: ListView.builder(
                                        itemCount: widget.snapshot['dayswork']
                                                        [index]
                                                    ['cancelnameclients'] !=
                                                null
                                            ? widget
                                                .snapshot['dayswork'][index]
                                                    ['cancelnameclients']
                                                .length
                                            : 0,
                                        itemBuilder: (context, indexx) {
                                          return Card(
                                            elevation: 4.0,
                                            color: Colors.grey[100],
                                            child: Text(
                                              "${widget.snapshot['dayswork'][index]['cancelnameclients'][indexx] != null ? widget.snapshot['dayswork'][index]['cancelnameclients'][indexx] : ""}",
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  });
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text(
                            "${DemoLocalizations.of(context).cancel}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    // TableRowInkWell(
                    //   onTap: () {
                    //     try {
                    //       showDialog(
                    //           context: context,
                    //           builder: (context) {
                    //             return AlertDialog(
                    //               actions: <Widget>[
                    //                 IconButton(
                    //                   onPressed: () =>
                    //                       Navigator.of(context).pop(),
                    //                   icon: Icon(Icons.check),
                    //                 )
                    //               ],
                    //               content: ListView.builder(
                    //                 itemCount: widget
                    //                     .snapshot['dayswork'][index]
                    //                         ['nameclients']
                    //                     .length,
                    //                 itemBuilder: (context, indexx) {
                    //                   return Card(
                    //                     elevation: 4.0,
                    //                     color: Colors.grey[100],
                    //                     child: Text(
                    //                       "${widget.snapshot['dayswork'][index]['nameclients'][indexx]}",
                    //                       textAlign: TextAlign.center,
                    //                     ),
                    //                   );
                    //                 },
                    //               ),
                    //             );
                    //           });
                    //     } catch (e) {
                    //       print(e);
                    //     }

                    //     ///show nameclients
                    //   },
                    //   child: Text(" clients"),
                    // ),
                  ]),
                ],
              );
            },
          ),
        ));
  }
}
