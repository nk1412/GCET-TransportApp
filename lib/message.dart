// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';


// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('title: ${message.notification?.title}');
//   print('body: ${message.notification?.body}');
//   print('payload: ${message.data}');
// }


// class messagex {
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   Future<void> initNotifications() async {
//     await _firebaseMessaging.requestPermission();
//     final fmcToken = await _firebaseMessaging.getToken();
//     print('fmcToken: $fmcToken');
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }
// }
// // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
// //  @override
// //   void initState() {
// //     super.initState();
// //     _firebaseMessaging.requestPermission();
    
// //     _firebaseMessaging.getToken().then((token) {
// //       print("Firebase Messaging Token: $token");
// //     });

// //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// //       print('Received message: ${message.notification?.title}');
// //       showDialog(
// //         context: context,
// //         builder: (context) => AlertDialog(
// //           title: Text(message.notification?.title ?? "No Title"),
// //           content: Text(message.notification?.body ?? "No Body"),
// //         ),
// //       );
// //     });

// //     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
// //       print('Message clicked!');
// //     });
// //   }

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'firebase_options.dart';

// const presetLocation = LatLng(17.4716588,78.5459858); // Example coordinates for San Francisco
// const double radius = 50.0; // 50 meters

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('Handling a background message: ${message.messageId}');
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   late LatLng positionx;
//   @override
//   void initState() {
//     super.initState();
//     _askLocPermission();
//     print("location permission done");
//     _initializeFirebase();
//     print("init firebase done");
//     _initLocalNotifications();
//     print("init Notifications done");
//     _checkLocation();
//     print("Check location done");
//     _startLocationUpdates();
//   }

//   void _startLocationUpdates() {
//     Timer.periodic(const Duration(seconds: 3), (timer) {
//       _checkLocation();
//     });
//   }

//   Future<void> _initializeFirebase() async {
//     await Firebase.initializeApp();
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     await _firebaseMessaging.requestPermission();
//     final fmcToken = await _firebaseMessaging.getToken();
//     print('FCM Token: $fmcToken');

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null) {
//         _showNotification(notification);
//       }
//     });
//   }

//   Future<void> _initLocalNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> _showNotification(RemoteNotification notification) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your channel id',
//       'your channel name',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       notification.title,
//       notification.body,
//       platformChannelSpecifics,
//       payload: 'item x',
//     );
//   }

//   Future<void> _askLocPermission() async{
//     await Permission.locationWhenInUse.request();
//   }


//   Future<void> _checkLocation() async {
//     var loc = await Geolocator.getCurrentPosition();
//     positionx = LatLng(loc.latitude, loc.longitude);
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     double distance = Geolocator.distanceBetween(
//       position.latitude,
//       position.longitude,
//       presetLocation.latitude,
//       presetLocation.longitude,
//     );
//     if (distance <= radius) {
//       _showNotification(RemoteNotification(
//         title: 'You are near the location!',
//         body: 'You are within 50 meters of the preset location.',
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Location-based Notifications'),
//         ),
//         body: Center(
//           child: Text(positionx as String),
//         ),
//       ),
//     );
//   }
// }

// Future<void> main() async {
//     await Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
// );
//   runApp(MaterialApp(
//     // home: StopFind(userLocation: LatLng(17.4716588,78.5459858),description: "Your current location",),
//     home:MyApp()));
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}




class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Handle the message accordingly.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Messaging Example"),
      ),
      body: Center(
        child: Text("Listening for messages..."),
      ),
    );
  }
}
