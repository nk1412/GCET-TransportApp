// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMapWidget extends StatefulWidget {
  final String selectedItem;

  const GoogleMapWidget({super.key, required this.selectedItem});

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController _controller;
  late Set<Marker> _markers;
  LatLng _currentPosition = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _markers = {};
    _getLocation();
//    _requestLocationPermission();
    _positionload();
    _startLocationUpdates();
    _addMarkers();
  }

  void _startLocationUpdates() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      _getLocation();
    });
  }

  void _positionload() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      _getLocation();
      _controller.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 18));
      timer.cancel();
    });
  }

  void _getLocation() async {
    try {
      var position = await Geolocator.getCurrentPosition();
      setState(() {
        _markers.remove(const Marker(markerId: MarkerId('currentPosition')));
        _currentPosition = LatLng(position.latitude, position.longitude);
        _markers.add(
          Marker(
            markerId: const MarkerId('currentPosition'),
            position: _currentPosition,
          ),
        );
      });
    // ignore: empty_catches
    } catch (e) {
    }
  }

  void _addMarkers() {
    var route = {
      '1': [
        [17.496171726822396, 78.5851329343433],
        [17.500952221016316, 78.58550528758049],
      ],
      '2': [
        [17.501470474299282, 78.58992277952596],
        [17.50039198796902, 78.5916332849724],
      ],
      '3': [
        [17.499361458495326, 78.59314513740827],
        [17.49768039194528, 78.59461647005656],
      ],
    };

    var marker = route[widget.selectedItem];
    for (var i = 0; i < marker!.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('marker${i + 1}'),
          position: LatLng(marker[i][0], marker[i][1]),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Example'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 15.0,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        zoomControlsEnabled: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getLocation();
          _controller.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 18));
          
        },
        child: const Icon(Icons.location_on),
      ),
    );
  }
}
  