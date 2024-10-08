import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sappeli/tools/app_routes.dart';
import 'package:sappeli/tools/app_text.dart';
import 'package:http/http.dart' as http;

import '../../utils/helpers.dart';


Drawer buildDrawer(BuildContext context) {
  // Récupérer la route actuelle
  String? currentRoute = ModalRoute.of(context)?.settings.name;

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
          ),
          child: Text(
            'Pengolin',
            style: AppText.drawerHeaderText(),
          ),
        ),
        _createDrawerItem(
          context: context,
          icon: Icons.home,
          text: 'Accueil',
          routeName: '/directeur',
          currentRoute: currentRoute,
          onTap: () {
            Navigator.pushNamed(context, '/directeur');
          },
        ),
        _createDrawerItem(
          context: context,
          icon: Icons.work,
          text: 'Travaux',
          routeName: '/travaux',
          currentRoute: currentRoute,
          onTap: () {
            Navigator.pushNamed(context, '/travaux');
          },
        ),
        _createDrawerItem(
          context: context,
          icon: Icons.assignment,
          text: 'Tâches',
          routeName: '/taches',
          currentRoute: currentRoute,
          onTap: () {
            Navigator.pushNamed(context, '/taches');
          },
        ),
        _createDrawerItem(
          context: context,
          icon: Icons.person,
          text: 'Profil',
          routeName: AppRoutes.login,
          currentRoute: currentRoute,
          onTap: () {
            Navigator.pushNamed(context, '/profil');
          },
        ),
        _createDrawerItem(
          context: context,
          icon: Icons.analytics_outlined,
          text: 'Etude',
          routeName: AppRoutes.login,
          currentRoute: currentRoute,
          onTap: () {
            Navigator.pushNamed(context, '/etude');
          },
        ),
        _createDrawerItem(
          context: context,
          icon: Icons.exit_to_app,
          text: 'Déconnexion',
          routeName: '/login',
          currentRoute: currentRoute,
          onTap: () async {
            // Logique de déconnexion
          await logout(context);
          },
        ),
        _createDrawerItem(
          context: context,
          icon: Icons.help,
          text: 'FAQ',
          routeName: '/faq',
          currentRoute: currentRoute,
          onTap: () {
            Navigator.pushNamed(context, '/faq');
          },
        ),
      ],
    ),
  );
}

Widget _createDrawerItem({
  required BuildContext context,
  required IconData icon,
  required String text,
  required String routeName,
  required String? currentRoute, // Route courante
  required VoidCallback onTap,
}) {
  // Si la route actuelle correspond à l'élément du menu, on applique un style différent
  bool isSelected = currentRoute == routeName;

  return ListTile(
    leading: Icon(icon, color: isSelected ? Colors.white : Colors.blueAccent),
    title: Text(
      text,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    ),
    tileColor: isSelected ? Colors.blueAccent : null, // Change le fond si sélectionné
    onTap: () {
      Navigator.of(context).pop(); // Fermer le menu
      onTap(); // Action associée au menu
    },
  );
}

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  static Future<void> save(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}

Future<void> logout(BuildContext context) async {
  try {
    // Lire le token depuis le stockage sécurisé
    final token = await SecureStorage.read('auth_token');

    if (token != null) {
      // Envoyer une requête au backend pour la déconnexion
      final response = await http.post(
        Uri.parse('http://192.168.43.39:8000/api/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Ajouter le token dans l'en-tête
        },
      );

      if (response.statusCode == 200) {
        // Supprimer le token stocké localement pour effacer la session
        await SecureStorage.delete('auth_token');

        // Rediriger vers l'écran de connexion après la déconnexion
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
              (Route<dynamic> route) => false,
        );

        Helper.snackBar(context, message: 'Déconnexion réussie', isSuccess: true);
      } else {
        Helper.snackBar(context, message: 'Échec de la déconnexion', isSuccess: false);
      }
    }
  } catch (e) {
    Helper.snackBar(context, message: 'Erreur de déconnexion. Réessayez.', isSuccess: false);
  }
}

