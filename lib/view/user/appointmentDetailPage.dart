import 'package:flutter/material.dart';

class AppointmentDetailScreen extends StatelessWidget {
  const AppointmentDetailScreen({super.key, required this.items, required this.totalAmount, required this.paymentStatus});

  final List items;
  final double totalAmount;
  final String paymentStatus;

  @override
  Widget build(BuildContext context) {
    // print(items.length);
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment Detail Page"),
      ),
      body: Column(
        children: [
          Text("Payment Status : $paymentStatus", style: TextStyle(fontSize: 20),),
          Expanded(
            child: ListView.builder(
              primary: false,
              itemCount: items.length + 1, // Add 1 for the total price item
              itemBuilder: (context, index) {
                if (index < items.length) {
                  // Display individual items
                  final item = items[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text('₹${item['price'].toStringAsFixed(2)}'), // Assuming price is in double
                  );
                } else {
                  // Display total price item
                  // double totalPrice = items.fold<double>(0.0, (previousValue, item) => previousValue + item.price);
                  return ListTile(
                    title: Text('Total Price: $totalAmount'),
                    // subtitle: Text('\$${totalPrice.toStringAsFixed(2)}'),
                  );
                }
              },
            ),
          ),
        ]
      ),
    );
  }
}
