import 'package:flutter_application/redux/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseService {
  static Future<void> purchaseCartItems(
      Store<AppState> store, int userId) async {
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
  }
}
