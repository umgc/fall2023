// Import necessary packages
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

// Main widget to display location history
class LocationHistoryScreen extends StatefulWidget {
  @override
  _LocationHistoryScreenState createState() => _LocationHistoryScreenState();
}

class _LocationHistoryScreenState extends State<LocationHistoryScreen> {
  // List of locations initialized with sample data
  final List<String> locations = [];

  @override
  void initState() {
    super.initState();
    // Start listening to location changes when the widget is initialized
    _listenToLocationChanges();
  }
  int locationCheckCounter = 0;

  // Function to listen to changes in device's location
  _listenToLocationChanges() {
    // Get a stream of location data from Geolocator
    final locationStream = Geolocator.getPositionStream();

    // Listen to the stream for location changes
    locationStream.listen((Position position) async {
      try {
        print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
        // Convert the latitude and longitude to an address
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          String address = '${placemark.locality}, ${placemark.country}';
          // Check if the location is different from the last one
          // If it is, add it to the list
          if (locations.isEmpty || locations[0] != address) {
            setState(() {
              locations.insert(0, address);
            });
          }
        }
      } catch (e) {
        // Print the error if something goes wrong
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Building the widget layout
    return Scaffold(
      // Set up app bar
      appBar: AppBar(
        title: Text("Location History"),
      ),
      // Display the list of locations in the body
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: locations.isEmpty
            ? Center(child: Text("No locations found"))
            : ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, index) {
            return Card(
              // Each list item has an icon and a location name
              child: ListTile(
                leading: Icon(Icons.location_on),
                title: Text(locations[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
