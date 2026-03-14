import 'package:flutter/material.dart';
import 'ride_tracking_screen.dart';

class SearchingRiderScreen extends StatefulWidget {
  const SearchingRiderScreen({super.key});

  @override
  State<SearchingRiderScreen> createState() => _SearchingRiderScreenState();
}

class _SearchingRiderScreenState extends State<SearchingRiderScreen> {

  @override
  void initState() {
    super.initState();

    /// simulate rider search
    Future.delayed(const Duration(seconds: 5), () {

      if (mounted) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const RideTrackingScreen(),
          ),
        );

      }

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Finding Rider"),
      ),

      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CircularProgressIndicator(),

            SizedBox(height: 20),

            Text(
              "Searching for nearby bike rider...",
              style: TextStyle(
                fontSize: 18,
              ),
            ),

          ],
        ),
      ),

    );
  }
}