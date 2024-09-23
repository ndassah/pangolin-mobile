import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sappeli/tools/app_text.dart';
import 'package:sappeli/widgets/drawers/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Pour stocker et récupérer le token

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  Map<String, dynamic>? userData; // Stocker les informations utilisateur ici
  bool _isLoading = true; // Indicateur de chargement
  String? errorMessage; // Pour stocker le message d'erreur éventuel

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Récupérer les données utilisateur à l'initialisation de la page
  }

  // Fonction pour récupérer l'ID de l'utilisateur en session et ses informations
  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Récupérer le token

    if (token != null) {
      print("Token: $token"); // Vérifier que le token est bien récupéré
      final url = Uri.parse('http://192.168.43.39:8000/api/user'); // URL de l'API
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token', // Utiliser le token pour l'authentification
      });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse); // Imprimer la réponse complète pour vérifier la structure

        setState(() {
          userData = jsonResponse['user']; // Accéder à l'objet 'user'
          _isLoading = false; // Arrêter l'indicateur de chargement
        });
      } else if (response.statusCode == 401) {
        // Gérer le cas où le token est invalide
        setState(() {
          errorMessage = 'Erreur d\'authentification';
        });
      } else {
        setState(() {
          errorMessage = 'Erreur lors de la récupération des données';
        });
      }
    } else {
      setState(() {
        errorMessage = 'Aucun token trouvé';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
          style: AppText.mainTitle(),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      drawer: buildDrawer(context),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Afficher un indicateur de chargement
          : errorMessage != null
          ? Center(child: Text(errorMessage!)) // Afficher un message d'erreur s'il y a un problème
          : userData == null
          ? Center(child: Text('Aucune donnée disponible.'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nom : ${userData!['nom'] ?? 'Non disponible'}',
              style: AppText.mainTitle(),
            ),
            SizedBox(height: 8),
            Text(
              'Prénom : ${userData!['prenom'] ?? 'Non disponible'}',
              style: AppText.mainContent(),
            ),
            SizedBox(height: 8),
            Text(
              'Email : ${userData!['email'] ?? 'Non disponible'}',
              style: AppText.mainContent(),
            ),
            SizedBox(height: 8),
            Text(
              'Téléphone : ${userData!['telephone'] ?? 'Non disponible'}',
              style: AppText.mainContent(),
            ),
          ],
        ),
      ),
    );
  }
}
