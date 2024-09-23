import 'package:flutter/material.dart';

class VerticalSpacer extends StatelessWidget {
  final double height; // Taille de l'espacement

  const VerticalSpacer({super.key, this.height = 16.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height); // Espacement vertical avec la hauteur définie
  }
}
