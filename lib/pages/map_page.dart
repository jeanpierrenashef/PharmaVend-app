import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/custom/nav_bar.dart';
import 'package:flutter_application/models/machine.dart';
import 'package:flutter_application/pages/cart_page.dart';
import 'package:flutter_application/pages/products_page.dart';
import 'package:flutter_application/redux/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redux/redux.dart';
import 'package:flutter_application/services/machine_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Future<void> saveMachineId(int machineId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedMachineId', machineId);
    _userSelected = true;
  }

  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  StreamSubscription<LocationData>? _locationSubscription;

  LatLng? _currentP;
  List<LatLng> _polylineCoordinates = [];
  late PolylinePoints _polylinePoints;

  final googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;
  String _selectedMode = "driving";
  String _distance = "-";
  String _eta = "-";
  Machine? _selectedMachine;
  bool _userSelected = false;
  bool _isMachinesFetched = false;

  final Map<int, String> _machineDistances = {};
  final Map<int, String> _machineETAs = {};

  @override
  void initState() {
    super.initState();
    _polylinePoints = PolylinePoints();
    getLocationUpdates();
    Future.delayed(const Duration(seconds: 2), () async {
      if (_currentP != null) {
        await fetchAndUpdateClosestDestination();
      } else {
        print("Current position (_currentP) is still null after delay.");
      }
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isMachinesFetched) {
      final store = StoreProvider.of<AppState>(context);

      MachineService.fetchMachines(store).then((_) {
        final machines = store.state.machines;
        print(
            "Machines fetched in MapPage: ${machines.map((m) => m.location).toList()}");

        if (machines.isNotEmpty) {
          setState(() {
            _isMachinesFetched = true;
          });
          loadSavedMachine();
        }
      });
    } else if (_selectedMachine != null && _polylineCoordinates.isEmpty) {
      _updatePolyline(LatLng(
        _selectedMachine!.latitude,
        _selectedMachine!.longitude,
      ));
    }
  }

  Future<void> loadSavedMachine() async {
    final prefs = await SharedPreferences.getInstance();
    final machineId = prefs.getInt('selectedMachineId');

    if (machineId != null) {
      final Store<AppState> store = StoreProvider.of<AppState>(context);
      final List<Machine> machines = store.state.machines;

      final savedMachine = machines.firstWhere((m) => m.id == machineId);

      setState(() {
        _selectedMachine = savedMachine;
        _userSelected = true;
      });

      await _updatePolyline(
          LatLng(savedMachine.latitude, savedMachine.longitude));
      await _cameraToPosition(
          LatLng(savedMachine.latitude, savedMachine.longitude));
      setState(() {
        _distance = "Fetching...";
        _eta = "Fetching...";
      });
      await fetchThisDestination(savedMachine);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Machine>>(
      converter: (store) {
        final machines = store.state.machines;
        return machines;
      },
      builder: (context, machines) {
        if (!_isMachinesFetched || machines.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          body: _currentP == null
              ? const Center(
                  child: Text("Loading..."),
                )
              : Column(
                  children: [
                    Flexible(
                      flex: 7,
                      child: GoogleMap(
                        onMapCreated: (GoogleMapController controller) =>
                            _mapController.complete(controller),
                        initialCameraPosition: machines.isNotEmpty
                            ? CameraPosition(
                                target: LatLng(machines[1].latitude,
                                    machines[1].longitude),
                                zoom: 9,
                              )
                            : const CameraPosition(
                                target: LatLng(0, 0), zoom: 1),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        markers: machines
                            .map(
                              (machine) => Marker(
                                markerId: MarkerId(machine.location),
                                icon: BitmapDescriptor.defaultMarker,
                                position: LatLng(
                                  machine.latitude,
                                  machine.longitude,
                                ),
                              ),
                            )
                            .toSet(),
                        polylines: {
                          Polyline(
                            polylineId: const PolylineId("route"),
                            points: _polylineCoordinates,
                            color: Colors.blue,
                            width: 5,
                          ),
                        },
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 5,
                            ),
                            height: 90,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Selected machine",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _selectedMachine != null
                                          ? _selectedMachine!.location
                                          : "Loading...",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          _selectedMode == "driving"
                                              ? Icons.directions_car
                                              : _selectedMode == "walking"
                                                  ? Icons.directions_walk
                                                  : Icons.directions_bike,
                                          size: 24,
                                        ),
                                        DropdownButton<String>(
                                          value: _selectedMode,
                                          underline: const SizedBox(),
                                          items: const [
                                            DropdownMenuItem(
                                              value: "driving",
                                              child: Text("Driving"),
                                            ),
                                            DropdownMenuItem(
                                              value: "walking",
                                              child: Text("Walking"),
                                            ),
                                            DropdownMenuItem(
                                              value: "bicycling",
                                              child: Text("Bicycling"),
                                            ),
                                          ],
                                          onChanged: (value) async {
                                            setState(() {
                                              _selectedMode = value!;
                                            });

                                            if (_selectedMachine != null) {
                                              await fetchThisDestination(
                                                  _selectedMachine!);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Distance",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _distance,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "ETA",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _eta,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: machines
                                  .where((machine) =>
                                      _selectedMachine == null ||
                                      machine.location !=
                                          _selectedMachine!.location)
                                  .length,
                              itemBuilder: (context, index) {
                                final filteredMachines = machines
                                    .where((machine) =>
                                        _selectedMachine == null ||
                                        machine.location !=
                                            _selectedMachine!.location)
                                    .toList();

                                final otherMachine = filteredMachines[index];
                                if (!_machineDistances
                                    .containsKey(otherMachine.id)) {
                                  fetchMachineData(otherMachine);
                                }

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            otherMachine.location,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              setState(() {
                                                _userSelected = true;
                                              });
                                              await fetchThisDestination(
                                                  otherMachine);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      32, 181, 115, 1),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                            ),
                                            child: const Text(
                                              "Select",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Distance: ${_machineDistances[otherMachine.id] ?? 'Fetching...'}",
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            "ETA: ${_machineETAs[otherMachine.id] ?? 'Fetching...'}",
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: 1,
            onItemTapped: (index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProductPage()),
                  );
                  break;
                case 1:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MapPage()),
                  );
                  break;
                case 2:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                  break;
                case 3:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                  break;
                case 4:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                  break;
              }
            },
          ),
        );
      },
    );
  }

  Future<void> fetchMachineData(Machine machine) async {
    if (_currentP == null) return;

    final String origin = "${_currentP!.latitude},${_currentP!.longitude}";
    final String destination = "${machine.latitude},${machine.longitude}";

    final String url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destination&key=$googleMapsApiKey&mode=$_selectedMode';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final distance = data['rows'][0]['elements'][0]['distance']['text'];
        final duration = data['rows'][0]['elements'][0]['duration']['text'];

        setState(() {
          _machineDistances[machine.id] = distance;
          _machineETAs[machine.id] = duration;
        });
      }
    } catch (e) {
      print("Error fetching machine data: $e");
    }
  }

  Future<void> fetchThisDestination(Machine selectedMachine) async {
    if (_currentP == null) return;

    final String origin = "${_currentP!.latitude},${_currentP!.longitude}";
    final String destination =
        "${selectedMachine.latitude},${selectedMachine.longitude}";

    final String url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destination&key=$googleMapsApiKey&mode=$_selectedMode';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final distance = data['rows'][0]['elements'][0]['distance']['text'];
        final duration = data['rows'][0]['elements'][0]['duration']['text'];

        setState(() {
          _selectedMachine = selectedMachine;
          _distance = distance;
          _eta = duration;
        });
        //localStorage.setItem('machineID', _selectedMachine!.id.toString());
        await saveMachineId(selectedMachine.id);

        await _updatePolyline(
          LatLng(selectedMachine.latitude, selectedMachine.longitude),
        );
        await _cameraToPosition(
          LatLng(selectedMachine.latitude, selectedMachine.longitude),
        );
      }
    } catch (e) {
      print("Error fetching this destination: $e");
    }
  }

  Future<void> _updatePolyline(LatLng destination) async {
    if (_currentP == null) return;

    final result = await _polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleMapsApiKey,
        request: PolylineRequest(
          origin: PointLatLng(_currentP!.latitude, _currentP!.longitude),
          destination: PointLatLng(destination.latitude, destination.longitude),
          mode: TravelMode.values
              .firstWhere((m) => m.toString().split('.').last == _selectedMode),
        ));

    if (result.points.isNotEmpty) {
      setState(() {
        _polylineCoordinates = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
      });
    } else {
      print("Error retrieving polyline: ${result.errorMessage}");
    }
  }

  Future<Map<String, dynamic>> fetchClosestDestination() async {
    final String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;
    if (_currentP == null) {
      print("Current position is missing.");
      return {};
    }

    final String origin = "${_currentP!.latitude},${_currentP!.longitude}";

    final Store<AppState> store = StoreProvider.of<AppState>(context);
    final List<Machine> machines = store.state.machines;

    final String destinations = machines
        .map((machine) => "${machine.latitude},${machine.longitude}")
        .join('|');

    final String url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destinations&key=$apiKey&mode=$_selectedMode';

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

        return {
          "destination": LatLng(
            machines[closestIndex].latitude,
            machines[closestIndex].longitude,
          ),
          "distance": elements[closestIndex]['distance']['text'],
          "duration": elements[closestIndex]['duration']['text'],
          "name": machines[closestIndex].location
        };
      } else {
        print("Failed to fetch distance: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      print("Error fetching Distance Matrix: $e");
      return {};
    }
  }

  Future<void> fetchAndUpdateClosestDestination() async {
    if (_userSelected || _selectedMachine != null) {
      return;
    }
    final closest = await fetchClosestDestination();
    if (closest.isNotEmpty) {
      final Store<AppState> store = StoreProvider.of<AppState>(context);
      final List<Machine> machines = store.state.machines;

      setState(() {
        _selectedMachine = machines.firstWhere(
          (machine) => machine.location == closest['name'],
        );
        _distance = closest['distance'];
        _eta = closest['duration'];
      });
      await saveMachineId(_selectedMachine!.id);

      await _updatePolyline(
        LatLng(_selectedMachine!.latitude, _selectedMachine!.longitude),
      );
      await _cameraToPosition(
        LatLng(_selectedMachine!.latitude, _selectedMachine!.longitude),
      );
    }
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
    }

    DateTime lastUpdate = DateTime.now();

    _locationSubscription = _locationController.onLocationChanged
        .listen((LocationData currentLocation) async {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });

        if (DateTime.now().difference(lastUpdate) >
            const Duration(seconds: 50)) {
          lastUpdate = DateTime.now();

          if (_selectedMachine != null) {
            await fetchThisDestination(_selectedMachine!);
          } else {
            await fetchAndUpdateClosestDestination();
          }
        }
      }
    });
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: 9,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }
}
