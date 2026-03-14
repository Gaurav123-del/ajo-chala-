// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {

//   GoogleMapController? _mapController;
//   Position? _currentPosition;

//   final LatLng _defaultLocation = const LatLng(31.3260, 75.5762);

//   final TextEditingController _destinationController = TextEditingController();

//   final Set<Marker> _markers = {};
//   final Set<Polyline> _polylines = {};

//   PolylinePoints polylinePoints = PolylinePoints();

//   String googleApiKey = "AIzaSyBEoV5Xa1HaM97mdXERpFm44jkDd_QWVOY";

//   double distanceKm = 0;
//   double estimatedFare = 0;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   @override
//   void dispose() {
//     _destinationController.dispose();
//     super.dispose();
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//   }

//   Future<void> _getCurrentLocation() async {

//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return;

//     LocationPermission permission = await Geolocator.checkPermission();

//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }

//     if (permission == LocationPermission.deniedForever) return;

//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     LatLng userLocation = LatLng(position.latitude, position.longitude);

//     setState(() {
//       _currentPosition = position;

//       _markers.add(
//         Marker(
//           markerId: const MarkerId("pickup"),
//           position: userLocation,
//           infoWindow: const InfoWindow(title: "Pickup Location"),
//         ),
//       );
//     });

//     _mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: userLocation,
//           zoom: 15,
//         ),
//       ),
//     );
//   }

//   Future<void> _drawRoute(LatLng destination) async {

//     if (_currentPosition == null) return;

//     PolylineResult result =
//         await polylinePoints.getRouteBetweenCoordinates(
//       googleApiKey,
//       PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
//       PointLatLng(destination.latitude, destination.longitude),
//     );

//     if (result.points.isNotEmpty) {

//       List<LatLng> routePoints = [];

//       for (var point in result.points) {
//         routePoints.add(
//           LatLng(point.latitude, point.longitude),
//         );
//       }

//       setState(() {

//         _polylines.clear();

//         _polylines.add(
//           Polyline(
//             polylineId: const PolylineId("route"),
//             points: routePoints,
//             color: Colors.blue,
//             width: 5,
//           ),
//         );

//       });

//       _calculateDistance(destination);
//     }
//   }

//   void _calculateDistance(LatLng destination) {

//     double distance = Geolocator.distanceBetween(
//       _currentPosition!.latitude,
//       _currentPosition!.longitude,
//       destination.latitude,
//       destination.longitude,
//     );

//     distanceKm = distance / 1000;

//     _calculateFare(distanceKm);
//   }

//   void _calculateFare(double distance) {

//     const double baseFare = 20;
//     const double perKmRate = 8;

//     setState(() {
//       estimatedFare = baseFare + (distance * perKmRate);
//     });
//   }

//   void _bookRide() {

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           "Ride booked! Estimated Fare ₹${estimatedFare.toStringAsFixed(2)}",
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Ajochale"),
//       ),

//       body: Stack(
//         children: [

//           /// GOOGLE MAP
//           GoogleMap(
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: CameraPosition(
//               target: _defaultLocation,
//               zoom: 14,
//             ),
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             markers: _markers,
//             polylines: _polylines,
//           ),

//           /// DESTINATION SEARCH
//           Positioned(
//             top: 20,
//             left: 15,
//             right: 15,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: const [
//                   BoxShadow(color: Colors.black26, blurRadius: 6)
//                 ],
//               ),
//               child: TextField(
//                 controller: _destinationController,
//                 decoration: const InputDecoration(
//                   hintText: "Enter destination",
//                   border: InputBorder.none,
//                   icon: Icon(Icons.search),
//                 ),
//                 onSubmitted: (value) {

//                   /// Demo destination
//                   LatLng destination = const LatLng(31.5204, 75.7200);

//                   _drawRoute(destination);
//                 },
//               ),
//             ),
//           ),

//           /// FARE DISPLAY
//           Positioned(
//             bottom: 90,
//             left: 20,
//             right: 20,
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: const [
//                   BoxShadow(color: Colors.black26, blurRadius: 6)
//                 ],
//               ),
//               child: Text(
//                 "Estimated Fare: ₹${estimatedFare.toStringAsFixed(2)}",
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),

//           /// BOOK RIDE BUTTON
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               onPressed: _bookRide,
//               child: const Text(
//                 "Book Bike Ride",
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),

//         ],
//       ),
//     );
//   }
// }
import 'package:ajochale_app/screens/ride_confirm_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

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

  final PolylinePoints polylinePoints = PolylinePoints();

  String googleApiKey = "YOUR_GOOGLE_MAPS_API_KEY";

  double distanceKm = 0;
  double estimatedFare = 0;

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

    LatLng userLocation = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentPosition = position;

      _markers.add(
        Marker(
          markerId: const MarkerId("pickup"),
          position: userLocation,
          infoWindow: const InfoWindow(title: "Pickup Location"),
        ),
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: userLocation,
          zoom: 15,
        ),
      ),
    );
  }

  Future<void> _drawRoute(LatLng destination) async {

    if (_currentPosition == null) return;

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        destination: PointLatLng(
          destination.latitude,
          destination.longitude,
        ),
        mode: TravelMode.driving,
      ),
      googleApiKey: googleApiKey,
    );

    if (result.points.isNotEmpty) {

      List<LatLng> routePoints = [];

      for (var point in result.points) {
        routePoints.add(
          LatLng(point.latitude, point.longitude),
        );
      }

      setState(() {

        _polylines.clear();

        _polylines.add(
          Polyline(
            polylineId: const PolylineId("route"),
            points: routePoints,
            color: Colors.blue,
            width: 5,
          ),
        );

      });

      _calculateDistance(destination);
    }
  }

  void _calculateDistance(LatLng destination) {

    double distance = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      destination.latitude,
      destination.longitude,
    );

    distanceKm = distance / 1000;

    _calculateFare(distanceKm);
  }

  void _calculateFare(double distance) {

    const double baseFare = 20;
    const double perKmRate = 8;

    setState(() {
      estimatedFare = baseFare + (distance * perKmRate);
    });
  }
void _bookRide() {

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RideConfirmScreen(
        fare: estimatedFare,
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
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _defaultLocation,
              zoom: 14,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _markers,
            polylines: _polylines,
          ),

          /// DESTINATION SEARCH
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
                  BoxShadow(color: Colors.black26, blurRadius: 6)
                ],
              ),
              child: TextField(
                controller: _destinationController,
                decoration: const InputDecoration(
                  hintText: "Enter destination",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
                onSubmitted: (value) {

                  /// Example destination (demo)
                  LatLng destination = const LatLng(31.5204, 75.7200);

                  _drawRoute(destination);
                },
              ),
            ),
          ),

          /// FARE DISPLAY
          Positioned(
            bottom: 90,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 6)
                ],
              ),
              child: Text(
                "Estimated Fare: ₹${estimatedFare.toStringAsFixed(2)}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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