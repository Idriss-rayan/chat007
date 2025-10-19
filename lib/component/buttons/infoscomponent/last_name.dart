import 'package:flutter/material.dart';

class LastName extends StatefulWidget {
  final TextEditingController controller;
  const LastName({super.key, required this.controller});

  @override
  State<LastName> createState() => _LastNameState();
}

class _LastNameState extends State<LastName> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Form(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Last name',
                      style: TextStyle(
                        color: const Color.fromARGB(128, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: widget.controller,
                  cursorColor: const Color.fromARGB(133, 0, 0, 0),
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(5, 255, 109, 64),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(5, 255, 109, 64),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(5, 255, 109, 64),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(5, 255, 109, 64),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.white60),
                    floatingLabelStyle: TextStyle(color: Colors.white),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your first name";
                    }

                    String name = value.trim();

                    if (name.length < 2) {
                      return "Name is too short";
                    }

                    if (name.length > 50) {
                      return "Name is too long";
                    }

                    // Vérifie qu'il n'y a que des lettres, espaces simples, apostrophes et tirets
                    final nameRegExp = RegExp(
                        r"^[A-Za-zÀ-ÖØ-öø-ÿ'-]+(?: [A-Za-zÀ-ÖØ-öø-ÿ'-]+)*$");
                    if (!nameRegExp.hasMatch(name)) {
                      return "Invalid characters in name";
                    }

                    // Vérifie qu'il n'y a pas d'espaces consécutifs
                    if (name.contains("  ")) {
                      return "Name cannot contain consecutive spaces";
                    }

                    // Optionnel : première lettre en majuscule
                    if (name[0] != name[0].toUpperCase()) {
                      return "First letter should be uppercase";
                    }

                    return null; // ✅ aucun message si valide
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
