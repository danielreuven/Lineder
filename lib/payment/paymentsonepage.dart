import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripePaymentPage extends StatefulWidget {
  final uid;

  const StripePaymentPage({Key key, this.uid}) : super(key: key);
  @override
  _StripePaymentPageState createState() => _StripePaymentPageState();
}

class _StripePaymentPageState extends State<StripePaymentPage> {
  double _amount = 10000.00;

  _showStripeCardInterface() async {
    // String token = await StripeSource.addSource();
    // print(token);
    // await Firestore.instance
    //     .collection("AdminUsers")
    //     .document(widget.uid)
    //     .updateData({
    //   "stripetoken": token,
    // });
    // Save the token to firebase
    // Create a cloud function to charge the user
    Response response = await http.post(
      "https://us-central1-danielhaircutnew.cloudfunctions.net/chargeUser",
      body: {
        "uid": widget.uid,
        "amount": _amount.toString(),
        "number": "4242424242424242",
        "exp_month":"12",
        "exp_year": "2424",
        "cvc":"242"

      },
    );

    print(response.body.toString());

    // We get the repsonse
  }

  @override
  void initState() {
    super.initState();
    StripeSource.setPublishableKey(
        "pk_test_1ir2YEmaw58Xkin6zdT42kaM00kqZVFSqA");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Stripe Payment Demo"),
        ),
        body: Container(
          child: Center(
            child: RaisedButton(
              onPressed: () => _showStripeCardInterface(),
              child: Text("Pay Now"),
            ),
          ),
        ));
  }
}
