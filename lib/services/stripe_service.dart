import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret =
      "sk_test_51Qhjis2Ki09t4LEryF5w0WWGrbDOCPahLE0ltolNejsfEwC3OtKmCBpcZYZy8IK0gTYVJ26RKoxpEvlzy69ysjKv000DpDtIVg";

  static Map<String, String> headers = {
    "Authorization": 'Bearer ${StripeService.secret}',
    "Content-Type": 'application/x-www-form-urlencoded'
  };

  static init() {
    Stripe.publishableKey =
        "pk_test_51Qhjis2Ki09t4LErkg8T4s4JCvkGHhZ5RxQEZ9wAIrnHy7QUkbZDLj9VRQhcMJVsjvpN8MVrX6135ZDb3HxOHMZ6006ESRqKxr";
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse(StripeService.paymentApiUrl),
        body: body,
        headers: StripeService.headers,
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception("Failed to create payment intent");
    }
  }

  static Future<void> initPaymentSheet(String amount, String currency) async {
    try {
      final paymentIntent = await createPaymentIntent(amount, currency);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent[
                'sk_test_51Qhjis2Ki09t4LEryF5w0WWGrbDOCPahLE0ltolNejsfEwC3OtKmCBpcZYZy8IK0gTYVJ26RKoxpEvlzy69ysjKv000DpDtIVg'],
            merchantDisplayName: "Dear Programmer",
            style: ThemeMode.system),
      );
    } catch (e) {
      throw Exception("Failed to initialize payment sheet");
    }
  }

  static Future<void> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      throw Exception("Failed to present payment sheet");
    }
  }
}
