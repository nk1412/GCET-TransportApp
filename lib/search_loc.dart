// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'stop_find.dart';
import 'select_on_map.dart';


class SearchLoc extends StatefulWidget {
  const SearchLoc({super.key, required this.desc, required this.location});
  final String desc;
  final LatLng location;

  @override
  SearchLocState createState() => SearchLocState();
}

class SearchLocState extends State<SearchLoc> {
  //GoogleMapController? _mapController;
  //final LatLng _currentLocation = const LatLng(0.0, 0.0); // Replace with user's initial location
  final TextEditingController _controller = TextEditingController();
  var uuid = const Uuid();
  final String _sessionToken = '112233';
  List<dynamic> _placesList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChange();
    });
  }

  Future<void> currentPosition() async { 
    var position = await Geolocator.getCurrentPosition();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => StopFind(userLocation: LatLng(position.latitude,position.longitude),description: "Your Current Location")),
    );
  }

  Future<void> selectFromMap() async {
    var value = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SelectOnMap(location: LatLng(widget.location.latitude, widget.location.longitude)),
    ));

    print(value);
    String desc = await getDescription(value);
    _controller.text = desc;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => StopFind(userLocation: LatLng(value.latitude,value.longitude),description: desc)),
    );
  }

  Future<String> getDescription(value) async {
    var latitude = value.latitude;
    var longitude = value.longitude;
    const apiKey = 'AIzaSyDk1QAh0VBQFdkIoCBNXdUu_HaSigidsGE'; // Replace with your API key
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 'OK' && json['results'].isNotEmpty) {
        return json['results'][0]['formatted_address'];
      } else {
        return 'No location description found';
      }
    } else {
      throw Exception('Failed to load location description');
    }
  }

  void _onChange(){
    // ignore: prefer_is_empty
    if (_controller.text.length == 0){
      setState(() {
        _placesList = [];
      });
    }
    getSuggestion(_controller.text);
  }

  getSuggestion(String input) async {

    String mapsApi = "AIzaSyDk1QAh0VBQFdkIoCBNXdUu_HaSigidsGE";
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$mapsApi&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    if(response.statusCode == 200){
      setState(() {
        _placesList = jsonDecode(response.body.toString())['predictions'];
      });
    }else{
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            top: 120,
            left: 25,
            right: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                    const Icon(
                      Icons.my_location_sharp, // Use any icon you want
                      color: Colors.black, // Set the color of the icon
                    ),
                    
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: ButtonStyle(
                          // side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
                          padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10.0)),
                        ),
                        child: const Text("Your Location",style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),),
                        onPressed: () {
                          currentPosition();
                        },
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.018),
                    const SizedBox(
                      width: 10,
                      height: 10,
                      child: Divider(),// Specify the background color here
                    ),
                     SizedBox(width: MediaQuery.of(context).size.width * 0.022),
                    const Icon(
                      Icons.location_pin, // Use any icon you want
                      color: Colors.black, // Set the color of the icon
                    ),
                    
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: ButtonStyle(
                          // side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
                          padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10.0)),
                        ),
                        child: const Text("Select On Map",style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),),
                        onPressed: () {
                          selectFromMap();
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child:  ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _placesList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          String description = _placesList[index]['description'];
                          List<Location> location = await locationFromAddress(_placesList[index]['description']);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => StopFind(userLocation: LatLng(location.last.latitude, location.last.longitude),description: description )),
                          );
                        },
                        title: Text(_placesList[index]['description']),
                      );
                    }
                  ),
                ),
              ],
            )
          ),
          Positioned(
            top: 60.0,
            right: 30.0,
            left: 30.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4.0,
                    spreadRadius: 2.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(25.0)
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Center(
                child: Row( 
                  children: [ 
                    InkWell(
                      onTap: () {
                      Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => StopFind(userLocation: widget.location,description: widget.desc)),
                          );
                      }, 
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child:  const Icon(Icons.arrow_back_ios_new)
                      ),
                    ), 
                    Expanded(
                      child: TextFormField(
                        autofocus: true,
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Search place",
                          contentPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 10),
                          border: InputBorder.none,
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
