import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateTachePage extends StatefulWidget {
  @override
  _CreateTachePageState createState() => _CreateTachePageState();
}

class _CreateTachePageState extends State<CreateTachePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers pour les valeurs des champs texte
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dureePrevueController = TextEditingController();

  List<dynamic> _activites = []; // Liste des activités récupérées depuis l'API
  dynamic _selectedActivite; // Activité sélectionnée
  List<dynamic> _superviseurs = []; // Liste des superviseurs récupérés depuis l'API
  dynamic _selectedSuperviseur; // Superviseur sélectionné

  bool _isLoadingActivites = false;
  bool _isLoadingSuperviseurs = false;

  @override
  void initState() {
    super.initState();
    _fetchActivites(); // Récupérer les activités à l'initialisation
    _fetchSuperviseurs(); // Récupérer les superviseurs à l'initialisation
  }

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    _dureePrevueController.dispose();
    super.dispose();
  }

  // Fonction pour récupérer les activités depuis l'API
  Future<void> _fetchActivites() async {
    setState(() {
      _isLoadingActivites = true;
    });

    final response = await http.get(Uri.parse('http://192.168.43.39:8000/api/activites/all'));

    if (response.statusCode == 200) {
      setState(() {
        _activites = json.decode(response.body);
        _isLoadingActivites = false;
      });
    } else {
      setState(() {
        _isLoadingActivites = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors du chargement des activités.'),
      ));
    }
  }

  // Fonction pour récupérer les superviseurs depuis l'API
  Future<void> _fetchSuperviseurs() async {
    setState(() {
      _isLoadingSuperviseurs = true;
    });

    final response = await http.get(Uri.parse('http://192.168.43.39:8000/api/superviseur/all'));

    if (response.statusCode == 200) {
      setState(() {
        _superviseurs = json.decode(response.body);
        _isLoadingSuperviseurs = false;
      });
    } else {
      setState(() {
        _isLoadingSuperviseurs = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors du chargement des superviseurs.'),
      ));
    }
  }

  // Fonction pour soumettre le formulaire
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> data = {
        'titre': _titreController.text,
        'description': _descriptionController.text,
        'duree_prevue': _dureePrevueController.text,
        'activite_id': _selectedActivite != null ? _selectedActivite['id'] : null,
        'id_superviseur': _selectedSuperviseur != null ? _selectedSuperviseur['id'] : null,
      };

      final response = await http.post(
        Uri.parse('http://192.168.43.39:8000/api/taches/creer'),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Tâche créée avec succès !'),
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur lors de la création de la tâche.'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer une tâche'),
      ),
      body: _isLoadingActivites || _isLoadingSuperviseurs
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titreController,
                decoration: InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le titre est requis';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La description est requise';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dureePrevueController,
                decoration: InputDecoration(labelText: 'Durée prévue'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La durée prévue est requise';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // DropdownButtonFormField pour les activités
              DropdownButtonFormField<dynamic>(
                hint: Text('Sélectionnez une activité'),
                value: _selectedActivite,
                items: _activites.map((activite) {
                  return DropdownMenuItem(
                    value: activite,
                    child: Text('${activite['nom_activites']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedActivite = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner une activité';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // DropdownButtonFormField pour les superviseurs
              DropdownButtonFormField<dynamic>(
                hint: Text('Sélectionnez un superviseur'),
                value: _selectedSuperviseur,
                items: _superviseurs.map((superviseur) {
                  return DropdownMenuItem(
                    value: superviseur,
                    child: Text('${superviseur['nom_superviseur']}'), // Afficher le nom du superviseur
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSuperviseur = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un superviseur';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Créer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
