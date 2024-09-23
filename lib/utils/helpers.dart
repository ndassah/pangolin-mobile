import 'package:flutter/material.dart';

import '../tools/app_colours.dart';
import '../tools/app_styles.dart';


class Helper{
  static snackBar(context,{ required String message, bool isSuccess = true}){
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: isSuccess ? AppColours.success : Colors.red.shade500,
      content: Text(message, style: AppStyles.snackbar()),
    ));
  }
}