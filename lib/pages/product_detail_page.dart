import 'package:flutter/material.dart';
import 'package:flutter_application/custom/app_bar.dart';
import 'package:flutter_application/models/product.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({Key? key, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CustomAppBar(),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  "Hamra V12",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Category: ${product.category}",
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Price: \$${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Handle Add to Cart
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
