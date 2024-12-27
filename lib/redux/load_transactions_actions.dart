import 'package:flutter_application/models/transaction.dart';

class LoadTransactionsAction {}

class LoadTransactionsSuccessAction {
  final List<Transaction> transactions;
  LoadTransactionsSuccessAction(this.transactions);
}

class LoadTransactionsFailureAction {
  final String error;
  LoadTransactionsFailureAction(this.error);
}
