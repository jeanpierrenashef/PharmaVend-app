import 'package:flutter/material.dart';
import 'package:flutter_application/custom/app_bar.dart';
import 'package:flutter_application/custom/nav_bar.dart';
import 'package:flutter_application/models/machine.dart';
import 'package:flutter_application/models/product.dart';
import 'package:flutter_application/pages/cart_page.dart';
import 'package:flutter_application/pages/history_page.dart';
import 'package:flutter_application/pages/map_page.dart';
import 'package:flutter_application/pages/product_detail_page.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/services/product_service.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Machine? _selectedMachine;

  Future<void> loadSelectedMachine() async {
    final prefs = await SharedPreferences.getInstance();
    final machineId = prefs.getInt('selectedMachineId');

    if (machineId != null) {
      final store = StoreProvider.of<AppState>(context);
      while (store.state.machines.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (store.state.machines.isEmpty) {
        print("Machines not loaded yet, waiting...");
        await Future.delayed(const Duration(milliseconds: 500));
        await loadSelectedMachine();
        return;
      }
      setState(() {
        _selectedMachine = store.state.machines.firstWhere(
          (machine) => machine.id == machineId,
        );
      });
      if (_selectedMachine != null) {
        print("Loaded Machine: ${_selectedMachine!.location}");
        await ProductService.fetchProductsByMachineId(
                store, _selectedMachine!.id)
            .then((_) {
          final products = store.state.products;
          print(
              "Products fetched in ProductsPage: ${products.map((m) => m.name).toList()}");
        });
        while (store.state.products.isEmpty) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      } else {
        print("Machine with ID $machineId not found in AppState");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadSelectedMachine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const CustomAppBar(),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _selectedMachine?.location ?? "Machine not found",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: StoreConnector<AppState, List<Product>>(
              converter: (store) => store.state.products,
              builder: (context, products) {
                final Map<String, List<Product>> productsByCategory = {};
                for (var product in products) {
                  productsByCategory
                      .putIfAbsent(product.category, () => [])
                      .add(product);
                }

                return ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  children: productsByCategory.entries.map((entry) {
                    final category = entry.key;
                    final categoryProducts = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            category,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: categoryProducts.length,
                          itemBuilder: (context, index) {
                            final product = categoryProducts[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailPage(
                                        productId: product.id),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      product.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 0,
        onItemTapped: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProductPage()),
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
      ),
    );
  }
}
