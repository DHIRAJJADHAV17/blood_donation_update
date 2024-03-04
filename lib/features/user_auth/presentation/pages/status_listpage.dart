import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../global/common/toast.dart';
import 'customer_fill.dart';
import 'infopage.dart';

class ListPages extends StatefulWidget {
  static String id = 'listpage';

  @override
  State<ListPages> createState() => _ListPagesState();
}

class _ListPagesState extends State<ListPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CustomerReq()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var document = snapshot.data!.docs[index];
                    return Column(
                      children: [
                        Container(
                          height: 100,
                          margin:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.yellow[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                child: Icon(Icons.bloodtype_outlined),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${document['name']}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      'Status:${document['status']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      'Amount:${document['amount']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      child: Icon(
                                        Icons.delete_forever_rounded,
                                        color: Colors.red,
                                        size: 30.0,
                                      ),
                                      onTap: () {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(document.id)
                                            .delete()
                                            .then((_) {
                                          showToast(
                                              message:
                                                  "Document deleted successfully");
                                        }).catchError((error) {
                                          showToast(
                                              message:
                                                  "Failed to delete document");
                                        });
                                      },
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        try {
                                          final email = document['email'];
                                          if (email is String) {
                                            print(document.id);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RequetInfopage(document.id),
                                              ),
                                            );
                                          } else {
                                            print(
                                                'Email is not a String: $email');
                                          }
                                        } catch (e, stackTrace) {
                                          print(
                                              'Error navigating to Profilepage: $e');
                                          print(stackTrace);
                                        }
                                      },
                                      child: Text('Info'),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Colors.green[100] ??
                                              Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  });
            } else {
              return Center(child: Text('No data found'));
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
