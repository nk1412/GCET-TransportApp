// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectOnMap extends StatefulWidget {
  const SelectOnMap({super.key,required this.location});
  final LatLng location;

  @override
  SelectOnMapState createState() => SelectOnMapState();
}

class SelectOnMapState extends State<SelectOnMap> {
  LatLng _center = const LatLng(0, 0); // Initial center of the map
  final Offset _markerOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: Stack(
        children: [
          GoogleMap(
            onCameraMove: (position) {
              setState(() {
                _center = position.target;
              });
            },
            initialCameraPosition: CameraPosition(target: widget.location, zoom: 18.0),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 25 + _markerOffset.dx,
            top: MediaQuery.of(context).size.height / 2 - 50 + _markerOffset.dy,
            child: GestureDetector(
              // onPanUpdate: (details) {
              //   setState(() {
              //     _markerOffset += details.delta;
              //     _center = _getLatLngFromOffset(_markerOffset);
              //   });
              // },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.5),
                ),
                child: const Icon(Icons.location_pin,),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Selected location: $_center');
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(builder: (context) =>  StopFind(description: '', userLocation: _center,),),
          // );
          Navigator.of(context).pop(_center); // Pop selected location back to previous screen
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  // LatLng _getLatLngFromOffset(Offset offset) {
  //   final RenderBox renderBox = context.findRenderObject() as RenderBox;
  //   final topLeft = renderBox.localToGlobal(Offset.zero);
  //   final x = (offset.dx + 25 - topLeft.dx) / renderBox.size.width;
  //   final y = (offset.dy + 50 - topLeft.dy) / renderBox.size.height;
  //   final latLng = LatLng(
  //     _center.latitude + (0.5 - y) * 2,
  //     _center.longitude + (x - 0.5) * 2,
  //   );
  //   return latLng;
  // }
}
