import 'package:flutter_application/models/user.dart';

class LoginSuccessAction {
  final User user;
  final String token;

  LoginSuccessAction(this.user, this.token);
}
