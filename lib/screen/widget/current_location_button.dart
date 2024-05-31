import 'package:flutter/material.dart';

class CurrentLocationButton extends StatelessWidget {
  const CurrentLocationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 3,
        child: Container(
          color: Colors.lightGreenAccent,
          height: 40,
          width: double.infinity,
          child: Center(
            child: Text('Current Location'),
          ),
        ),
      ),
    );
  }
}
