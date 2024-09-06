import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_help_new/view/auth/mechanic/signupScreenMechanic.dart';

import '../../mechanic/mechanicDashboard.dart';
import '../../user/homeScreenUser.dart';
import '../forgotPasswordScreen.dart';



class LoginScreenMechanic extends StatefulWidget {
  const LoginScreenMechanic({super.key});


  @override
  State<LoginScreenMechanic> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenMechanic> {
  // Define form key
  final _formKey = GlobalKey<FormState>();

  // FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  // Function to handle user login
  Future<void> _loginUser(String email, String password, BuildContext context) async {
    // Validate form fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Form fields are valid, proceed with login
    try {
      setState(() {
        _isLoading = true;
      });

      // Sign in user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      setState(() {
        _isLoading = false;
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MechanicDashboardPage()),
            (route) => false,
      );
      // }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle login errors
      print('Login failed: $e');
      // Display error message to the user (e.g., using a Snackbar)
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Mechanic Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        _loginUser(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          context,
                        );
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageUser()));
                      },
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    TextButton(
                      onPressed: () {
                        // Navigate to password reset screen
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                      },
                      child: const Text('Forgot Password?'),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Don\'t have an account?'),
                        TextButton(
                          onPressed: () {
                            // Navigate to signup screen
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreenMechanic()));
                          },
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
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
}
