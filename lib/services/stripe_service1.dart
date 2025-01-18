import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StripeService1 {
  StripeService1._();
  static final StripeService1 instance = StripeService1._();

  Future<void> makePayment(double totalAmount, String currency) async {
    try {
      String? paymentIntentClientSecret =
          await _createPaymentIntent(totalAmount, currency);
      if (paymentIntentClientSecret == null) return;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Your Store Name",
        ),
      );
      await _processPayment();
    } catch (e) {
      print("Error in payment: $e");
    }
  }

  Future<String?> _createPaymentIntent(double amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print("Error creating payment intent: $e");
    }
    return null;
  }

  String _calculateAmount(double amount) {
    final calculatedAmount = (amount * 100).toInt();
    return calculatedAmount.toString();
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print("Error processing payment: $e");
    }
  }
}
