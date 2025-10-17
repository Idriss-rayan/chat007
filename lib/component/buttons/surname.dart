import 'package:flutter/material.dart';

class Surname extends StatefulWidget {
  final TextEditingController controller;
  const Surname({super.key, required this.controller});

  @override
  State<Surname> createState() => _SurnameState();
}

class _SurnameState extends State<Surname> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Padding(
      padding: EdgeInsets.only(top: width * 0.08),
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: widget.controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,

          // 🔹 Style du texte que l'utilisateur entre
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          cursorColor: Colors.white,
          keyboardType: TextInputType.emailAddress,

          decoration: InputDecoration(
            labelText: "Enter your surname",

            // Bordures
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Colors.white70),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(
                color: Color.fromARGB(179, 255, 255, 255),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(
                color: Color.fromARGB(70, 255, 255, 255),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),

            // Fond et labels
            filled: true,
            fillColor: const Color.fromARGB(28, 255, 255, 255),
            labelStyle: const TextStyle(color: Colors.white60),
            floatingLabelStyle: const TextStyle(color: Colors.white),
          ),

          // Validation
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your surname";
            }
            if (value.length < 6) {
              return "At least 6 characters";
            }
            return null;
          },
        ),
      ),
    );
  }
}
