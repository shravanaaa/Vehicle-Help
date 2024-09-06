


import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Onclick Mechanic',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Onclick Mechanic is a convenient and efficient solution for all your automotive repair needs. Whether you\'re facing an urgent breakdown or simply need routine maintenance, "Onclick Mechanic" connects you with qualified mechanics in your area, ensuring prompt and reliable service.',
            textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20.0),
            Text(
              'Functionality:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '- Book Mechanics: Easily book mechanics for immediate assistance or schedule appointments for future service.',
            ),
            Text(
              '- Accept/Decline Requests: Mechanics can manage service requests by accepting or declining based on their availability and workload.',
            ),
            Text(
              '- Generate Invoice: Mechanics can efficiently generate invoices for completed services right from the app, streamlining billing and payment processes.',
            ),
            // Add more functionality details as needed
          ],
        ),
      ),
    );
  }
}
