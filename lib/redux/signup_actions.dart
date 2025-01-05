import 'package:flutter_application/models/user.dart';

class StartSignupAction {}

class SignupSuccessAction {
  final User user;
  final String token;

  SignupSuccessAction(this.user, this.token);
}

class SignupFailureAction {
  final String error;

  SignupFailureAction(this.error);
}

StartSignupAction startSignupAction() => StartSignupAction();

SignupSuccessAction signupSuccessAction(User user, String token) =>
    SignupSuccessAction(user, token);

SignupFailureAction signupFailureAction(String error) =>
    SignupFailureAction(error);
