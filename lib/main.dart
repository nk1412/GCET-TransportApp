import 'package:flutter/material.dart';
import 'package:flutter_application_2/signin.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'firebase_options.dart';
//import 'stop_find.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MaterialApp(
    // home: StopFind(userLocation: LatLng(17.4716588,78.5459858),description: "Your current location",),
    home: SignInPage(),
  ));
}