import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/cart_reducer.dart';
import 'package:flutter_application/redux/load_machines_reducer.dart';
import 'package:flutter_application/redux/load_products_reducer.dart';
import 'package:flutter_application/redux/load_transactions_reducer.dart';
import 'package:flutter_application/redux/login_reducer.dart';
import 'package:flutter_application/redux/signup_reducer.dart';
import 'package:redux/redux.dart';

final rootReducer = combineReducers<AppState>([
  TypedReducer<AppState, dynamic>(loadMachinesReducer).call,
  TypedReducer<AppState, dynamic>(loadProductsReducer).call,
  TypedReducer<AppState, dynamic>(cartReducer).call,
  TypedReducer<AppState, dynamic>(loadTransactionsReducer).call,
  TypedReducer<AppState, dynamic>(signupReducer).call,
  TypedReducer<AppState, dynamic>(loginReducer).call,
]);
