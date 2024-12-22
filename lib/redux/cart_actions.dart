import 'package:flutter_application/models/product.dart';

class AddToCartAction {
  final Product product;

  AddToCartAction(this.product);
}

class RemoveFromCartAction {
  final Product product;

  RemoveFromCartAction(this.product);
}

class ClearCartAction {}
