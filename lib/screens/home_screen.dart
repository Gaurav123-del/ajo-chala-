import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  GoogleMapController? mapController;
  Position? currentPosition;

  Set<Marker> markers = {};

  TextEditingController destinationController = TextEditingController();

  final LatLng defaultLocation = const LatLng(31.3260, 75.5762);

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> getCurrentLocation() async {

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    LatLng userLocation = LatLng(position.latitude, position.longitude);

    setState(() {
      currentPosition = position;

      markers.add(
        Marker(
          markerId: const MarkerId("pickup"),
          position: userLocation,
          infoWindow: const InfoWindow(title: "Pickup Location"),
        ),
      );
    });

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: userLocation,
          zoom: 15,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajochale"),
      ),

      body: Stack(
        children: [

          /// GOOGLE MAP
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
              target: defaultLocation,
              zoom: 14,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            markers: markers,
          ),

          /// DESTINATION SEARCH BAR
          Positioned(
            top: 20,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 5)
                ],
              ),
              child: TextField(
                controller: destinationController,
                decoration: const InputDecoration(
                  hintText: "Enter destination",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),

          /// BOOK RIDE BUTTON
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Bike ride booking coming soon"),
                  ),
                );

              },
              child: const Text(
                "Book Bike Ride",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),

        ],
      ),
    );
  }
}