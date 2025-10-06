import 'dart:io';
import 'package:flutter/material.dart';

class ImageOverContainer extends StatelessWidget {
  final File imageFile;

  const ImageOverContainer({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        clipBehavior: Clip.none, // 🔥 autorise le débordement visuel
        children: [
          // 🌈 Le container de fond avec dégradé
          Container(
            width: double.infinity,
            height: height * 0.4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 🖼️ L'image qui dépasse légèrement
          Positioned(
            bottom: -30, // 🔥 Fait dépasser l’image du container
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Image.file(
                  imageFile,
                  height: height * 0.25,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
