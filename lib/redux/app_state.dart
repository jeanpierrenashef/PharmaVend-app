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
        products: this.products,
        cart: this.cart,
        machines: this.machines,
        error: this.error);
  }
}

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});
}
