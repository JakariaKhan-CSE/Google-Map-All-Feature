import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Polyline Demo',
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  List<LatLng> polylineCoordinates = [];
  List<Marker> markers = [];
  final LatLng sourceLocation = const LatLng(23.230459, 89.149020);
  //final LatLng sourceLocation = LatLng(23.171387, 89.201513);
  final LatLng destinationLocation = const LatLng(23.272665, 89.009596);
  final List<LatLng> checkPoints = [
    const LatLng(23.209257, 89.172331),
    const LatLng(23.231974, 89.132162),
    const LatLng(23.234497, 89.098173),
    const LatLng(23.249837903009773, 89.05878491113003),
    const LatLng(23.255007, 89.044347),
    const LatLng(23.259818, 89.025893),
    const LatLng(23.318792, 88.975573),
    const LatLng(23.34570388563941, 88.91695626649748),
    const LatLng(23.126896, 89.338109),
    const LatLng(23.085845, 89.359051),
  ];

  @override
  void initState() {
    super.initState();
    _setPolyline();
  }

  _setPolyline() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyBTDqAhurKsynehyIXmC35IO272b3xdvX4', // Replace with your actual Google API Key
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates = result.points
          .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
          .toList();
    }

    _addMarkers();
    setState(() {});
  }

  _addMarkers() {
    markers.add(Marker(
      markerId: const MarkerId('source'),
      position: sourceLocation,
      infoWindow: const InfoWindow(title: 'Source'),
    ));
    markers.add(Marker(
      markerId: const MarkerId('destination'),
      position: destinationLocation,
      infoWindow: const InfoWindow(title: 'Destination'),
    ));

    for (LatLng point in checkPoints) {
      if (_isPointNearPolyline(point)) {
        markers.add(Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          infoWindow: const InfoWindow(title: 'Check Point'),
        ));
      }
    }
  }

  bool _isPointNearPolyline(LatLng point) {
    const double tolerance = 1.0; // Tolerance in kilometers
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      LatLng start = polylineCoordinates[i];
      LatLng end = polylineCoordinates[i + 1];
      double distance = _calculateDistanceToLineSegment(point, start, end);
      if (distance < tolerance) {
        return true;
      }
    }
    return false;
  }

  double _calculateDistanceToLineSegment(LatLng point, LatLng start, LatLng end) {
    double x0 = point.latitude;
    double y0 = point.longitude;
    double x1 = start.latitude;
    double y1 = start.longitude;
    double x2 = end.latitude;
    double y2 = end.longitude;

    double A = x0 - x1;
    double B = y0 - y1;
    double C = x2 - x1;
    double D = y2 - y1;

    double dot = A * C + B * D;
    double len_sq = C * C + D * D;
    double param = (len_sq != 0) ? dot / len_sq : -1;

    double xx, yy;

    if (param < 0) {
      xx = x1;
      yy = y1;
    } else if (param > 1) {
      xx = x2;
      yy = y2;
    } else {
      xx = x1 + param * C;
      yy = y1 + param * D;
    }

    double dx = x0 - xx;
    double dy = y0 - yy;

    return _calculateDistance(LatLng(x0, y0), LatLng(xx, yy));
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371; // Radius of the Earth in kilometers
    double dLat = _degreesToRadians(end.latitude - start.latitude);
    double dLon = _degreesToRadians(end.longitude - start.longitude);
    double a =
        sin(dLat / 2) * sin(dLat / 2) +
            cos(_degreesToRadians(start.latitude)) *
                cos(_degreesToRadians(end.latitude)) *
                sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Polyline Demo'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: sourceLocation,
          zoom: 13,
        ),
        markers: Set<Marker>.of(markers),
        polylines: {
          Polyline(
            polylineId: const PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
    );
  }
}



