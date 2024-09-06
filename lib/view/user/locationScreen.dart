import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vehicle_help_new/view/user/searchMecanicsPage.dart';


class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String _locationMessage = '';
  bool isLoading = false;
  late double lat;
  late double long;

  @override
  void initState() {
    super.initState();
    _getLocationPermission();
  }

  // Request permission
  void _getLocationPermission() async {
    setState(() {
      isLoading = true;
    });
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle case when user denies permission
      setState(() {
        _locationMessage = 'Permission denied';
      });
    } else if (permission == LocationPermission.deniedForever) {
      // Handle case when user denies permission permanently
      setState(() {
        _locationMessage = 'Permission denied forever';
      });
    } else {
      // Permission granted, proceed to get location
      getUserLocation();
    }
  }

  // Get user location
  void getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      double latitude = position.latitude;
      double longitude = position.longitude;
      // Now you have the user's location (latitude and longitude)
      setState(() {
        _locationMessage = 'Latitude: $latitude, Longitude: $longitude';
        lat = latitude;
        long = longitude;
        isLoading = false;
      });
    } catch (e) {
      // Handle errors, such as when location services are disabled
      setState(() {
        _locationMessage = 'Error getting location: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: isLoading
            ? const Card(
              color: Colors.white,
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10,),
                    Text("Getting your location...", style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
            )
            : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Your Location", style: TextStyle(fontSize: 20),),
                SizedBox(height: 10,),
                Text(
                  _locationMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 10,),
                ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchMechanicsPage(latitude: lat, longitude: long,)));
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => SearchMechanicsPage(latitude: 14.833097, longitude: 74.138609,)));
                    },
                    child: Text("Search Mecanics")
                )

              ],
            ),
          ),
          // if (isLoading)
          //   Container(
          //     color: Colors.black.withOpacity(0.4), // Dark background with 40% transparency
          //     child: Center(
          //       child: CircularProgressIndicator(),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
