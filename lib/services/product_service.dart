import 'dart:convert';

import 'package:flutter_application/models/product.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/load_products_actions.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static Future<void> fetchProductsByMachineId(
      Store<AppState> store, int machineId) async {
    store.dispatch(loadProductsAction());

    try {
      final response = await http.get(
        Uri.parse("http://192.168.1.7:800/api/${machineId}"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> productList = responseData['products'];

        final products =
            productList.map((item) => Product.fromJson(item)).toList();
        store.dispatch(loadProductsSuccessAction(products));
      } else {
        store.dispatch(loadProductsFailureAction("Failed to load products"));
      }
    } catch (e) {
      store.dispatch(loadProductsFailureAction(e.toString()));
    }
  }
}
