import 'package:flutter/material.dart';

class Gender extends StatefulWidget {
  final TextEditingController? controller;
  const Gender({super.key, this.controller});

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    // Initialiser avec la valeur du controller si elle existe
    if (widget.controller != null && widget.controller!.text.isNotEmpty) {
      _selectedGender = widget.controller!.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(5, 255, 109, 64),
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
                  borderSide: const BorderSide(
                    color: Color.fromARGB(5, 255, 109, 64),
                  ),
                ),
              ),
              items: ['Male', 'Female']
                  .map((gender) => DropdownMenuItem<String>(
                        value: gender,
                        child: Text(
                          gender,
                          style: const TextStyle(
                              color: Color.fromARGB(213, 0, 0, 0)),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
                // Mettre à jour le controller externe si fourni
                if (widget.controller != null) {
                  widget.controller!.text = value ?? '';
                }
              },
              validator: (value) => value == null || value.isEmpty
                  ? "Please select a gender"
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
