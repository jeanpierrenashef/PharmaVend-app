import 'package:flutter/material.dart';
import 'package:flutter_application/custom/app_bar.dart';
import 'package:flutter_application/custom/nav_bar.dart';
import 'package:flutter_application/main.dart';
import 'package:flutter_application/pages/dispense_page.dart';
import 'package:flutter_application/pages/history_page.dart';
import 'package:flutter_application/pages/map_page.dart';
import 'package:flutter_application/pages/products_page.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/cart_actions.dart';

import 'package:flutter_application/services/stripe_service1.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String currency = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const CustomAppBar(),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
      ),
      body: _buildCartBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildCartBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Cart",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Your Cart",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: StoreConnector<AppState, List<CartItem>>(
            converter: (store) => store.state.cart,
            builder: (context, cartItems) {
              if (cartItems.isEmpty) {
                return const Center(
                  child: Text(
                    "Your cart is empty.",
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              return _buildCartList(cartItems);
            },
          ),
        ),
        _buildCheckoutSection(),
      ],
    );
  }

  Widget _buildCartList(List<CartItem> cartItems) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final cartItem = cartItems[index];
        final product = cartItem.product;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.image, // Assuming `product.image` contains the URL
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        size: 80,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${cartItem.quantity} x \$${product.price.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // Cart Item Actions (Add/Remove Buttons)
                _buildCartItemActions(cartItem),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartItemActions(CartItem cartItem) {
    final store = StoreProvider.of<AppState>(context);

    return Row(
      children: [
        IconButton(
          onPressed: () {
            store.dispatch(RemoveFromCartAction(cartItem.product.id));
          },
          icon: const Icon(
            Icons.remove_circle_outline,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          "${cartItem.quantity}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () {
            final updatedCartItem = store.state.cart.firstWhere(
              (item) => item.product.id == cartItem.product.id,
              orElse: () => CartItem(product: cartItem.product, quantity: 0),
            );

            if (updatedCartItem.quantity >= 2) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    "You cannot add more than 2 of this product!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 1),
                ),
              );
            } else {
              store.dispatch(AddToCartAction(cartItem.product.id));
            }
          },
          icon: const Icon(
            Icons.add_circle_outline,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: StoreConnector<AppState, double>(
        converter: (store) => store.state.cart.fold(
          0.0,
          (total, cartItem) =>
              total + cartItem.product.price * cartItem.quantity,
        ),
        builder: (context, total) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Total: ${total.toStringAsFixed(2)} USD",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await StripeService1.instance.makePayment(total, currency);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Payment successful!")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Payment failed: ${e.toString()}")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(32, 181, 115, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return CustomBottomNavBar(
      selectedIndex: -1,
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
              MaterialPageRoute(builder: (context) => MapPage()),
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
    );
  }
}
