import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/pages/otherspages/publication/pub_card.dart';

class PubPage extends StatefulWidget {
  const PubPage({super.key});

  @override
  State<PubPage> createState() => _PubPageState();
}

class _PubPageState extends State<PubPage> {
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
              // 🔹 Search + Notifications regroupés
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: SvgPicture.asset(
                        "assets/component/search.svg",
                        fit: BoxFit.contain,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: SvgPicture.asset(
                        "assets/component/notifications.svg",
                        fit: BoxFit.contain,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(color: Colors.deepOrangeAccent),
          Expanded(
            child: ListView(
              children: [
                PubCard(),
                PubCard(),
                PubCard(),
                PubCard(),
                PubCard(),
                PubCard(),
                PubCard(),
                PubCard(),
                PubCard(),
                PubCard(),
                PubCard(),
                PubCard(),
                PubCard(),
                PubCard(),
                PubCard(),
                PubCard(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
