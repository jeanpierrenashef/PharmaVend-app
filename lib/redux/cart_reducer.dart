import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/cart_actions.dart';

AppState cartReducer(AppState state, dynamic action) {
  if (action is AddToCartAction) {
    return AppState(
      products: state.products,
      cart: [...state.cart, action.product],
    );
  } else if (action is RemoveFromCartAction) {
    return AppState(
      products: state.products,
      cart: state.cart
          .where((product) => product.id != action.product.id)
          .toList(),
    );
  } else if (action is ClearCartAction) {
    return AppState(
      products: state.products,
      cart: [],
    );
  }
  return state;
}
