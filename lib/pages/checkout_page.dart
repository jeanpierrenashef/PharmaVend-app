import 'package:flutter/material.dart';
import 'package:flutter_application/custom/app_bar.dart';

class CheckoutPage extends StatelessWidget {
  final double total;

  const CheckoutPage({Key? key, required this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      )),
                  const Center(
                    child: Text(
                      "Checkout",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48)
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "Vending Machine",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }
}
