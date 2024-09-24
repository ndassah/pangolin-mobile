import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AssignWorkPage extends StatefulWidget {
  @override
  _AssignWorkPageState createState() => _AssignWorkPageState();
}

class _AssignWorkPageState extends State<AssignWorkPage> {
  List<dynamic> _stagiaires = [];
  List<dynamic> _travaux = [];
  String? _selectedStagiaire;
  String? _selectedTravail;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchStagiaires();
    _fetchTravaux();
  }

  // Fonction pour récupérer les stagiaires
  Future<void> _fetchStagiaires() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.43.39:8000/api/stagiaire/all'));
      if (response.statusCode == 200) {
        setState(() {
          _stagiaires = json.decode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Échec de la récupération des stagiaires. Code: ${response.statusCode}'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur: $e'),
      ));
    }
  }

  // Fonction pour récupérer les travaux
  Future<void> _fetchTravaux() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.43.39:8000/api/travaux/all'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Vérifie que tu as bien une liste de travaux
        if (data is List) {
          setState(() {
            _travaux = data;
          });
        } else {
          // Si ce n'est pas une liste, affiche un message d'erreur
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Format inattendu de la réponse: ${response.body}'),
          ));
        }
      } else {
        // Affiche un message d'erreur si le statut HTTP est autre que 200
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur lors de la récupération des travaux. Code: ${response.statusCode}'),
        ));
      }
    } catch (e) {
      // Affiche les erreurs réseau
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur de connexion: $e'),
      ));
    }
  }

  // Fonction pour attribuer un travail à un stagiaire
  Future<void> _assignWork() async {
    if (_selectedStagiaire == null || _selectedTravail == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Veuillez sélectionner un stagiaire et un travail.'),
      ));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final Map<String, dynamic> workData = {
      'stagiaire_id': _selectedStagiaire,
      'travail_id': _selectedTravail,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.43.39:8000/api/travaux/assign'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(workData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Travail attribué avec succès!'),
        ));
      } else {
        final errorMsg = json.decode(response.body)['message'] ?? 'Erreur inconnue';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur lors de l\'attribution du travail. Message: $errorMsg'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur de connexion: $e'),
      ));
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attribuer un Travail'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sélectionnez un stagiaire', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedStagiaire,
              items: _stagiaires.map<DropdownMenuItem<String>>((stagiaire) {
                return DropdownMenuItem<String>(
                  value: stagiaire['id'].toString(),
                  child: Text(stagiaire['nom']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStagiaire = value;
                });
              },
              hint: Text('Choisir un stagiaire'),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            SizedBox(height: 20),
            Text('Sélectionnez un travail', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedTravail,
              items: _travaux.map<DropdownMenuItem<String>>((travail) {
                return DropdownMenuItem<String>(
                  value: travail['id'].toString(),
                  child: Text(travail['nom']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTravail = value;
                });
              },
              hint: Text('Choisir un travail'),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            SizedBox(height: 20),
            _isSubmitting
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _assignWork,
              child: Text('Attribuer le Travail'),
            ),
          ],
        ),
      ),
    );
  }
}
