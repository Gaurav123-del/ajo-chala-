import 'package:flutter/material.dart';

class RideConfirmScreen extends StatelessWidget {

  final double fare;

  const RideConfirmScreen({super.key, required this.fare});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Ride"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Bike Ride",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const ListTile(
              leading: Icon(Icons.location_pin, color: Colors.green),
              title: Text("Pickup Location"),
              subtitle: Text("Your current location"),
            ),

            const ListTile(
              leading: Icon(Icons.flag, color: Colors.red),
              title: Text("Destination"),
              subtitle: Text("Selected destination"),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                    "Estimated Fare",
                    style: TextStyle(fontSize: 18),
                  ),

                  Text(
                    "₹${fare.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                ),
                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Searching for nearby rider..."),
                    ),
                  );

                },
                child: const Text(
                  "Confirm Ride",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}