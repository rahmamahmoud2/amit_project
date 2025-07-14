import 'package:flutter/material.dart';

class appsize {
  static double screenHeight = 0;
  static double screenWidth = 0;

  void int(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }
}
