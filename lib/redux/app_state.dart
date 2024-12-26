import 'package:flutter_application/models/machine.dart';
import 'package:flutter_application/models/product.dart';

class AppState {
  final List<Product> products;
  final List<CartItem> cart;
  final List<Machine> machines;
  final String? error;

  AppState(
      {this.products = const [],
      this.cart = const [],
      this.machines = const [],
      this.error});

  AppState copyWith(
      {List<Product>? products,
      List<CartItem>? cart,
      List<Machine>? machines,
      String? error}) {
    return AppState(
      products: products ?? this.products,
      cart: this.cart,
      machines: machines ?? this.machines,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'AppState(machines: $machines, error: $error)';
  }
}

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});
}
