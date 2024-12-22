import 'package:flutter/material.dart';
import 'package:flutter_application/models/product.dart';
import 'package:flutter_application/pages/cart_page.dart';
import 'package:flutter_application/pages/map_page.dart';
import 'package:flutter_application/pages/products_page.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductPage()),
              )
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/home.png",
                  height: 30,
                  width: 30,
                  color: selectedIndex == 0 ? Colors.black : Colors.grey,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapPage()),
              )
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/map.png",
                  height: 30,
                  width: 30,
                  color: selectedIndex == 1 ? Colors.black : Colors.grey,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapPage()),
              )
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/history.png",
                  height: 30,
                  width: 30,
                  color: selectedIndex == 2 ? Colors.black : Colors.grey,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              )
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/cart.png",
                  height: 30,
                  width: 30,
                  color: selectedIndex == 3 ? Colors.black : Colors.grey,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapPage()),
              )
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/dispense.png",
                  height: 30,
                  width: 30,
                  color: selectedIndex == 4 ? Colors.black : Colors.grey,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
