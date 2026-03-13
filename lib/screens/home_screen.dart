import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(31.3260, 75.5762); // example location

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Ajochale"),
      ),

      body: Stack(
        children: [

          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0,
            ),
          ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,

            child: ElevatedButton(
              onPressed: () {},
              child: Text("Book Bike Ride"),
            ),
          )

        ],
      ),
    );
  }
}