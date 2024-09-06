import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookMechanicPage extends StatefulWidget {
  final String mechanicId;
  final String mechanicName;
  final String mechanicAddress;
  final String mechanicPricePerHour;

  BookMechanicPage({super.key,
    required this.mechanicId,
    required this.mechanicName,
    required this.mechanicAddress,
    required this.mechanicPricePerHour,
  });

  @override
  State<BookMechanicPage> createState() => _BookMechanicPageState();
}

class _BookMechanicPageState extends State<BookMechanicPage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController problemController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Mechanic'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mechanic Details:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text('Name: ${widget.mechanicName}'),
                    Text('Address: ${widget.mechanicAddress}'),
                    Text('Price per Hour: ${widget.mechanicPricePerHour}'),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Enter your details:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Your Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // borderSide: BorderSide.none,
                        ),
                        // prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Contact Number',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // borderSide: BorderSide.none,
                        ),
                        // prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: problemController,
                      decoration: InputDecoration(
                        hintText: 'Describe Your Problem',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // borderSide: BorderSide.none,
                        ),
                        // prefixIcon: Icon(Icons.person),
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        // Add functionality to book mechanic
                        if(formKey.currentState!.validate()){
                          setState(() {
                            isLoading = true;
                          });
                          _bookMechanic(context);
                        }
                      },
                      child: const Text('Book Now'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.4), // Dark background with 40% transparency
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _bookMechanic(BuildContext context) async {
    try {
      // Get the current user's UID
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        // Handle the case where the user is not authenticated
        return;
      }

      DocumentReference userAppointmentRef = await FirebaseFirestore.instance
          .collection('bookMechanic')
          .doc(uid)
          .collection("appointments")
          .add({
        'mechanicId': widget.mechanicId,
        'mechanicName': widget.mechanicName,
        'mechanicAddress': widget.mechanicAddress,
        'mechanicPricePerHour': widget.mechanicPricePerHour,
        'userName': nameController.text,
        'contactNumber': phoneController.text,
        'problemDescription': problemController.text,
        'status': 'pending',
        'bill': [],
        'paymentStatus': false,
        'totalBillAmount': 0.0,
        'bookingTime': DateTime.now(),
      });

      String userAppointmentDocId = userAppointmentRef.id;

      // await FirebaseFirestore.instance.collection('bookMechanic').doc(uid).collection("appointments").add({
      //   'mechanicId': widget.mechanicId,
      //   'mechanicName': widget.mechanicName,
      //   'mechanicAddress': widget.mechanicAddress,
      //   'mechanicPricePerHour': widget.mechanicPricePerHour,
      //   'userName': nameController.text, // Assuming you have controllers for name, contact, and description fields
      //   'contactNumber': phoneController.text,
      //   'problemDescription': problemController.text,
      //   'status': 'pending', // Set the status as pending
      //   'bookingTime': DateTime.now(), // You can add the booking time if needed
      // });

      DocumentReference mechanicAppointmentRef = await FirebaseFirestore.instance.collection('mechanics')
          .doc(widget.mechanicId)
          .collection('appointments')
          .add({
            'userId': uid,
            'userName': nameController.text,
            'contactNumber': phoneController.text,
            'problemDescription': problemController.text,
            'status': 'pending',
            'bill': [],
            'paymentStatus': false,
            'bookingTime': DateTime.now(),
            'totalBillAmount': 0.0,
            'userAppointmentDocId': userAppointmentDocId
          });

      String mechanicAppointmentDocId = mechanicAppointmentRef.id;

      await FirebaseFirestore.instance
          .collection('bookMechanic')
          .doc(uid)
          .collection("appointments")
          .doc(userAppointmentDocId)
          .update({
            'mechanicAppointmentDocId': mechanicAppointmentDocId
          });


      setState(() {
        isLoading = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Booking Confirmed'),
            content: const Text('Your booking has been confirmed.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  nameController.clear();
                  phoneController.clear();
                  problemController.clear();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error booking mechanic: $e');
      // Handle error if needed
    }
  }
}
