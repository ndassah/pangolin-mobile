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
  List<dynamic> taches = []; // Stocker la liste des tâches
  List<dynamic> superviseurs = []; // Stocker la liste des superviseurs
  List<dynamic> activites = []; // Stocker la liste des activités
  bool _isLoading = false; // Indicateur de chargement
  final _storage = FlutterSecureStorage(); // Stockage sécurisé

  @override
  void initState() {
    super.initState();
    _fetchData(); // Récupérer les données au démarrage
  }

  // Fonction pour récupérer la liste des tâches, superviseurs et activités
  Future<void> _fetchData() async {
    String? token = await _storage.read(key: 'auth_token'); // Récupérer le token sécurisé

    if (token != null) {
      setState(() => _isLoading = true);

      // URL de l'API pour toutes les tâches, superviseurs et activités
      final tachesUrl = Uri.parse('http://192.168.43.39:8000/api/taches/all');
      final superviseursUrl = Uri.parse('http://192.168.43.39:8000/api/superviseurs/all');
      final activitesUrl = Uri.parse('http://192.168.43.39:8000/api/activites/all');

      // Requêtes pour les tâches, superviseurs et activités
      final tachesResponse = await http.get(tachesUrl, headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      final superviseursResponse = await http.get(superviseursUrl, headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      final activitesResponse = await http.get(activitesUrl, headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      if (tachesResponse.statusCode == 200 && superviseursResponse.statusCode == 200 && activitesResponse.statusCode == 200) {
        setState(() {
          taches = json.decode(tachesResponse.body)['taches']; // Tâches
          superviseurs = json.decode(superviseursResponse.body)['superviseurs']; // Superviseurs
          activites = json.decode(activitesResponse.body)['activites']; // Activités
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la récupération des données')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aucun token trouvé')),
      );
    }
  }

  // Fonction pour trouver le nom d'un superviseur à partir de l'ID
  String _getSuperviseurName(int idSuperviseur) {
    final superviseur = superviseurs.firstWhere(
          (s) => s['id'] == idSuperviseur,
      orElse: () => null,
    );
    return superviseur != null ? superviseur['nom'] : 'Inconnu';
  }

  // Fonction pour trouver le nom d'une activité à partir de l'ID
  String _getActiviteName(int idActivite) {
    final activite = activites.firstWhere(
          (a) => a['id'] == idActivite,
      orElse: () => null,
    );
    return activite != null ? activite['nom'] : 'Inconnue';
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
                Text('Superviseur: ${_getSuperviseurName(tache['id_superviseur'])}'),
                Text('Activité: ${_getActiviteName(tache['activite_id'])}'),
              ],
            ),
            trailing: Text('Statut: ${tache['status']}'),
          );
        },
      ),
    );
  }
}
