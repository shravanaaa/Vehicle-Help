import 'package:flutter/material.dart';
import 'package:vehicle_help_new/view/auth/mechanic/loginScreenMechanic.dart';
import 'package:vehicle_help_new/view/auth/user/signupScreen.dart';

import 'user/loginScreen.dart';


class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Vehicle Help'),
      //   centerTitle: true,
      // ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Onclick Mechanic'),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'User Login'),
                Tab(text: 'Mechanic Login'),
              ],
              // indicator: BoxDecoration(
              //   color: Colors.purpleAccent,
              //   shape: BoxShape.rectangle,
              // ),
            ),
          ),
          body: const TabBarView(
            children: [
              LoginScreen(),
              LoginScreenMechanic()
              // SignupScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

