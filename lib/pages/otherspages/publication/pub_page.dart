import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/pages/otherspages/publication/component/search_bar.dart';
import 'package:simplechat/pages/otherspages/publication/pub_card.dart';

class PubPage extends StatefulWidget {
  const PubPage({super.key});

  @override
  State<PubPage> createState() => _PubPageState();
}

class _PubPageState extends State<PubPage> {
  bool IsPressed = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🔹 Logo à gauche
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: SvgPicture.asset(
                    "assets/logo/PAPAchou.svg",
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // 🔹 Zone à droite (search + notifications)
              IsPressed
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SearchBarCostum(
                          onClose: () {
                            setState(() {
                              IsPressed = false;
                            });
                          },
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        // Bouton recherche
                        IconButton(
                          icon: SvgPicture.asset(
                            "assets/component/search.svg",
                            width: 30,
                            height: 30,
                            color: Colors.deepOrangeAccent,
                          ),
                          onPressed: () {
                            setState(() {
                              IsPressed = true;
                            });
                          },
                        ),
                        // Bouton notifications
                        IconButton(
                          icon: SvgPicture.asset(
                            "assets/component/notifications.svg",
                            width: 30,
                            height: 30,
                            color: Colors.deepOrangeAccent,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
            ],
          ),

          // Liste principale
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return PubCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
