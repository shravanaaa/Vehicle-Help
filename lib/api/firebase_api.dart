// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:vehicle_help_new/main.dart';
//
// class FirebaseAPI {
//   // Create an instance of firebase messaging
//   final _firebaseMessaging = FirebaseMessaging.instance;
//
//   // Function to initialize notifications
//   Future<void> initNotifications() async {
//     // request permission from user (will prompt user)
//     await _firebaseMessaging.requestPermission();
//
//     // fetch the FCM token for this device
//     final fCMToken = await _firebaseMessaging.getToken();
//
//     // print the token
//     print("Token: $fCMToken");
//
//     // initialize further settings for push notification
//     initPUshNotifications();
//   }
//
//   // Function to handle received messages
//   void handleMessage(RemoteMessage? message) {
//     // if the message is null, do nothing
//     if(message == null) return;
//
//     // navigate to new screen when message is received and user taps notification
//     navigatorKey.currentState?.pushNamed(
//         '/user_notification',
//       arguments: message
//     );
//   }
//
//   // Function to initialize foreground and background settings
//   Future initPUshNotifications() async {
//     // handle notifications if the app was terminated and now opened
//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//
//     // attach event listeners for when a notification opens the app
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//   }
// }

// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class FirebaseAPI {
//   final _firebaseMessaging = FirebaseMessaging.instance;
//   final _notificationsKey = 'notifications';
//
//   // Method to handle receiving messages
//   Future<void> handleMessage(RemoteMessage message) async {
//     // Extract relevant data from the message
//     final notificationData = {
//       'title': message.notification?.title,
//       'body': message.notification?.body,
//       // Add any other data you need from the message
//     };
//
//     // Store the notification data locally using shared preferences
//     final prefs = await SharedPreferences.getInstance();
//     final notificationsJson = prefs.getStringList(_notificationsKey) ?? [];
//     notificationsJson.add(jsonEncode(notificationData));
//     await prefs.setStringList(_notificationsKey, notificationsJson);
//   }
//
//   // Method to get the list of notifications
//   // Future<List<Map<String, dynamic>>> getNotifications() async {
//   //   // Retrieve the list of notifications from shared preferences
//   //   final prefs = await SharedPreferences.getInstance();
//   //   final notificationsJson = prefs.getStringList(_notificationsKey) ?? [];
//   //   final notifications = notificationsJson.map((json) => jsonDecode(json)).toList();
//   //   return notifications.cast<Map<String, dynamic>>();
//   // }
//   Future<List<RemoteMessage>> getNotifications() async {
//     final prefs = await SharedPreferences.getInstance();
//     final notificationsJson = prefs.getStringList(_notificationsKey) ?? [];
//     final notifications = notificationsJson.map((json) {
//       final notificationData = jsonDecode(json);
//       return RemoteMessage.fromJson(notificationData);
//     }).toList();
//     return notifications;
//   }
//
//
// // Other methods and properties...
// }


import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../main.dart';

class FirebaseAPI {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _notificationsKey = 'notifications';

    Future<void> initNotifications() async {
    // request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    // fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();

    // print the token
    print("Token: $fCMToken");

    // initialize further settings for push notification
    initPUshNotifications();
  }

    // Function to handle received messages
  void handleMessage(RemoteMessage? message) {
    // if the message is null, do nothing
    if(message == null) return;

    // navigate to new screen when message is received and user taps notification
    navigatorKey.currentState?.pushNamed(
        '/user_notification',
      arguments: message
    );
  }

  Future initPUshNotifications() async {
    // handle notifications if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  Future<void> saveNotification(RemoteMessage notification) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList(_notificationsKey) ?? [];
    notifications.add(jsonEncode(notification.data));
    await prefs.setStringList(_notificationsKey, notifications);
  }

  Future<List<RemoteMessage>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getStringList(_notificationsKey) ?? [];
    final notifications = notificationsJson.map((json) {
      final notificationData = jsonDecode(json);
      final notification = RemoteNotification(
        title: notificationData['title'] ?? '',
        body: notificationData['body'] ?? '',
      );
      // Deserialize each notification data into a RemoteMessage object manually
      return RemoteMessage(
        messageId: notificationData['messageId'] ?? '',
        data: Map<String, String>.from(notificationData['data'] ?? {}),
        notification: notification,
      );
    }).toList();
    return notifications;
  }




  Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsKey);
  }
}
