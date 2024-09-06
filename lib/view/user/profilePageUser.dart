// import 'package:flutter/material.dart';
//
// class ProfileScreenUser extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: 20.0),
//           CircleAvatar(
//             radius: 40.0,
//             child: Icon(Icons.person),
//           ),
//           SizedBox(height: 20.0),
//           Text(
//             'Darshan Patel',
//             style: TextStyle(
//               fontSize: 24.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 10.0),
//           Text(
//             '(User)',
//             style: TextStyle(
//               fontSize: 18.0,
//               color: Colors.grey,
//             ),
//           ),
//           SizedBox(height: 20.0),
//           ListTile(
//             leading: Icon(Icons.email),
//             title: Text('darshanpatel@example.com'),
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.phone),
//             title: Text('+91 9988776655'),
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.location_on),
//             title: Text('Patel wada, Karwar'),
//           ),
//           Divider(),
//           // SizedBox(height: 20.0),
//           // ElevatedButton(
//           //   onPressed: () {
//           //     // Add functionality to edit profile
//           //   },
//           //   child: Text('Edit Profile'),
//           // ),
//         ],
//       ),
//     );
//   }
// }



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreenUser extends StatefulWidget {
  const ProfileScreenUser({super.key,});

  @override
  State<ProfileScreenUser> createState() => _ProfileScreenUserState();
}

class _ProfileScreenUserState extends State<ProfileScreenUser> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('usersInfo').doc(user!.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading indicator while fetching data
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            // Data exists, show profile screen
            return buildProfileScreen(snapshot.data!, user.uid);
          } else {
            // Data doesn't exist, show registration form
            return const BuildRegistrationFormUser();
          }
        },
      )
    );
  }


  Widget buildProfileScreen(DocumentSnapshot userData, userUid) {
    // Extract user data from the snapshot
    String name = userData['name'];
    String email = userData['email'];
    String phoneNumber = userData['phone'];
    String address = userData['address'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            const CircleAvatar(
              radius: 40.0,
              child: Icon(Icons.person),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: (){
                    _showPopup(context, "Name", "name", userUid);
                  },
                  icon: const Icon(Icons.edit),
                )
              ],
            ),
            const SizedBox(height: 10.0),
            const Text(
              '(User)',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20.0),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(email),
              trailing: IconButton(
                onPressed: (){
                  _showPopup(context, "Email", "email", userUid);
                },
                icon: const Icon(Icons.edit),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(phoneNumber),
              trailing: IconButton(
                onPressed: (){
                  _showPopup(context, "Phone", "phone", userUid);
                },
                icon: const Icon(Icons.edit),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(address),
              trailing: IconButton(
                onPressed: (){
                  _showPopup(context, "Address", "address", userUid);
                },
                icon: const Icon(Icons.edit),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}


// Building the form to collect the user information
class BuildRegistrationFormUser extends StatefulWidget {
  const BuildRegistrationFormUser({super.key});

  @override
  State<BuildRegistrationFormUser> createState() => _BuildRegistrationFormUserState();
}

class _BuildRegistrationFormUserState extends State<BuildRegistrationFormUser> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  registerUser() {

    // Create a map containing user data
    Map<String, dynamic> userData = {
      'name': nameController.text.toString(),
      'email': emailController.text.toString(),
      'phone': phoneController.text.toString(),
      'address': addressController.text.toString(),
      // Add other user data here
    };

    // Save user data to Firestore
    FirebaseFirestore.instance.collection('usersInfo').doc(FirebaseAuth.instance.currentUser!.uid).set(userData)
        .then((value) {
      if (kDebugMode) {
        print('user data saved successfully');
      }
      Navigator.pop(context);
      // You can navigate to the profile screen here if needed
    })
        .catchError((error) {
      if (kDebugMode) {
        print('Failed to save user data: $error');
      }
      // Handle any errors here
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add your details'),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            // borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            // borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter your phone',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            // borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                          hintText: 'Enter your address',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            // borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: (){
                          if(formKey.currentState!.validate()){
                            registerUser();
                          }
                        }, // Call the registerUser function
                        child: const Text('Add details'),
                      ),
                    ],
                  ),
                )
            )
        ),
      ),
    );
  }
}



// dialogue box to collect the new value and update it
void _showPopup(BuildContext context, title, field, userUid) {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController fieldController = TextEditingController();


  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter your new $title',style: const TextStyle(fontSize: 18),),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: fieldController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: title,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your $title';
              }
              return null;
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {

                await FirebaseFirestore.instance
                    .collection('usersInfo')
                    .doc(userUid)
                    .update({'$field': fieldController.text.toString()});

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

