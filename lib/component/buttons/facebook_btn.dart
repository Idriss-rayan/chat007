import 'package:flutter/material.dart';

class FacebookBtn extends StatefulWidget {
  const FacebookBtn({super.key});

  @override
  State<FacebookBtn> createState() => _FacebookBtnState();
}

class _FacebookBtnState extends State<FacebookBtn> {
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
                    EdgeInsets.only(left: width * 0.05, right: width * 0.02),
                child: Row(
                  children: [
                    Icon(
                      fill: 1,
                      Icons.facebook_outlined,
                      color: Colors.white70,
                    ),
                    Spacer(),
                    Text(
                      "facebook",
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
