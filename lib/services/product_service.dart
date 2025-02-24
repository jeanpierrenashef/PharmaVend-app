import 'dart:convert';

import 'package:flutter_application/models/product.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/load_products_actions.dart';
import 'package:flutter_application/services/login_service.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static Future<void> fetchProductsByMachineId(
      Store<AppState> store, int machineId) async {
    store.dispatch(loadProductsAction());
    try {
      final token = await LoginService.getToken();
      final response = await http.get(
        Uri.parse("http://192.168.1.7:8000/api/$machineId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
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

  static Future<void> fetchProductById(
      Store<AppState> store, int productId) async {
    try {
      final token = await LoginService.getToken();
      final response = await http.get(
        Uri.parse("http://192.168.1.7:8000/api/product/$productId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final product = Product.fromJson(responseData['product']);
        store.dispatch(AddProductAction(product));
      } else {
        print("Failed to fetch product: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching product by ID: $e");
    }
  }
}
