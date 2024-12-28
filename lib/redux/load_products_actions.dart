import 'package:flutter_application/models/product.dart';

class loadProductsAction {}

class loadProductsSuccessAction {
  final List<Product> products;
  loadProductsSuccessAction(this.products);
}

class loadProductsFailureAction {
  final String error;
  loadProductsFailureAction(this.error);
}

class AddProductAction {
  final Product product;

  AddProductAction(this.product);
}
