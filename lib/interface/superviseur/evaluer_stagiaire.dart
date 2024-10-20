import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EvaluerStagiairePage extends StatefulWidget {
  @override
  _EvaluerStagiairePageState createState() => _EvaluerStagiairePageState();
}

class _EvaluerStagiairePageState extends State<EvaluerStagiairePage> {
  Map<String, dynamic>? evaluationData;
  List<dynamic> _stagiaires = []; // Liste des stagiaires disponibles
  int? stagiaireId; // ID du stagiaire sélectionné
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStagiaires(); // Chargement des stagiaires au démarrage
  }

  // Fonction pour récupérer la liste des stagiaires depuis l'API
  Future<void> _fetchStagiaires() async {
    final url = Uri.parse('http://192.168.43.39:8000/api/stagiaire/all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _stagiaires = json.decode(response.body);
        if (_stagiaires.isNotEmpty) {
          stagiaireId = _stagiaires[0]['id']; // Sélection du premier stagiaire par défaut
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des stagiaires')),
      );
    }
  }

  // Fonction pour récupérer les données d'évaluation pour le stagiaire sélectionné
  Future<void> _fetchEvaluationData() async {
    if (stagiaireId != null) {
      setState(() {
        _isLoading = true;
      });

      final url = Uri.parse('http://192.168.43.39:8000/api/stagiaires/$stagiaireId/evaluer');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          evaluationData = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de récupération des données.')),
        );
      }
    }
  }

  // Fonction pour télécharger le rapport PDF
  Future<void> _downloadRapport() async {
    final url = Uri.parse('http://192.168.43.39:8000/api/evaluation/$stagiaireId/rapport');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rapport téléchargé avec succès')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du téléchargement du rapport.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Évaluation du Stagiaire'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DropdownButtonFormField pour sélectionner un stagiaire
            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: 'Sélectionner un Stagiaire'),
              value: _stagiaires.isNotEmpty ? stagiaireId : null, // Sélectionne la valeur par défaut
              items: _stagiaires.isNotEmpty
                  ? _stagiaires.map<DropdownMenuItem<int>>((stagiaire) {
                return DropdownMenuItem<int>(
                  value: stagiaire['id'],
                  child: Text(stagiaire['nom'] ?? 'Inconnu'),
                );
              }).toList()
                  : null,
              onChanged: (value) {
                setState(() {
                  stagiaireId = value; // Met à jour l'ID du stagiaire sélectionné
                });
                _fetchEvaluationData(); // Met à jour les données d'évaluation
              },
            ),
            SizedBox(height: 20),
            // Si les données d'évaluation existent, les afficher
            evaluationData != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Travaux Totaux: ${evaluationData!['total_travaux']}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Travaux Bien Faits: ${evaluationData!['travaux_bien_faits']}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Temps Total Prévu: ${evaluationData!['temps_total_prevu']} heures',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Temps Total Effectif: ${evaluationData!['temps_total_effectif']} heures',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Note Finale: ${evaluationData!['note_finale']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _downloadRapport,
                  child: Text('Télécharger le Rapport PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
              ],
            )
                : Center(child: Text('Aucune donnée disponible')),
          ],
        ),
      ),
    );
  }
}
