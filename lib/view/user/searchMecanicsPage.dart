import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;

import 'bookMechanic.dart';

class SearchMechanicsPage extends StatefulWidget {
  const SearchMechanicsPage({Key? key, required this.latitude, required this.longitude}) : super(key: key);

  final double latitude;
  final double longitude;

  @override
  State<SearchMechanicsPage> createState() => _SearchMechanicsPageState();
}

class _SearchMechanicsPageState extends State<SearchMechanicsPage> {
  List<DocumentSnapshot>? _mechanics;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getNearbyMechanics();
  }

  Future<void> _getNearbyMechanics() async {
    try {
      setState(() {
        isLoading = true;
      });
      const double radius = 0.5; // Define the search radius in kilometers
      const double earthRadius = 6371.0; // Earth radius in kilometers
      final double lat = widget.latitude;
      final double lon = widget.longitude;

      const double latRadius = radius / earthRadius * (180.0 / math.pi);
      final double lonRadius = radius / earthRadius * (180.0 / math.pi) / math.cos(lat * math.pi / 180.0);

      final double minLat = lat - latRadius;
      final double maxLat = lat + latRadius;
      final double minLon = lon - lonRadius;
      final double maxLon = lon + lonRadius;
      // final double minLat = double.parse((lat - latRadius).toStringAsFixed(6));
      // final double maxLat = double.parse((lat + latRadius).toStringAsFixed(6));
      // final double minLon = double.parse((lon - lonRadius).toStringAsFixed(6));
      // final double maxLon = double.parse((lon + lonRadius).toStringAsFixed(6));

      // final double minLat = widget.latitude;
      // final double maxLat = widget.latitude;
      // final double minLon = widget.longitude;
      // final double maxLon = widget.longitude;

      print("maximum latitude: $maxLat");
      print(14.837593608029595 > 14.834505);
      // print("minimum longitude: $minLon");

      // final QuerySnapshot snapshot = await FirebaseFirestore.instance
      //     .collection('mechanics')
      //     .where('latitude', isGreaterThanOrEqualTo: minLat)
      //     // .where('latitude', isLessThanOrEqualTo: maxLat)
      //     .get();


      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('mechanics')
          // .where('latitude', isLessThanOrEqualTo: minLat)
          .where('latitude', isGreaterThanOrEqualTo: maxLat)
          // .where('longitude', isGreaterThanOrEqualTo: minLon)
          // .where('longitude', isLessThanOrEqualTo: maxLon)
          .get();


      // final QuerySnapshot snapshot = await FirebaseFirestore.instance
      //     .collection('mechanics')
      //     .where('latitude', isGreaterThanOrEqualTo: minLat)
      //     .where('latitude', isLessThanOrEqualTo: maxLat)
      //     .where('longitude', isGreaterThanOrEqualTo: minLon)
      //     .where('longitude', isLessThanOrEqualTo: maxLon)
      //     .get();

      setState(() {
        _mechanics = snapshot.docs;
        isLoading = false;
        if(_mechanics!.isNotEmpty){
          print("Data exists");
        }
        else{
          print("Data does not exists");
        }
      });
    } catch (e) {
      print('Error fetching nearby mechanics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Mechanics"),
        centerTitle: true,
      ),
      body: _mechanics != null && _mechanics!.isNotEmpty
      ? Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Center(
                  child: Text("Your current location", style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Text("Latitude: ${widget.latitude} \nLongitude: ${widget.longitude}", style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
                ),
                SizedBox(height: 10,),
                Expanded(
                  child: ListView.builder(
                    itemCount: _mechanics!.length,
                    itemBuilder: (context, index) {
                      final mechanic = _mechanics![index].data() as Map<String, dynamic>;
                      // print(_mechanics![index].id.toString());
                      return MechanicCard(
                          id: _mechanics![index].id,
                          name: mechanic['mechanicName'],
                          address: mechanic['mechanicAddress'],
                          pricePerHour: mechanic['pricePerHour'],
                          image: mechanic['mechanicImage']
                      );
                      // return ListTile(
                      //   title: Text(mechanic['mechanicName'] ?? ''),
                      //   subtitle: Text(mechanic['mechanicAddress'] ?? ''),
                      //   // Add more information if needed
                      // );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.4), // Dark background with 40% transparency
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ]
      )
      : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("Your current location", style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
          ),
          SizedBox(height: 10,),
          Center(
            child: Text("Latitude: ${widget.latitude} \nLongitude: ${widget.longitude}", style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
          ),
          SizedBox(height: 10,),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 200,
                height: 200,
                child: Image.asset('assets/images/noDataFound.jpg')
            ),
          ),
          SizedBox(height: 30,),
          Center(
            child: Text("No Mechanics found \nfor this location", style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
          ),
          SizedBox(height: 150,)
        ],
      ),
    );
  }
}


class MechanicCard extends StatelessWidget {
  final String id;
  final String name;
  final String address;
  final String pricePerHour;
  final String image;

  MechanicCard({
    required this.id,
    required this.name,
    required this.address,
    required this.pricePerHour,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.only(bottom: 20.0),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Price/hour: $pricePerHour',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      // Add functionality to book mechanic
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BookMechanicPage(mechanicId: id, mechanicName: name, mechanicAddress: address, mechanicPricePerHour: pricePerHour, )));
                    },
                    child: Text('Book Now'),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: AspectRatio(
                aspectRatio: 9/12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}