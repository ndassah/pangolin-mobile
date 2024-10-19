import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sappeli/tools/app_text.dart';
import 'package:sappeli/widgets/drawers/drawer.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  Map<String, dynamic>? userData; // Stocker les informations de l'utilisateur ici
  bool _isLoading = true; // Indicateur de chargement
  String? errorMessage; // Pour stocker le message d'erreur éventuel

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Récupérer les données de l'utilisateur à l'initialisation de la page
  }

  // Fonction pour récupérer les informations de l'utilisateur via son ID et le token d'authentification
  Future<void> _fetchUserData() async {
    String? token = await SecureStorage.read('auth_token');
    String? userId = await SecureStorage.read('user_id');

    if (token != null && token.isNotEmpty && userId != null && userId.isNotEmpty) {
      print("Token: $token");
      print("User ID: $userId");

      final url = Uri.parse('http://192.168.43.39:8000/api/superviseur/all/$userId');

      try {
        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final contentType = response.headers['content-type'];

          if (contentType != null && contentType.contains('application/json')) {
            final jsonResponse = json.decode(response.body);

            // Adapter la structure JSON pour obtenir les données de l'utilisateur
            if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('user')) {
              setState(() {
                userData = jsonResponse['user']; // Les données de l'utilisateur sont sous 'user'
                _isLoading = false;
              });
            } else {
              setState(() {
                errorMessage = 'Format inattendu : ${response.body}';
                _isLoading = false;
              });
            }
          } else {
            setState(() {
              errorMessage = 'Réponse non JSON reçue : ${response.body}';
              _isLoading = false;
            });
          }
        } else if (response.statusCode == 404) {
          setState(() {
            errorMessage = 'Utilisateur non trouvé. Vérifiez l\'ID et réessayez.';
            _isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Erreur lors de la récupération des données: ${response.statusCode}';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          errorMessage = 'Erreur réseau : ${e.toString()}';
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        errorMessage = 'Aucun token ou ID d\'utilisateur trouvé';
        _isLoading = false;
      });
    }
  }

  // Widget pour les différents états (chargement, erreur, ou données manquantes)
  Widget _buildStateWidget() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    } else if (userData == null) {
      return Center(child: Text('Aucune donnée disponible.'));
    } else {
      return _buildProfileContent();
    }
  }

  // Contenu du profil
  Widget _buildProfileContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blueAccent,
            child: Text(
              // Conversion explicite en String
              userData!['prenom'] != null
                  ? userData!['prenom'].toString()[0]
                  : 'N/A',
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          SizedBox(height: 16),
          Text(
            // Conversion explicite des noms
            '${userData!['prenom']?.toString() ?? 'Non disponible'} ${userData!['nom']?.toString() ?? 'Non disponible'}',
            style: AppText.mainTitle(),
          ),
          SizedBox(height: 8),
          Divider(thickness: 1, color: Colors.grey),
          SizedBox(height: 8),
          _buildProfileDetailRow('Nom', userData!['nom']?.toString() ?? 'Non disponible'),
          _buildProfileDetailRow('Prenom', userData!['prenom']?.toString() ?? 'Non disponible'),
          _buildProfileDetailRow('Email', userData!['email']?.toString() ?? 'Non disponible'),
          _buildProfileDetailRow('Téléphone', userData!['telephone']?.toString() ?? 'Non disponible'),
        ],
      ),
    );
  }

  // Widget pour afficher chaque ligne de détail
  Widget _buildProfileDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppText.mainContent(),
          ),
          Text(
            value,
            style: AppText.mainContent(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Utilisateur',
          style: AppText.mainTitle(),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      drawer: buildDrawer(context),
      body: _buildStateWidget(),
    );
  }
}
