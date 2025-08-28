import 'package:flutter/material.dart';

class Email extends StatefulWidget {
  const Email({super.key});

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
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
                    children: [
                      Text(
                        'Email address',
                        style: TextStyle(
                            color: const Color.fromARGB(117, 0, 0, 0)),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(5, 255, 109, 64),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(color: Colors.deepOrangeAccent),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your email";
                      }

                      String email = value.trim();

                      // Vérifie le format email basique
                      final emailRegExp =
                          RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                      if (!emailRegExp.hasMatch(email)) {
                        return "Invalid email address";
                      }

                      return null; // ✅ aucun message si valide
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
