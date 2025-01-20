import 'package:flutter_application/models/machine.dart';
import 'package:flutter_application/models/product.dart';
import 'package:flutter_application/models/transaction.dart';
import 'package:flutter_application/models/user.dart';

class AppState {
  final List<Product> products;
  final List<CartItem> cart;
  final List<Machine> machines;
  final List<Transaction> transactions;
  final String? error;
  final User? user;

  AppState(
      {this.products = const [],
      this.cart = const [],
      this.machines = const [],
      this.transactions = const [],
      this.error,
      this.user});

  AppState copyWith(
      {List<Product>? products,
      List<CartItem>? cart,
      List<Machine>? machines,
      List<Transaction>? transactions,
      String? error,
      User? user}) {
    return AppState(
      products: products ?? this.products,
      cart: cart ?? this.cart,
      machines: machines ?? this.machines,
      transactions: transactions ?? this.transactions,
      error: error ?? this.error,
      user: user ?? this.user,
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
