class AddToCartAction {
  final int productId;

  AddToCartAction(this.productId);
}

class RemoveFromCartAction {
  final int productId;

  RemoveFromCartAction(this.productId);
}

class ClearCartAction {}
