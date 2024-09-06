import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_help_new/api/firebase_api.dart';
import 'package:vehicle_help_new/view/auth/authScreen.dart';
import 'package:vehicle_help_new/view/auth/user/loginScreen.dart';
import 'package:vehicle_help_new/view/mechanic/mechanicDashboard.dart';
import 'package:vehicle_help_new/view/mechanic/notificationScreenMechanic.dart';
import 'package:vehicle_help_new/view/user/homeScreenUser.dart';
import 'package:vehicle_help_new/view/user/notificationScreenUser.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAPI().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Onclick Mechanic',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      routes: {
        '/authScreen': (context) => AuthScreen(),
        '/mainPage': (context) => MainPage(),
        '/user_notification': (context) => NotificationScreenUser(),
        '/mechanic_notification': (context) => NotificationScreenMechanic(),
      },
      // home: const MyHomePage(title: 'Vehicle Help'),
      // home: MainPage(),
      home: SplashScreen(),
    );
  }
}



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Set animation duration
    );
    // Start animation
    _animationController.forward();
    // Navigate to the next screen after animation completes
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/mainPage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Center(
        child: ScaleTransition(
          scale: _animationController,
          child: const Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // FlutterLogo(size: 200),
              FaIcon(FontAwesomeIcons.wrench, size: 100,), // This will display a wrench icon from Font Awesome
              SizedBox(height: 15,),
              Text("Onclick Mechanic", style: TextStyle(fontSize: 30), textAlign: TextAlign.center,)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose animation controller
    super.dispose();
  }
}


class MainPage extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User?>(
        future: Future.value(_auth.currentUser),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Loading indicator while checking user login status
          }
          if (snapshot.hasData && snapshot.data != null) {
            // User is logged in, determine user role
            String? userEmail = snapshot.data!.email;
            if (userEmail != null) {
              // Check if user is staff based on email domain (example)
              bool isMechanic = userEmail.startsWith('mechanic');
              //mechanic_vijay@gmail.com

              // Navigate to the appropriate screen based on user role
              if (isMechanic) {
                // User is staff, navigate to staff menu screen
                return MechanicDashboardPage();
              } else {
                // User is regular user, navigate to menu screen
                return HomePageUser();
              }
            } else {
              // Email is null, navigate to login screen
              return AuthScreen();
            }
          } else {
            // User is not logged in, navigate to login screen
            return AuthScreen();
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // body: MechanicDashboardPage()
      // body: HomePageUser()
      body: AuthScreen()
    );
  }
}


