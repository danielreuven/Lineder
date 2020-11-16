import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lineder/helpers/locale.dart';

class PaymentsData extends StatefulWidget {
  final uid;
  final snapshots;
  const PaymentsData({Key key, this.uid, this.snapshots}) : super(key: key);
  @override
  _PaymentsDataState createState() => _PaymentsDataState();
}

class _PaymentsDataState extends State<PaymentsData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          "תשלומים",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(
                  "${DemoLocalizations.of(context).changecard}",
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                height: 8,
                color: Colors.black38,
              ),
              ListTile(
                title: Text(
                  "פניות לתשלומים ",
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                height: 8,
                color: Colors.black38,
              ),
              ListTile(
                title: Text(
                  "${DemoLocalizations.of(context).trial}",
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  "${DateFormat('yMd').format(widget.snapshots['stripe_trial_end'].toDate())}",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
