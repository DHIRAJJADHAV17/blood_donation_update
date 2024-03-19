import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/login_page.dart';
import 'package:flutter_firebase/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:flutter_firebase/global/common/toast.dart';
import 'package:image_picker/image_picker.dart';

Future<String> uploadimg() async {
  String? imageUrl;
  ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

  // Check if a file was selected
  if (file == null) {
    print('No image selected');
    return ""; // Return an empty string if no image was selected
  }

  print('Selected image path: ${file.path}');

  // Proceed with uploading the image
  String uniqueFilename = DateTime.now().millisecondsSinceEpoch.toString();
  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referanceDirImages = referenceRoot.child('images');
  Reference referanceimgtoupload = referanceDirImages.child(uniqueFilename);

  try {
    await referanceimgtoupload.putFile(File(file.path));
    imageUrl = await referanceimgtoupload.getDownloadURL();
    print('Image uploaded successfully');
  } catch (e) {
    print('Error uploading image: $e');
  }

  return imageUrl ??
      ""; // Return imageUrl or an empty string if imageUrl is null
}

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
  bool self = true;
  bool organisation = false;
  String? imageUrl;

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
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: Text('Self Use'),
                        value: self,
                        onChanged: (bool? value) {
                          setState(() {
                            self = value!;
                            organisation = !self;
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
                        title: Text('Organisation'),
                        value: organisation,
                        onChanged: (bool? value) {
                          setState(() {
                            organisation = value!;
                            self = !organisation;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                _buildFormWidgets(), // Call the method for conditional rendering
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

  Widget _buildFormWidgets() {
    if (organisation) {
      return Column(
        children: [
          FormContainerWidget(
            controller: _usernameController,
            hintText: "Full Name",
            isPasswordField: false,
          ),
          SizedBox(height: 10),
          FormContainerWidget(
            controller: _usertypeController,
            hintText: "UserType:(ex.NGO,Hospital,Doctor)",
            isPasswordField: false,
          ),
          SizedBox(height: 10),
          FormContainerWidget(
            controller: _firmnameController,
            hintText: "Name of the Firm",
            isPasswordField: false,
          ),
          SizedBox(height: 10),
          FormContainerWidget(
            controller: _addressController,
            hintText: "Address of the Firm",
            isPasswordField: false,
          ),
          SizedBox(height: 10),
          FormContainerWidget(
            controller: _licenceController,
            hintText: "Government License id Number",
            isPasswordField: false,
          ),
          SizedBox(height: 10),
          FormContainerWidget(
            controller: _userphoneController,
            hintText: "Phone no.",
            isPasswordField: false,
          ),
          SizedBox(height: 10),
          FormContainerWidget(
            controller: _emailController,
            hintText: "Email",
            isPasswordField: false,
          ),
          SizedBox(height: 10),
          FormContainerWidget(
            controller: _passwordController,
            hintText: "Password",
            isPasswordField: true,
          ),
          Column(
            children: [
              // Show loading indicator or image based on the presence of imageUrl
              if (imageUrl == null)
                IconButton(
                  icon: const Icon(
                    Icons.paste_sharp,
                    size: 100,
                  ),
                  onPressed: () async {
                    await _selectImage();
                  },
                ),
              if (imageUrl != null)
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await _selectImage();
                      },
                      child: Image.network(
                        imageUrl!, // Show the uploaded image
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Positioned(
                      top: 4, // Adjust top position as needed
                      right: -15, // Adjust right position as needed
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.red, // Adjust icon color as needed
                        ),
                        onPressed: () {
                          _deleteImage();
                        },
                      ),
                    ),
                  ],
                ),

              const Text(
                'Government License',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          FormContainerWidget(
            controller: _usernameController,
            hintText: "Full Name",
            isPasswordField: false,
          ),
          SizedBox(height: 10),
          FormContainerWidget(
            controller: _addressController,
            hintText: "Address",
            isPasswordField: false,
          ),
          SizedBox(height: 10),
          FormContainerWidget(
            controller: _userphoneController,
            hintText: "Phone no.",
            isPasswordField: false,
          ),
          SizedBox(height: 10),
          FormContainerWidget(
            controller: _emailController,
            hintText: "Email",
            isPasswordField: false,
          ),
          SizedBox(height: 10),
          FormContainerWidget(
            controller: _passwordController,
            hintText: "Password",
            isPasswordField: true,
          ),
          Column(
            children: [
              // Show loading indicator or image based on the presence of imageUrl
              if (imageUrl == null)
                IconButton(
                  icon: const Icon(
                    Icons.person,
                    size: 100,
                  ),
                  onPressed: () async {
                    await _selectImage();
                  },
                ),
              if (imageUrl != null)
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await _selectImage();
                      },
                      child: Image.network(
                        imageUrl!, // Show the uploaded image
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Positioned(
                      top: 4, // Adjust top position as needed
                      right: -15, // Adjust right position as needed
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.red, // Adjust icon color as needed
                        ),
                        onPressed: () {
                          _deleteImage();
                        },
                      ),
                    ),
                  ],
                ),

              const Text(
                'Adhar Image',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ); // Returns an empty widget if not organisation
    }
  }

  Future<void> _selectImage() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);

    // Check if a file was selected
    if (file != null) {
      setState(() {
        // Update the imageUrl variable with the newly selected image
        imageUrl = null; // Clear the imageUrl to remove the previous image
      });

      // Proceed with uploading the newly selected image
      String uniqueFilename = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referanceDirImages = referenceRoot.child('images');
      Reference referanceimgtoupload = referanceDirImages.child(uniqueFilename);

      try {
        await referanceimgtoupload.putFile(File(file.path));
        String newImageUrl = await referanceimgtoupload.getDownloadURL();
        setState(() {
          // Update the imageUrl variable with the new image URL
          imageUrl = newImageUrl;
        });
        print('Image uploaded successfully');
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
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

    if (imageUrl == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please upload image.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      setState(() {
        isSigningUp = false;
      });
      return;
    }

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      try {
        if (organisation) {
          await FirebaseFirestore.instance.collection('registration').add({
            'username': username,
            'phone': phone,
            'license': license,
            'address': address,
            'firmname': firmname,
            'usertype': self,
            'email': email,
            'image': imageUrl,
          });
        } else {
          await FirebaseFirestore.instance.collection('registration').add({
            'username': username,
            'phone': phone,
            'address': address,
            'usertype': self,
            'email': email,
            'image': imageUrl,
          });
        }
      } catch (e) {
        print(e);
      }

      showToast(message: "User is successfully created");
      Navigator.pushNamed(context, "/dashboard");
    } else {
      showToast(message: "Some error happened");
    }

    setState(() {
      isSigningUp = false;
    });
  }

  Future<void> _deleteImage() async {
    if (imageUrl != null) {
      try {
        // Delete the image from Firebase Storage
        await FirebaseStorage.instance.refFromURL(imageUrl!).delete();
        // Reset the imageUrl variable to null
        setState(() {
          imageUrl = null;
        });
        print('Image deleted successfully');
      } catch (e) {
        print('Error deleting image: $e');
      }
    }
  }
}
