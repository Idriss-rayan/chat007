import 'package:flutter/material.dart';

class Phonenumber extends StatefulWidget {
  const Phonenumber({super.key});

  @override
  State<Phonenumber> createState() => _PhonenumberState();
}

class _PhonenumberState extends State<Phonenumber> {
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
                        'Phone number',
                        style: TextStyle(
                            color: const Color.fromARGB(107, 0, 0, 0)),
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
