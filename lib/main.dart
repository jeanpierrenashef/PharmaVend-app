import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/api/firebase_api.dart';
import 'package:flutter_application/custom/app_bar.dart';
import 'package:flutter_application/custom/nav_bar.dart';
import 'package:flutter_application/firebase_options.dart';
import 'package:flutter_application/pages/login_page.dart';
import 'package:flutter_application/pages/products_page.dart';
import 'package:flutter_application/redux/root_reducer.dart';
import 'package:flutter_application/services/machine_service.dart';
import 'package:flutter_application/services/product_service.dart';
//import 'package:flutter_application/services/stripe_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:location/location.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Message received in background: ${message.notification?.title}');
}

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi.instance.allowNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await _setUp();
  runApp(MyApp());
}

Future<void> _setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51Qhjis2Ki09t4LErkg8T4s4JCvkGHhZ5RxQEZ9wAIrnHy7QUkbZDLj9VRQhcMJVsjvpN8MVrX6135ZDb3HxOHMZ6006ESRqKxr";
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
        debugShowCheckedModeBanner: false,
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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _showSearchBar = false;

  Future<void> findMachine(BuildContext context, Store<AppState> store,
      {String? productName}) async {
    setState(() {
      _isSearching = productName != null;
    });

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
        setState(() {
          _isSearching = false;
        });
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
        final List<int> sortedIndexes = List.generate(elements.length, (i) => i)
          ..sort((a, b) => elements[a]['distance']['value']
              .compareTo(elements[b]['distance']['value']));

        for (int index in sortedIndexes) {
          final machine = machines[index];

          if (productName != null) {
            await ProductService.fetchProductsByMachineId(store, machine.id);
            final products = store.state.products;

            final foundProduct = products.any((product) =>
                product.name.toLowerCase() == productName.toLowerCase());

            if (foundProduct) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setInt('selectedMachineId', machine.id);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "Product '$productName' found in machine: ${machine.location}"),
                  backgroundColor: Colors.grey,
                  duration: const Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.only(bottom: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProductPage()),
              );
              return;
            } else {
              print(
                  "Product '$productName' not found in machine: ${machine.location}");
            }
          } else {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('selectedMachineId', machine.id);

            print("Closest machine: ${machine.location}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Closest machine: ${machine.location}"),
                backgroundColor: Colors.grey,
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.only(bottom: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProductPage()),
            );
            return;
          }
        }

        if (productName != null) {
          print("Product '$productName' not found in any machine.");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Medicine '$productName' not found in any of our machines."),
              backgroundColor: Colors.grey,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } else {
        print("Failed to fetch distance matrix: ${response.statusCode}");
      }
    } catch (e) {
      print("Error searching for product: $e");
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const CustomAppBar(),
        automaticallyImplyLeading: false,
      ),
      body: StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("assets/logo.png"),
                        height: 94.0,
                        width: 45.0,
                      ),
                      const Text(
                        "PharmaVend",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        "Your 24/7 Lifesaver in a Box.",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Image(
                        image: AssetImage("assets/maps.png"),
                      ),
                    ],
                  ),
                ),
                if (!_showSearchBar)
                  Column(
                    children: [
                      Center(
                        child: ElevatedButton(
                          onPressed: () => findMachine(context, store),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(32, 181, 115, 1),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text(
                            'Find Closest Machine',
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showSearchBar = true;
                          });
                        },
                        child: const Text(
                          "Try another method",
                          style: TextStyle(
                            color: Color.fromRGBO(32, 181, 115, 1),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 42,
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: "Looking for a certain medicine?",
                                    hintStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    prefixIcon: const Icon(Icons.search),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    fillColor:
                                        Color.fromRGBO(32, 181, 115, 0.05),
                                    filled: true,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (_searchController.text.isNotEmpty) {
                                  findMachine(context, store,
                                      productName: _searchController.text);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(32, 181, 115, 1),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: _isSearching
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Search',
                                      style: TextStyle(
                                        fontFamily: "Inter",
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showSearchBar = false;
                          });
                        },
                        child: const Text(
                          "Try another method",
                          style: TextStyle(
                            color: Color.fromRGBO(32, 181, 115, 1),
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 2,
        onItemTapped: (index) {},
      ),
    );
  }
}
