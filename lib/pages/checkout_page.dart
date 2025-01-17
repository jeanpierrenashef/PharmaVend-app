import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CheckoutPage extends StatefulWidget {
  final double total;

  const CheckoutPage({super.key, required this.total});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Map<String, dynamic>? paymentIntentData;

  @override
  void initState() {
    super.initState();

    // Set your Stripe publishable key here
    Stripe.publishableKey =
        'pk_test_51Qhjis2Ki09t4LEryF5w0WWGrbDOCPahLE0ltolNejsfEwC3OtKmCBpcZYZy8IK0gTYVJ26RKoxpEvlzy69ysjKv000DpDtIVg';
  }

  Future<void> _initiatePaymentSheet() async {
    try {
      // Mocked PaymentIntent data (replace this with your actual backend integration in production)
      paymentIntentData = {
        'clientSecret':
            'pi_test_client_secret_mock', // Replace with actual client secret
      };

      // Initialize the PaymentSheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['clientSecret'],
          merchantDisplayName: 'Your Store', // Display name in the UI
          style: ThemeMode.light, // Light or dark theme
        ),
      );

      // Present the PaymentSheet
      await _displayPaymentSheet();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _displayPaymentSheet() async {
    try {
      // Present the PaymentSheet
      await Stripe.instance.presentPaymentSheet();

      // Handle payment success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment successful!"),
        ),
      );

      // Clear the mock PaymentIntent after success
      paymentIntentData = null;
    } catch (e) {
      // Handle payment failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Checkout",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Payment Method",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RadioListTile(
                value: "Card Payment",
                groupValue: "Card Payment",
                onChanged: (value) {},
                title: const Text("Card Payment"),
                secondary: const Icon(Icons.credit_card, color: Colors.black),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Order Summary",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Subtotal (incl. VAT)"),
                Text("${widget.total.toStringAsFixed(2)} USD"),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Discount"),
                Text("0.00 USD"),
              ],
            ),
            const Divider(thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${widget.total.toStringAsFixed(2)} USD",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _initiatePaymentSheet, // Call PaymentSheet initialization
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(32, 181, 115, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            "Purchase Now",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
