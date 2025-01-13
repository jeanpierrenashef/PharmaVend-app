import 'dart:convert';
import 'package:flutter_application/models/user.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/signup_actions.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

class SignupService {
  static Future<void> registerUser(Store<AppState> store, String username,
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.7:8000/api/register"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);

        final user = User.fromJson(responseData['user']);
        final token = responseData['token'];

        store.dispatch(SignupSuccessAction(user, token));

        print("Signup successful. User: ${user.username}, Token: $token");
      } else {
        print("Signup failed with status code: ${response.statusCode}");
        print("Error message: ${response.body}");
      }
    } catch (e) {
      print("Signup error: $e");
    }
  }
}
