import 'package:flutter/material.dart';
import 'package:flutter_application/custom/app_bar.dart';
import 'package:flutter_application/custom/nav_bar.dart';
import 'package:flutter_application/models/transaction.dart';
import 'package:flutter_application/pages/cart_page.dart';
import 'package:flutter_application/pages/history_page.dart';
import 'package:flutter_application/pages/map_page.dart';
import 'package:flutter_application/pages/products_page.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/services/dispense_service.dart';
import 'package:flutter_redux/flutter_redux.dart';

class DispensePage extends StatefulWidget {
  const DispensePage({Key? key}) : super(key: key);

  @override
  State<DispensePage> createState() => _DispensePageState();
}

class _DispensePageState extends State<DispensePage> {
  List<Transaction> undispensedTransactions = [];

  @override
  void initState() {
    super.initState();
    _fetchUndispensedTransactions();
  }

  void _fetchUndispensedTransactions() {
    final store = StoreProvider.of<AppState>(context);
    final transactions = store.state.transactions;

    setState(() {
      undispensedTransactions =
          transactions.where((t) => t.dispensed == 0).toList();
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  transaction.machineId.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "Ordered at:  ${transaction.updatedAt}",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                )
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await DispenseService.dispenseTransaction(
                                    transaction.id);
                                setState(() {
                                  undispensedTransactions =
                                      undispensedTransactions
                                          .where((t) => t.id != transaction.id)
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
