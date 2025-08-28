import 'package:flutter/material.dart';

class City extends StatefulWidget {
  const City({super.key});

  @override
  State<City> createState() => _CityState();
}

class _CityState extends State<City> {
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
                        'City',
                        style: TextStyle(
                            color: const Color.fromARGB(128, 0, 0, 0)),
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
