import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationEntry {
  final String address;
  final DateTime startTime;
  DateTime? endTime;

  LocationEntry({required this.address, required this.startTime, this.endTime});
}

class LocationHistoryScreen extends StatefulWidget {
  @override
  _LocationHistoryScreenState createState() => _LocationHistoryScreenState();
}

class _LocationHistoryScreenState extends State<LocationHistoryScreen> {
  final List<LocationEntry> locations = [];

  @override
  void initState() {
    super.initState();
    _listenToLocationChanges();
  }

  _listenToLocationChanges() {
    final locationStream = Geolocator.getPositionStream();
    locationStream.listen((Position position) async {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          List<String> addressParts = [];
          if (placemark.street != null && placemark.street!.isNotEmpty) addressParts.add(placemark.street!);
          if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) addressParts.add(placemark.subLocality!);
          if (placemark.locality != null && placemark.locality!.isNotEmpty) addressParts.add(placemark.locality!);
          if (placemark.postalCode != null && placemark.postalCode!.isNotEmpty) addressParts.add(placemark.postalCode!);
          if (placemark.country != null && placemark.country!.isNotEmpty) addressParts.add(placemark.country!);

          String address = addressParts.join(', ');

          if (locations.isEmpty || locations[0].address != address) {
            setState(() {
              if (locations.isNotEmpty && locations[0].endTime == null) {
                locations[0].endTime = DateTime.now();
              }
              locations.insert(0, LocationEntry(address: address, startTime: DateTime.now()));
            });
          }
        }
      } catch (e) {
        print(e);
      }
    });
  }

  String formattedTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return "${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period";
  }


  String sanitizeAddress(String address) {
    return address.replaceAll(' ,', ',').replaceAll(', ,', ',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location History"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: locations.isEmpty
            ? Center(child: Text("No locations found"))
            : ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: Icon(Icons.location_on),
                title: Text(sanitizeAddress(locations[index].address)),
                subtitle: Text(
                    '${formattedTime(locations[index].startTime)} - ${locations[index].endTime != null ? formattedTime(locations[index].endTime!) : 'Now'}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
