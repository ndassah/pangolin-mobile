import 'package:flutter/material.dart';
import 'package:sappeli/widgets/drawers/drawer.dart';
import '../../tools/app_text.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  // Liste des questions et réponses pour la FAQ
  final List<Map<String, String>> faqItems = [
    {
      'question': 'Comment créer un compte sur la plateforme ?',
      'answer': 'Pour créer un compte, cliquez sur "S’inscrire" sur la page d’accueil et remplissez le formulaire d’inscription avec vos informations personnelles.'
    },
    {
      'question': 'Comment récupérer mon mot de passe ?',
      'answer': 'Sur la page de connexion, cliquez sur "Mot de passe oublié" et suivez les étapes pour réinitialiser votre mot de passe.'
    },
    {
      'question': 'Comment suivre mes projets et activités ?',
      'answer': 'Accédez à votre tableau de bord après connexion pour voir la liste des projets assignés ainsi que les activités associées. Vous pouvez suivre votre progression en temps réel.'
    },
    {
      'question': 'Puis-je modifier mes informations personnelles ?',
      'answer': 'Oui, rendez-vous dans la section "Mon profil" pour modifier vos informations personnelles telles que votre nom, email ou numéro de téléphone.'
    },
    {
      'question': 'Comment contacter le support technique ?',
      'answer': 'Pour toute question ou problème technique, vous pouvez contacter notre support via la section "Contact" dans le menu principal. Nous nous efforcerons de vous répondre rapidement.'
    },
    {
      'question': 'Quels types de services proposez-vous ?',
      'answer': 'Nous offrons une gamme complète de services, incluant la gestion de projets, le suivi des travaux, et l’évaluation des performances des stagiaires. Chaque utilisateur peut avoir accès à des services spécifiques selon son rôle (administrateur, superviseur, stagiaire).'
    },
    {
      'question': 'Comment puis-je voir l’évaluation de mon travail ?',
      'answer': 'Les évaluations sont disponibles dans votre profil sous l’onglet "Évaluations". Vous pouvez consulter les résultats de chaque tâche que vous avez réalisée.'
    },
    {
      'question': 'Est-il possible de recevoir des notifications ?',
      'answer': 'Oui, activez les notifications dans les paramètres de votre compte pour recevoir des mises à jour sur vos projets et des rappels importants.'
    },
    {
      'question': 'Comment puis-je me déconnecter de l’application ?',
      'answer': 'Vous pouvez vous déconnecter en cliquant sur votre avatar dans le coin supérieur droit et en sélectionnant l’option "Déconnexion".'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'F.A.Q',
          style: AppText.mainTitle(),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      drawer: buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: faqItems.length,
          itemBuilder: (context, index) {
            return _buildFaqItem(faqItems[index]['question']!, faqItems[index]['answer']!);
          },
        ),
      ),
    );
  }

  // Fonction pour construire chaque élément de la FAQ (question + réponse)
  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: AppText.mainContent().copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            answer,
            style: AppText.mainContent(),
          ),
        ),
      ],
    );
  }
}
