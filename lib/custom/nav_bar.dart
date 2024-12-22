import 'package:flutter/material.dart';

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
            onTap: () => onItemTapped(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/home.png",
                  color: selectedIndex == 0 ? Colors.black : Colors.grey,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onItemTapped(1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/map.png",
                  color: selectedIndex == 1 ? Colors.black : Colors.grey,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onItemTapped(2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/history.png",
                  color: selectedIndex == 2 ? Colors.black : Colors.grey,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onItemTapped(3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/cart.png",
                  color: selectedIndex == 3 ? Colors.black : Colors.grey,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onItemTapped(4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/dispense.png",
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
