import 'dart:convert';
import 'package:flutter_application/models/user.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/login_actions.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static Future<bool> loginUser(
      Store<AppState> store, String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.7:8000/api/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final user = User.fromJson(responseData['user']);
        final token = responseData['token'];

        store.dispatch(LoginSuccessAction(user, token));
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);

        print("Login successful. User: ${user.username}, Token: $token");
        return true;
      } else {
        print("Login failed with status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }
}
