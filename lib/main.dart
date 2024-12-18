import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text("Custom Button Example"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return const Color.fromRGBO(32, 181, 115, 100)
                      .withValues(alpha: 0.8);
                }
                if (states.contains(WidgetState.hovered)) {
                  return const Color.fromRGBO(32, 181, 115, 100)
                      .withValues(alpha: 0.6);
                }
                if (states.contains(WidgetState.focused)) {
                  return const Color.fromRGBO(32, 181, 115, 100)
                      .withValues(alpha: 0.7);
                }
                return const Color.fromRGBO(32, 181, 115, 100);
              },
            ),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            overlayColor: WidgetStateProperty.all<Color>(
              Colors.white.withValues(alpha: 0.2),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          onPressed: () {
            print("Button Pressed!");
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Text(
              'Find a Machine',
              style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    ),
  ));
}
