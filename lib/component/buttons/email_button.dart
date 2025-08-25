import 'package:flutter/material.dart';

class EmailButton extends StatefulWidget {
  const EmailButton({super.key});

  @override
  State<EmailButton> createState() => _EmailButtonState();
}

class _EmailButtonState extends State<EmailButton> {
  final TextEditingController _emailController = TextEditingController();
  @override
  void initState() {
    super.initState();

    // 🔸 écouter les changements en temps réel
    _emailController.addListener(() {
      print("Texte actuel: ${_emailController.text}");
      // Ici tu peux faire une validation live, ou activer un bouton
    });
  }

  @override
  void dispose() {
    _emailController.dispose(); // bonne pratique pour libérer la mémoire
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: width * 0.08),
      child: TextFormField(
        controller: _emailController,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        cursorColor: Colors.white,
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: "Enter your email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(color: Colors.white70),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(color: Colors.white54),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: const Color.fromARGB(28, 255, 255, 255),
          labelStyle: TextStyle(color: Colors.white60),
          floatingLabelStyle: TextStyle(color: Colors.white),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your email";
          }
          if (!value.contains('@')) {
            return "Email invalide";
          }
          return null; // ✅ aucun message si valide
        },
      ),
    );
  }
}
