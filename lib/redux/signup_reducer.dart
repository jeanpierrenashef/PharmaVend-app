import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/signup_actions.dart';

AppState signupReducer(AppState state, dynamic action) {
  if (action is SignupSuccessAction) {
    return state.copyWith(user: action.user);
  }

  return state;
}
