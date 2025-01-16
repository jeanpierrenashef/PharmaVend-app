import 'package:flutter/material.dart';
import 'package:flutter_application/custom/app_bar.dart';
import 'package:flutter_application/custom/nav_bar.dart';
import 'package:flutter_application/main.dart';
import 'package:flutter_application/models/machine.dart';
import 'package:flutter_application/models/product.dart';
import 'package:flutter_application/models/transaction.dart';
import 'package:flutter_application/pages/dispense_page.dart';
import 'package:flutter_application/pages/map_page.dart';
import 'package:flutter_application/pages/products_page.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/services/product_service.dart';
import 'package:flutter_application/services/transaction_service.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

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
    TransactionService.fetchTransactions(store).then((_) {
      final transactions = store.state.transactions;
      print(
          "Transactions fetched in HistoryPage: ${transactions.map((t) => t.id).toList()}");

      transactions.forEach((transaction) {
        final productExists =
            store.state.products.any((p) => p.id == transaction.productId);
        if (!productExists) {
          ProductService.fetchProductById(store, transaction.productId);
        }
      });
    });
  }

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
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "History",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StoreConnector<AppState, List<Transaction>>(
                converter: (store) => store.state.transactions,
                builder: (context, transactions) {
                  if (transactions.isEmpty) {
                    return const Center(
                      child: Text(
                        "No History",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  final machines =
                      StoreProvider.of<AppState>(context).state.machines;
                  final groupedTransactions =
                      _groupByDateAndLocation(transactions, machines);

                  return ListView.builder(
                    itemCount: groupedTransactions.length,
                    itemBuilder: (context, index) {
                      final entry = groupedTransactions.entries.toList()[index];
                      final dateAndLocation = entry.key;
                      final transactionsList = entry.value;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dateAndLocation,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: transactionsList
                                  .fold<Map<int, Product>>({},
                                      (uniqueProducts, transaction) {
                                    final products =
                                        StoreProvider.of<AppState>(context)
                                            .state
                                            .products;
                                    final product = products.firstWhere(
                                      (p) => p.id == transaction.productId,
                                      orElse: () => Product(
                                        id: 0,
                                        name: "Unknown",
                                        description: "",
                                        category: "",
                                        price: 0.0,
                                        image:
                                            "https://via.placeholder.com/100",
                                      ),
                                    );

                                    if (!uniqueProducts
                                        .containsKey(transaction.productId)) {
                                      uniqueProducts[transaction.productId] =
                                          product;
                                    }
                                    return uniqueProducts;
                                  })
                                  .values
                                  .map((product) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        product.image,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  })
                                  .toList(),
                            ),
                            const SizedBox(height: 8),
                            const Divider(thickness: 1),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 3,
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
                MaterialPageRoute(builder: (context) => Home()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage()),
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

  Map<String, List<Transaction>> _groupByDateAndLocation(
    List<Transaction> transactions,
    List<Machine> machines,
  ) {
    transactions.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final grouped = <String, List<Transaction>>{};

    for (var transaction in transactions) {
      final machine = machines.firstWhere(
        (m) => m.id == transaction.machineId,
        orElse: () => Machine(
          id: -1,
          location: "Unknown Location",
          latitude: 0.0,
          longitude: 0.0,
          status: '',
        ),
      );

      final key =
          "On ${transaction.updatedAt.split('T')[0]}, ${machine.location}";

      grouped.putIfAbsent(key, () => []).add(transaction);
    }
    return grouped;
  }
}
