import 'package:flutter/material.dart';
import 'package:flutter_application/custom/app_bar.dart';
import 'package:flutter_application/custom/nav_bar.dart';
import 'package:flutter_application/pages/cart_page.dart';
import 'package:flutter_application/pages/history_page.dart';
import 'package:flutter_application/pages/map_page.dart';
import 'package:flutter_application/pages/products_page.dart';

class DispensePage extends StatefulWidget {
  const DispensePage({super.key});

  @override
  State<DispensePage> createState() => _DispensePageState();
}

class _DispensePageState extends State<DispensePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const CustomAppBar(),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Text(
                "Dispense",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 4,
        onItemTapped: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProductPage()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MapPage()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
              break;
            case 4:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DispensePage()),
              );
              break;
          }
        },
      ),
    );
  }
}
