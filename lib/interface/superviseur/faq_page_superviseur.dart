import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sappeli/widgets/drawers/drawer_superviseur.dart';

import '../../tools/app_text.dart';

class FaqPageSub extends StatefulWidget {
  const FaqPageSub({super.key});

  @override
  State<FaqPageSub> createState() => _FaqPageSubState();
}

class _FaqPageSubState extends State<FaqPageSub> {
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


