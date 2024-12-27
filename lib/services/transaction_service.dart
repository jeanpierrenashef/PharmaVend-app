import 'dart:convert';

import 'package:flutter_application/models/transaction.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/load_machines_actions.dart';
import 'package:flutter_application/redux/load_transactions_actions.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

class TransactionService {
  static Future<void> fetchTransactions(
      Store<AppState> store, int userId) async {
    store.dispatch(loadMachinesAction());
    try {
      final response = await http.post(
          Uri.parse("http://192.168.1.7:8000/api/history"),
          headers: {"Content-Type": "application/json"},
          body: {userId});
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final transactionsList = responseData['transactions'] as List<dynamic>;
        print("Products in API response: $transactionsList");
        final transactions =
            transactionsList.map((item) => Transaction.fromJson(item)).toList();

        store.dispatch(LoadTransactionsSuccessAction(transactions));
      } else {
        store.dispatch(
            LoadTransactionsFailureAction("Failed to load transactions"));
      }
    } catch (e) {
      store.dispatch(LoadTransactionsFailureAction(e.toString()));
    }
  }
}
