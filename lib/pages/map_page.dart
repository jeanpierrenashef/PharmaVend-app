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
  @override
  void initState() {
    super.initState();
    _polylinePoints = PolylinePoints();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? const Center(
              child: Text("Loading..."),
            )
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) =>
                  _mapController.complete(controller),
              initialCameraPosition: CameraPosition(
                target:
                    _Hamra, //here target should be automatically the closest
                zoom: 9,
              ),
              myLocationEnabled:
                  true, // Enables the blue circle for user location
              myLocationButtonEnabled:
                  true, // Adds the location button on the map
              markers: {
                // Marker(
                //   markerId: MarkerId("_sourceLocation"),
                //   icon: BitmapDescriptor.defaultMarker,
                //   position: _currentP!,
                // ),
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
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
        _cameraToPosition(_currentP!);
        _updatePolyline();
      }
    });
  }

  Future<void> _updatePolyline() async {
    if (_currentP == null) return;
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleMapsApiKey,
      request: PolylineRequest(
        origin: PointLatLng(_currentP!.latitude, _currentP!.longitude),
        destination: PointLatLng(_Hamra.latitude, _Hamra.longitude),
        mode: TravelMode.driving,
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
      print("Distance Matrix Response: $data");
    }
  }catch{}
  }
}
