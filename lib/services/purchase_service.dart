import 'dart:convert';

import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/cart_actions.dart';
import 'package:flutter_application/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

class PurchaseService {
  static Future<void> purchaseCartItems(Store<AppState> store) async {
    final cartItems = store.state.cart;
    if (cartItems.isEmpty) {
      print("Cart is Empty");
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final machineId = prefs.getInt('selectedMachineId');

    if (machineId == null) {
      print("No machine id found");
      return;
    }
    bool allSuccessful = true;

    for (final cartItem in cartItems) {
      final product = cartItem.product;

      final requestBody = {
        //'user_id': userId,
        'machine_id': machineId,
        'product_id': product.id,
        'quantity': cartItem.quantity
      };
      print("Request Body: ${json.encode(requestBody)}");

      try {
        final token = await LoginService.getToken();
        final response = await http.post(
          Uri.parse("http://192.168.1.7:8000/api/purchase"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: json.encode(requestBody),
        );
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          print(
              "Purchase successful for product ${product.name}: $responseData");
        } else {
          print("Response Status Code: ${response.statusCode}");
          allSuccessful = false;
          print("Purchase unseccessful");
        }
      } catch (e) {
        allSuccessful = false;
        print("Error purchasing product , $e");
      }
    }
    if (allSuccessful) {
      store.dispatch(ClearCartAction());
    } else {
      print("Some purchases failed. Cart was not cleared.");
    }
  }
}
