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
        Uri.parse("http://192.168.1.7:8000/api/${machineId}"),
        headers: {"ContentType": "application/json"},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final productList = responseData['products'] as List<dynamic>;
        print("Products in API response: $productList");
        final products =
            productList.map((item) => Product.fromJson(item)).toList();
        store.dispatch(loadProductsSuccessAction(products));
        print(
            "Products in store after dispatch: ${store.state.products.map((p) => p.name).toList()}");
      } else {
        store.dispatch(loadProductsFailureAction("Failed"));
      }
    } catch (e) {
      store.dispatch(loadProductsFailureAction(e.toString()));
    }
  }
}
