import 'package:flutter/material.dart';

class CreatePostMainPage extends StatefulWidget {
  const CreatePostMainPage({super.key});

  @override
  State<CreatePostMainPage> createState() => _CreatePostMainPageState();
}

class _CreatePostMainPageState extends State<CreatePostMainPage> {
  @override
  Widget build(BuildContext context) {
    // Récupération de la taille de l’écran
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Cercle orange responsive
          Positioned(
            top: -height * 0.5, // remplace -700 → la moitié de l’écran
            left: -width * 0.2,
            child: Container(
              width: width * 1.5, // cercle très large (150% de la largeur)
              height: width * 1.5, // cercle reste rond
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
            ),
          ),

          // Bande rose responsive
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     height: height * 0.25, // prend 25% de la hauteur écran
          //     decoration: const BoxDecoration(
          //       color: Colors.pink,
          //       borderRadius: BorderRadius.only(
          //         bottomLeft: Radius.circular(40),
          //         bottomRight: Radius.circular(40),
          //       ),
          //     ),
          //   ),
          // ),

          // Exemple contenu (texte au centre)
          Center(
            child: Text(
              "Créer un post",
              style: TextStyle(
                fontSize: width * 0.07, // taille du texte responsive
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
