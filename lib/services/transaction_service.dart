import 'dart:convert';
import 'package:flutter_application/models/transaction.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/load_transactions_actions.dart';
import 'package:flutter_application/services/login_service.dart';
import 'package:flutter_application/services/machine_service.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

class TransactionService {
  static Future<void> fetchTransactions(
      Store<AppState> store, int userId) async {
    store.dispatch(loadTransactionsAction());

    try {
      final token = await LoginService.getToken();
      final response = await http.post(
        Uri.parse("http://192.168.1.7:8000/api/history"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({"user_id": userId}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final transactionsList = responseData['transactions'] as List<dynamic>;
        print("Transactions in API response: $transactionsList");

        final transactions =
            transactionsList.map((item) => Transaction.fromJson(item)).toList();
        store.dispatch(loadTransactionsSuccessAction(transactions));
        print(
            "Products in store after dispatch: ${store.state.transactions.map((p) => p.quantity).toList()}");
        await MachineService.fetchMachines(store);
      } else {
        store.dispatch(
          loadTransactionsFailureAction("Failed to load transactions."),
        );
      }
    } catch (e) {
      store.dispatch(loadTransactionsFailureAction(e.toString()));
    }
  }
}
