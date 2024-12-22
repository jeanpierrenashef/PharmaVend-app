import 'package:flutter_application/models/product.dart';

class AppState {
  final List<Product> products;
  final List<Product> cart;
  final String? error;

  AppState({this.products = const [], this.cart = const [], this.error});

  AppState copyWith(
      {List<Product>? products, List<Product>? cart, String? error}) {
    return AppState(
        products: this.products, cart: this.cart, error: this.error);
  }
}
