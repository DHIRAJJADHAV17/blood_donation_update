import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/login_page.dart';
import 'package:flutter_firebase/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:flutter_firebase/global/common/toast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _userphoneController = TextEditingController();
  TextEditingController _licenceController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _firmnameController = TextEditingController();
  TextEditingController _usertypeController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _userphoneController.dispose();
    _licenceController.dispose();
    _addressController.dispose();
    _firmnameController.dispose();
    _usertypeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("SignUp"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                FormContainerWidget(
                  controller: _usernameController,
                  hintText: " Full Name",
                  isPasswordField: false,
                ),
                SizedBox(
                  height: 10,
                ),
                FormContainerWidget(
                  controller: _usertypeController,
                  hintText: "UserType:(ex.NGO,Hospital,Doctor)",
                  isPasswordField: false,
                ),
                SizedBox(
                  height: 10,
                ),
                FormContainerWidget(
                  controller: _firmnameController,
                  hintText: "Name of the Firm",
                  isPasswordField: false,
                ),
                SizedBox(
                  height: 10,
                ),
                FormContainerWidget(
                  controller: _addressController,
                  hintText: "Address of the Firm",
                  isPasswordField: false,
                ),
                SizedBox(
                  height: 10,
                ),
                FormContainerWidget(
                  controller: _licenceController,
                  hintText: "Government License id Number",
                  isPasswordField: false,
                ),
                SizedBox(
                  height: 10,
                ),
                FormContainerWidget(
                  controller: _userphoneController,
                  hintText: "Phone no.",
                  isPasswordField: false,
                ),
                SizedBox(
                  height: 10,
                ),
                FormContainerWidget(
                  controller: _emailController,
                  hintText: "Email",
                  isPasswordField: false,
                ),
                SizedBox(
                  height: 10,
                ),
                FormContainerWidget(
                  controller: _passwordController,
                  hintText: "Password",
                  isPasswordField: true,
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    _signUp();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: isSigningUp
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (route) => false);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String username = _usernameController.text;
    String phone = _userphoneController.text;
    String license = _licenceController.text;
    String address = _addressController.text;
    String firmname = _firmnameController.text;
    String usertype = _usertypeController.text;

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('registration').add({
          'username': username,
          'phone': phone,
          'license': license,
          'address': address,
          'firmname': firmname,
          'usertype': usertype,
          'email': email,
        });
      } catch (e) {
        print(e);
      }

      showToast(message: "User is successfully created");
      Navigator.pushNamed(context, "/listpage");
    } else {
      showToast(message: "Some error happend");
    }
  }
}
