import 'package:flutter/material.dart';
import 'package:flutter_application/main.dart';
import 'package:flutter_application/pages/signup_page.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/services/login_service.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _signup(context)
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return const Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage("assets/logo.png"),
            height: 80.0,
            width: 40.0,
          ),
          SizedBox(width: 12),
          Column(
            children: [
              Text(
                "PharmaVend",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Your 24/7 Lifesaver in a Box.",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          )
        ],
      ),
      SizedBox(
        height: 48,
      ),
      Column(
        children: [
          Text(
            "Welcome Back",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Text("Enter your credential to login"),
        ],
      )
    ]);
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
              hintText: "Username",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Color.fromRGBO(32, 181, 115, 0.1),
              filled: true,
              prefixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Color.fromRGBO(32, 181, 115, 0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.only(top: 3, left: 3),
          child: StoreConnector<AppState, dynamic>(
            converter: (store) => store,
            builder: (context, store) {
              return ElevatedButton(
                onPressed: () async {
                  final isSuccess = await LoginService.loginUser(
                    store,
                    _usernameController.text,
                    _passwordController.text,
                  );
                  if (isSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Invalid username or password. Please try again."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromRGBO(32, 181, 115, 1),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account? "),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignupPage()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
              color: Color.fromRGBO(32, 181, 115, 1),
            ),
          ),
        )
      ],
    );
  }
}
