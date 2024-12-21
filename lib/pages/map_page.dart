import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng _Jbeil =
      LatLng(34.115568, 35.674343); //grabbed from the db
  static const LatLng _Hamra =
      LatLng(33.896198, 35.477865); //grabbed from the db

  LatLng? _currentP;
  List<LatLng> _polylineCoordinates = [];
  late PolylinePoints _polylinePoints;

  final googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;
  String _selectedMode = "driving";
  String _distance = "-";
  String _eta = "-";

  @override
  void initState() {
    super.initState();
    _polylinePoints = PolylinePoints();
    getLocationUpdates();

    fetchClosestDestination().then((closest) {
      if (closest.isNotEmpty) {
        setState(() {
          _distance = closest['distance'];
          _eta = closest['duration'];
        });
      } else {
        print("Error fetching initial closest destination.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? const Center(
              child: Text("Loading..."),
            )
          : Column(
              children: [
                Flexible(
                  flex: 3,
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController controller) =>
                        _mapController.complete(controller),
                    initialCameraPosition: CameraPosition(
                      target: _Hamra,
                      zoom: 9,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    markers: {
                      Marker(
                        markerId: MarkerId("_JbeilLocation"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: _Jbeil,
                      ),
                      Marker(
                        markerId: MarkerId("_HamraLocation"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: _Hamra,
                      ),
                    },
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
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Closest machine",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Hamra, V12", //to be fixed soon
                                    style: TextStyle(fontSize: 14),
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
                                          final closest =
                                              await fetchClosestDestination();
                                          setState(() {
                                            _distance = closest['distance'];
                                            _eta = closest['duration'];
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                        )
                      ],
                    )),
              ],
            ),
    );
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
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) async {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
        final closest = await fetchClosestDestination();
        if (closest.isNotEmpty) {
          print("Closest Destination: ${closest['destination']}");
          print("Distance: ${closest['distance']}");
          print("ETA: ${closest['duration']}");
          _cameraToPosition(_currentP!);
          _updatePolyline();
        }
      }
    });
  }

  Future<void> _updatePolyline() async {
    if (_currentP == null) return;
    final closest = await fetchClosestDestination();
    LatLng closestDestination = closest["destination"];
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleMapsApiKey,
      request: PolylineRequest(
        origin: PointLatLng(_currentP!.latitude, _currentP!.longitude),
        destination: PointLatLng(
          closestDestination.latitude,
          closestDestination.longitude,
        ),
        mode: TravelMode.values
            .firstWhere((m) => m.toString().split('.').last == _selectedMode),
      ),
    );

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
    final String origin = "${_currentP!.latitude},${_currentP!.longitude}";
    final String destinations =
        "${_Jbeil.latitude},${_Jbeil.longitude}|${_Hamra.latitude},${_Hamra.longitude}";

    final String url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destinations&key=$apiKey&mode=$_selectedMode';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        //print("Distance Matrix Response: $data");

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
          "destination": closestIndex == 0 ? _Jbeil : _Hamra,
          "distance": elements[closestIndex]['distance']['text'],
          "duration": elements[closestIndex]['duration']['text'],
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
}
