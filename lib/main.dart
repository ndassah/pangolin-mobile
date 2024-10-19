import 'package:flutter/material.dart';
import 'package:sappeli/auth/login.dart';
import 'package:sappeli/auth/signup.dart';
import 'package:sappeli/form/activite_flutter.dart';
import 'package:sappeli/form/service_flutter.dart';
import 'package:sappeli/form/tache_flutter.dart';
import 'package:sappeli/form/travaux_flutter.dart';
import 'package:sappeli/interface/acteurs/directeur_page.dart';
import 'package:sappeli/interface/acteurs/stagiaire_page.dart';
import 'package:sappeli/interface/acteurs/superviseur_page.dart';
import 'package:sappeli/interface/directeur/etude_page.dart';
import 'package:sappeli/interface/stagiaire/profil_page_stagiaire.dart';
import 'package:sappeli/interface/stagiaire/taches_page_stagaire.dart';
import 'package:sappeli/interface/superviseur/assign_work_page.dart';
import 'package:sappeli/interface/superviseur/evaluer_stagiaire.dart';
import 'package:sappeli/interface/superviseur/faq_page_superviseur.dart';
import 'package:sappeli/interface/superviseur/profil_page_superviseur.dart';
import 'package:sappeli/interface/superviseur/taches_page_superviseur.dart';
import 'package:sappeli/interface/superviseur/travaux_page_superviseur.dart';
import 'package:sappeli/onBoarding/splash.dart';
import 'package:sappeli/onBoarding/walk.dart';
import 'package:sappeli/tools/app_routes.dart';
import 'auth/verification.dart';
import 'interface/directeur/faq_page.dart';
import 'interface/directeur/travaux_page.dart';
import 'interface/stagiaire/travaux_page_stagiaire.dart';
import 'interface/directeur/taches_page.dart';
import 'interface/directeur/profil_page.dart';
import 'interface/deconnexion_page.dart';
import 'interface/stagiaire/faq_page_stagiaire.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      initialRoute: 'splash',
      routes: <String, WidgetBuilder>{
        AppRoutes.splash:(context)=>const SplashScreen(),
        AppRoutes.walk:(context)=>const WalkScreen(),
        AppRoutes.login:(context)=>const LoginScreen(),
        AppRoutes.signup:(context)=>const SignupScreen(),
        AppRoutes.verification:(context)=>VerificationScreen(email: '', token: '',),
        '/travaux': (context) => TravauxPage(),
        '/travauxStagiaire': (context) => TravauxPageStagiaire(),
        '/verification': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return VerificationScreen(
            email: args['email']!,
            token: args['token']!,
          );
        },
        '/taches': (context) => TachesPage(),
        '/profil': (context) => ProfilPage(),
        '/profilStagiaire': (context) => ProfilPageStagiaire(),
        '/deconnexion': (context) => DeconnexionPage(),
        '/faq': (context) => FaqPage(),
        'faqStagiaire': (context) => FaqPageStagiaire(),
        '/create-activite': (context) => CreateActivitePage(),
        '/tache':(context) => CreateTachePage(),
        '/tacheStagiaire': (context) => TachesPageStagiaire(),
        '/TravauxPageStagiaire': (context) =>TravauxPageStagiaire(),
        '/superviseur': (context) => superviseurPage(),
        '/directeur': (context) => directeurPage(),
        '/stagiaire': (context) =>stagiairePage(),
        '/etude':(context) => EtudePage(stagiaireId: 1,),
        '/work': (context) => CreateTravailPage(),
        '/service': (context) =>CreateServicePage(),
        '/faqSub': (context) =>FaqPageSub(),
        '/travauxSub': (context) =>TravauxPageSub(),
        '/tachesSub': (context) =>TachesPageSub(),
        '/profileSub': (context) =>ProfilPageSub(),
        '/assign-work': (context) => AssignWorkPage(),
        '/evaluerStagiaire': (context) => evaluerStagiaire(),
      },
    );
  }
}
