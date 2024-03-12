import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:flutter_firebase/global/common/toast.dart';

class DonateForm extends StatefulWidget {
  static String id = 'Registration';

  @override
  State<DonateForm> createState() => _DonateFormState();
}

class _DonateFormState extends State<DonateForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? name;
  String? age;
  String? selectedGender;
  String? bloodgrp;

  late User loggedInuser;
  List<String> genders = [
    'Male',
    'Female',
    'Other',
  ];

  List<String> bloods = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
  ];

  void initState() {
    super.initState();
    currentuser();
  }

  void currentuser() async {
    try {
      final user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedInuser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Container(
            margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, "/login");
                    showToast(message: "Successfully signed out");
                  },
                  child: Icon(
                    Icons.logout_outlined,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Patient Details'),
                    Divider(),
                    SizedBox(height: 10.0),
                    TextFormField(
                      textAlign: TextAlign.left,
                      onChanged: (value) {
                        name = value;
                      },
                      decoration: customElevate(
                        'Full Name',
                        Icons.account_box_rounded,
                      ),
                      validator: (value) {
                        // Add validation for required field
                        if (value == null || value.isEmpty) {
                          return 'Enter Patient Name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedGender,
                            onChanged: (newValue) {
                              setState(() {
                                selectedGender = newValue;
                              });
                            },
                            items: genders.map((gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            decoration: customElevate('Gender', Icons.person),
                            validator: (value) {
                              // Add validation for required field
                              if (value == null || value.isEmpty) {
                                return 'Select Gender';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            onChanged: (value) {
                              age = value;
                            },
                            decoration:
                                customElevate('Age', Icons.confirmation_number),
                            validator: (value) {
                              // Add validation for required field
                              if (value == null || value.isEmpty) {
                                return 'Enter Patient Age';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: bloodgrp,
                            onChanged: (newValue) {
                              setState(() {
                                bloodgrp = newValue;
                              });
                            },
                            items: bloods.map((blood) {
                              return DropdownMenuItem<String>(
                                value: blood,
                                child: Text(blood),
                              );
                            }).toList(),
                            decoration:
                                customElevate('Blood Grp', Icons.bloodtype),
                            validator: (value) {
                              // Add validation for required field
                              if (value == null || value.isEmpty) {
                                return 'Select Blood Group';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 10.0),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Text('Blood Component Requirement'),
                    Divider(),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  await FirebaseFirestore.instance.collection('users').add({
                    'name': name,
                    'gender': selectedGender,
                    'status': 'Pending',
                    'email': loggedInuser.email,
                    'bloodgrp': bloodgrp,
                    'age': age,
                  });
                  // Delay for 1 second and then redirect to dashboard
                  Navigator.pushNamed(context, '/listpage');
                  showToast(message: 'request generated will contact you soon');
                } catch (error) {
                  print('Error adding user to Firestore: $error');
                }
              }
            },
            child: Text(
              'Make Request',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
