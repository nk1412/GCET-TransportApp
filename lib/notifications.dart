// // ignore_for_file: library_private_types_in_public_api, avoid_print

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// //import 'package:firebase_messaging/firebase_messaging.dart';
// import 'message.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await message().initNotifications();
//   runApp(const MyApp());
// }



// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('FCM Example'),
//       ),
//       body: const Center(
//         child: Text('Listening for notifications...'),
//       ),
//     );
//   }
// }
