import 'package:flutter/material.dart';
import 'package:flutter_application/models/machine.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/custom/app_bar.dart';
import 'package:flutter_application/models/product.dart';
import 'package:flutter_application/redux/cart_actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Machine? _selectedMachine;

  Future<void> loadMachineName() async {
    final prefs = await SharedPreferences.getInstance();
    final machineId = prefs.getInt('selectedMachineId');

    if (machineId != null) {
      final store = StoreProvider.of<AppState>(context);

      setState(() {
        _selectedMachine = store.state.machines.firstWhere(
          (machine) => machine.id == machineId,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadMachineName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const CustomAppBar(),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _selectedMachine?.location ?? "Loading...",
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
          ),
          Expanded(
            child: StoreConnector<AppState, Product?>(
              converter: (store) => store.state.products.firstWhere(
                (product) => product.id == widget.productId,
              ),
              builder: (context, product) {
                if (product == null) {
                  return const Center(
                    child: Text('Product not found.'),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            product.image,
                            height: 350,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\$${product.price.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            final store = StoreProvider.of<AppState>(context);
                            final cartItem = store.state.cart.firstWhere(
                              (item) => item.product.id == widget.productId,
                              orElse: () =>
                                  CartItem(product: product, quantity: 0),
                            );

                            if (cartItem.quantity >= 2) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    "You can't add more than 2 of this product!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            } else {
                              store.dispatch(AddToCartAction(widget.productId));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    "Added to cart!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  backgroundColor: Colors.grey,
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.only(
                                      bottom: 120, left: 86, right: 86),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(32, 181, 115, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
