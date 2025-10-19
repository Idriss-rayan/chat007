import 'package:flutter/material.dart';

class City extends StatefulWidget {
  final TextEditingController controller;
  const City({super.key, required this.controller});

  @override
  State<City> createState() => _CityState();
}

class _CityState extends State<City> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  String? _validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your city";
    }

    String city = value.trim();

    if (city.length < 2) {
      return "City name is too short";
    }

    if (city.length > 50) {
      return "City name is too long";
    }

    // Vérifie qu'il n'y a que des lettres, espaces simples, apostrophes et tirets
    final cityRegExp =
        RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ'-]+(?: [A-Za-zÀ-ÖØ-öø-ÿ'-]+)*$");
    if (!cityRegExp.hasMatch(city)) {
      return "City contains invalid characters";
    }

    // Vérifie qu'il n'y a pas d'espaces consécutifs
    if (city.contains("  ")) {
      return "City cannot contain consecutive spaces";
    }

    // Optionnel : première lettre en majuscule
    if (city[0] != city[0].toUpperCase()) {
      return "First letter should be uppercase";
    }

    return null; // Valide
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'City',
                      style: TextStyle(
                        color: Color.fromARGB(128, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(5, 255, 109, 64),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(5, 255, 109, 64),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(5, 255, 109, 64),
                      ),
                    ),
                  ),
                  validator: _validateCity,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
