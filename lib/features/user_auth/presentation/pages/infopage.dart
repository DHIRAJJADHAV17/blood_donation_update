import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../global/common/toast.dart';
import '../widgets/form_container_widget.dart';

class RequetInfopage extends StatelessWidget {
  static String id = 'Profilepage';
  final String documentId;

  RequetInfopage(this.documentId);

  Future<DocumentSnapshot> fetchUserData(String documentId) async {
    try {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(documentId)
          .get();
    } catch (e) {
      print('Error fetching user data: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: fetchUserData(documentId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error.toString()}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data found'));
            } else {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              print('User Data: $userData'); // Debug print
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Patient Details'),
                      Divider(),
                      SizedBox(height: 10.0),
                      TextFormField(
                        textAlign: TextAlign.left,
                        initialValue: 'Name: ' +
                            userData['name'], // Display fetched value
                        enabled: false, // Disable editing
                        decoration: customElevate(
                          'Name',
                          Icons.account_box_rounded,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              initialValue: 'Gender:' +
                                  userData['gender'], // Display fetched value
                              enabled: false, // Disable editing
                              decoration: customElevate(
                                ' Gender',
                                Icons.account_box_rounded,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              initialValue: 'Age:' +
                                  userData['age'], // Display fetched value
                              enabled: false, // Disable editing
                              decoration: customElevate(
                                  'Age', Icons.confirmation_number),
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
                              initialValue: 'Blood:' +
                                  userData['bloodgrp'], // Display fetched value
                              enabled: false, // Disable editing
                              decoration: customElevate(
                                  'Blood Grp', Icons.confirmation_number),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              initialValue: 'HB:' +
                                  userData['hb'], // Display fetched value
                              enabled: false, // Disable editing
                              decoration:
                                  customElevate('HB (gm%)', Icons.percent),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        textAlign: TextAlign.left,
                        initialValue: 'Diagnos:' +
                            userData['diagnosis'], // Display fetched value
                        enabled: false,
                        decoration:
                            customElevate('Enter Diagnosis', Icons.home),
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
                              initialValue: 'WB:' +
                                  userData['wb'], // Display fetched value
                              enabled: false,
                              decoration: customElevate('WB', Icons.bloodtype),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              initialValue: 'FFP:' +
                                  userData['ffp'], // Display fetched value
                              enabled: false,
                              decoration: customElevate('FFP', Icons.bloodtype),
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
                              initialValue: 'RDP:' +
                                  userData['rdp'], // Display fetched value
                              enabled: false,
                              decoration: customElevate('RDP', Icons.bloodtype),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              initialValue: 'SDP:' +
                                  userData['sdp'], // Display fetched value
                              enabled: false,
                              decoration: customElevate('SDP', Icons.bloodtype),
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
                              initialValue: 'PB:' +
                                  userData[
                                      'pediatricbag'], // Display fetched value
                              enabled: false,
                              decoration: customElevate(
                                  'Pediatric 100ml/Bags', Icons.bloodtype),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              initialValue: 'PRC:' +
                                  userData['prc'], // Display fetched value
                              enabled: false,
                              decoration: customElevate('PRC', Icons.bloodtype),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Text('Delivery & Payment Details'),
                      Divider(),
                      TextFormField(
                        textAlign: TextAlign.left,
                        initialValue: 'Address:' +
                            userData['address'], // Display fetched value
                        enabled: false,
                        decoration: customElevate('Enter Address', Icons.home),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              initialValue: 'Payment:' +
                                  userData[
                                      'paymentmode'], // Display fetched value
                              enabled: false,
                              decoration:
                                  customElevate('Payment Mode', Icons.home),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              initialValue: 'Type:' +
                                  userData['type'], // Display fetched value
                              enabled: false,
                              decoration:
                                  customElevate('Type', Icons.bloodtype),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
      // backgroundColor: Color(0xFFCFF3F8),
    );
  }
}
