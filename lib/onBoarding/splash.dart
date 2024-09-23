import 'package:flutter/material.dart';

import '../tools/app_colours.dart';
import '../tools/app_routes.dart';
import '../tools/app_strings.dart';
import '../tools/app_styles.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.primaryColor,
      body: Center(
        child: Text(
          AppStrings.appName,
          style: AppStyles.titleX(size: 50,color: Colors.white),
        ),
      ),
    );
  }

  @override
  void initState() {
    initApp();
    super.initState();
  }

  void initApp() {
    Future.delayed(const Duration(seconds: 3),
            ()=>
            Navigator.of(context).pushReplacementNamed(AppRoutes.walk));

  }
}
