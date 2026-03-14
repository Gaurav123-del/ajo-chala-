// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// import 'ride_confirm_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {

//   GoogleMapController? mapController;
//   Position? currentPosition;

//   final LatLng defaultLocation = const LatLng(31.3260, 75.5762);

//   final TextEditingController destinationController = TextEditingController();

//   final Set<Marker> markers = {};
//   final Set<Polyline> polylines = {};

//   final PolylinePoints polylinePoints = PolylinePoints();

//   String googleApiKey = "YOUR_GOOGLE_MAPS_API_KEY";

//   double estimatedFare = 0;
//   double distanceKm = 0;

//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation();
//   }

//   @override
//   void dispose() {
//     destinationController.dispose();
//     super.dispose();
//   }

//   void onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   /// ADD NEARBY RIDERS
//   void addNearbyRiders(LatLng userLocation) {

//     for (int i = 0; i < 5; i++) {

//       double lat = userLocation.latitude + (0.002 * i);
//       double lng = userLocation.longitude + (0.002 * i);

//       markers.add(
//         Marker(
//           markerId: MarkerId("rider$i"),
//           position: LatLng(lat, lng),
//           icon: BitmapDescriptor.defaultMarkerWithHue(
//             BitmapDescriptor.hueAzure,
//           ),
//           infoWindow: InfoWindow(
//             title: "Bike Rider ${i + 1}",
//           ),
//         ),
//       );
//     }

//   }

//   /// GET CURRENT LOCATION
//   Future<void> getCurrentLocation() async {

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

//       currentPosition = position;

//       /// USER PICKUP MARKER
//       markers.add(
//         Marker(
//           markerId: const MarkerId("pickup"),
//           position: userLocation,
//           infoWindow: const InfoWindow(title: "Pickup Location"),
//         ),
//       );

//       /// ADD NEARBY RIDERS
//       addNearbyRiders(userLocation);

//     });

//     mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: userLocation,
//           zoom: 15,
//         ),
//       ),
//     );
//   }

//   /// DRAW ROUTE
//   Future<void> drawRoute(LatLng destination) async {

//     if (currentPosition == null) return;

//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       request: PolylineRequest(
//         origin: PointLatLng(
//           currentPosition!.latitude,
//           currentPosition!.longitude,
//         ),
//         destination: PointLatLng(
//           destination.latitude,
//           destination.longitude,
//         ),
//         mode: TravelMode.driving,
//       ),
//       googleApiKey: googleApiKey,
//     );

//     if (result.points.isNotEmpty) {

//       List<LatLng> routePoints = [];

//       for (var point in result.points) {
//         routePoints.add(
//           LatLng(point.latitude, point.longitude),
//         );
//       }

//       setState(() {

//         polylines.clear();

//         polylines.add(
//           Polyline(
//             polylineId: const PolylineId("route"),
//             points: routePoints,
//             color: Colors.blue,
//             width: 5,
//           ),
//         );

//       });

//       calculateDistance(destination);
//     }
//   }

//   /// CALCULATE DISTANCE
//   void calculateDistance(LatLng destination) {

//     double distance = Geolocator.distanceBetween(
//       currentPosition!.latitude,
//       currentPosition!.longitude,
//       destination.latitude,
//       destination.longitude,
//     );

//     distanceKm = distance / 1000;

//     calculateFare(distanceKm);
//   }

//   /// CALCULATE FARE
//   void calculateFare(double distance) {

//     const double baseFare = 20;
//     const double perKmRate = 8;

//     setState(() {
//       estimatedFare = baseFare + (distance * perKmRate);
//     });
//   }

//   /// BOOK RIDE
//   void bookRide() {

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => RideConfirmScreen(
//           fare: estimatedFare,
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
//             onMapCreated: onMapCreated,
//             initialCameraPosition: CameraPosition(
//               target: defaultLocation,
//               zoom: 14,
//             ),
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             markers: markers,
//             polylines: polylines,
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
//                 controller: destinationController,
//                 decoration: const InputDecoration(
//                   hintText: "Enter destination",
//                   border: InputBorder.none,
//                   icon: Icon(Icons.search),
//                 ),
//                 onSubmitted: (value) {

//                   LatLng destination = const LatLng(31.5204, 75.7200);

//                   drawRoute(destination);

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
//               onPressed: bookRide,
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


import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'ride_confirm_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  GoogleMapController? mapController;
  Position? currentPosition;

  final LatLng defaultLocation = const LatLng(31.3260, 75.5762);

  final TextEditingController destinationController = TextEditingController();

  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};

  final PolylinePoints polylinePoints = PolylinePoints();

  String googleApiKey = "YOUR_GOOGLE_MAPS_API_KEY";

  double estimatedFare = 0;
  double distanceKm = 0;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  void dispose() {
    destinationController.dispose();
    super.dispose();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// ADD NEARBY RIDERS
  void addNearbyRiders(LatLng userLocation) {
    for (int i = 0; i < 5; i++) {

      double lat = userLocation.latitude + (0.002 * i);
      double lng = userLocation.longitude + (0.002 * i);

      markers.add(
        Marker(
          markerId: MarkerId("rider$i"),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: InfoWindow(
            title: "Bike Rider ${i + 1}",
          ),
        ),
      );
    }
  }

  /// GET USER LOCATION
  Future<void> getCurrentLocation() async {

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

      currentPosition = position;

      markers.add(
        Marker(
          markerId: const MarkerId("pickup"),
          position: userLocation,
          infoWindow: const InfoWindow(title: "Pickup Location"),
        ),
      );

      addNearbyRiders(userLocation);

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

  /// DRAW ROUTE
  Future<void> drawRoute(LatLng destination) async {

    if (currentPosition == null) return;

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(
          currentPosition!.latitude,
          currentPosition!.longitude,
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

        polylines.clear();

        polylines.add(
          Polyline(
            polylineId: const PolylineId("route"),
            points: routePoints,
            color: Colors.blue,
            width: 5,
          ),
        );

      });

      calculateDistance(destination);
    }
  }

  /// CALCULATE DISTANCE
  void calculateDistance(LatLng destination) {

    double distance = Geolocator.distanceBetween(
      currentPosition!.latitude,
      currentPosition!.longitude,
      destination.latitude,
      destination.longitude,
    );

    distanceKm = distance / 1000;

    calculateFare(distanceKm);
  }

  /// CALCULATE FARE
  void calculateFare(double distance) {

    const double baseFare = 20;
    const double perKmRate = 8;

    setState(() {
      estimatedFare = baseFare + (distance * perKmRate);
    });
  }

  /// BOOK RIDE
  void bookRide() {

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

      body: Stack(
        children: [

          /// GOOGLE MAP BACKGROUND
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
              target: defaultLocation,
              zoom: 14,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: markers,
            polylines: polylines,
          ),

          /// SEARCH BAR
          SafeArea(
            child: Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 6)
                ],
              ),
              child: TextField(
                controller: destinationController,
                decoration: const InputDecoration(
                  hintText: "Where are you going?",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),

          /// RECENT LOCATIONS PANEL
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [

                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text("Bus stand Hoshiarpur"),
                    subtitle: const Text("Civil Line, Hoshiarpur"),
                    trailing: const Icon(Icons.favorite_border),
                    onTap: () {

                      LatLng destination =
                          const LatLng(31.5204, 75.7200);

                      drawRoute(destination);
                    },
                  ),

                  const Divider(),

                  const ListTile(
                    leading: Icon(Icons.history),
                    title: Text("Hoshiarpur"),
                    subtitle: Text("Punjab, India"),
                    trailing: Icon(Icons.favorite_border),
                  ),

                  const Divider(),

                  const ListTile(
                    leading: Icon(Icons.history),
                    title: Text("Shimla Pahari Chowk"),
                    subtitle: Text("Saraswati Vihar, Hoshiarpur"),
                    trailing: Icon(Icons.favorite_border),
                  ),

                ],
              ),
            ),
          ),

          /// BOOK RIDE BUTTON
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: bookRide,
              child: const Text(
                "Book Bike Ride",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),

        ],
      ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Ride",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: "All Services",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.beach_access),
            label: "Travel",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),

        ],
      ),
    );
  }
}