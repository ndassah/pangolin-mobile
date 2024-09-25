import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sappeli/tools/app_text.dart';
import 'package:sappeli/widgets/drawers/drawer_superviseur.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilPageSub extends StatefulWidget {
  const ProfilPageSub({super.key});

  @override
  State<ProfilPageSub> createState() => _ProfilPageSubState();
}

class _ProfilPageSubState extends State<ProfilPageSub> {
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
    String? token = await SecureStorage.read('auth_token'); // Récupérer le token

    if (token != null && token.isNotEmpty) {
      print("Token: $token"); // Vérifier que le token est bien récupéré
      final url = Uri.parse('http://192.168.43.39:8000/api/user'); // URL de l'API
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json', // Indique que tu veux une réponse JSON
          'Content-Type': 'application/json', // Indique que la requête attend un format JSON
        },
      );

      // Affiche la réponse complète pour le débogage
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final jsonResponse = json.decode(response.body);

          // Validation de la structure attendue dans la réponse JSON
          if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('user')) {
            setState(() {
              userData = jsonResponse['user']; // Accéder à l'objet 'user'
              _isLoading = false; // Arrêter l'indicateur de chargement
            });
          } else {
            setState(() {
              errorMessage = 'Format inattendu : ${response.body}'; // Affiche le contenu de la réponse inattendue
              _isLoading = false;
            });
          }
        } catch (e) {
          // Gestion des erreurs lors du parsing JSON
          setState(() {
            errorMessage = 'Erreur de format JSON : ${e.toString()}';
            _isLoading = false;
          });
        }
      } else if (response.statusCode == 401) {
        setState(() {
          errorMessage = 'Erreur d\'authentification : token invalide';
          _isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erreur lors de la récupération des données: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        errorMessage = 'Aucun token trouvé';
        _isLoading = false;
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
