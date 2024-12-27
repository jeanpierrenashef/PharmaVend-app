import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/load_transactions_actions.dart';

AppState loadTransactionsReducer(AppState state, dynamic action) {
  if (action is loadTransactionsFailureAction) {
    return state.copyWith(error: null);
  } else if (action is loadTransactionsSuccessAction) {
    return state.copyWith(transactions: action.transactions, error: null);
  } else if (action is loadTransactionsFailureAction) {
    return state.copyWith(error: action.error);
  }
  return state;
}
