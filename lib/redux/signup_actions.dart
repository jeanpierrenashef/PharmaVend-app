import 'package:flutter_application/models/user.dart';

class SignupSuccessAction {
  final User user;
  final String token;

  SignupSuccessAction(this.user, this.token);
}
