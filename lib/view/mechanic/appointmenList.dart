import 'package:flutter/material.dart';

class MechanicViewAppointmentsPage  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Appointments', style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
      //   centerTitle: true,
      // ),
      body: Column(

        children: [
          // Text('Appointments', style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
          Expanded(
            // flex: 1,
            child: ListView.builder(
              itemCount: 5, // Number of appointments
              itemBuilder: (context, index) {
                return AppointmentCard(
                  appointmentDate: 'Date: ${DateTime.now().add(Duration(days: index)).toString().split(' ')[0]}', // Example date
                  appointmentTime: 'Time: 10:00 AM', // Example time
                  customerName: 'Darshan patel', // Example customer name
                  customerAddress: 'Patel wada, Karwar', // Example customer address
                  status: index % 2 == 0 ? 'Pending' : 'Completed', // Example status
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String appointmentDate;
  final String appointmentTime;
  final String customerName;
  final String customerAddress;
  final String status;

  const AppointmentCard({
    required this.appointmentDate,
    required this.appointmentTime,
    required this.customerName,
    required this.customerAddress,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appointment Details',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(appointmentDate),
                  Text(appointmentTime),
                  SizedBox(height: 10.0),
                  Text(
                    'Customer: $customerName',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(customerAddress),
                  SizedBox(height: 10.0),
                  Text(
                    'Status: $status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: status == 'Pending' ? Colors.orange : Colors.green,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     ElevatedButton(
                  //       onPressed: () {
                  //         // Add functionality to accept appointment
                  //       },
                  //       style: ButtonStyle(
                  //         backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  //       ),
                  //       child: Text('Accept', style: TextStyle(color: Colors.white),),
                  //     ),
                  //     ElevatedButton(
                  //       onPressed: () {
                  //         // Add functionality to decline appointment
                  //       },
                  //       style: ButtonStyle(
                  //         backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  //       ),
                  //       child: Text('Decline', style: TextStyle(color: Colors.white),),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add functionality to accept appointment
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    child: Text('Accept', style: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add functionality to decline appointment
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child: Text('Decline', style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}