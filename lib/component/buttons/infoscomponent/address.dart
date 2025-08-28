import 'package:flutter/material.dart';

class Address extends StatefulWidget {
  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your address";
    }

    String address = value.trim();

    if (address.length < 5) {
      return "Address is too short";
    }

    if (address.length > 100) {
      return "Address is too long";
    }

    // Vérifie qu'il n'y a que des lettres, chiffres, espaces simples, apostrophes, tirets et virgules
    final addressRegExp = RegExp(r"^[A-Za-z0-9À-ÖØ-öø-ÿ'.,\- ]+$");
    if (!addressRegExp.hasMatch(address)) {
      return "Address contains invalid characters";
    }

    // Vérifie qu'il n'y a pas d'espaces consécutifs
    if (address.contains("  ")) {
      return "Address cannot contain consecutive spaces";
    }

    // Optionnel : première lettre en majuscule
    if (address[0] != address[0].toUpperCase()) {
      return "First letter should be uppercase";
    }

    return null; // Valide
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Expanded(
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
                        'Address',
                        style: TextStyle(
                          color: Color.fromARGB(128, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _controller,
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
                    validator: _validateAddress,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
