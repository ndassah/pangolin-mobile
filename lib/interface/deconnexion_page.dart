import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sappeli/widgets/drawers/drawer.dart';

import '../tools/app_text.dart';

class DeconnexionPage extends StatefulWidget {
  const DeconnexionPage({super.key});

  @override
  State<DeconnexionPage> createState() => _DeconnexionPageState();
}

class _DeconnexionPageState extends State<DeconnexionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Deconnexion',
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



