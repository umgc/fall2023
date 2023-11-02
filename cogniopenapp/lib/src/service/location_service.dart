// Import the Geolocator package for location services
import 'package:geolocator/geolocator.dart';

// Import the custom Location data model
import 'location.dart';

// LocationService class provides a method to fetch the current device location
class LocationService {

  // Returns a Future of the LocationDataModel which contains details like latitude, longitude, and timestamp
  Future<LocationDataModel?> getLocation() async {
    try {
      // Use Geolocator to fetch the current position of the device
      final position = await Geolocator.getCurrentPosition();

      // Convert the fetched position to a LocationDataModel and return it
      return LocationDataModel(
        latitude: position.latitude,
        longitude: position.longitude,

        // Convert the timestamp from the position to a DateTime object
        timestamp: DateTime.fromMillisecondsSinceEpoch(position.timestamp!.millisecondsSinceEpoch),
      );
    } catch (e) {
      // In case of any errors, print the error and return null
      print(e);
      return null;
    }
  }
}
