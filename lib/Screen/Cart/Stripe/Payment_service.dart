/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  final int amount;
  final String url;

  PaymentService(
      {required this.amount,
      this.url =
          'https://us-central1-ichiani-flutter.cloudfunctions.net/StripePI'});

  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey: 'pk_test_5zdHchT4molM3QUkqvUXdonx00aX5mXabQ',
        androidPayMode: 'test',
        merchantId: 'test'));
  }

  Future<PaymentMethod?> createPaymentMethod() async {
    print('La transazione da effettuare è di $amount');

    PaymentMethod paymentMethod =
        await StripePayment.paymentRequestWithCardForm(
            CardFormPaymentRequest());
    

    return paymentMethod;
  }

  Future<void> processPayment(PaymentMethod paymentMethod) async {
    final http.Response response = await http.post(
        Uri.parse('$url?amount=$amount&currency=USD&paym=${paymentMethod.id}'));

    if (response.body != 'error') {
      final paymentIntent = jsonDecode(response.body);
      final status = paymentIntent['paymentIntent']['status'];

      if (status == 'succeded') {
        
        print(
            'Payment Completed. ${paymentIntent['paymentIntent']['amout'].toString()} successfully charged!');
      }
    } else {
      print('Payment Failed!');
    }
  }
}*/
