import 'package:flutter/material.dart';

class AnonymeWhite extends StatelessWidget {
  const AnonymeWhite({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
        child: Text(
          'Anonymous',
          style: TextStyle(
            fontSize: 14,
            color: Colors.deepOrange,
          ),
        ),
      ),
    );
    ;
  }
}
