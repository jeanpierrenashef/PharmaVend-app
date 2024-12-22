import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/cart_actions.dart';

AppState cartReducer(AppState state, dynamic action) {
  if (action is AddToCartAction) {
    final updatedCart = [...state.cart];
    final productIndex = updatedCart
        .indexWhere((cartItem) => cartItem.product.id == action.productId);

    if (productIndex != -1) {
      updatedCart[productIndex] = CartItem(
        product: updatedCart[productIndex].product,
        quantity: updatedCart[productIndex].quantity + 1,
      );
    } else {
      final product =
          state.products.firstWhere((p) => p.id == action.productId);
      updatedCart.add(CartItem(product: product, quantity: 1));
    }

    return AppState(products: state.products, cart: updatedCart);
  } else if (action is RemoveFromCartAction) {
    final updatedCart = [...state.cart];
    final productIndex = updatedCart
        .indexWhere((cartItem) => cartItem.product.id == action.productId);

    if (productIndex != -1) {
      if (updatedCart[productIndex].quantity > 1) {
        updatedCart[productIndex] = CartItem(
          product: updatedCart[productIndex].product,
          quantity: updatedCart[productIndex].quantity - 1,
        );
      } else {
        updatedCart.removeAt(productIndex);
      }
    }

    return AppState(products: state.products, cart: updatedCart);
  }

  return state;
}
