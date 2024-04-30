import 'package:flutter/material.dart';
import 'package:flutter_application_2/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MaterialApp(
    home: SignInPage(),
  ));
}