import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppText{
  // Style pour le titre principal
  static TextStyle mainTitle() {
    return TextStyle(
      fontSize: 24,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  // Style pour le texte du menu
  static TextStyle menuText() {
    return TextStyle(
      fontSize: 18,
      color: Colors.black,
    );
  }

  // Style pour le texte du drawer header
  static TextStyle drawerHeaderText() {
    return TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.w800
    );
  }

  // Style pour le texte de bouton
  static TextStyle buttonText() {
    return TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );
  }

  // Style pour le texte de message d'erreur
  static TextStyle errorText() {
    return TextStyle(
      fontSize: 14,
      color: Colors.red,
    );
  }

  static TextStyle errorSuccess() {
    return TextStyle(
      fontSize: 14,
      color: Colors.green,
    );
  }

  static TextStyle sectionTitle() {
    return TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline
    );
  }

  static TextStyle cardText() {
    return TextStyle(
      fontSize: 14,
      color: Colors.white,
    );
  }

  static TextStyle iconLabelText() {
    return TextStyle(
      fontSize: 14,
      color: Colors.black,
    );
  }

  static mainContent() {
    return TextStyle(
      fontSize: 16,
      color: Colors.black,
    );
  }
}