import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripePaymentHandle {

  // getCards() async {
  //   setState(() {
  //     loaded = false;
  //   });
  //   var newpaymentCards = await api.getpaymentCard(user: user.id.toString());
  //   setState(() {
  //     paymentCards = newpaymentCards;
  //   });
  //
  //   Future.delayed(Duration(seconds: 2), () {
  //     setState(() {
  //       loaded = true;
  //     });
  //     if (paymentCards.length > 0) getUserCardTransactions();
  //   });
  // }

}
