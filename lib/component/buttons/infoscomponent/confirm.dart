import 'package:flutter/material.dart';
import 'package:simplechat/pages/otherspages/messages/message/succesfull_page.dart';

class Confirm extends StatefulWidget {
  final Map<String, TextEditingController> controllers;
  final bool areConditionsAccepted;
  final Future<bool> Function() onSave;

  const Confirm({
    super.key,
    required this.controllers,
    required this.areConditionsAccepted,
    required this.onSave,
  });

  @override
  State<Confirm> createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  Future<void> _submitForm() async {
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

    bool success = await widget.onSave();

    // Si tout est valide, naviguer vers la page de succès
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SuccesfullPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur lors de la sauvegarde"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
