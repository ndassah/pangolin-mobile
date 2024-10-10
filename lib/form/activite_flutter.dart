import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateActivitePage extends StatefulWidget {
  @override
  _CreateActivitePageState createState() => _CreateActivitePageState();
}

class _CreateActivitePageState extends State<CreateActivitePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers pour récupérer les valeurs des champs
  final TextEditingController _nomActiviteController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<dynamic> _services = []; // Liste de services récupérés depuis l'API
  dynamic _selectedService; // Service sélectionné
  bool _isLoading = false; // Variable pour indiquer si les services sont en cours de chargement

  @override
  void initState() {
    super.initState();
    _fetchServices(); // Récupérer la liste des services dès l'initialisation
  }

  // Nettoyage des contrôleurs lorsque le widget est supprimé
  @override
  void dispose() {
    _nomActiviteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Fonction pour récupérer la liste des services depuis l'API
  Future<void> _fetchServices() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse('http://192.168.43.39:8000/api/service/all'));

    if (response.statusCode == 200) {
      // Parse les données JSON reçues depuis l'API
      setState(() {
        _services = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Échec de la récupération des services. Code: ${response.statusCode}'),
      ));
    }
  }

  // Fonction pour envoyer les données au serveur
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Construction du corps de la requête
      final Map<String, dynamic> data = {
        'nom_activites': _nomActiviteController.text,
        'description': _descriptionController.text,
        'id_service': _selectedService != null ? _selectedService['id'] : null, // Utilise l'id du service sélectionné
      };

      // Envoi de la requête POST avec l'ajout du content-type
      final response = await http.post(
        Uri.parse('http://192.168.43.39:8000/api/activites/create'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json', // Ajout du Content-Type
        },
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Activité créée avec succès !'),
        ));

        // Retourner à la page précédente
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Échec de la création de l\'activité.'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer une activité'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchServices, //rafraîchir manuellement
        child: _isLoading
            ? Center(child: CircularProgressIndicator()) // Affiche un loader pendant le chargement
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nomActiviteController,
                  decoration: InputDecoration(labelText: 'Nom de l\'activité'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le nom de l\'activité';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // DropdownButtonFormField pour les services
                DropdownButtonFormField<dynamic>(
                  hint: Text('Sélectionnez un service'),
                  value: _selectedService,
                  items: _services.map((service) {
                    return DropdownMenuItem(
                      value: service, // On stocke l'objet service complet ici
                      child: Text('${service['nom_services']}'), // On affiche le nom
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedService = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner un service';
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
      ),
    );
  }
}
