import 'package:flutter/material.dart';
import 'package:flutter_application/models/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application/pages/map_page.dart';
import 'package:flutter_application/pages/products_page.dart';

import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_application/redux/reducer.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Store<AppState> _store = Store<AppState>(loadProductsReducer,
      initialState: AppState(products: [
        Product(
          id: '1',
          name: 'Panadol (12 tablets)',
          description: 'Pain reliever and fever reducer',
          category: 'First Aid',
          price: 5.0,
          image: 'https://www.linkpicture.com/q/panadol.png',
        ),
        Product(
          id: '2',
          name: 'Surgical gloves (1 pair)',
          description: 'Sterile gloves for medical use',
          category: 'Skin Care',
          price: 2.0,
          image: 'https://www.linkpicture.com/q/gloves.png',
        ),
      ]));
  //const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: _store,
      child: MaterialApp(
        title: "Demo",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: ProductPage(),
      ),
    );
  }
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
                    icon: Image.asset(
                      "assets/info.png",
                      height: 30,
                      width: 30,
                    )),
                IconButton(
                    onPressed: () => print("pressed on menu"),
                    icon: Image.asset(
                      "assets/menu.png",
                      height: 30,
                      width: 30,
                    ))
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapPage()),
                );
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
