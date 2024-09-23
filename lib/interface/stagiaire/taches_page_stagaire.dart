import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sappeli/tools/app_text.dart';
import 'package:sappeli/widgets/drawers/drawer_stagiaire.dart';

class TachesPageStagiaire extends StatefulWidget {
  const TachesPageStagiaire({super.key});

  @override
  State<TachesPageStagiaire> createState() => _TachesPageStagiaireState();
}

class _TachesPageStagiaireState extends State<TachesPageStagiaire> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Taches',
          style:  AppText.mainTitle(),
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


