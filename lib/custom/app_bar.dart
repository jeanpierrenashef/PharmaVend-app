import 'package:flutter/material.dart';
import 'package:flutter_application/pages/cart_page.dart';
import 'package:flutter_application/pages/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  Future<void> _logout(BuildContext context) async {
    await GoogleSignIn().signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () async {
            await _logout(context);
          },
          icon: const Icon(
            Icons.logout,
            size: 30,
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
