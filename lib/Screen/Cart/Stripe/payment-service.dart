/*import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../prodotti_item_it.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message = "", this.success = false});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret = 'sk_live_WLVmHEm6aev1DrZs4Su8U5WZ001oH20IwH';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() async{
     
    Stripe.merchantIdentifier = "test";
    Stripe.publishableKey = "pk_test_5zdHchT4molM3QUkqvUXdonx00aX5mXabQ";
    await Stripe.instance.applySettings();
  }

  static Future<StripeTransactionResponse> payWithNewCard(
      {String amount = "", String currency = ""}) async {
    try {
      final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.card(
              paymentMethodData: PaymentMethodData(
                  billingDetails: BillingDetails(name: "Arturo"))));
      /* var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest(
              prefilledInformation: PrefilledInformation(
                  billingAddress: BillingAddress(name: "Arturo"))));*/
      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);

      var response = await Stripe.instance.confirmPayment(
          paymentIntentClientSecret: paymentIntent!['client_secret']);
      /*var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent!['client_secret'],
          paymentMethodId: paymentMethod.id));*/

      var currentUserId = FirebaseAuth.instance.currentUser!.uid;
      var currentUserMail = FirebaseAuth.instance.currentUser!.email;

      if (response.status == 'succeeded') {
        FirebaseFirestore.instance
            .collection('Ordini')
            .doc(currentUserId)
            .update({
          'order.001.info': {
            'exists': true,
            'userId': '$currentUserId',
            'email': '$currentUserMail',
            'transactionId': '${paymentMethod.id}',
            'amount': amount,
          }
        });

        return new StripeTransactionResponse(
            message: 'Thanks for your order!', success: true);
      } else {
        var currentUserId = FirebaseAuth.instance.currentUser!.uid;
        FirebaseFirestore.instance
            .collection('Ordini')
            .doc(currentUserId)
            .delete();
        return new StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (err) {
      var currentUserId = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance
          .collection('Ordini')
          .doc(currentUserId)
          .delete();
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      var currentUserId = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance
          .collection('Ordini')
          .doc(currentUserId)
          .delete();
      print(err);
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(message: message, success: false);
  }

  static Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    var currentUserEmail = FirebaseAuth.instance.currentUser!.email;
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': "card",
        'receipt_email': currentUserEmail,
      };
      var response = await http.post(Uri.parse(StripeService.paymentApiUrl),
          body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}
*/