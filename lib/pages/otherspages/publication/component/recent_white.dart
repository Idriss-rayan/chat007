import 'package:flutter/material.dart';

class RecentWhite extends StatelessWidget {
  const RecentWhite({super.key});

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
          'Newest',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
