import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../components/form/checkbox_input.dart';
import '../components/form/text_input.dart';
import '../components/ui/button.dart';
import '../tools/app_colours.dart';
import '../tools/app_routes.dart';
import '../tools/app_spacing.dart';
import '../tools/app_strings.dart';
import '../tools/app_styles.dart';
import '../utils/helpers.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formkey = GlobalKey<FormState>();
  final roleIdEditingController = TextEditingController();
  final nomEditingController = TextEditingController();
  final prenomEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final telephoneEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final serviceIdEditingController = TextEditingController();

  final roleFocus = FocusNode();
  final nomFocus = FocusNode();
  final prenomFocus = FocusNode();
  final emailFocus = FocusNode();
  final telephoneFocus = FocusNode();
  final passwordFocus = FocusNode();
  final serviceFocus = FocusNode();

  bool isLoading = false;
  bool hasAgreed = false;
  bool isSuperviseur = false;
  bool isStagiaire = false;// vérifier si le rôle est superviseur

  Map<String, dynamic> errors = {};

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
            AppStrings.signup,
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
        ),
        body: Form(
          key: formkey,
          child: ListView(
            padding: EdgeInsets.all(24),
            children: [
              TextInputComponent(
                error: errors['role_id']?.join(', '),
                isRequired: true,
                focusNode: roleFocus,
                label: AppStrings.role,
                textEditingController: roleIdEditingController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.number,
                onChanged: (value) {
                  // Vérifie si le rôle est superviseur (id = 3) ou stagiaire (id = 4)
                  setState(() {
                    isSuperviseur = value == '3' || value == '4';
                  });
                },
              ),

              AppSpacing.vertical(size: 16),
              TextInputComponent(
                error: errors['nom']?.join(', '),
                isRequired: true,
                focusNode: nomFocus,
                label: AppStrings.nom,
                textEditingController: nomEditingController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.name,
              ),
              AppSpacing.vertical(size: 16),
              TextInputComponent(
                error: errors['prenom']?.join(', '),
                isRequired: true,
                focusNode: prenomFocus,
                label: AppStrings.prenom,
                textEditingController: prenomEditingController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.name,
              ),
              AppSpacing.vertical(size: 16),
              TextInputComponent(
                error: errors['telephone']?.join(', '),
                isRequired: true,
                focusNode: telephoneFocus,
                label: AppStrings.telephone,
                textEditingController: telephoneEditingController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.phone,
              ),
              AppSpacing.vertical(size: 16),
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
              if (isSuperviseur) // Afficher le champ service_id si rôle superviseur ou stagiaire
                Column(
                  children: [
                    AppSpacing.vertical(size: 16),
                    TextInputComponent(
                      error: errors['service_id']?.join(', '),
                      isRequired: true,
                      focusNode: serviceFocus,
                      label: AppStrings.service,
                      textEditingController: serviceIdEditingController,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.number,
                    ),
                  ],
                ),
              AppSpacing.vertical(size: 16),
              CheckboxInputComponent(
                label: Text.rich(
                  style: AppStyles.meduim(size: 14),
                  TextSpan(text: AppStrings.agree, children: [
                    WidgetSpan(child: AppSpacing.horizontal(size: 4)),
                    TextSpan(
                      text: AppStrings.agree2,
                      style: AppStyles.meduim(
                          size: 14, color: AppColours.primaryColor2),
                    ),
                  ]),
                ),
                value: hasAgreed,
                onChanged: (value) => setState(() => hasAgreed = value!),
              ),
              AppSpacing.vertical(size: 19),
              ButtonComponent(
                label: AppStrings.btn_signup,
                onPressed: signup,
              ),
              // Rest of your code...
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signup() async {
    setState(() => errors = {});
    FocusScope.of(context).unfocus();
    if (!formkey.currentState!.validate()) {
      return;
    }
    if (!hasAgreed) {
      Helper.snackBar(
        context,
        message: AppStrings.InputRequired.replaceAll(
            "input", AppStrings.agree2),
        isSuccess: false,
      );
      return;
    }

    setState(() => isLoading = true);

    // Prépare les données à envoyer
    final Map<String, dynamic> data = {
      'role_id': roleIdEditingController.text,
      'nom': nomEditingController.text,
      'prenom': prenomEditingController.text,
      'email': emailEditingController.text,
      'telephone': telephoneEditingController.text,
      'password': passwordEditingController.text,
    };

    if (isSuperviseur) {
      data['service_id'] = serviceIdEditingController.text;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.43.39:8000/api/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        Navigator.of(context).pushNamed(AppRoutes.login);
      } else {
        final responseBody = jsonDecode(response.body);
        setState(() {
          errors = responseBody['errors'] ?? {};
        });
        Helper.snackBar(
          context,
          message: 'Inscription échouée : ${responseBody['message']}',
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
