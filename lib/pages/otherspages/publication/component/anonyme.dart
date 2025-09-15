import 'package:flutter/material.dart';

class Anonyme extends StatelessWidget {
  const Anonyme({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
        child: Text(
          'Anonymous',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
