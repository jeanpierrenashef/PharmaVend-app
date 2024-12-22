import 'package:flutter_application/models/product.dart';

class AppState {
  final List<Product> products;

  AppState({required this.products});
  AppState copyWith({List<Product>? products}) {
    return AppState(products: this.products);
  }
}
