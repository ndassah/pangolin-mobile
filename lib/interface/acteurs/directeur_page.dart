import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sappeli/tools/Vertical_spacer.dart';
import 'package:sappeli/tools/app_text.dart';
import 'package:sappeli/widgets/drawers/drawer.dart';

class directeurPage extends StatefulWidget {
  @override
  _directeurPageState createState() => _directeurPageState();
}

class _directeurPageState extends State<directeurPage> {
  bool _isLoading = true;
  List<dynamic> _activites = [];
  List<dynamic> _superviseurs = []; // Nouvelle variable pour stocker les superviseurs

  @override
  void initState() {
    super.initState();
    _fetchActivites(); // Récupérer les activités lors de l'initialisation
    _fetchSuperviseurs(); // Récupérer les superviseurs lors de l'initialisation
  }

  // Fonction pour récupérer les activités depuis l'API
  Future<void> _fetchActivites() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.43.39:8000/api/activites/all'));

      if (response.statusCode == 200) {
        setState(() {
          _activites = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Échec de la récupération des activités. Code: ${response.statusCode}'),
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

  // Nouvelle fonction pour récupérer les superviseurs depuis l'API
  Future<void> _fetchSuperviseurs() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.43.39:8000/api/superviseur/all'));

      if (response.statusCode == 200) {
        setState(() {
          _superviseurs = json.decode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Échec de la récupération des superviseurs. Code: ${response.statusCode}'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur: $e'),
      ));
    }
  }

  // Fonction pour rafraîchir les données
  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchActivites();
    await _fetchSuperviseurs();
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
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
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
                  _buildIconOption(
                      Icons.workspaces, 'activité', '/create-activite', context),
                  _buildIconOption(
                      Icons.assignment, 'tâches', '/tache', context),
                  _buildIconOption(
                      Icons.design_services, ' service', '/service', context),
                ],
              ),
              VerticalSpacer(height: 30),
              Text(
                'Liste des superviseurs',
                style: AppText.sectionTitle(),
              ),
              VerticalSpacer(height: 10),
              _buildSuperviseurList(), // Appel à la nouvelle fonction
              VerticalSpacer(height: 30),
              Text(
                'Activités',
                style: AppText.sectionTitle(),
              ),
              VerticalSpacer(height: 10),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _buildActiviteTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconOption(
      IconData icon, String label, String routeName, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
            context, routeName); // Navigation vers la page spécifiée
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

  // Modification pour utiliser les superviseurs récupérés depuis l'API
  Widget _buildSuperviseurList() {
    if (_superviseurs.isEmpty) {
      return Center(child: Text('Aucun superviseur trouvé'));
    }

    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _superviseurs.length,
        itemBuilder: (context, index) {
          final superviseur =
              _superviseurs[index]['nom_superviseur'] ?? 'Superviseur inconnu';
          return _buildSuperviseurCard(superviseur);
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
          DataColumn(
              label:
                  Text('Nom', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Service',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Tâche(s)',
                  style: TextStyle(
                      fontWeight: FontWeight
                          .bold))), // Colonne pour le nombre de tâches
          DataColumn(
              label: Text('Réalisation',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: _activites.map(
          (activite) {
            final serviceNom = activite['service'] ??
                'Non défini'; // Récupérer le nom du service
            final nombreTotalTaches = activite['nombre_total_taches'] ??
                '0'; // Récupérer le nombre total de tâches
            final pourcentageRealise = activite['pourcentageRealise'] ??
                '0%'; // Récupérer le pourcentage de réalisation

            return DataRow(
              cells: [
                DataCell(Text(activite['nom_activites'])), // Nom de l'activité
                DataCell(Text(serviceNom)), // Nom du service
                DataCell(Text(
                    nombreTotalTaches.toString())), // Nombre total de tâches
                DataCell(
                    Text(pourcentageRealise)), // Pourcentage de réalisation
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
