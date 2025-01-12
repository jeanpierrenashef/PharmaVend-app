import 'dart:convert';
import 'package:flutter_application/models/user.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/signup_actions.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignupService {
  static Future<void> registerUser(
    Store<AppState> store,
    String username,
    String email,
    String password, {
    String? token, // Optional token parameter
  }) async {
    try {
      // Prepare request body
      final requestBody = {
        "username": username,
        "email": email,
        "password": password,
      };

      // Make HTTP POST request
      final response = await http.post(
        Uri.parse("http://192.168.1.7:8000/api/register"),
        headers: {
          "Content-Type": "application/json",
          if (token != null)
            "Authorization": "Bearer $token", // Add token if provided
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);

        final user = User.fromJson(responseData['user']);
        final newToken = responseData['token'];

        store.dispatch(SignupSuccessAction(user, newToken));

        // Save the token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', newToken);

        print("Signup successful. User: ${user.username}, Token: $newToken");
      } else {
        print("Signup failed with status code: ${response.statusCode}");
        print("Error message: ${response.body}");
      }
    } catch (e) {
      print("Signup error: $e");
    }
  }
}
