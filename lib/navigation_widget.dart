// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'google_map_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavigationWidget extends StatefulWidget {
  final String userId;
  const NavigationWidget({super.key, required this.userId});
  
  @override
  _NavigationWidgetState createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  String _selectedItem = '1';
  final List<String> _items = ['1', '2', '3'];

  Future<void> _signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    // Navigate back to SignInPage
    Navigator.pop(context);
  } catch (e) {
    print('Failed to sign out: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: _selectedItem,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedItem = newValue!;
                });
              },
              items: _items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Request location permission before accessing location data
                final permissionStatus = await Permission.locationWhenInUse.request();
                if (permissionStatus.isGranted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => GoogleMapWidget(selectedItem: _selectedItem)),
                  );
                } else if (permissionStatus.isDenied) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Location permission denied. Please enable it from settings.'),
                      duration: Duration(seconds: 5),
                    ),
                  );
                } else if (permissionStatus.isPermanentlyDenied) {
                  openAppSettings(); // Function to open app settings
                }
              },
              child: const Text('Get Selected Item'),
            ),
            ElevatedButton(
  onPressed: _signOut,
  child: Text('Logout'),
),

          ],
        ),
      ),
    );
  }
}
