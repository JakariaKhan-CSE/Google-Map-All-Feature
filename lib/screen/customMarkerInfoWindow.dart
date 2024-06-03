import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkerInfoWindow extends StatefulWidget {
  const CustomMarkerInfoWindow({super.key});

  @override
  State<CustomMarkerInfoWindow> createState() => _CustomMarkerInfoWindowState();
}

class _CustomMarkerInfoWindowState extends State<CustomMarkerInfoWindow> {
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final List<Marker> _marker = [];
  final List<LatLng> _latlng = const [
    LatLng(23.235002, 89.131201),
    LatLng(23.234080, 89.123882),
    LatLng(23.236686, 89.115458),
    LatLng(23.219979, 89.162004),
    LatLng(23.219979, 89.162004),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() {
    for (int i = 0; i < _latlng.length; i++) {
      _marker.add(
        Marker(
            markerId: MarkerId(
              i.toString(),
            ),
            icon: BitmapDescriptor.defaultMarker,
            position: _latlng[i],
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                  Container(
                    height: 300,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 300,
                          height: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://www.foodiesfeed.com/wp-content/uploads/2023/06/burger-with-melted-cheese.jpg'),
                                fit: BoxFit.fitWidth,
                                filterQuality: FilterQuality.high,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))), //full image border circle or rantangle kora jabe (very important)
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Food')
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('This is very interisting food. which is very tasty and delicious.'),
                        )
                      ],
                    ),
                  ), // ai widget show korbe marker a click korle
                  _latlng[i]);
            }),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom info window example'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _latlng[0], zoom: 15),
              onTap: (position) {
                _customInfoWindowController.hideInfoWindow;
              },
              onCameraMove: (position) {
                _customInfoWindowController.onCameraMove;
              },
              markers: Set<Marker>.of(_marker),
              onMapCreated: (controller) {
                _customInfoWindowController.googleMapController = controller;
              },
            ),
            CustomInfoWindow(
              controller: _customInfoWindowController,
              height: 200,
              width: 300,
              offset: 35,
            )
          ],
        ),
      ),
    );
  }
}
