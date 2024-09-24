import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Pour les courbes statistiques
import 'package:http/http.dart' as http;
import 'dart:convert';

class EtudePage extends StatefulWidget {
  final int stagiaireId;

  EtudePage({required this.stagiaireId});

  @override
  _EtudePageState createState() => _EtudePageState();
}

class _EtudePageState extends State<EtudePage> {
  List<double> totalTaches = [];
  List<double> tachesBienFaites = [];
  double noteFinale = 0.0;

  // Liste de noms récupérés pour l'ID donné
  List<String> nomStagiaires = [];
  String? nomSelectionne;

  @override
  void initState() {
    super.initState();
    _fetchEvaluationData();
    _fetchNomsStagiaires(); // Récupérer les noms associés à l'ID
  }

  // Méthode pour récupérer les données d'évaluation
  Future<void> _fetchEvaluationData() async {
    final url = Uri.parse('http://192.168.43.39:8000/api/stagiaires/${widget.stagiaireId}/evaluer');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        totalTaches = [data['total_taches'].toDouble()];
        tachesBienFaites = [data['taches_bien_faites'].toDouble()];
        noteFinale = data['note_finale'];
      });
    } else {
      print('Erreur : ${response.statusCode}');
    }
  }

  // Méthode pour récupérer la liste des noms
  Future<void> _fetchNomsStagiaires() async {
    final url = Uri.parse('http://192.168.43.39:8000/api/stagiaire/all'); // API fictive pour récupérer les noms
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        nomStagiaires = List<String>.from(data['noms']); // Assurez-vous que l'API renvoie une liste de noms
      });
    } else {
      print('Erreur lors de la récupération des noms : ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Évaluation du Stagiaire')),
      body: totalTaches.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Dropdown pour choisir un nom parmi ceux récupérés
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              hint: Text('Sélectionner un stagiaire'),
              value: nomSelectionne,
              onChanged: (String? newValue) {
                setState(() {
                  nomSelectionne = newValue!;
                });
              },
              items: nomStagiaires.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20),
          Text('Nom sélectionné : $nomSelectionne'),
          SizedBox(height: 20),
          Text('Note finale : $noteFinale'),
          SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: totalTaches
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 4,
                  ),
                  LineChartBarData(
                    spots: tachesBienFaites
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
