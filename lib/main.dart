import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () => print("pressed on info"),
                    icon: Image.asset("")),
                IconButton(
                    onPressed: () => print("pressed on menu"),
                    icon: Image.asset(""))
              ],
            )),
        body: Center(
          child: Column(children: [
            Image(
              image: AssetImage("assets/logo.png"),
              height: 94.0,
              width: 45.0,
            ),
            Text(
              "PharmaVend",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Your 24/7 Lifesaver in a Box.",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20.0),
            Image(
              image: AssetImage("assets/map.png"),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Text(
                  'Find a Machine',
                  style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ]),
        ));
  }
}
