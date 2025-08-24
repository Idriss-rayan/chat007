import 'package:flutter/material.dart';

class PasswordButton extends StatefulWidget {
  const PasswordButton({super.key});

  @override
  State<PasswordButton> createState() => _PasswordButtonState();
}

class _PasswordButtonState extends State<PasswordButton> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _controller,
        obscureText: _obscurePassword,
        // 🔸 le texte que l'utilisateur tape
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        cursorColor: Colors.white,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(color: Colors.white70),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(
              color: const Color.fromARGB(179, 255, 255, 255),
            ),
          ),
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
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide:
                BorderSide(color: const Color.fromARGB(70, 255, 255, 255)),
          ),
          // Bordure quand il y a une erreur
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide(color: Colors.red, width: 1.5),
          ),

          // Bordure quand focus + erreur
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
            return "Please enter your password";
          }
          if (value.length < 6) {
            return "At least 6 character";
          }
          return null;
        },
      ),
    );
  }
}
