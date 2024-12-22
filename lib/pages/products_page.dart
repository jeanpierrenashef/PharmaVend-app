import 'package:flutter/material.dart';
import 'package:flutter_application/models/product.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StoreConnector<AppState, List<Product>>(
        converter: (store) => store.state.products,
        builder: (context, products) {
          final Map<String, List<Product>> productsByCategory = {};
          for (var product in products) {
            productsByCategory
                .putIfAbsent(product.category, () => [])
                .add(product);
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
                          // Handle product click (e.g., navigate to details)
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
    );
  }
}
