//
//
// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import '../../api/firebase_api.dart';
//
// class NotificationScreenUser extends StatefulWidget {
//   const NotificationScreenUser({Key? key}) : super(key: key);
//
//   @override
//   _NotificationScreenUserState createState() => _NotificationScreenUserState();
// }
//
// class _NotificationScreenUserState extends State<NotificationScreenUser> {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   List<RemoteMessage> _notifications = [];
//
//   @override
//   void initState() {
//     super.initState();
//     // Retrieve notifications when the widget initializes
//     FirebaseAPI().getNotifications().then((notifications) {
//       setState(() {
//         _notifications = notifications;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notifications'),
//       ),
//       body: ListView.builder(
//         itemCount: _notifications.length,
//         itemBuilder: (context, index) {
//           final message = _notifications[index];
//           return ListTile(
//             title: Text(message.notification?.title ?? 'Empty Title'),
//             subtitle: Text(message.notification?.body ?? 'Empty Body'),
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NotificationScreenUser extends StatefulWidget {
  @override
  _NotificationScreenUserState createState() => _NotificationScreenUserState();
}

class _NotificationScreenUserState extends State<NotificationScreenUser> {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _initFirebaseMessaging();
    _loadNotifications();
  }

  void _initFirebaseMessaging() {
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     // Handle incoming FCM message when the app is in foreground
    //     _showNotification(message);
    //     _storeNotification(message);
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     // Handle when the app is launched from a terminated state by tapping on the notification
    //     _navigateToScreen(message);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     // Handle when the app is resumed from the background by tapping on the notification
    //     _navigateToScreen(message);
    //   },
    // );
  }

  void _showNotification(Map<String, dynamic> message) {
    // Display notification
    // Use Flutter local notification plugin or any other notification library
  }

  void _storeNotification(Map<String, dynamic> message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedNotifications = prefs.getStringList('notifications') ?? [];
    storedNotifications.add(json.encode(message));
    prefs.setStringList('notifications', storedNotifications);
    _loadNotifications();
  }

  void _loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedNotifications = prefs.getStringList('notifications') ?? [];
    setState(() {
      _notifications = storedNotifications.map((jsonString) => json.decode(jsonString)).toList().cast<Map<String, dynamic>>();
    });
  }

  void _navigateToScreen(Map<String, dynamic> message) {
    // Navigate to relevant screen based on the notification payload
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
            title: Text(_notifications[index]['notification']['title'] ?? ''),
            subtitle: Text(_notifications[index]['notification']['body'] ?? ''),
            onTap: () {
              // Handle tap on notification to navigate to relevant screen
              _navigateToScreen(_notifications[index]);
            },
          );
        },
      ),
    );
  }
}