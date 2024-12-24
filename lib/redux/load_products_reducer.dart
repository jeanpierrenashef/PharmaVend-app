import 'package:flutter_application/redux/load_products_actions.dart';
import 'package:flutter_application/redux/app_state.dart';

AppState loadProductsReducer(AppState state, dynamic action) {
  if (action is loadProductsAction) {
    return state.copyWith(error: null);
  } else if (action is loadProductsSuccessAction) {
    return state.copyWith(products: action.products, error: null);
  } else if (action is loadProductsFailureAction) {
    return state.copyWith(error: action.error);
  }
  return state;
}
