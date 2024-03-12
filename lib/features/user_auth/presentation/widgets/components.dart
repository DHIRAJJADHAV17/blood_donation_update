import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

InputDecoration customElevate(String title, IconData icon) {
  return InputDecoration(
    hintText: title,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 20.0,
    ),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blueAccent,
        width: 1.0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
      borderSide: BorderSide(color: Colors.blueAccent),
    ),
    prefixIcon: Icon(icon),
  );
}

Future<String> uploadimg() async {
  String? imageUrl;
  ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
  print('${file?.path}');
  if (file == null) return "";

  String uniqueFilename = DateTime.now().millisecondsSinceEpoch.toString();
  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referanceDirImages = referenceRoot.child('images');
  Reference referanceimgtoupload = referanceDirImages.child(uniqueFilename);

  try {
    await referanceimgtoupload.putFile(File(file.path));
    imageUrl = await referanceimgtoupload.getDownloadURL();
    print('here its done');
  } catch (e) {
    print('error in try');
    print(e);
  }
  return '$imageUrl';
}
