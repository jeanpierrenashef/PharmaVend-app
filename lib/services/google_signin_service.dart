import 'dart:convert';
import 'package:flutter_application/models/user.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/login_actions.dart';
import 'package:flutter_application/redux/signup_actions.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInService {
  static Future<void> handleGoogleUser(
    Store<AppState> store,
    String email,
    String username,
    String token,
  ) async {
    try {
      final checkResponse = await http.post(
        Uri.parse("http://192.168.1.7:8000/api/check_user"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}),
      );

      if (checkResponse.statusCode == 200) {
        final responseData = json.decode(checkResponse.body);
        final user = User.fromJson(responseData['user']);
        final token = responseData['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);

        store.dispatch(LoginSuccessAction(user, token));

        print("Login successful. User: ${user.username}, Token: $token");
      } else if (checkResponse.statusCode == 404) {
        final addResponse = await http.post(
          Uri.parse("http://192.168.1.7:8000/api/register_google"),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "email": email,
            "username": username,
            "password": "google_auth",
          }),
        );

        if (addResponse.statusCode == 201) {
          final responseData = json.decode(addResponse.body);
          final user = User.fromJson(responseData['user']);
          final newToken = responseData['token'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', newToken);

          store.dispatch(SignupSuccessAction(user, newToken));

          print("New user created and token saved.");
        } else {
          print("Error adding user. Status: ${addResponse.statusCode}");
        }
      } else {
        print("Unexpected error: ${checkResponse.statusCode}");
      }
    } catch (e) {
      print("Error handling Google user: $e");
    }
  }
}
