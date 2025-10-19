import 'package:flutter/material.dart';
import 'package:simplechat/pages/otherspages/messages/message/succesfull_page.dart';

class Confirm extends StatefulWidget {
  final Map<String, TextEditingController> controllers;
  final bool areConditionsAccepted;

  const Confirm({
    super.key,
    required this.controllers,
    required this.areConditionsAccepted,
  });

  @override
  State<Confirm> createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  void _submitForm() {
    // Vérifier si les conditions sont acceptées
    if (!widget.areConditionsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez accepter les conditions d'utilisation"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Valider que tous les champs sont remplis
    for (var entry in widget.controllers.entries) {
      if (entry.value.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Le champ ${entry.key} est requis"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // Afficher les données dans la console (pour debug)
    print("=== DONNÉES DU FORMULAIRE ===");
    widget.controllers.forEach((key, controller) {
      print("$key: ${controller.text}");
    });
    print("Conditions acceptées: ${widget.areConditionsAccepted}");
    print("=============================");

    // Si tout est valide, naviguer vers la page de succès
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SuccesfullPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: InkWell(
        onTap: _submitForm, // Utiliser la nouvelle fonction de validation
        child: Container(
          width: width * 0.7,
          height: height * 0.08,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepOrangeAccent),
            borderRadius: BorderRadius.circular(7),
            color: Colors.deepOrange,
          ),
          child: const Center(
            child: Text(
              'Confirm',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
