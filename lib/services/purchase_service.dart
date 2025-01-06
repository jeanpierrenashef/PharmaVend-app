import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/cart_actions.dart';
import 'package:flutter_application/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

class PurchaseService {
  static Future<void> purchaseCartItems(
      Store<AppState> store, BuildContext context) async {
    final cartItems = store.state.cart;
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cart is empty."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final machineId = prefs.getInt('selectedMachineId');

    bool allSuccessful = true;

    for (final cartItem in cartItems) {
      final product = cartItem.product;

      final requestBody = {
        'machine_id': machineId,
        'product_id': product.id,
        'quantity': cartItem.quantity,
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
          final errorResponse = json.decode(response.body);
          allSuccessful = false;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorResponse["message"] ?? "Purchase unsuccessful.",
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print(e);
      }

      if (allSuccessful) {
        store.dispatch(ClearCartAction());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("All purchases were successful!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print("Some purchases failed. Cart was not cleared.");
      }
    }
  }
}
