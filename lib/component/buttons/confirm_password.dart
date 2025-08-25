import 'package:flutter/material.dart';

class ConfirmPassword extends StatefulWidget {
  const ConfirmPassword({super.key});

  @override
  State<ConfirmPassword> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _controller,
        obscureText: _obscurePassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        // 🔹 Style du texte que l'utilisateur entre
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        cursorColor: Colors.white,
        keyboardType: TextInputType.emailAddress,

        decoration: InputDecoration(
          labelText: "confirm Password",

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

          // Icône pour voir / cacher le mot de passe
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white54,
            ),
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
            return "Please enter your password";
          }
          if (value.length < 6) {
            return "At least 6 characters";
          }
          return null;
        },
      ),
    );
  }
}
