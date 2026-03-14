import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'trip_completed_screen.dart';

class RideTrackingScreen extends StatelessWidget {
  const RideTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ride in Progress"),
      ),

      body: Stack(
        children: [

          /// GOOGLE MAP
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(31.3260, 75.5762),
              zoom: 14,
            ),
            myLocationEnabled: true,
          ),

          /// RIDE INFO PANEL
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 6)
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text(
                    "Rider arriving in 4 mins",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text("Bike: PB07 AB 1234"),

                  const SizedBox(height: 20),

                  /// END RIDE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const TripCompletedScreen(fare: 120),
                          ),
                        );

                      },
                      child: const Text("End Ride"),
                    ),
                  )

                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}