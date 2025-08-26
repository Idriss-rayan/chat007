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
      child: Column(
        children: [
          Text('First name'),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(5, 255, 109, 64),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.deepOrangeAccent),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(5, 255, 109, 64),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.deepOrangeAccent),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
