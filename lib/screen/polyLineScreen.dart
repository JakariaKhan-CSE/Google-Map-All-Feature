import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolyLineScreen extends StatefulWidget {
  const PolyLineScreen({super.key});

  @override
  State<PolyLineScreen> createState() => _PolyLineScreenState();
}

class _PolyLineScreenState extends State<PolyLineScreen> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _initialCameraPositionPoint = CameraPosition(
      target: LatLng(23.235002, 89.131201),
    zoom: 15
  );
  final Set<Marker> _marker ={};
  final Set<Polyline> _polyline ={};

  List<LatLng> _latlng = [
    LatLng(23.234080, 89.123882 ),
    LatLng(23.236686, 89.115458),
    LatLng(23.219979, 89.162004),
  ];
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i=0; i<_latlng.length; i++)
      {
        _marker.add(
          Marker(markerId: MarkerId(i.toString()),
          position: _latlng[i],
            icon: BitmapDescriptor.defaultMarker,
            infoWindow:  InfoWindow(
              title: "This the place of ${i}",
              snippet: "This is snippet"
            )
          )
        );
        setState(() {

        });
        _polyline.add(Polyline(polylineId: PolylineId(i.toString()),
        points: _latlng,
          color: Colors.lightGreenAccent
        ));
      }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Polyline'),centerTitle: true,),
body: GoogleMap(
  initialCameraPosition: _initialCameraPositionPoint,
  onMapCreated: (controller){
    _controller.complete(controller);
  },
  myLocationEnabled: true,
  markers: Set<Marker>.of(_marker),
  mapType: MapType.normal,
  polylines: _polyline,
),
    );
  }
}
