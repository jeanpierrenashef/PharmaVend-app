import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/login_actions.dart';

AppState loginReducer(AppState state, dynamic action) {
  if (action is LoginSuccessAction) {
    return state.copyWith(user: action.user);
  }

  return state;
}
