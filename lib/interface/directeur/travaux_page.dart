import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sappeli/tools/app_text.dart';
import 'package:sappeli/widgets/drawers/drawer.dart';

class TravauxPage extends StatefulWidget {
  const TravauxPage({super.key});

  @override
  State<TravauxPage> createState() => _TravauxPageState();
}

class _TravauxPageState extends State<TravauxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Travaux',
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


