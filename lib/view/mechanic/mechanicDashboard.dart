// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:vehicle_help_new/view/mechanic/invoiceGenerator.dart';
// import 'package:vehicle_help_new/view/mechanic/profilePageMechanic.dart';
// import 'package:vehicle_help_new/view/screens/aboutScreen.dart';
//
// import '../auth/authRepository.dart';
// import 'appointmenList.dart';
//
// class MechanicDashboardPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Appointments'),
//         centerTitle: true,
//         actions: [
//           IconButton(onPressed: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreenMechanic()));
//           }, icon: Icon(Icons.person))
//         ],
//       ),
//       body:  Padding(
//         padding: const EdgeInsets.all(10),
//         child: FutureBuilder<User?>(
//           future: _getCurrentUser(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             if (snapshot.hasError || snapshot.data == null) {
//               return Center(
//                 child: Text('Error: Unable to fetch user data.'),
//               );
//             }
//             // User is logged in, fetch appointments using UID
//             final String uid = snapshot.data!.uid;
//
//             return StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('mechanics')
//                   .doc(uid)
//                   .collection('appointments')
//                   .snapshots(),
//
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text('Error: ${snapshot.error}'),
//                   );
//                 }
//                 if (snapshot.data!.docs.isEmpty) {
//                   return Center(
//                     child: Text('No appointments found.'),
//                   );
//                 }
//
//                 // Display appointment documents from the subcollection
//                 return ListView(
//                   children: snapshot.data!.docs.map((DocumentSnapshot document) {
//                     Map<String, dynamic> data =
//                     document.data() as Map<String, dynamic>;
//
//                     // Determine the color based on status
//                     Color statusColor = data['status'] == 'pending'
//                         ? Colors.orange
//                         : Colors.green;
//
//                     DateTime bookingTime = (data['bookingTime'] as Timestamp).toDate();
//
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Card(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text('Customer Name:${data['userName']}', style: TextStyle(fontSize: 15),),
//                                       Text('Booking Time: ${_formatDateTime(bookingTime)}'),
//                                       Text('Problem description: ${data['problemDescription']}'),
//                                       Text('Contact Number: ${data['contactNumber']}'),
//                                     ],
//                                   )
//                               ),
//                               data['status'] == 'pending'
//                                     ? Column(
//                                       children: [
//                                         ElevatedButton(
//                                           onPressed: (){
//                                             updateStatusToAccepted(document.id, data['userId']);
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(20), // Adjust the value as needed
//                                             ),
//                                             backgroundColor: Colors.green
//                                           ),
//                                           child: const Text(
//                                             "Accept",
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white
//                                             ),
//                                           ),
//                                         ),
//                                         // SizedBox(height: 10,),
//                                         ElevatedButton(
//                                           onPressed: (){
//                                             updateStatusToDeclined(document.id, data['userId']);
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(20), // Adjust the value as needed
//                                             ),
//                                               backgroundColor: Colors.red
//                                           ),
//                                           child: const Text(
//                                             "Decline",
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold,
//                                                 color: Colors.white
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     )
//                                     : const Text(
//                                   "Completed",
//                                   style: TextStyle(color: Colors.green),
//                                 ),
//                             ],
//                           ),
//                         )
//                         // ListTile(
//                         //   title: Text('Customer Name:${data['userName']}'),
//                         //   subtitle: Column(
//                         //     crossAxisAlignment: CrossAxisAlignment.start,
//                         //     children: [
//                         //       Text('Booking Time: ${_formatDateTime(bookingTime)}'),
//                         //       Text('Problem description: ${data['problemDescription']}'),
//                         //       Text('Contact Number: ${data['contactNumber']}'),
//                         //     ],
//                         //   ),
//                         //   trailing: data['status'] == 'pending'
//                         //       ? Column(
//                         //         children: [
//                         //           ElevatedButton(
//                         //             onPressed: (){
//                         //               updateStatusToAccepted(document.id, data['userId']);
//                         //             },
//                         //             style: ElevatedButton.styleFrom(
//                         //               shape: RoundedRectangleBorder(
//                         //                 borderRadius: BorderRadius.circular(20), // Adjust the value as needed
//                         //               ),
//                         //               backgroundColor: Colors.green
//                         //             ),
//                         //             child: Text(
//                         //               "Accept",
//                         //               style: TextStyle(
//                         //                 fontSize: 16,
//                         //                 fontWeight: FontWeight.bold,
//                         //               ),
//                         //             ),
//                         //           ),
//                         //           // SizedBox(height: 10,),
//                         //           ElevatedButton(
//                         //             onPressed: (){
//                         //               updateStatusToDeclined(document.id, data['userId']);
//                         //             },
//                         //             style: ElevatedButton.styleFrom(
//                         //               shape: RoundedRectangleBorder(
//                         //                 borderRadius: BorderRadius.circular(20), // Adjust the value as needed
//                         //               ),
//                         //                 backgroundColor: Colors.red
//                         //             ),
//                         //             child: Text(
//                         //               "Decline",
//                         //               style: TextStyle(
//                         //                 fontSize: 16,
//                         //                 fontWeight: FontWeight.bold,
//                         //               ),
//                         //             ),
//                         //           )
//                         //         ],
//                         //       )
//                         //       : const Text(
//                         //     "Completed",
//                         //     style: TextStyle(color: Colors.green),
//                         //   ),
//                         // ),
//                       ),
//                     );
//                   }).toList(),
//                 );
//                 // return ListView(
//                 //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
//                 //     Map<String, dynamic> data =
//                 //     document.data() as Map<String, dynamic>;
//                 //     // Customize the UI to display appointment data
//                 //     return ListTile(
//                 //       title: Text(data['mechanicName']),
//                 //       subtitle: Text(data['status']),
//                 //       // Add more ListTile properties as needed
//                 //     );
//                 //   }).toList(),
//                 // );
//               },
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigator.push(context, MaterialPageRoute(builder: (context) => InvoiceGeneratorScreen()));
//           _addMechanic();
//         },
//         child: Icon(Icons.add),
//         tooltip: "Generate Invoice",
//       ),
//       // MechanicViewAppointmentsPage(),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 image: DecorationImage(
//                   image: NetworkImage('https://images.pexels.com/photos/12884318/pexels-photo-12884318.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   'Welcome Mechanic', // Replace with the user's name
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                   ),
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.home),
//               title: Text('Home'),
//               onTap: () {
//                 // Navigate to the home page
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Profile'),
//               onTap: () {
//                 // Navigate to the settings page
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreenMechanic()));
//                 // Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.info),
//               title: Text('About'),
//               onTap: () {
//                 // Navigate to the about page
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
//                 // Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Logout'),
//               onTap: () {
//                 // Navigate to the about page
//                 Navigator.pop(context);
//                 logout(context);
//               },
//             ),
//           ],
//         ),
//       ),
//       // body: Center(
//       //   child: Column(
//       //     mainAxisAlignment: MainAxisAlignment.center,
//       //     children: [
//       //       MechanicViewAppointmentsPage(),
//       //     ],
//       //   ),
//       // ),
//     );
//   }
//
//   Future<User?> _getCurrentUser() async {
//     return FirebaseAuth.instance.currentUser;
//   }
//
//   String _formatDateTime(DateTime dateTime) {
//     String period = dateTime.hour < 12 ? 'AM' : 'PM';
//     int hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
//     hour = hour == 0 ? 12 : hour; // Handle midnight (12 AM)
//     String minute = dateTime.minute.toString().padLeft(2, '0');
//     return '${dateTime.day}/${dateTime.month}/${dateTime.year} at $hour:$minute $period';
//   }
//
//   Future<void> _addMechanic() async {
//     try {
//       // Get the current user's UID
//       String? uid = FirebaseAuth.instance.currentUser?.uid;
//       if (uid == null) {
//         // Handle the case where the user is not authenticated
//         return;
//       }
//       await FirebaseFirestore.instance.collection('mechanics')
//           .doc(uid)
//           .set({
//         'latitude':14.834505,
//         'longitude':74.146224,
//         'mechanicAddress':"Patel wada, Karwar",
//         'mechanicImage':"https://i.pinimg.com/originals/6b/eb/d2/6bebd2f554c39c4c62e548efa536a97c.jpg",
//         'mechanicName':"Gajanan Naik",
//         'mechanicPhone':"99887755",
//         'pricePerHour':"₹600/hr",
//       });
//       print("Successful");
//     }catch (e) {
//       print('Error booking mechanic: $e');
//       // Handle error if needed
//     }
//   }
//
//   void updateStatusToAccepted(docId, uid) async {
//     await FirebaseFirestore.instance.collection('bookMechanic')
//         .doc(uid)
//         .collection("appointments")
//         .doc(docId)
//         .update({'status': 'accepted'});
//   }
//
//   void updateStatusToDeclined(docId, uid) async {
//     await FirebaseFirestore.instance.collection('bookMechanic')
//         .doc(uid)
//         .collection("appointments")
//         .doc(docId)
//         .update({'status': 'declined'});
//
//   }
//
// }
//
// class CardOption extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final VoidCallback onPressed;
//
//   const CardOption({
//     required this.title,
//     required this.icon,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width * 0.8,
//       child: Card(
//         elevation: 4.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15.0),
//         ),
//         child: InkWell(
//           onTap: onPressed,
//           borderRadius: BorderRadius.circular(15.0),
//           child: Padding(
//             padding: EdgeInsets.all(20.0),
//             child: Row(
//               children: [
//                 Icon(
//                   icon,
//                   size: 30.0,
//                   color: Theme.of(context).primaryColor,
//                 ),
//                 SizedBox(width: 20.0),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vehicle_help_new/view/mechanic/invoiceGenerator.dart';
import 'package:vehicle_help_new/view/mechanic/profilePageMechanic.dart';
import 'package:vehicle_help_new/view/screens/aboutScreen.dart';

import '../auth/authRepository.dart';
import 'appointmenList.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);


class MechanicDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreenMechanic()));
          }, icon: Icon(Icons.person))
        ],
      ),
      body:  Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<User?>(
          future: _getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError || snapshot.data == null) {
              return const Center(
                child: Text('Error: Unable to fetch user data.'),
              );
            }
            // User is logged in, fetch appointments using UID
            final String uid = snapshot.data!.uid;

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('mechanics')
                  .doc(uid)
                  .collection('appointments')
                  .orderBy('bookingTime', descending: true) // Sort by bookingTime in descending order
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No appointments found.'),
                  );
                }

                // Display appointment documents from the subcollection
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                    // Determine the color based on status
                    Color statusColor = data['status'] == 'pending'
                        ? Colors.orange
                        : Colors.green;

                    DateTime bookingTime = (data['bookingTime'] as Timestamp).toDate();

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Customer Name:${capitalize(data['userName'])}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                        Text('Booking Time: ${_formatDateTime(bookingTime)}'),
                                        Text('Problem description: ${data['problemDescription']}'),
                                        Text('Contact Number: ${data['contactNumber']}'),
                                        if(data['status'] == "completed")
                                          Text('Payment Status: ${data['paymentStatus'] == true ? "Payment Complete": "Payment Pending"}'),

                                      ],
                                    )
                                ),
                                data['status'] == 'pending'
                                    ? Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: (){
                                        updateUserStatusToAccepted(document.id, data['userId'], data['userAppointmentDocId']);
                                        updateMechanicStatusToAccepted(document.id, uid,);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20), // Adjust the value as needed
                                          ),
                                          backgroundColor: Colors.green
                                      ),
                                      child: const Text(
                                        "Accept",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                    // SizedBox(height: 10,),
                                    ElevatedButton(
                                      onPressed: (){
                                        updateUserStatusToDeclined(document.id, data['userId'], data['userAppointmentDocId']);
                                        updateMechanicStatusToDeclined(document.id, uid,);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20), // Adjust the value as needed
                                          ),
                                          backgroundColor: Colors.red
                                      ),
                                      child: const Text(
                                        "Decline",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                      ),
                                    )
                                  ],
                                )
                                    : Column(
                                        children: [
                                          // if(data['status'] != "completed" )
                                          Text(
                                            capitalize(data['status']),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: data['status'] == "accepted"
                                                  ? Colors.green
                                                  : data['status'] == "declined"
                                                    ? Colors.red
                                                    : data['status'] == "pending"
                                                      ? Colors.orange
                                                      : Colors.blue,
                                            )
                                          ),
                                          if(data['status'] == "accepted" )
                                            ElevatedButton(
                                              onPressed: (){
                                                updateUserStatusToCompleted(document.id, data['userId'], data['userAppointmentDocId']);
                                                updateMechanicStatusToCompleted(document.id, uid,);
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => InvoiceGeneratorScreen(customerName: data['userName'], docId: document.id, uid: uid, userId: data['userId'], userAppointmentDocId: data['userAppointmentDocId'],)));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20), // Adjust the value as needed
                                                  ),
                                                  backgroundColor: Colors.blue
                                              ),
                                              child: const Text(
                                                "Complete",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ),
                                              // Icon(Icons.check, color: Colors.green,)
                                          ElevatedButton(
                                              onPressed: (){
                                                Uri call = Uri.parse('tel:${data['contactNumber']}');
                                                launchUrl(call);
                                                // _launchPhoneCall('1234567890');
                                              },
                                              child: Icon(Icons.call)
                                          )
                                        ],
                                      ),

                              ],
                            ),
                          )
                      ),
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Navigator.push(context, MaterialPageRoute(builder: (context) => InvoiceGeneratorScreen()));
      //     // _addMechanic();
      //   },
      //   tooltip: "Generate Invoice",
      //   child: const Icon(Icons.add),
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
                  'Welcome Mechanic', // Replace with the user's name
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreenMechanic()));
                // Navigator.pop(context);
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

  Future<User?> _getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  String _formatDateTime(DateTime dateTime) {
    String period = dateTime.hour < 12 ? 'AM' : 'PM';
    int hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    hour = hour == 0 ? 12 : hour; // Handle midnight (12 AM)
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at $hour:$minute $period';
  }

  Future<void> _addMechanic() async {
    try {
      // Get the current user's UID
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        // Handle the case where the user is not authenticated
        return;
      }
      await FirebaseFirestore.instance.collection('mechanics')
          .doc(uid)
          .set({
        'latitude':14.834505,
        'longitude':74.146224,
        'mechanicAddress':"Patel wada, Karwar",
        'mechanicImage':"https://i.pinimg.com/originals/6b/eb/d2/6bebd2f554c39c4c62e548efa536a97c.jpg",
        'mechanicName':"Gajanan Naik",
        'mechanicPhone':"99887755",
        'pricePerHour':"₹600/hr",
      });
      print("Successful");
    }catch (e) {
      print('Error booking mechanic: $e');
      // Handle error if needed
    }
  }

  // // make phone call
  // void _launchPhoneCall(String phoneNumber) async {
  //   String url = 'tel:$phoneNumber';
  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(Uri.parse(url));
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  void _launchPhoneCall(String phoneNumber) async {
    // Remove any non-digit characters from the phone number
    phoneNumber = phoneNumber.replaceAll(RegExp(r'\D+'), '');

    // Check if the phone number is not empty
    if (phoneNumber.isNotEmpty) {
      String url = 'tel:$phoneNumber';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } else {
      throw 'Invalid phone number';
    }
  }



  // update the user's status
  void updateUserStatusToAccepted(docId, uid, userAppointmentDocId) async {
    await FirebaseFirestore.instance.collection('bookMechanic')
        .doc(uid)
        .collection("appointments")
        .doc(userAppointmentDocId)
        .update({'status': 'accepted'});
  }

  void updateUserStatusToDeclined(docId, uid, userAppointmentDocId) async {
    await FirebaseFirestore.instance.collection('bookMechanic')
        .doc(uid)
        .collection("appointments")
        .doc(userAppointmentDocId)
        .update({'status': 'declined'});

  }

  void updateUserStatusToCompleted(docId, uid, userAppointmentDocId) async {
    await FirebaseFirestore.instance.collection('bookMechanic')
        .doc(uid)
        .collection("appointments")
        .doc(userAppointmentDocId)
        .update({'status': 'completed'});

  }


  // update the mechanics's status
  void updateMechanicStatusToAccepted(docId, uid) async {
    await FirebaseFirestore.instance.collection('mechanics')
        .doc(uid)
        .collection("appointments")
        .doc(docId)
        .update({'status': 'accepted'});
  }

  void updateMechanicStatusToDeclined(docId, uid,) async {
    await FirebaseFirestore.instance.collection('mechanics')
        .doc(uid)
        .collection("appointments")
        .doc(docId)
        .update({'status': 'declined'});

  }

  void updateMechanicStatusToCompleted(docId, uid,) async {
    await FirebaseFirestore.instance.collection('mechanics')
        .doc(uid)
        .collection("appointments")
        .doc(docId)
        .update({'status': 'completed'});

  }

}

// class CardOption extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final VoidCallback onPressed;
//
//   const CardOption({
//     required this.title,
//     required this.icon,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width * 0.8,
//       child: Card(
//         elevation: 4.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15.0),
//         ),
//         child: InkWell(
//           onTap: onPressed,
//           borderRadius: BorderRadius.circular(15.0),
//           child: Padding(
//             padding: EdgeInsets.all(20.0),
//             child: Row(
//               children: [
//                 Icon(
//                   icon,
//                   size: 30.0,
//                   color: Theme.of(context).primaryColor,
//                 ),
//                 SizedBox(width: 20.0),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
