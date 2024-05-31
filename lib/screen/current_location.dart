import 'dart:async';

import 'package:complete_location_feature/screen/widget/current_location_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition initialPositionCamera = CameraPosition(
      target: LatLng(23.175917, 89.191708),
    zoom: 14
  );

  List<Marker> _marker = [
    const Marker(markerId: MarkerId('initial Position'),
    position: LatLng(23.175917, 89.191708),
      infoWindow: InfoWindow(title: "This is inital position")
    )
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Current Location Google Map'),
          elevation: 10,
          backgroundColor: Colors.lightGreenAccent,
        ),
        body: Column(
          children: [
            Expanded(child: GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(23.175917, 89.191708),
                zoom: 14
              ),
              markers: Set<Marker>.of(_marker),
            ),

            ),
            GestureDetector(
              onTap: () {
                print("click");
              },
              child: const CurrentLocationButton(),
            )
          ],
        ),
      ),
    );
  }
}
