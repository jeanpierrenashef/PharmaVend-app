import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with TickerProviderStateMixin {
  late MotionTabBarController _motionTabBarController;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: widget.selectedIndex,
      length: 5,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _motionTabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MotionTabBar(
      controller: _motionTabBarController,
      initialSelectedTab: _getTabName(widget.selectedIndex),
      labels: const ["Home", "Map", "Search", "History", "Dispense"],
      icons: const [
        Icons.home_outlined,
        Icons.map_outlined,
        Icons.search,
        Icons.history,
        Icons.contactless_outlined,
      ],
      tabSize: 50,
      tabBarHeight: 55,
      textStyle: const TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      tabIconColor: Colors.grey,
      tabIconSize: 30,
      tabIconSelectedSize: 30,
      tabSelectedColor: const Color.fromARGB(255, 255, 255, 255),
      tabIconSelectedColor: const Color.fromRGBO(32, 181, 115, 1),
      tabBarColor: Colors.white,
      onTabItemSelected: (int index) {
        widget.onItemTapped(index);
      },
    );
  }

  String _getTabName(int index) {
    switch (index) {
      case 0:
        return "Home";
      case 1:
        return "Map";
      case 2:
        return "Search";
      case 3:
        return "History";
      case 4:
        return "Dispense";
      default:
        return "Home";
    }
  }
}
