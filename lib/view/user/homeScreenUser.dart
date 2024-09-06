import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vehicle_help_new/view/user/locationScreen.dart';
import 'package:vehicle_help_new/view/user/notificationScreenUser.dart';
import 'package:vehicle_help_new/view/user/profilePageUser.dart';
import 'package:vehicle_help_new/view/user/getLocation.dart';
import 'package:vehicle_help_new/view/user/userAppointmetsScreen.dart';

import '../auth/authRepository.dart';
import '../screens/aboutScreen.dart';
import 'bookMechanic.dart';


class HomePageUser extends StatelessWidget {
  const HomePageUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mechanic Services'),
        actions: [
          IconButton(onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreenUser()));
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserAppointmentScreen()));
            },
            icon: Icon(Icons.inventory_rounded)
          ),
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreenUser()));
            },
            icon: Icon(Icons.person)
          )
        ],
      ),
      body: CurrentLocation(),
      // ListView(
      //   padding: EdgeInsets.all(20.0),
      //   children: [
      //     MechanicCard(
      //       name: 'Manjunatha',
      //       address: 'Mangrapoi road, Karwar',
      //       pricePerHour: '₹500/hr',
      //       image: 'https://thumbs.dreamstime.com/b/happy-mechanic-7457479.jpg',
      //     ),
      //     MechanicCard(
      //       name: 'Gajanan Naik',
      //       address: 'Patel wada, Karwar',
      //       pricePerHour: '₹600/hr',
      //       image: 'https://i.pinimg.com/originals/6b/eb/d2/6bebd2f554c39c4c62e548efa536a97c.jpg',
      //     ),
      //     MechanicCard(
      //       name: 'Manoj Gaudar',
      //       address: 'Kodibag road, Karwar',
      //       pricePerHour: '₹550/hr',
      //       image: 'https://yt3.googleusercontent.com/VFKa6F70O7lTtP_RAK5sCub78Xud_g-x4Q13j-DGWJSNQ57DdtwNvWK7uvKzKrdcUTETERYRqbw=s900-c-k-c0x00ffffff-no-rj',
      //     ),
      //     MechanicCard(
      //       name: 'Nilesh garage',
      //       address: 'Mangrapoi road, Karwar',
      //       pricePerHour: '₹450/hr',
      //       image: 'https://thumbs.dreamstime.com/z/indian-mechanic-repairing-hero-bike-workshop-india-january-indian-mechanic-repairing-hero-bike-workshop-india-170883288.jpg',
      //     ),
      //     MechanicCard(
      //       name: 'Rajesh Naik',
      //       address: 'Henja naik road, Karwar',
      //       pricePerHour: '₹580/hr',
      //       image: 'https://5.imimg.com/data5/GC/TH/MY-37824774/bike-engine-repairing-service-500x500.jpg',
      //     ),
      //   ],
      // ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: NetworkImage('https://images.pexels.com/photos/12884318/pexels-photo-12884318.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  'Welcome User', // Replace with the user's name
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Navigate to the home page
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                // Navigate to the settings page
                // Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreenUser()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory_rounded),
              title: const Text('Appointments'),
              onTap: () {
                // Navigate to the settings page
                // Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserAppointmentScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                // Navigate to the about page
                Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
                // Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Navigate to the about page
                Navigator.pop(context);
                logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// class MechanicCard extends StatelessWidget {
//   final String name;
//   final String address;
//   final String pricePerHour;
//   final String image;
//
//   MechanicCard({
//     required this.name,
//     required this.address,
//     required this.pricePerHour,
//     required this.image,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4.0,
//       margin: EdgeInsets.only(bottom: 20.0),
//       child: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 3,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: TextStyle(
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 5.0),
//                   Text(
//                     address,
//                     style: TextStyle(
//                       fontSize: 16.0,
//                     ),
//                   ),
//                   SizedBox(height: 5.0),
//                   Text(
//                     'Price/hour: $pricePerHour',
//                     style: TextStyle(
//                       fontSize: 16.0,
//                     ),
//                   ),
//                   SizedBox(height: 10.0),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Add functionality to book mechanic
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => BookMechanicPage(mechanicName: name, mechanicAddress: address, mechanicPricePerHour: pricePerHour,)));
//                     },
//                     child: Text('Book Now'),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: AspectRatio(
//                 aspectRatio: 9/12,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12.0),
//                   child: Image(
//                     image: NetworkImage(image),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }





class CurrentLocation extends StatefulWidget {

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  late String lat;
  late String long;
  String locationMessage = "Current Location of the user";

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error("Location Services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error("Location Services are denied");
      }
    }

    if(permission == LocationPermission.deniedForever){
      return Future.error("Location permissions are permanently denied, we cannot proceed further without the location");
    }

    return await Geolocator.getCurrentPosition();
  }

  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            BannerSlider(),
            Expanded(child: LocationScreen()),
          ],
        ),
        // Column(
        //   children: [
        //     // Text(locationMessage),
        //
        //     // TextFormField(
        //     //   controller: locationController,
        //     //   keyboardType: TextInputType.number,
        //     //   decoration: InputDecoration(
        //     //     hintText: 'enter your current location',
        //     //     filled: true,
        //     //     fillColor: Colors.white,
        //     //     border: OutlineInputBorder(
        //     //       borderRadius: BorderRadius.circular(10.0),
        //     //       // borderSide: BorderSide.none,
        //     //     ),
        //     //     prefixIcon: Icon(Icons.inventory_rounded),
        //     //   ),
        //     //   validator: (value) {
        //     //     if (value == null || value.isEmpty) {
        //     //       return 'This field is required';
        //     //     }
        //     //     return null;
        //     //   },
        //     // ),
        //     // SizedBox(height: 20,),
        //     // ElevatedButton(
        //     //     onPressed: (){
        //     //       //search mechanics
        //     //       // searchMechanics(locationController.text.toString());
        //     //       // addMechanicsToFirestore();
        //     //       getLocationPermission();
        //     //     },
        //     //     child: Text("Get my location")
        //     // ),
        //
        //     // ElevatedButton(
        //     //     onPressed: (){
        //     //       _getCurrentLocation().then((value){
        //     //         lat = '${value.latitude}';
        //     //         long = '${value.longitude}';
        //     //         setState(() {
        //     //           locationMessage = "Latitude: $lat, Longitude: $long";
        //     //         });
        //     //       });
        //     //     },
        //     //     child: Text("Get Current Location")
        //     // )
        //   ],
        // ),
      ),
    );
  }




  void addMechanicsToFirestore() {
    final List<Map<String, dynamic>> mechanicsData = [
      {
        "mechanicName": "Suresh Kumar",
        'mechanicPhone': '99887755',
        "mechanicAddress": "MG Road, Bangalore",
        "pricePerHour": "₹550/hr",
        "mechanicImage": "https://example.com/suresh_kumar.jpg",
        "latitude": "",
        "longitude": "",
      },
      {
        "mechanicName": "Ramesh Gupta",
        'mechanicPhone': '99887755',
        "mechanicAddress": "Gandhi Nagar, Delhi",
        "pricePerHour": "₹600/hr",
        "mechanicImage": "https://example.com/ramesh_gupta.jpg"
      },
      {
        "mechanicName": "Deepak Singh",
        'mechanicPhone': '99887755',
        "mechanicAddress": "Lal Chowk, Lucknow",
        "pricePerHour": "₹500/hr",
        "mechanicImage": "https://example.com/deepak_singh.jpg"
      },
      {
        "mechanicName": "Amit Sharma",
        'mechanicPhone': '99887755',
        "mechanicAddress": "Railway Colony, Mumbai",
        "pricePerHour": "₹650/hr",
        "mechanicImage": "https://example.com/amit_sharma.jpg"
      },
      {
        "mechanicName": "Vinod Patel",
        'mechanicPhone': '99887755',
        "mechanicAddress": "Ashram Road, Ahmedabad",
        "pricePerHour": "₹550/hr",
        "mechanicImage": "https://example.com/vinod_patel.jpg"
      }
    ];
    final CollectionReference mechanicsCollection = FirebaseFirestore.instance.collection('mechanics');

    mechanicsData.forEach((mechanic) {
      mechanicsCollection.add(mechanic).then((value) {
        print("Mechanic added with ID: ${value.id}");
      }).catchError((error) {
        print("Failed to add mechanic: $error");
      });
    });
  }

  Future<void> searchMechanics(String string) async {

    // mechanicName
    // mechanicPhone
    // mechanicAddress
    // mechanicImage
    // pricePerHour

  }
}


class BannerSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('banners').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List<String> imageUrls = snapshot.data!.docs.map((doc) => doc['imageUrl'] as String).toList();

        return CarouselSlider(
          options: CarouselOptions(
            height: 150.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 0.8,
          ),
          items: imageUrls.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(width: 1)
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}

// class Location {
//   double latitude;
//   double longitude;
//
//   Location({required this.latitude, required this.longitude});
// }
//
// class Mechanic {
//   String name;
//   Location location;
//
//   Mechanic({required this.name, required this.location});
// }
//
// // Function to calculate distance between two locations using Haversine formula
// double calculateDistance(Location location1, Location location2) {
//   const earthRadius = 6371; // Radius of the earth in kilometers
//   var latDifference = (location2.latitude - location1.latitude).toRadians();
//   var lonDifference = (location2.longitude - location1.longitude).toRadians();
//
//   var a = sin(latDifference / 2) * sin(latDifference / 2) +
//       cos(location1.latitude.toRadians()) *
//           cos(location2.latitude.toRadians()) *
//           sin(lonDifference / 2) *
//           sin(lonDifference / 2);
//   var c = 2 * atan2(sqrt(a), sqrt(1 - a));
//
//   return earthRadius * c; // Distance in kilometers
// }
//
// // Example user location
// var userLocation = Location(latitude: 12.9716, longitude: 77.5946);
//
// // Example list of mechanics
// var mechanics = [
//   Mechanic(name: 'Manjunatha', location: Location(latitude: 12.9722, longitude: 77.5806)),
//   Mechanic(name: 'Gajanan Naik', location: Location(latitude: 12.9634, longitude: 77.5970)),
//   Mechanic(name: 'Manoj Gaudar', location: Location(latitude: 12.9681, longitude: 77.6245)),
//   // Add more mechanics here...
// ];
//
// // Filter mechanics based on proximity to user's location within a certain radius
// double maxDistance = 5.0; // Maximum distance in kilometers
// var nearbyMechanics = mechanics.where((mechanic) => calculateDistance(userLocation, mechanic.location) <= maxDistance);
//
// // Display nearby mechanics
// nearbyMechanics.forEach((mechanic) {
// print('Name: ${mechanic.name}, Distance: ${calculateDistance(userLocation, mechanic.location)} km');
// });


// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
//
//
// class HomePageUser extends StatefulWidget {
//   @override
//   _HomePageUserState createState() => _HomePageUserState();
// }
//
// class _HomePageUserState extends State<HomePageUser> {
//   String _locationMessage = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _getLocation();
//   }
//
//   Future<void> _getLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _locationMessage =
//       'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('GPS Tracking'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Location:',
//               style: TextStyle(fontSize: 20),
//             ),
//             Text(
//               _locationMessage,
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
