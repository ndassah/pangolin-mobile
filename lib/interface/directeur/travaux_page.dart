import 'dart:convert'; // Pour décoder la réponse JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sappeli/tools/app_text.dart';
import 'package:sappeli/widgets/drawers/drawer.dart';

class TravauxPage extends StatefulWidget {
  const TravauxPage({super.key});

  @override
  State<TravauxPage> createState() => _TravauxPageState();
}

class _TravauxPageState extends State<TravauxPage> {
  List travaux = []; // Liste pour stocker les travaux
  bool _isLoading = true; // Indicateur de chargement
  final _storage = FlutterSecureStorage(); // Stockage sécurisé pour le token

  @override
  void initState() {
    super.initState();
    _fetchTravaux(); // Récupérer les travaux au démarrage
  }

  // Fonction pour récupérer les travaux depuis l'API Laravel
  Future<void> _fetchTravaux() async {
    String? token = await _storage.read(key: 'auth_token'); // Récupérer le token sécurisé

    if (token != null) {
      final url = Uri.parse('http://192.168.43.39:8000/api/travaux/all'); // URL de l'API pour les travaux
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token', // Ajout du token d'authentification
        'Accept': 'application/json', // Attendre une réponse en JSON
      });

      if (response.statusCode == 200) {
        setState(() {
          travaux = json.decode(response.body)['travaux']; // Stocker les travaux récupérés
          _isLoading = false; // Fin du chargement
        });
      } else {
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}'); // Afficher la réponse en cas d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la récupération des travaux: ${response.body}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aucun token trouvé')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Travaux',
          style: AppText.mainTitle(),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      drawer: buildDrawer(context),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Afficher un indicateur de chargement
          : ListView.builder(
        itemCount: travaux.length,
        itemBuilder: (context, index) {
          final travail = travaux[index];
          return ListTile(
            title: Text(
              'Travail: ${travail['nom']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${travail['description'] ?? 'Pas de description'}'),
                Text('Statut: ${travail['status']}'),
              ],
            ),
            trailing: Text(
              travail['status'] == 'terminé' ? '✔ Terminé' : '⏳ En cours',
              style: TextStyle(
                fontSize: 16,
                color: travail['status'] == 'terminé' ? Colors.green : Colors.orange,
              ),
            ),
          );
        },
      ),
    );
  }
}
