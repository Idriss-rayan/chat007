import 'package:flutter/material.dart';
import 'package:simplechat/pages/custom/animated_gradient_border.dart';

class Spaces extends StatefulWidget {
  const Spaces({super.key});

  @override
  State<Spaces> createState() => _SpacesState();
}

class _SpacesState extends State<Spaces> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: AnimatedGradientBorder(
        width: 120,
        height: 40,
        strokeWidth: 1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.centerLeft,
          child: Row(
            children: const [
              CircleAvatar(radius: 14),
              SizedBox(width: 8),
              Text(
                'name spaces',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
