// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signin.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'profile.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});


  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController _controller;
  late Set<Marker> _markers;
  LatLng _currentPosition = const LatLng(0, 0);
  String _busNumber = '';
  final String _studentEmail = FirebaseAuth.instance.currentUser!.email!; // Fetch user's email

  @override
  void initState() {
    super.initState();
    _getUserData();
    _markers = {};
    _getLocation();
    _positionload();
    _startLocationUpdates();
  }

  Future<void> _signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    // Navigate back to SignInPage
    //Navigator.pop(context);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  } catch (e) {
    print('Failed to sign out: $e');
  }
}


  Future<void> _getUserData() async {
    try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('year21').doc(_studentEmail).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        _busNumber = data['Bus Number'];
        _addMarkers();
      });
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
  }

  void _startLocationUpdates() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      _getLocation();
    });
  }

  void _positionload() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
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

  void _addMarkers() async{
    try {
    // Reference to your Firestore collection
      DocumentReference documentRef = FirebaseFirestore.instance.collection('Route').doc(_busNumber);
      DocumentSnapshot snapshot = await documentRef.get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        List<String> keys = data.keys.toList();
      
        for (var i = 0; i < keys.length; i++) {
          GeoPoint? geoPoint = data[keys[i]] as GeoPoint?;
          if(geoPoint != null){
          double latitude = geoPoint.latitude;
          double longitude = geoPoint.longitude;
          _markers.add(
        Marker(
          markerId: MarkerId('marker${i + 1}'),
          position: LatLng(latitude,longitude),
        ),
      );
          print('Latitude: $latitude, Longitude: $longitude');
        }
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error retrieving location data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarIconBrightness: Brightness.dark, // Use dark icons for status bar
      statusBarColor: Colors.black, // Make status bar transparent
    ));
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Bus Location"),
        backgroundColor: Colors.transparent, // Make app bar background transparent
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer
                },
              );
            },
          ),
        ),
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  // Handle drawer item tap for Home
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Handle drawer item tap for Settings
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Profile'),
        onTap: () {
          // Handle drawer item tap for Profile
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        },
      ),
              const Divider(), // Add a divider between menu items
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () {
                  _signOut();
                },
              ),
            ],
          ),
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
          //_controller.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 18));
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _currentPosition,
                zoom: 18,
                bearing: 0, // Set bearing to 0 for north orientation
              ),
            ));
          _getUserData();
        },
        child: const Icon(Icons.location_on),
      ),
    ),);
  }
}
  