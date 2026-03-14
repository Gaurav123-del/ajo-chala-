import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  GoogleMapController? _mapController;
  Position? _currentPosition;

  final LatLng _defaultLocation = const LatLng(31.3260, 75.5762);

  final TextEditingController _destinationController = TextEditingController();

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _getCurrentLocation() async {

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    LatLng userLatLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentPosition = position;

      _markers.add(
        Marker(
          markerId: const MarkerId("pickup"),
          position: userLatLng,
          infoWindow: const InfoWindow(title: "Pickup Location"),
        ),
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: userLatLng,
          zoom: 15,
        ),
      ),
    );
  }

  void _bookRide() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Bike ride booking feature coming soon 🚲"),
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
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _defaultLocation,
              zoom: 14,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            markers: _markers,
            polylines: _polylines,
          ),

          /// DESTINATION SEARCH BOX
          Positioned(
            top: 20,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                  )
                ],
              ),
              child: TextField(
                controller: _destinationController,
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
              onPressed: _bookRide,
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