import 'package:geolocator/geolocator.dart';

// Request permission
void getLocationPermission() async {
  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied) {
    // Handle case when user denies permission
  } else if (permission == LocationPermission.deniedForever) {
    // Handle case when user denies permission permanently
  } else {
    // Permission granted, proceed to get location
    getUserLocation();
  }
}


void getUserLocation() async {
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    double latitude = position.latitude;
    double longitude = position.longitude;
    // Now you have the user's location (latitude and longitude)
    print('Latitude: $latitude, Longitude: $longitude');
  } catch (e) {
    // Handle errors, such as when location services are disabled
    print('Error getting location: $e');
  }
}
