import 'package:flutter/material.dart';
import 'package:simplechat/pages/custom/animated_gradient_border.dart';

class UiNavBar extends StatefulWidget {
  const UiNavBar({super.key});

  @override
  State<UiNavBar> createState() => _UiNavBarState();
}

class _UiNavBarState extends State<UiNavBar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: AnimatedGradientBorder(
          width: 300,
          height: 60,
          borderRadius: 30,
          strokeWidth: 2,
          duration: const Duration(seconds: 3),
          colors: [Colors.purple, Colors.blue, Colors.cyan, Colors.teal],
          child: Center(
            child: Text(
              'NavBar Item',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
