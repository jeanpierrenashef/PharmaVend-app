import 'package:http/http.dart' as http;

class DispenseService {
  static Future<void> dispenseTransaction(int transactionId) async {
    try {
      final response = await http.put(
        Uri.parse("http://192.168.1.7:8000/api/dispense/$transactionId"),
        headers: {"Content-Type": "application/json"},
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
