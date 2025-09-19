import 'package:flutter/material.dart';

class CardCalls extends StatelessWidget {
  const CardCalls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(color: Colors.amber),
          ),
        ),
        Expanded(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
