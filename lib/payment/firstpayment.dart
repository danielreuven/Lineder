// import 'package:appsnew/payment/servies/serviespayment.dart';
// import 'package:flutter/material.dart';
// import 'package:stripe_payment/stripe_payment.dart';

// class FirstPayment extends StatefulWidget {
//   String uid;
//   String email;
//   String displayName;
//   String productId;

//   FirstPayment({this.uid, this.email, this.displayName, this.productId});
//   @override
//   _FirstPaymentState createState() => _FirstPaymentState();
// }

// class _FirstPaymentState extends State<FirstPayment> {
//   @override
//   void initState() {
//     super.initState();

//     StripeSource.setPublishableKey(
//         "pk_test_ev98t1s8bn1B5iF99wSOHX3o00ejjHVK1u");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Payment"),
//       ),
//       body: Container(
//         color: Colors.blueAccent,
//         child: Column(
//           children: <Widget>[
//             Center(
//               child: RaisedButton(
//                 onPressed: () {
//                   StripeSource.addSource().then((token) {
//                     PaymentService().addCard(token);
//                   });
//                 },
//                 child: Text("Card"),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
