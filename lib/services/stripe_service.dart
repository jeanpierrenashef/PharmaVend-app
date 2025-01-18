import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';

  static Map<String, String> headers = {
    'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static void init() {
    Stripe.publishableKey =
        "pk_test_51Qhjis2Ki09t4LErkg8T4s4JCvkGHhZ5RxQEZ9wAIrnHy7QUkbZDLj9VRQhcMJVsjvpN8MVrX6135ZDb3HxOHMZ6006ESRqKxr";
  }

  // Updated to accept double
  static Future<Map<String, dynamic>> createPaymentIntent(
      double amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': (amount * 100).toInt().toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse(StripeService.paymentApiUrl),
        body: body,
        headers: StripeService.headers,
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to create payment intent: ${response.body}");
      }

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception("Failed to create payment intent");
    }
  }

  static Future<void> initPaymentSheet(double amount, String currency) async {
    try {
      final paymentIntent = await createPaymentIntent(amount, currency);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: "Dear Programmer",
          style: ThemeMode.system,
        ),
      );
    } catch (e) {
      throw Exception("Failed to initialize payment sheet");
    }
  }

  static Future<void> presentPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment successful!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: ${e.toString()}")),
      );
    }
  }
}
