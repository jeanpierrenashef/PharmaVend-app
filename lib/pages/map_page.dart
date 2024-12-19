import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _pGooglePlex = LatLng(33.833905, 35.591587);
  static const LatLng _Jbeil = LatLng(34.115568, 35.674343);
  static const LatLng _Hamra = LatLng(33.896198, 35.477865);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _pGooglePlex,
        zoom: 9,
      ),
      markers: {
        Marker(
            markerId: MarkerId("_currentLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pGooglePlex),
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
}
