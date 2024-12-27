import 'package:flutter/material.dart';
import 'package:flutter_application/custom/nav_bar.dart';
import 'package:flutter_application/pages/cart_page.dart';
import 'package:flutter_application/pages/map_page.dart';
import 'package:flutter_application/pages/products_page.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/services/transaction_service.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchTransactions();
  }

  void _fetchTransactions() {
    final store = StoreProvider.of<AppState>(context);
    const userId = 1;
    TransactionService.fetchTransactions(store, userId).then((_) {
      final transactions = store.state.transactions;
      print(
          "Transactions fetched in HistoryPage: ${transactions.map((t) => t.id).toList()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomBottomNavBar(
      selectedIndex: 2,
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
              MaterialPageRoute(builder: (context) => CartPage()),
            );
            break;
        }
      },
    ));
  }
}
