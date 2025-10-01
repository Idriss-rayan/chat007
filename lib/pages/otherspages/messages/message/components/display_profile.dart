import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DisplayProfile extends StatefulWidget {
  const DisplayProfile({super.key});

  @override
  State<DisplayProfile> createState() => _DisplayProfileState();
}

class _DisplayProfileState extends State<DisplayProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Hero(
          tag: 'profile',
          child: SvgPicture.asset(
            'assets/component/avatar.svg',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
