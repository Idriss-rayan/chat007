import 'package:flutter/material.dart';

class Recent extends StatelessWidget {
  const Recent({super.key});

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
          'Newest',
          style: TextStyle(
            fontSize: 14,
            color: Colors.deepOrange,
          ),
        ),
      ),
    );
  }
}
