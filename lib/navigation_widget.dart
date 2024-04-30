// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'google_map_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin.dart';

class NavigationWidget extends StatefulWidget {
  final String userId;
  const NavigationWidget({super.key, required this.userId});
  
  @override
  _NavigationWidgetState createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  String _selectedItem = '1';
  final List<String> _items = ['1','Bus27', 'Bus31'];

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


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
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
              DrawerHeader(
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
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  // Handle drawer item tap for Home
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Handle drawer item tap for Settings
                  Navigator.pop(context); // Close the drawer
                },
              ),
              Divider(), // Add a divider between menu items
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () {
                  _signOut();
                },
              ),
            ],
          ),
        ),
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => GoogleMapWidget(selectedItem: _selectedItem)),
                  );
              },
              child: const Text('Get Selected Item'),
            ),

          ],
        ),
      ),
    ),);
  }
}
