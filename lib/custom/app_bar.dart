import 'package:flutter/material.dart';
import 'package:flutter_application/pages/cart_page.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            "assets/info.png",
            height: 30,
            width: 30,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CartPage()),
            );
          },
          icon: Image.asset(
            "assets/cart.png",
            height: 30,
            width: 30,
          ),
        ),
      ],
    );
  }
}
