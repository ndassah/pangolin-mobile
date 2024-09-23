import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sappeli/tools/Vertical_spacer.dart';
import 'package:sappeli/tools/app_text.dart';
import 'package:sappeli/widgets/drawers/drawer_stagiaire.dart';

class stagiairePage extends StatefulWidget {
  @override
  _stagiairePageState createState() => _stagiairePageState();
}

class _stagiairePageState extends State<stagiairePage> {
  bool _isLoading = true;
  List<dynamic> _activites = [];

  @override
  void initState() {
    super.initState();
    _fetchActivites(); // Récupérer les activités lors de l'initialisation
  }

  // Fonction pour récupérer les activités depuis l'API
  Future<void> _fetchActivites() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.43.39:8000/api/activites/all'));

      if (response.statusCode == 200) {
        setState(() {
          _activites = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Échec de la récupération des activités. Code: ${response.statusCode}'),
        ));
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur: $e'),
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Accueil',
          style: AppText.mainTitle(),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      drawer: buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalSpacer(height: 20),
            Text(
              'Options',
              style: AppText.sectionTitle(),
            ),
            VerticalSpacer(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconOption(Icons.assessment, 'liste des taches','/tache',context),
                _buildIconOption(Icons.history_rounded, 'historique des travaux','/work',context),
              ],
            ),
            VerticalSpacer(height: 30),
            Text(
              'Liste des travaux',
              style: AppText.sectionTitle(),
            ),
            VerticalSpacer(height: 10),
            _buildSuperviseurList(),
            VerticalSpacer(height: 30),
            Text(
              'Activités',
              style: AppText.sectionTitle(),
            ),
            VerticalSpacer(height: 10),
            _isLoading ? Center(child: CircularProgressIndicator()) : _buildActiviteTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconOption(IconData icon, String label, String routeName, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName); // Navigation vers la page spécifiée
      },
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.blueAccent),
          SizedBox(height: 8),
          Text(label, style: AppText.iconLabelText()),
        ],
      ),
    );
  }

  Widget _buildSuperviseurList() {
    List<String> superviseurs = ['Superviseur 1', 'Superviseur 2', 'Superviseur 3', 'Superviseur 4', 'Superviseur 5'];

    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: superviseurs.length,
        itemBuilder: (context, index) {
          return _buildSuperviseurCard(superviseurs[index]);
        },
      ),
    );
  }

  Widget _buildSuperviseurCard(String superviseur) {
    return Container(
      width: 100,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          superviseur,
          style: AppText.cardText(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Création de la table d'activités
  Widget _buildActiviteTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Permet le défilement horizontal
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Nom', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Service', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Tâche(s)', style: TextStyle(fontWeight: FontWeight.bold))), // Colonne pour le nombre de tâches
          DataColumn(label: Text('Réalisation', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: _activites.map(
              (activite) {
            final serviceNom = activite['service'] ?? 'Non défini'; // Récupérer le nom du service
            final nombreTotalTaches = activite['nombre_total_taches'] ?? '0'; // Récupérer le nombre total de tâches
            final pourcentageRealise = activite['pourcentageRealise'] ?? '0%'; // Récupérer le pourcentage de réalisation

            return DataRow(
              cells: [
                DataCell(Text(activite['nom_activites'])), // Nom de l'activité
                DataCell(Text(serviceNom)),                // Nom du service
                DataCell(Text(nombreTotalTaches.toString())), // Nombre total de tâches
                DataCell(Text(pourcentageRealise)),         // Pourcentage de réalisation
              ],
            );
          },
        ).toList(),
      ),
    );
  }


}
