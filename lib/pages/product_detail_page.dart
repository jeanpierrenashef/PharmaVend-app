import 'package:flutter/material.dart';
import 'package:flutter_application/custom/app_bar.dart';
import 'package:flutter_application/models/product.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/cart_actions.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;

  const ProductDetailPage({Key? key, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomAppBar(),
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
                      "Hamra V12",
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
              converter: (store) {
                return store.state.products.firstWhere(
                  (product) => product.id == productId,
                );
              },
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
                      Image.network(
                        product.image,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 16),
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
                            StoreProvider.of<AppState>(context)
                                .dispatch(AddToCartAction(productId));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(
                                  child: Text(
                                    "Added to cart!",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                backgroundColor: Colors.grey,
                                duration: Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.only(
                                    bottom: 120, left: 86, right: 86),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
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
