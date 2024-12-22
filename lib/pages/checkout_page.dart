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
                      )),
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
                  const SizedBox(width: 48)
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "Vending Machine",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/machine.png",
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "Hamra V12",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text("Payment Method",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(
                height: 8,
              ),
              RadioListTile(
                value: "Card Payment",
                groupValue: "Card Payment",
                onChanged: (value) {},
                title: const Text("Card Payment"),
                secondary: Icon(Icons.credit_card, color: Colors.black),
              ),
              RadioListTile(
                value: "Wish Money",
                groupValue: "Card Payment",
                onChanged: (value) {},
                title: const Text("Wish Money"),
                secondary: Icon(Icons.wallet, color: Colors.black),
              ),
            ],
          )),
    );
  }
}
