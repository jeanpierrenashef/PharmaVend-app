import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/cart_reducer.dart';
import 'package:flutter_application/redux/load_machines_reducer.dart';
import 'package:flutter_application/redux/load_products_reducer.dart';
import 'package:redux/redux.dart';

final rootReducer = combineReducers<AppState>([
  TypedReducer<AppState, dynamic>(loadMachinesReducer),
  TypedReducer<AppState, dynamic>(loadProductsReducer),
  TypedReducer<AppState, dynamic>(cartReducer),
]);
