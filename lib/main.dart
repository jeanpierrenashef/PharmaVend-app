import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/custom/app_bar.dart';
import 'package:flutter_application/pages/login_page.dart';
import 'package:flutter_application/pages/products_page.dart';
import 'package:flutter_application/redux/root_reducer.dart';
import 'package:flutter_application/services/machine_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:location/location.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Store<AppState> _store = Store<AppState>(
    rootReducer,
    initialState:
        AppState(products: [], machines: [], cart: [], transactions: []),
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: _store,
      child: MaterialApp(
        title: "Demo",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(32, 181, 115, 1)),
          useMaterial3: true,
        ),
        home: LoginPage(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  Future<void> findClosestMachine(
      BuildContext context, Store<AppState> store) async {
    // Fetch current location
    final locationController = Location();
    final currentLocation = await locationController.getLocation();
    final LatLng currentPosition = LatLng(
      currentLocation.latitude ?? 0.0,
      currentLocation.longitude ?? 0.0,
    );

    if (store.state.machines.isEmpty) {
      print("Fetching machines...");
      await MachineService.fetchMachines(store);
      if (store.state.machines.isEmpty) {
        print("No machines found even after fetching.");
        return;
      }
    }

    final machines = store.state.machines;
    final String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;
    final destinations =
        machines.map((m) => "${m.latitude},${m.longitude}").join('|');
    final url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${currentPosition.latitude},${currentPosition.longitude}&destinations=$destinations&key=$apiKey&mode=driving';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List elements = data['rows'][0]['elements'];
        int closestIndex = 0;
        int shortestDistance = elements[0]['distance']['value'];

        for (int i = 1; i < elements.length; i++) {
          if (elements[i]['distance']['value'] < shortestDistance) {
            closestIndex = i;
            shortestDistance = elements[i]['distance']['value'];
          }
        }

        final closestMachine = machines[closestIndex];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('selectedMachineId', closestMachine.id);

        print("Closest machine: ${closestMachine.location}");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProductPage()),
        );
      } else {
        print("Failed to fetch distance matrix: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching closest machine: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar:
            AppBar(backgroundColor: Colors.white, title: const CustomAppBar()),
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
              image: AssetImage("assets/maps.png"),
            ),
            SizedBox(height: 20.0),
            StoreConnector<AppState, Store<AppState>>(
              converter: (store) => store,
              builder: (context, store) {
                return ElevatedButton(
                  onPressed: () => findClosestMachine(context, store),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(32, 181, 115, 1),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Find a Machine',
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ]),
        ));
  }
}
