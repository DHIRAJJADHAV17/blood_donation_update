import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:flutter_firebase/global/common/toast.dart';

class CustomerReq extends StatefulWidget {
  static String id = 'Registration';

  @override
  State<CustomerReq> createState() => _CustomerReqState();
}

class _CustomerReqState extends State<CustomerReq> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? name;
  String? address;
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  String? amount;
  String? selectedGender;
  String? diagnosis;
  String? bloodgrp;
  String? paymentmode;
  bool urgent = false;
  bool regular = true;
  String? age;
  String? hb;
  String? wb;
  String? prc;
  String? ffp;
  String? rdp;
  String? sdp;
  String? pediatricbag;
  String? type;
  String? doctorname;

  late User loggedInuser;
  List<String> genders = [
    'Male',
    'Female',
    'Other',
  ];
  List<String> modetype = [
    'Cash',
    'Online',
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
                        Expanded(
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            onChanged: (value) {
                              hb = value;
                            },
                            decoration:
                                customElevate('HB (gm%)', Icons.percent),
                            validator: (value) {
                              // Add validation for required field
                              if (value == null || value.isEmpty) {
                                return 'Enter Patient HB';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      textAlign: TextAlign.left,
                      onChanged: (value) {
                        diagnosis = value;
                      },
                      decoration: customElevate('Enter Diagnosis', Icons.home),
                      // validator: (value) {
                      //   // Add validation for required field
                      //   if (value == null || value.isEmpty) {
                      //     return 'Enter Diagnosis';
                      //   }
                      //   return null;
                      // },
                    ),
                    SizedBox(height: 20.0),
                    Text('Blood Component Requirement'),
                    Divider(),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            onChanged: (value) {
                              wb = value;
                            },
                            decoration: customElevate('WB', Icons.bloodtype),
                            // validator: (value) {
                            //   // Add validation for required field
                            //   if (value == null || value.isEmpty) {
                            //     return 'Enter Value';
                            //   }
                            //   return null;
                            // },
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            onChanged: (value) {
                              prc = value;
                            },
                            decoration: customElevate('PRC', Icons.bloodtype),
                            // validator: (value) {
                            //   // Add validation for required field
                            //   if (value == null || value.isEmpty) {
                            //     return 'Enter Value';
                            //   }
                            //   return null;
                            // },
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            onChanged: (value) {
                              ffp = value;
                            },
                            decoration: customElevate('FFP', Icons.bloodtype),
                            // validator: (value) {
                            //   // Add validation for required field
                            //   if (value == null || value.isEmpty) {
                            //     return 'Enter Value';
                            //   }
                            //   return null;
                            // },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            onChanged: (value) {
                              rdp = value;
                            },
                            decoration: customElevate('RDP', Icons.bloodtype),
                            // validator: (value) {
                            //   // Add validation for required field
                            //   if (value == null || value.isEmpty) {
                            //     return 'Enter Value';
                            //   }
                            //   return null;
                            // },
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            onChanged: (value) {
                              sdp = value;
                            },
                            decoration: customElevate('SDP', Icons.bloodtype),
                            // validator: (value) {
                            //   // Add validation for required field
                            //   if (value == null || value.isEmpty) {
                            //     return 'Enter Value';
                            //   }
                            //   return null;
                            // },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      textAlign: TextAlign.left,
                      onChanged: (value) {
                        pediatricbag = value;
                      },
                      decoration: customElevate(
                          'Pediatric 100ml/Bags', Icons.bloodtype),
                      // validator: (value) {
                      //   // Add validation for required field
                      //   if (value == null || value.isEmpty) {
                      //     return 'Enter Value';
                      //   }
                      //   return null;
                      // },
                    ),
                    SizedBox(height: 20.0),
                    Text('Delivery & Payment Details'),
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: Text('Urgent'),
                            value: urgent,
                            onChanged: (bool? value) {
                              setState(() {
                                urgent = value!;
                                regular = !urgent;
                              });
                            },
                          ),
                        ),
                        Text(
                          '|',
                          style: TextStyle(
                            fontSize: 30.0,
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: Text('Regular'),
                            value: regular,
                            onChanged: (bool? value) {
                              setState(() {
                                regular = value!;
                                urgent = !regular;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      textAlign: TextAlign.left,
                      onChanged: (value) {
                        address = value;
                      },
                      decoration: customElevate('Enter Address', Icons.home),
                      validator: (value) {
                        // Add validation for required field
                        if (value == null || value.isEmpty) {
                          return 'Enter Address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: paymentmode,
                            onChanged: (newValue) {
                              setState(() {
                                paymentmode = newValue;
                              });
                            },
                            items: modetype.map((mode) {
                              return DropdownMenuItem<String>(
                                value: mode,
                                child: Text(mode),
                              );
                            }).toList(),
                            decoration:
                                customElevate('Payment Type', Icons.payment),
                            validator: (value) {
                              // Add validation for required field
                              if (value == null || value.isEmpty) {
                                return 'Select Payment';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 10.0),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      textAlign: TextAlign.left,
                      onChanged: (value) {
                        doctorname = value;
                      },
                      decoration:
                          customElevate('Enter Doctor Name', Icons.home),
                      validator: (value) {
                        // Add validation for required field
                        if (value == null || value.isEmpty) {
                          return 'Enter Doctor Name';
                        }
                        return null;
                      },
                    ),
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
                  if (urgent)
                    type = 'urgent';
                  else
                    type = 'regular';
                  await FirebaseFirestore.instance.collection('users').add({
                    'name': name,
                    'address': address,
                    'gender': selectedGender,
                    'diagnosis': diagnosis,
                    'status': 'Pending',
                    'email': loggedInuser.email,
                    'amount': '0',
                    'bloodgrp': bloodgrp,
                    'paymentmode': paymentmode,
                    'age': age,
                    'hb': hb,
                    'wb': wb,
                    'prc': prc,
                    'ffp': ffp,
                    'rdp': rdp,
                    'sdp': sdp,
                    'pediatricbag': pediatricbag,
                    'rdp': rdp,
                    'prc': prc,
                    'ffp': ffp,
                    'rdp': rdp,
                    'type': type,
                    'doctor': doctorname,
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
