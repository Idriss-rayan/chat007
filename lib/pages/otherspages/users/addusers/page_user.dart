import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simplechat/pages/otherspages/users/addusers/list_user.dart';

class PageUser extends StatefulWidget {
  const PageUser({super.key});

  @override
  State<PageUser> createState() => _PageUserState();
}

class _PageUserState extends State<PageUser> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AppBar personnalisé avec gradient
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          child: Container(
            width: double.infinity,
            height: 160,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF6464),
                  Color(0xFFFFB744),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Cercle déco
                Positioned(
                  right: -60,
                  top: -40,
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: const Color.fromARGB(65, 255, 86, 34),
                      ),
                    ),
                  ),
                ),

                // Contenu AppBar
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      // Logo papachou.svg
                      SvgPicture.asset(
                        "assets/logo/PAPAchou.svg",
                        height: 20,
                        width: 20,
                      ),

                      const Spacer(),

                      // Search
                      IconButton(
                        onPressed: () {
                          // TODO: ouvrir recherche
                        },
                        icon: const Icon(Icons.search, color: Colors.black87),
                      ),

                      // Notifications
                      IconButton(
                        onPressed: () {
                          // TODO: notifications
                        },
                        icon: const Icon(Icons.notifications,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Liste des utilisateurs
        Expanded(
          child: ListUser(),
        ),
      ],
    );
  }
}
