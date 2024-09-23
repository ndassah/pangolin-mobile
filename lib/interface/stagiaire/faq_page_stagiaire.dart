import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sappeli/widgets/drawers/drawer_stagiaire.dart';

import '../../tools/app_text.dart';

class FaqPageStagiaire extends StatefulWidget {
  const FaqPageStagiaire({super.key});

  @override
  State<FaqPageStagiaire> createState() => _FaqPageStagiaireState();
}

class _FaqPageStagiaireState extends State<FaqPageStagiaire> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'F.A.Q',
          style: AppText.mainTitle(),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      drawer: buildDrawer(context),
      body: Center(
        child: Text(
          'Bienvenue sur l\'application!',
          style: TextStyle(
            fontSize: 24,
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


