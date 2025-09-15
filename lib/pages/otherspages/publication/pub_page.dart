import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/pages/custom/animated_gradient_border.dart';
import 'package:simplechat/pages/otherspages/publication/component/search_bar.dart';
import 'package:simplechat/pages/otherspages/publication/pub_card.dart';
import 'package:simplechat/pages/otherspages/publication/spaces/spaces.dart';

class PubPage extends StatefulWidget {
  const PubPage({super.key});

  @override
  State<PubPage> createState() => _PubPageState();
}

class _PubPageState extends State<PubPage> {
  bool isSearchActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 HEADER (Logo + Search/Notifs)
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  // Logo à gauche
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: SvgPicture.asset(
                        "assets/logo/p.svg",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Zone à droite (expand pour occuper tout l’espace restant)
                  Expanded(
                    child: isSearchActive
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SearchBarCostum(
                              onClose: () {
                                setState(() {
                                  isSearchActive = false;
                                });
                              },
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Bouton recherche
                              IconButton(
                                icon: SvgPicture.asset(
                                  "assets/component/search.svg",
                                  width: 28,
                                  height: 28,
                                  color: Colors.deepOrangeAccent,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isSearchActive = true;
                                  });
                                },
                              ),

                              // Bouton notifications avec menu
                              PopupMenuButton<int>(
                                icon: SvgPicture.asset(
                                  "assets/component/notifications.svg",
                                  width: 28,
                                  height: 28,
                                  color: Colors.deepOrangeAccent,
                                ),
                                color: Colors.orange.shade50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 6,
                                onSelected: (value) {
                                  if (value == 1) {
                                    debugPrint("Voir les notifications");
                                  } else if (value == 2) {
                                    debugPrint("Paramètres des notifications");
                                  } else if (value == 3) {
                                    debugPrint("Tout marquer comme lu");
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 1,
                                    child: Row(
                                      children: [
                                        Icon(Icons.notifications,
                                            color: Colors.deepOrange),
                                        SizedBox(width: 8),
                                        Text("Voir les notifications"),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 2,
                                    child: Row(
                                      children: [
                                        Icon(Icons.settings,
                                            color: Colors.deepOrange),
                                        SizedBox(width: 8),
                                        Text("Paramètres"),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 3,
                                    child: Row(
                                      children: [
                                        Icon(Icons.done_all,
                                            color: Colors.deepOrange),
                                        SizedBox(width: 8),
                                        Text("Tout marquer comme lu"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50, // hauteur fixe pour le horizontal list
              child: ListView.builder(
                itemCount: 50,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemBuilder: (context, index) {
                  return const Spaces();
                },
              ),
            ),

            // 🔹 LISTE PRINCIPALE
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const PubCard();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
