class LocationService {
  Future<LocationDataModel?> getLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      List<String> addressParts = [];

      // Convert the fetched latitude and longitude to an address
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        if (placemark.street != null && placemark.street!.isNotEmpty) addressParts.add(placemark.street!);
        if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) addressParts.add(placemark.subLocality!);
        if (placemark.locality != null && placemark.locality!.isNotEmpty) addressParts.add(placemark.locality!);
        if (placemark.postalCode != null && placemark.postalCode!.isNotEmpty) addressParts.add(placemark.postalCode!);
        if (placemark.country != null && placemark.country!.isNotEmpty) addressParts.add(placemark.country!);
      }

      String locationAddress = addressParts.join(', ');

      return LocationDataModel(
        latitude: position.latitude,
        longitude: position.longitude,
        address: locationAddress,
        timestamp: DateTime.fromMillisecondsSinceEpoch(position.timestamp!.millisecondsSinceEpoch),
      );
    } catch (e) {
      print(e);
      return null;
    }
  }
}
