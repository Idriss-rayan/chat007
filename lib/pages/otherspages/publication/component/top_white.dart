import 'package:flutter/material.dart';

class TopWhite extends StatelessWidget {
  const TopWhite({super.key});

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
          'Top',
          style: TextStyle(
            fontSize: 14,
            color: Colors.deepOrange,
          ),
        ),
      ),
    );
  }
}
