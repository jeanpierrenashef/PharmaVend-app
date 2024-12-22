import 'package:flutter/material.dart';
import 'package:flutter_application/models/product.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/reducer.dart';
import 'package:redux/redux.dart';

class ProductPage extends StatelessWidget {
  final Store<AppState> _store = Store<AppState>(loadProductsReducer,
      initialState: AppState(products: [
        Product(
          id: '1',
          name: 'Panadol (12 tablets)',
          description: 'Pain reliever and fever reducer',
          category: 'First Aid',
          price: 5.0,
          image:
              'https://www.linkpicture.com/q/panadol.png', // Replace with actual image link
        ),
        Product(
          id: '2',
          name: 'Surgical gloves (1 pair)',
          description: 'Sterile gloves for medical use',
          category: 'First Aid',
          price: 2.0,
          image:
              'https://www.linkpicture.com/q/gloves.png', // Replace with actual image link
        ),
        Product(
          id: '3',
          name: 'Band-Aids (30 sizes)',
          description: 'Flexible fabric bandages',
          category: 'First Aid',
          price: 3.0,
          image:
              'https://www.linkpicture.com/q/bandaids.png', // Replace with actual image link
        ),
        Product(
          id: '4',
          name: 'Elastic Band-Aids (10 rolls)',
          description: 'Elastic bandages for injuries',
          category: 'First Aid',
          price: 8.0,
          image:
              'https://www.linkpicture.com/q/elastic_bandaid.png', // Replace with actual image link
        ),
        Product(
          id: '5',
          name: 'Betadine (Antiseptic)',
          description: 'Antiseptic liquid',
          category: 'First Aid',
          price: 7.0,
          image:
              'https://www.linkpicture.com/q/betadine.png', // Replace with actual image link
        ),
        Product(
          id: '6',
          name: 'Face Mask (Pack of 50)',
          description: 'Disposable masks',
          category: 'Face Masks',
          price: 15.0,
          image:
              'https://www.linkpicture.com/q/mask.png', // Replace with actual image link
        ),
        Product(
          id: '7',
          name: 'N95 Mask',
          description: 'High filtration mask',
          category: 'Face Masks',
          price: 20.0,
          image:
              'https://www.linkpicture.com/q/n95.png', // Replace with actual image link
        ),
      ]));
  final List<Product> products = [];

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Product>> productsByCategory = {};
    for (var product in products) {
      productsByCategory.putIfAbsent(product.category, () => []).add(product);
    }

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Jbeil, Blat LAU V12'), //to be changed to become dynamic
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.white,
      body: ListView(
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
      ),
    );
  }
}
