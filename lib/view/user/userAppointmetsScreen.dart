import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'appointmentDetailPage.dart';
// import 'package:vehicle_help_new/view/user/appointmentDetailPage.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);


class UserAppointmentScreen extends StatefulWidget {
  const UserAppointmentScreen({
    super.key,
    // required this.docId,
    // required this.uid,
    // required this.userId,
    // required this.userAppointmentDocId
  });

  @override
  State<UserAppointmentScreen> createState() => _UserAppointmentScreenState();

  // final String docId;
  // final String uid;
  // final String userId;
  // final String userAppointmentDocId;
}

class _UserAppointmentScreenState extends State<UserAppointmentScreen> {

  String userUid = FirebaseAuth.instance.currentUser!.uid;
  late String mechanicId;
  late String userDocId;
  late String mechanicDocId;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<User?>(
          future: _getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: Text('Error: Unable to fetch user data.'),
              );
            }

            // setState(() {
              // User is logged in, fetch appointments using UID
              // userUid = FirebaseAuth.instance.currentUser!.uid;
            // });

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bookMechanic')
                  .doc(userUid)
                  .collection('appointments')
                  .orderBy('bookingTime', descending: true)
                  .snapshots(),

              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
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

                    // mechanicId = data['mechanicId'];
                    // userDocId = document.id;
                    // mechanicDocId = data['mechanicAppointmentDocId'];

                    return InkWell(
                      onTap: (){
                        // print("clicked");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppointmentDetailScreen(
                                  items: data['bill'],
                                  totalAmount: data['totalBillAmount'],
                                  paymentStatus: data['paymentStatus'] == true ? "Completed" : "Pending",
                                )
                            )
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Mechanic Name: ${data['mechanicName']}', style: TextStyle(fontWeight: FontWeight.bold),),
                                      Text('Mechanic Address: ${data['mechanicAddress']}'),
                                      Text('Booking Time: ${_formatDateTime(bookingTime)}'),
                                      Text('Price Per Hour: ${data['mechanicPricePerHour']}'),
                                      Text('Problem Description: ${data['problemDescription']}'),
                                      if(data['status'] == "completed")
                                        Text('Total Amount: ${capitalize(data['totalBillAmount'].toString())}'),
                                        Text('Payment Status: ${data['paymentStatus'] == true ? "Payment Complete": "Payment Pending"}'),

                                    ],
                                  )
                              ),
                              // if(data['status'] == 'completed')
                                Column(
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
                                  if(data['status'] == "completed" && data['paymentStatus'] == false)
                                    ElevatedButton(
                                      onPressed: (){
                                        mechanicId = data['mechanicId'];
                                        userDocId = document.id;
                                        mechanicDocId = data['mechanicAppointmentDocId'];
                                        Razorpay razorpay = Razorpay();
                                        var options = {
                                          'key': 'rzp_test_1DP5mmOlF5G5ag',
                                          'amount': data['totalBillAmount']*100,
                                          'name': 'Onclick Mechanic',
                                          'description': 'Book Nearby Mechanics',
                                          'retry': {'enabled': true, 'max_count': 1},
                                          'send_sms_hash': true,
                                          'prefill': {
                                            'contact': '8888888888',
                                            'email': 'test@razorpay.com'
                                          },
                                          'external': {
                                            'wallets': ['paytm']
                                          }
                                        };
                                        razorpay.on(
                                            Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                                        razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                                            handlePaymentSuccessResponse
                                        );
                                        razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                                            handleExternalWalletSelected);
                                        razorpay.open(options);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20), // Adjust the value as needed
                                          ),
                                          backgroundColor: Colors.blue
                                      ),
                                      child: const Text(
                                        "Pay Now",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                  // Icon(Icons.check, color: Colors.green,)
                                  // ElevatedButton(
                                  //     onPressed: (){
                                  //       Uri call = Uri.parse('tel:${data['contactNumber']}');
                                  //       launchUrl(call);
                                  //       // _launchPhoneCall('1234567890');
                                  //     },
                                  //     child: Icon(Icons.call)
                                  // )
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                    );


                    // return Card(
                    //   child: ListTile(
                    //     title: Text(capitalize(data['mechanicName'])),
                    //     subtitle: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text('Booking Time: ${_formatDateTime(bookingTime)}'),
                    //         // Text('Contact Number: ${data['contactNumber']}'),
                    //         Text('Mechanic Address: ${data['mechanicAddress']}'),
                    //         // Text('Mechanic ID: ${data['mechanicId']}'),
                    //         Text('Mechanic Price Per Hour: ${data['mechanicPricePerHour']}'),
                    //         Text('Problem Description: ${data['problemDescription']}'),
                    //         // Text('User Name: ${data['userName']}'),
                    //         // Add more fields as needed
                    //       ],
                    //     ),
                    //     trailing: Text(
                    //       capitalize(data['status']),
                    //         style: TextStyle(
                    //           fontSize: 14,
                    //           color: data['status'] == "accepted"
                    //               ? Colors.green
                    //               : data['status'] == "declined"
                    //                 ? Colors.red
                    //                 : data['status'] == "pending"
                    //                   ? Colors.orange
                    //                   : Colors.blue,
                    //         )
                    //
                    //     ),
                    //   ),
                    // );
                  }).toList(),
                );
                // return ListView(
                //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
                //     Map<String, dynamic> data =
                //     document.data() as Map<String, dynamic>;
                //     // Customize the UI to display appointment data
                //     return ListTile(
                //       title: Text(data['mechanicName']),
                //       subtitle: Text(data['status']),
                //       // Add more ListTile properties as needed
                //     );
                //   }).toList(),
                // );
              },
            );
          },
        ),
      ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    print("\n\n\ncalled\n\n");
    print("userDocId: $userDocId");
    print("userUid: $userUid");
    updateUserPaymentStatus(userDocId, userUid);
    print("mechanicDocId: $mechanicDocId");
    print("mechanicId: $mechanicId");
    updateMechanicPaymentStatus(mechanicDocId, mechanicId);


    // Navigator.pop(context);
    // Navigator.pop(context);
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  updateUserPaymentStatus(userDocId, userUid,) async {
    await FirebaseFirestore.instance.collection('bookMechanic')
        .doc(userUid)
        .collection("appointments")
        .doc(userDocId)
        .update({'paymentStatus': true});
  }

  updateMechanicPaymentStatus(mechanicDocId, mechanicUid) async {
    await FirebaseFirestore.instance.collection('mechanics')
        .doc(mechanicUid)
        .collection("appointments")
        .doc(mechanicDocId)
        .update({'paymentStatus': true});
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
}
