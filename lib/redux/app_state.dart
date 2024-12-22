import 'package:flutter_application/models/product.dart';

class AppState {
  final List<Product> products;
  final String? error;

  AppState({required this.products, this.error});
  AppState copyWith({List<Product>? products, String? error}) {
    return AppState(products: this.products, error: this.error);
  }
}
