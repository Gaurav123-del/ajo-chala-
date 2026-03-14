import 'package:flutter/material.dart';
import 'rating_screen.dart';

class TripCompletedScreen extends StatelessWidget {

  final double fare;

  const TripCompletedScreen({super.key, required this.fare});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Completed"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),

            const SizedBox(height: 20),

            const Text(
              "Ride Completed",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Total Fare: ₹${fare.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 40),

            /// RATE RIDE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RatingScreen(),
                    ),
                  );

                },
                child: const Text("Rate Ride"),
              ),
            ),

            const SizedBox(height: 15),

            /// BACK HOME BUTTON
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {

                  Navigator.popUntil(context, (route) => route.isFirst);

                },
                child: const Text("Back to Home"),
              ),
            )

          ],
        ),
      ),
    );
  }
}