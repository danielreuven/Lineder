import 'package:flutter/material.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:url_launcher/url_launcher.dart';

class SendMails extends StatefulWidget {
  final uid;

  const SendMails({Key key, this.uid}) : super(key: key);
  @override
  _SendMailsState createState() => _SendMailsState();
}

class _SendMailsState extends State<SendMails> {
  final _bodyController = TextEditingController();
  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
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
        actions: <Widget>[
          IconButton(
            onPressed: () {
              var toMailId = 'linederdr@gmail.com';
              var subs = 'S Business Israel';
              _launchURL(toMailId, subs, _bodyController.text);
            },
            icon: Icon(
              Icons.send,
              color: Colors.blue[600],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            controller: _bodyController,
            maxLines: 6,
            decoration: InputDecoration(
                labelText: "${DemoLocalizations.of(context).tellus}",
                border: OutlineInputBorder()),
          ),
        ),
      ),
    );
  }
}
