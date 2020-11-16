import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class AddCreditCardForCustomer extends StatefulWidget {
  final uid;
  final data5;
  final addcard;
  const AddCreditCardForCustomer({Key key, this.uid, this.data5, this.addcard})
      : super(key: key);
  @override
  _AddCreditCardForCustomerState createState() =>
      _AddCreditCardForCustomerState();
}

class _AddCreditCardForCustomerState extends State<AddCreditCardForCustomer> {
  String cardNumber = '';

  String expiryDate = '';

  String cardHolderName = '';

  String cvvCode = '';

  bool isCvvFocused = false;

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
      print(cardNumber);
      print(expiryDate);
      print(cardHolderName);
      print(cvvCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            widget.addcard == "addcard"
                ? Card(
                    color: Colors.blue[600],
                    child: Text(
                      "המערכת זיהתה אשראי לא תקין, הכנס אשראי תקין ",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  )
                : Container(),
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: CreditCardForm(
                  onCreditCardModelChange: onCreditCardModelChange,
                  addcard:widget.addcard,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
