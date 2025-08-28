import 'package:flutter/material.dart';

class FirstName extends StatefulWidget {
  const FirstName({super.key});

  @override
  State<FirstName> createState() => _FirstNameState();
}

class _FirstNameState extends State<FirstName> {
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
                        'First name',
                        style: TextStyle(
                            color: const Color.fromARGB(128, 0, 0, 0)),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(5, 255, 109, 64),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(color: Colors.deepOrangeAccent),
                      ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
