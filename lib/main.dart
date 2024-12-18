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

class test extends StatelessWidget {
  const test({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
