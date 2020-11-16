import 'package:flutter/material.dart';
import 'package:lineder/loginpage/loginpagee.dart';

class RegulationApp extends StatelessWidget {
  final pres;

  const RegulationApp({Key key, this.pres}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.green[200], Colors.blue[300]])),
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text.rich(
                TextSpan(
                    text: "תקנון",
                    style:
                        TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 50,
              ),
              FlatButton(
                onPressed: () {}, //Link to regulation
                child: Text(
                  "הנך מאשר/ת את תקנון אפליקציה\nכרגע בגרסת בדיקה אין אחריות על נתונים שנמחקים\nהאחריות על המשתמש בלבד",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              InkWell(
                onTap: () {
                  pres.setBool('seen', true);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Text(
                    "מאשר/ת ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              // RaisedButton(
              //   textColor: Colors.black,
              //   color: Colors.grey[100],
              //   padding: EdgeInsets.only(left: 100, right: 100),
              //   onPressed: () =>
              //       Navigator.popAndPushNamed(context, '/loginpagee'),
              //   child: Text(
              //     "אישור",
              //     textAlign: TextAlign.center,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
