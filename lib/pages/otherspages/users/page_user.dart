import 'package:flutter/material.dart';
import 'package:simplechat/pages/otherspages/users/list_user.dart';

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
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
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
                          color: const Color.fromARGB(65, 255, 86, 34)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListUser(),
        ),
      ],
    );
  }
}
