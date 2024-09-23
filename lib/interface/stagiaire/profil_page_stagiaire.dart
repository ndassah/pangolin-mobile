import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sappeli/tools/app_text.dart';
import 'package:sappeli/widgets/drawers/drawer_stagiaire.dart';

class ProfilPageStagiaire extends StatefulWidget {
  const ProfilPageStagiaire({super.key});

  @override
  State<ProfilPageStagiaire> createState() => _ProfilPageStagiaireState();
}

class _ProfilPageStagiaireState extends State<ProfilPageStagiaire> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
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


