/* Tests the CogniOpen Address class
     1. Uses Mockito to intercept questions to the Global Positioning System (GPS)
     2. Uses Mockito to intercept queries to reverse geocoding web services
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:cogniopenapp/src/address.dart';

final mockPosition = Position(
    latitude: -77.1517459,
    longitude: 39.0903002,
    timestamp: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
    altitude: 0.0,
    altitudeAccuracy: 0.0,
    accuracy: 0.0,
    heading: 0.0,
    headingAccuracy: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0);

final mockPlacemark = Placemark(
    administrativeArea: 'Maryland',
    country: 'United States',
    isoCountryCode: 'US',
    locality: 'Rockville',
    name: '501',
    postalCode: '20850',
    street: '501 Hungerford Dr',
    subAdministrativeArea: 'Montgomery County',
    subLocality: '',
    subThoroughfare: '501',
    thoroughfare: 'Hungerford Drive');

void main() {
  test('U-1-1: Making sure that location and address are obtainable', () async {
    GeolocatorPlatform.instance = MockGeolocatorPlatform();
    GeocodingPlatform.instance = MockGeocodingPlatform();
    var physicalAddress = "";
    await Address.whereIAm().then((String address) => physicalAddress = address);
    expect(physicalAddress, "501 Hungerford Dr, Rockville, 20850, United States");
  });
}

class MockGeolocatorPlatform extends Mock with MockPlatformInterfaceMixin implements GeolocatorPlatform {
  @override
  Future<LocationPermission> requestPermission() => Future.value(LocationPermission.whileInUse);

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) =>
      Future.value(mockPosition);
}

class MockGeocodingPlatform extends Mock with MockPlatformInterfaceMixin implements GeocodingPlatform {
  @override
  Future<List<Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude, {
    String? localeIdentifier,
  }) async {
    return [mockPlacemark];
  }
}
