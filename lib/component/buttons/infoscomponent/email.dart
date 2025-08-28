import 'package:flutter/material.dart';

class Email extends StatefulWidget {
  const Email({super.key});

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
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
                          color: const Color.fromARGB(128, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  TextFormField(
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
                        return "Please enter your email";
                      }

                      String email = value.trim();

                      if (email.length < 6) {
                        return "Email is too short";
                      }

                      if (email.length > 254) {
                        return "Email is too long";
                      }

                      // Expression régulière stricte (RFC 5322 simplifiée)
                      final emailRegExp = RegExp(
                          r"^(?!\.)[A-Za-z0-9._%+-]{1,64}@(?!-)(?:[A-Za-z0-9-]{1,63}\.)+[A-Za-z]{2,24}$");

                      if (!emailRegExp.hasMatch(email)) {
                        return "Invalid email format";
                      }

                      // Vérifie qu'il n'y a pas d'espaces
                      if (email.contains(" ")) {
                        return "Email cannot contain spaces";
                      }

                      // Vérifie qu'il y a exactement un @
                      if ("@".allMatches(email).length != 1) {
                        return "Email must contain exactly one @";
                      }

                      // Vérifie que le domaine n'a pas de doubles points
                      if (email.contains("..")) {
                        return "Domain cannot contain consecutive dots";
                      }

                      return null;
                    },
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
