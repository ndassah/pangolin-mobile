import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateTravailPage extends StatefulWidget {
  @override
  _CreateTravailPageState createState() => _CreateTravailPageState();
}

class _CreateTravailPageState extends State<CreateTravailPage> {
  final _formKey = GlobalKey<FormState>();

  String nomTravail = '';
  String description = '';
  int tacheId = 1; // ID de la tâche par défaut
  List<dynamic> taches = []; // Liste des tâches disponibles

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTaches(); // Charger les tâches dès que la page est affichée
  }

  // Fonction pour récupérer la liste des tâches depuis l'API
  Future<void> _fetchTaches() async {
    final url = Uri.parse('http://192.168.43.39:8000/api/taches/all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        taches = json.decode(response.body)['taches'];
        if (taches.isNotEmpty) {
          tacheId = taches[0]['id']; // Définir un ID par défaut
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des tâches')),
      );
    }
  }

  // Fonction pour envoyer les données au serveur
  Future<void> _creerTravail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final url = Uri.parse('http://192.168.43.39:8000/api/travaux/creer');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'nom': nomTravail,
          'description': description,
          'tache_id': tacheId, // ID de la tâche sélectionnée
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Travail créé avec succès!')),
        );
        Navigator.pop(context); // Retourner à la page précédente après création
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création du travail')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un Travail'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom du Travail'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    nomTravail = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Sélectionner une Tâche'),
                value: taches.isNotEmpty ? tacheId : null, // Définit la valeur si la liste n'est pas vide
                items: taches.isNotEmpty
                    ? taches.map<DropdownMenuItem<int>>((tache) {
                  return DropdownMenuItem<int>(
                    value: tache['id'],
                    child: Text(tache['titre'] ?? 'Sans nom'),
                  );
                }).toList()
                    : null, // Ajoute une vérification pour empêcher l'erreur
                onChanged: taches.isNotEmpty
                    ? (value) {
                  setState(() {
                    tacheId = value ?? tacheId; // Conserve l'ID actuel si la valeur est nulle
                  });
                }
                    : null, // Désactive si la liste est vide
              ),


              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _creerTravail,
                child: Text('Créer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
