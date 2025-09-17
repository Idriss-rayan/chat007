import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/pages/custom/animated_gradient_border.dart';

class StoriesCard extends StatefulWidget {
  const StoriesCard({super.key});

  @override
  State<StoriesCard> createState() => _StoriesCardState();
}

class _StoriesCardState extends State<StoriesCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: AnimatedGradientBorder(
            width: 100,
            height: 100,
            strokeWidth: 2,
            borderRadius: 80,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                //color: Colors.amber,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
