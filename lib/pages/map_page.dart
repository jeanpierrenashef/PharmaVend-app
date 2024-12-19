import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  //static const LatLng _pGooglePlex = LatLng(33.833905, 35.591587);
  static const LatLng _Jbeil = LatLng(34.115568, 35.674343);
  static const LatLng _Hamra = LatLng(33.896198, 35.477865);

  LatLng? _currentP;
  @override
  void initState() {
    super.initState();
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
                onMapCreated: ((GoogleMapController controller) =>
                    _mapController.complete(controller)),
                initialCameraPosition: CameraPosition(
                  target: _Hamra,
                  zoom: 9,
                ),
                markers: {
                  Marker(
                      markerId: MarkerId("_sourceLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _currentP!),
                  Marker(
                      markerId: MarkerId("_JbeilLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _Jbeil),
                  Marker(
                      markerId: MarkerId("_HamraLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _Hamra),
                },
              ));
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
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }
    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentP!);
        });
        //print(_currentP);
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineRequest result = await polylinePoints.getRouteBetweenCoordinates();
  }
}
