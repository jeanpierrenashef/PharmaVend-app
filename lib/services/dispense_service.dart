import 'package:flutter_application/services/login_service.dart';
import 'package:http/http.dart' as http;

class DispenseService {
  static Future<void> dispenseTransaction(int transactionId) async {
    try {
      final token = await LoginService.getToken();
      final response = await http.put(
        Uri.parse("http://192.168.1.7:8000/api/dispense/$transactionId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        print("Dispense successful");
      } else {
        print("Failed to update the transactions table");
      }
    } catch (e) {
      print("Error updating: $e");
    }
  }
}
