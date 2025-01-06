import 'package:flutter/material.dart';
import 'package:flutter_application/custom/app_bar.dart';
import 'package:flutter_application/custom/nav_bar.dart';
import 'package:flutter_application/models/machine.dart';
import 'package:flutter_application/models/product.dart';
import 'package:flutter_application/models/transaction.dart';
import 'package:flutter_application/pages/cart_page.dart';
import 'package:flutter_application/pages/history_page.dart';
import 'package:flutter_application/pages/map_page.dart';
import 'package:flutter_application/pages/products_page.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/load_transactions_actions.dart';
import 'package:flutter_application/services/dispense_service.dart';
import 'package:flutter_application/services/product_service.dart';
import 'package:flutter_application/services/transaction_service.dart';
import 'package:flutter_redux/flutter_redux.dart';

class DispensePage extends StatefulWidget {
  const DispensePage({super.key});

  @override
  State<DispensePage> createState() => _DispensePageState();
}

class _DispensePageState extends State<DispensePage> {
  List<Transaction> undispensedTransactions = [];
  List<Machine> machines = [];
  List<Product> products = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUndispensedTransactions();
  }

  void _fetchUndispensedTransactions() async {
    final store = StoreProvider.of<AppState>(context);
    final transactions = store.state.transactions;

    if (transactions.isEmpty) {
      //const userId = 1;
      await TransactionService.fetchTransactions(store);
    }

    setState(() {
      final updatedTransactions = store.state.transactions;
      undispensedTransactions =
          updatedTransactions.where((t) => t.dispensed == 0).toList();
      machines = store.state.machines;
    });

    for (final transaction in undispensedTransactions) {
      final productExists = store.state.products.any(
        (product) => product.id == transaction.productId,
      );

      if (!productExists) {
        await ProductService.fetchProductById(
          store,
          transaction.productId,
        );
        setState(() {
          products = store.state.products;
        });
      }
    }
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
            Center(
              child: Text(
                "Dispense",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: undispensedTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = undispensedTransactions[index];
                  final machine = machines.firstWhere(
                    (m) => m.id == transaction.machineId,
                    orElse: () => Machine(
                      id: 0,
                      location: "Unknown Machine",
                      latitude: 0,
                      longitude: 0,
                      status: "",
                    ),
                  );
                  final product = StoreProvider.of<AppState>(context)
                      .state
                      .products
                      .firstWhere(
                        (p) => p.id == transaction.productId,
                        orElse: () => Product(
                            id: 0,
                            name: "Unknown",
                            description: "Empty",
                            category: "Unknown",
                            price: 0.0,
                            image: "null"),
                      );

                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              machine.location,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final store =
                                    StoreProvider.of<AppState>(context);

                                await DispenseService.dispenseTransaction(
                                    transaction.id);

                                final updatedTransactions =
                                    store.state.transactions.map((t) {
                                  if (t.id == transaction.id) {
                                    return t.copyWith(dispensed: 1);
                                  }
                                  return t;
                                }).toList();
                                store.dispatch(UpdateTransactionsAction(
                                    updatedTransactions));

                                setState(() {
                                  undispensedTransactions = updatedTransactions
                                      .where((t) => t.dispensed == 0)
                                      .toList();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(32, 181, 115, 1),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              child: const Text(
                                "Dispense",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              "Ordered at:  ${transaction.updatedAt.split('T')[0]}",
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
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
