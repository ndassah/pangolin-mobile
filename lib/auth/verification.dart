import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../tools/app_colours.dart';
import '../tools/app_strings.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  final String token;

  const VerificationScreen({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Utilisation directement widget.email et widget.token
    final String email = widget.email;
    final String token = widget.token;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColours.primaryColor,
          title: Text(
            AppStrings.verification,
            style: const TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Veuillez entrer le code OTP envoyé",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : () => _verifyOtp(email, token), // Utiliser le token ici
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColours.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 64),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Vérifier",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyOtp(String email, String token) async {
    String otpCode = _otpControllers.map((controller) => controller.text).join();

    if (otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un code OTP complet.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Effectuer la requête API pour vérifier le code OTP
      final response = await http.post(
        Uri.parse('http://192.168.43.39:8000/api/otp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',  // Utiliser le token ici
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'otp': otpCode,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Si la vérification réussit, rediriger vers la page de login
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        // Afficher un message d'erreur si le code OTP est invalide
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? "Code OTP invalide.")),
        );
      }
    } catch (e) {
      // Gérer les erreurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Une erreur est survenue: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
