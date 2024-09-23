import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sappeli/tools/app_text.dart';
import 'package:sappeli/widgets/drawers/drawer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TachesPage extends StatefulWidget {
  const TachesPage({super.key});

  @override
  State<TachesPage> createState() => _TachesPageState();
}

class _TachesPageState extends State<TachesPage> {
  List<dynamic> taches = []; // Stocker la liste des tâches ici
  bool _isLoading = false; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    _fetchTaches(); // Récupérer les tâches au démarrage de la page
  }

  // Fonction pour récupérer la liste des tâches depuis l'API
  final _storage = FlutterSecureStorage(); // Ajout du stockage sécurisé

// Fonction pour récupérer la liste des tâches depuis l'API
  Future<void> _fetchTaches() async {
    String? token = await _storage.read(key: 'auth_token'); // Récupérer le token sécurisé

    if (token != null) {
      final url = Uri.parse('http://192.168.43.39:8000/api/taches/all'); // URL de l'API pour toutes les tâches
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token', // Ajoutez le token d'authentification
        'Accept': 'application/json', // Indique que vous attendez une réponse en JSON
      });

      if (response.statusCode == 200) {
        setState(() {
          taches = json.decode(response.body)['taches']; // Récupérer les données de tâches
          _isLoading = false;
        });
      } else {
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}'); // Ajoutez cette ligne pour voir la réponse
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
            title: Text('Tâche: ${tache['titre']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${tache['description']}'),
                Text('Durée prévue: ${tache['duree_prevue']}'),
                Text('Superviseur ID: ${tache['id_superviseur']}'),
                Text('Activité ID: ${tache['activite_id']}'),
              ],
            ),
            trailing: Text('Statut: ${tache['status']}'),
          );
        },
      ),
    );
  }
}