import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateServicePage extends StatefulWidget {
  @override
  _CreateServicePageState createState() => _CreateServicePageState();
}

class _CreateServicePageState extends State<CreateServicePage> {
  final _formKey = GlobalKey<FormState>();
  String? _nomService;
  String? _description;
  String? _directionId;
  bool _isLoading = false;

  Future<void> _createService() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse('http://192.168.43.39:8000/api/service/create'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'nom_services': _nomService,
            'description': _description,
            'direction_id': _directionId,
          }),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Service créé avec succès')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de la création du service')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom du service'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom du service';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nomService = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Direction ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'ID de la direction';
                  }
                  return null;
                },
                onSaved: (value) {
                  _directionId = value;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _createService,
                child: Text('Créer le service'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
