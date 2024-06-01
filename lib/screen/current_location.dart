import 'dart:async';

import 'package:complete_location_feature/screen/widget/current_location_button.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  String? name;   // from placemark[1]
  String? street;
  String? counrty;
  String? administrative;
  String? subAdministrative;
  String? locality;  // from placemark[2]

  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition initialPositionCamera = CameraPosition(
      target: LatLng(23.175917, 89.191708),
    zoom: 14
  );

  List<Marker> _marker = [
    const Marker(markerId: MarkerId('initial Position'),
    position: LatLng(23.175917, 89.191708),
      infoWindow: InfoWindow(title: "This is initial position")
    ),
    // Marker(markerId: MarkerId('current position'),
    //   position: LatLng(23.2347756,89.1263167),
    //   infoWindow: InfoWindow(title: "My current location"),
    // )
  ];

  Future<Position> getUserCurrentPosition()async{
    // LocationPermission permission;
    // permission = await Geolocator.requestPermission();
    // if (permission == LocationPermission.denied ||
    //     permission == LocationPermission.deniedForever) {
    //   // Handle the case where permission is denied
    //   return Future.error('Location permissions are denied');
    // }

    await Geolocator.requestPermission().then((value){
      
    }).onError((errr, statckTrace ){
      print(errr);
    });

   return await Geolocator.getCurrentPosition();
  }
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
              // if you miss this not animate camera and not show marker
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
            ),

            ),
            GestureDetector(
              onTap: () {
                getUserCurrentPosition().then((value) async {


                  print('My Current Location: ');
                  print('Latitude: ${value.latitude}  Longitude: ${value.longitude}');


                 List<Placemark> placemarks = await placemarkFromCoordinates(value.latitude, value.longitude);
                  // print(placemarks[0].subAdministrativeArea);
                  // print(placemarks[0].name);
                  // print(placemarks[0].administrativeArea);
                  var firstAddress = placemarks[0];
                  var secondAddress = placemarks[1];
                  var thirdAddress = placemarks[2];

                  setState(() {
                    name = secondAddress.name.toString();
                    counrty = thirdAddress.country;
                    locality = thirdAddress.locality;
                    administrative = thirdAddress.administrativeArea;
                    subAdministrative = thirdAddress.subAdministrativeArea;
                    street = thirdAddress.street.toString();
                  });

                  // print(placemarks);

                  // move camera to current location
                  CameraPosition cameraPosition = CameraPosition(
                      // target: LatLng(23.2347604, 89.1263252),
                       target: LatLng(value.latitude, value.longitude),
                      zoom: 15
                  );
                  GoogleMapController controller =await _controller.future;
                  controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                          cameraPosition

                      )
                  );

                  // current location mark hobe
                    _marker.add(
                        Marker(markerId: MarkerId('current position'),
                      position: LatLng(value.latitude,value.longitude),
                      infoWindow: InfoWindow(title: "My current location"),
                    )
                    );




                });
              },
              child: const CurrentLocationButton(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: Column(
                  children: [
                  counrty!=null ? Text('${name} - ${street}') : Container(),
                   counrty!=null ? Text("${locality} - ${subAdministrative} - ${administrative} - ${counrty}"):Container()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
