import 'package:flutter/material.dart';
import 'package:flutter_application/pages/cart_page.dart';
import 'package:flutter_application/pages/login_page.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

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
            color: Color.fromRGBO(255, 0, 0, 0.5),
          ),
        ),
        StoreConnector<AppState, int>(
          converter: (store) =>
              store.state.cart.fold<int>(0, (sum, item) => sum + item.quantity),
          builder: (context, cartCount) {
            return IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
              icon: Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.asset(
                    "assets/cart.png",
                    height: 30,
                    width: 30,
                  ),
                  if (cartCount > 0)
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
