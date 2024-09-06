


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:food_ordering_attendence_app/landingPage.dart';
// import 'package:food_ordering_attendence_app/widgets/snackbar.dart';

import 'authScreen.dart';
import 'user/loginScreen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> logout(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text("Logout"),
            onPressed: () async {
              try {
                // Sign out the user
                await _auth.signOut();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()),
                      (route) => false, // Remove all routes
                );
              } catch (e) {
                print('Logout failed: $e');
                // Handle logout errors
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                  ),
                );
              }
            },
          ),
        ],
      );
    },
  );
}


Future<void> resetPassword(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    // Password reset email sent successfully
  } catch (e) {
    // An error occurred while sending the password reset email
    print('Error sending password reset email: $e');
  }
}


