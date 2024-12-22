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
    final List<Map<String, dynamic>> navItems = [
      {"icon": "assets/home.png", "index": 0},
      {"icon": "assets/map.png", "index": 1},
      {"icon": "assets/history.png", "index": 2},
      {"icon": "assets/cart.png", "index": 3},
      {"icon": "assets/dispense.png", "index": 4},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) {
          final isSelected = selectedIndex == item['index'];
          return GestureDetector(
            onTap: () => onItemTapped(item['index']),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  item['icon'],
                  height: 30,
                  width: 30,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
                const SizedBox(height: 4),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
