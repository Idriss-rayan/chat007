import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

class Phonenumber extends StatefulWidget {
  const Phonenumber({super.key});

  @override
  State<Phonenumber> createState() => _PhonenumberState();
}

class _PhonenumberState extends State<Phonenumber> {
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
                      'Phone number',
                      style: TextStyle(
                        color: const Color.fromARGB(128, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                /// 🔹 PhoneFormField avec ton design conservé
                PhoneFormField(
                  cursorColor: const Color.fromARGB(133, 0, 0, 0),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(5, 255, 109, 64),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(5, 255, 109, 64),
                      ),
                    ),
                    border: OutlineInputBorder(
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

                  /// 🔹 Validator complexe
                  validator: (phone) {
                    // 🔹 Vérifie que le champ n’est pas vide
                    if (phone == null || phone.nsn.isEmpty) {
                      return 'Phone number is required';
                    }

                    // 🔹 Utilise la lib pour vérifier le format international/numéro valide
                    if (!phone.isValid()) {
                      return 'Invalid phone number';
                    }

                    final national = phone.nsn;

                    // 🔹 Longueur minimale
                    if (national.length < 8) {
                      return "Phone number is too short";
                    }

                    // 🔹 Longueur maximale
                    if (national.length > 15) {
                      return "Phone number is too long";
                    }

                    // 🔹 Interdit les numéros commençant par 0 sauf pour FR
                    if (phone.isoCode != IsoCode.FR &&
                        national.startsWith('0')) {
                      return "Invalid prefix for international format";
                    }

                    // 🔹 Autorise uniquement les chiffres
                    if (!RegExp(r'^[0-9]+$').hasMatch(national)) {
                      return "Phone number contains invalid characters";
                    }

                    // ✅ Si tout est ok
                    return null;
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
