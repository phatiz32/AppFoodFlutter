import 'package:flutter/material.dart';
import 'package:foodapp/screens/homescreen.dart';
import 'package:foodapp/screens/loginscreen.dart';
import 'package:foodapp/screens/registerscreen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    )
  );
}
