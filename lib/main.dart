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
                  return Colors.blue.withValues(alpha: 0.8);
                }
                if (states.contains(WidgetState.hovered)) {
                  return Colors.blue.withValues(alpha: 0.6);
                }
                if (states.contains(WidgetState.focused)) {
                  return Colors.blue.withValues(alpha: 0.7);
                }
                return Colors.blue;
              },
            ),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            overlayColor: WidgetStateProperty.all<Color>(
              Colors.white.withValues(alpha: 0.2),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          onPressed: () {
            print("Button Pressed!");
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Text(
              'Custom Button',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    ),
  ));
}
