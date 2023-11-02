import 'package:flutter/material.dart';

class LocationHistoryScreen extends StatefulWidget {
  @override
  _LocationHistoryScreenState createState() => _LocationHistoryScreenState();
}

class _LocationHistoryScreenState extends State<LocationHistoryScreen> {
  // Dummy data for locations. Replace this with your actual location data.
  final List<String> locations = [
    "Paris, France",
    "Tokyo, Japan",
    "New York, USA",
    "London, UK",
    "Sydney, Australia"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location History"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, index) {
            return Card(
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
