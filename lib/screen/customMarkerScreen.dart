import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkerScreen extends StatefulWidget {
  const CustomMarkerScreen({super.key});

  @override
  State<CustomMarkerScreen> createState() => _CustomMarkerScreenState();
}

class _CustomMarkerScreenState extends State<CustomMarkerScreen> {
  Uint8List? markerImage;
  final Completer<GoogleMapController> _controller = Completer();

  List<String> images = ['images/school.png', 'images/nabawi-mosque.png',
  'images/gas-pump', 'images/but-stop.png'
  ];
  List<String> _name = ['School',"Massjid", "gas-pump", 'Bus-Stop'];
  final List<Marker> _markers = [
    const Marker(markerId: MarkerId('School'),
    position: LatLng(23.235002, 89.131201),
      infoWindow: InfoWindow(title: "This is school and have washroom fasility")
    )
  ];
  final List<LatLng> _latlng = const[
    LatLng(23.235002, 89.131201),
    LatLng(23.234080, 89.123882 ),
    LatLng(23.236686, 89.115458),
    LatLng(23.219979, 89.162004)
  ];

  static const CameraPosition _initialCameraPositionPoint = CameraPosition(
      target: LatLng(23.234715, 89.126871),
    zoom: 15
  );
  // Future<Uint8List> getByteFromAssets(String path, int width)async{
  //   ByteData data = await rootBundle.load(path);
  //   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
  //
  // }
  Future<Uint8List> getByteFromAssets(String path, int width)async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();

    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }
  void loadData(){
    for(int i=0; i<images.length; i++)
      {
        _markers.add(Marker(markerId: MarkerId(i.toString()),
        position: _latlng[i],
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: "This is title "+_name[i])
        ));
      }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Custom Marker",style: TextStyle(color: Colors.white),),
          centerTitle: true,backgroundColor: Colors.blueGrey,),
        body: GoogleMap(
          initialCameraPosition: _initialCameraPositionPoint,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
          markers: Set<Marker>.of(_markers),
        ),
      ),
    );
  }
}
