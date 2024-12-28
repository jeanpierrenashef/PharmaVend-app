import 'package:flutter/material.dart';
import 'package:flutter_application/custom/app_bar.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/services/purchase_service.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8)),
              child: RadioListTile(
                value: "Card Payment",
                groupValue: "Card Payment",
                onChanged: (value) {},
                title: const Text("Card Payment"),
                secondary: Icon(Icons.credit_card, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8)),
              child: RadioListTile(
                value: "Wish Money",
                groupValue: "Card Payment",
                onChanged: (value) {},
                title: const Text("Wish Money"),
                secondary: Image.asset(
                  "assets/whish.png",
                  height: 16,
                  width: 41,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Promo code",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                    child: SizedBox(
                  height: 36,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Add Promo code here",
                      hintStyle:
                          TextStyle(color: Colors.grey.shade800, fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                )),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(32, 181, 115, 1),
                  ),
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
                Text("${total.toStringAsFixed(2)} USD"),
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
                  "${total.toStringAsFixed(2)} USD",
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 62),
        child: ElevatedButton(
          onPressed: () async {
            final store = StoreProvider.of<AppState>(context);
            const userId = 1;
            await PurchaseService.purchaseCartItems(store, userId);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(32, 181, 115, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
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
