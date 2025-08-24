import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleBtn extends StatefulWidget {
  const GoogleBtn({super.key});

  @override
  State<GoogleBtn> createState() => _GoogleBtnState();
}

class _GoogleBtnState extends State<GoogleBtn> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Padding(
      padding: EdgeInsets.only(top: height * 0.06),
      child: Material(
        // elevation: 50,
        // shadowColor: Colors.orange,
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          splashColor: Colors.white.withOpacity(0.3), // couleur de l'ondulation
          highlightColor: Colors.white.withOpacity(0.1), // couleur quand pressé
          child: Container(
            width: width * 0.3,
            height: height * 0.06,
            decoration: BoxDecoration(
              color: Colors.white24,
              border: Border.all(
                color: const Color.fromARGB(0, 255, 255, 255),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Padding(
                padding:
                    EdgeInsets.only(left: width * 0.05, right: width * 0.07),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.google, // icône Google
                      color: Colors.white70,
                      size: width * 0.055, // taille responsive
                    ),
                    Spacer(),
                    Text(
                      "Googe",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
