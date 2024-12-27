import 'package:flutter_application/models/transaction.dart';

class loadTransactionsAction {}

class loadTransactionsSuccessAction {
  final List<Transaction> transactions;
  loadTransactionsSuccessAction(this.transactions);
}

class loadTransactionsFailureAction {
  final String error;
  loadTransactionsFailureAction(this.error);
}
