import 'package:flutter/material.dart';

class AppStyles{
  static TextStyle titleX({double size = 64, Color color = Colors.black}){
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    );
  }

  static TextStyle title1({double size = 32, Color color = Colors.black}){
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle regular1({double size = 16, Color color = Colors.black}){
    return TextStyle(
      color: color,
      fontSize: size,
    );
  }

  static TextStyle meduim({double size = 16, Color color = Colors.black}){
    return TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: size,
    );
  }

  static TextStyle snackbar({double size = 16, Color color = Colors.white}){
    return TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: size,
    );
  }

}