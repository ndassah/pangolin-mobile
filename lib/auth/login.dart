import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../components/form/text_input.dart';
import '../components/ui/button.dart';
import '../tools/app_colours.dart';
import '../tools/app_routes.dart';
import '../tools/app_spacing.dart';
import '../tools/app_strings.dart';
import '../tools/app_styles.dart';
import '../utils/helpers.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../widgets/drawers/drawer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  bool isLoading = false;
  Map<String, dynamic> errors = {};

  @override
  void initState() {
    super.initState();
    checkLoginStatus(); // Vérifier si l'utilisateur est déjà connecté
  }

  Future<void> checkLoginStatus() async {
    // Lire le token stocké
    String? token = await SecureStorage.read('auth_token');
    if (token != null) {
      // Si un token existe, redirigez vers la page d'accueil
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColours.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColours.primaryColor,
          title: Text(
            AppStrings.login,
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.signup),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(24),
            children: [
              TextInputComponent(
                error: errors['email']?.join(', '),
                isRequired: true,
                focusNode: emailFocus,
                label: AppStrings.email,
                textEditingController: emailEditingController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.emailAddress,
              ),
              AppSpacing.vertical(size: 16),
              TextInputComponent(
                error: errors['password']?.join(', '),
                isRequired: true,
                focusNode: passwordFocus,
                label: AppStrings.password,
                textEditingController: passwordEditingController,
                isPassword: true,
                textInputAction: TextInputAction.done,
              ),
              AppSpacing.vertical(size: 16),
              ButtonComponent(
                label: AppStrings.login,
                onPressed: login,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    setState(() => errors = {});
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() => isLoading = true);

    final Map<String, dynamic> data = {
      'email': emailEditingController.text,
      'password': passwordEditingController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.43.39:8000/api/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['results']['token'];
        final roleId = responseBody['results']['role_id']; // Récupération du role_id

        // Stocker le token dans un stockage sécurisé
        await SecureStorage.save('auth_token', token);
        print("Token enregistré: $token"); // Débogage

        // Redirection en fonction du role_id
        if (roleId == 2) {
          Navigator.of(context).pushReplacementNamed('/directeur');
        } else if (roleId == 3) {
          Navigator.of(context).pushReplacementNamed('/superviseur');
        } else if (roleId == 4) {
          Navigator.of(context).pushReplacementNamed('/stagiaire');
        } else {
          Helper.snackBar(
            context,
            message: 'Rôle non reconnu.',
            isSuccess: false,
          );
        }
      } else {
        final responseBody = jsonDecode(response.body);
        setState(() {
          errors = responseBody['errors'] ?? {};
        });
        Helper.snackBar(
          context,
          message: 'Connexion échouée : ${responseBody['message']}',
          isSuccess: false,
        );
      }
    } catch (e) {
      Helper.snackBar(
        context,
        message: 'Erreur de réseau. Veuillez réessayer.',
        isSuccess: false,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
