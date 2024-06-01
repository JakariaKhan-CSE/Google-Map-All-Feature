import 'package:complete_location_feature/screen/current_location.dart';
import 'package:complete_location_feature/screen/google_place_api_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GooglePlaceApiScreen(),
      // home: CurrentLocation(),
    );
  }
}

