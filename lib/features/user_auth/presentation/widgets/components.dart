import 'package:flutter/material.dart';

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
