import 'package:geocoding/geocoding.dart';

class LocationDataModel {
  final double? latitude;
  final double? longitude;
  final String? address;
  final DateTime timestamp;

  LocationDataModel({
    this.latitude,
    this.longitude,
    this.address,
    required this.timestamp
  });
}
