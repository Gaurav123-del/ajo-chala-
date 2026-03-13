import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(AjochaleApp());
}

class AjochaleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ajochale',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: SplashScreen(),
    );
  }
}