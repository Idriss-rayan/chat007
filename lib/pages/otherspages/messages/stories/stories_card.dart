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
    return AnimatedGradientBorder(
      width: 80,
      height: 80,
      strokeWidth: 1,
      borderRadius: 20,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          'assets/component/avatar.svg',
          width: 64,
          height: 64,
        ),
      ),
    );
  }
}
