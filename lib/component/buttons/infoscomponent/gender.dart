import 'package:flutter/material.dart';

class Gender extends StatefulWidget {
  const Gender({super.key});

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Gender',
                    style: TextStyle(
                      color: const Color.fromARGB(128, 0, 0, 0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(5, 255, 109, 64),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(5, 255, 109, 64),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(5, 255, 109, 64),
                    ),
                  ),
                  //prefixIcon: Icon(Icons.person),
                ),
                items: ['Male', 'Female']
                    .map((gender) => DropdownMenuItem<String>(
                          value: gender,
                          child: Text(
                            gender,
                            style: TextStyle(
                                color: const Color.fromARGB(213, 0, 0, 0)),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) => value == null || value.isEmpty
                    ? "Please select a gender"
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
