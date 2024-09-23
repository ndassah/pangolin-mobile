import 'dart:convert'; // Pour décoder la réponse JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sappeli/tools/app_text.dart';
import 'package:sappeli/widgets/drawers/drawer.dart';

class TachesPage extends StatefulWidget {
  const TachesPage({super.key});

  @override
  State<TachesPage> createState() => _TachesPageState();
}

class _TachesPageState extends State<TachesPage> {
  List taches = []; // Liste pour stocker les tâches
  bool _isLoading = true; // Indicateur de chargement
  final _storage = FlutterSecureStorage(); // Stockage sécurisé pour le token

  @override
  void initState() {
    super.initState();
    _fetchTaches(); // Récupérer les tâches au démarrage
  }

  // Fonction pour récupérer les tâches depuis l'API Laravel
  Future<void> _fetchTaches() async {
    String? token = await _storage.read(key: 'auth_token'); // Récupérer le token sécurisé

    if (token != null) {
      final url = Uri.parse('http://192.168.43.39:8000/api/taches/all'); // URL de l'API pour les tâches
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token', // Ajout du token d'authentification
        'Accept': 'application/json', // Attendre une réponse en JSON
      });

      if (response.statusCode == 200) {
        setState(() {
          taches = json.decode(response.body)['taches']; // Stocker les tâches récupérées
          _isLoading = false; // Fin du chargement
        });
      } else {
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}'); // Afficher la réponse en cas d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la récupération des tâches: ${response.body}')),
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
          'Tâches',
          style: AppText.mainTitle(),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      drawer: buildDrawer(context),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Afficher un indicateur de chargement
          : ListView.builder(
        itemCount: taches.length,
        itemBuilder: (context, index) {
          final tache = taches[index];
          return ListTile(
            title: Text(
              'Tâche: ${tache['titre']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${tache['description'] ?? 'Pas de description'}'),
                Text('Durée prévue: ${tache['duree_prevue']}'),
                Text('Superviseur ID: ${tache['id_superviseur']}'),
                Text('Activité ID: ${tache['activite_id']}'),
              ],
            ),
            trailing: Text(
              tache['status'] == 'terminée' ? '✔ Terminé' : '⏳ En cours',
              style: TextStyle(
                fontSize: 16,
                color: tache['status'] == 'terminée' ? Colors.green : Colors.orange,
              ),
            ),
          );
        },
      ),
    );
  }
}
