import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Courbes statistiques
import 'package:http/http.dart' as http;
import 'dart:convert';

class EtudePage extends StatefulWidget {
  late final int directionId;

 // EtudePage({required this.directionId});

  @override
  _EtudePageState createState() => _EtudePageState();
}

class _EtudePageState extends State<EtudePage> {
  List<double> nombreActivites = [];
  List<double> tauxRealisation = [];

  @override
  void initState() {
    super.initState();
    _fetchEtudeData();
  }

  Future<void> _fetchEtudeData() async {
    final url = Uri.parse('http://192.168.43.39:8000/api/direction/${widget.directionId}/etude');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        nombreActivites = data.map<double>((item) => item['nombre_activites']).toList();
        tauxRealisation = data.map<double>((item) => item['taux_realisation']).toList();
      });
    } else {
      print('Erreur : ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Étude sur la direction')),
      body: nombreActivites.isEmpty
          ? Center(child: CircularProgressIndicator())
          : LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: nombreActivites.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
            ),
            LineChartBarData(
              spots: tauxRealisation.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
              isCurved: true,
              color: Colors.green,
              barWidth: 4,
            ),
          ],
        ),
      ),
    );
  }
}
