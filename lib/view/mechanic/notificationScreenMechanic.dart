import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationScreenMechanic extends StatefulWidget {
  const NotificationScreenMechanic({super.key});

  @override
  _NotificationScreenUserMechanicState createState() => _NotificationScreenUserMechanicState();
}

class _NotificationScreenUserMechanicState extends State<NotificationScreenMechanic> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  List<String> _notifications = [];

  @override
  void initState() {
    super.initState();
    // Configure Firebase Messaging
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle incoming messages when the app is in the foreground
      _handleMessage(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notifications tapped when the app is terminated/background
      _handleMessage(message);
    });
    // Subscribe to a topic or set up token refreshing as needed
    _firebaseMessaging.subscribeToTopic('mechanic_notifications');
  }

  void _handleMessage(RemoteMessage message) {
    setState(() {
      // Extract relevant information from the message
      String notificationText = message.notification?.body ?? '';
      _notifications.add(notificationText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_notifications[index]),
          );
        },
      ),
    );
  }
}
