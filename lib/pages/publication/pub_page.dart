import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simplechat/pages/custom/animated_gradient_border.dart';

class PubPage extends StatefulWidget {
  const PubPage({super.key});

  @override
  State<PubPage> createState() => _PubPageState();
}

class _PubPageState extends State<PubPage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    Center(child: Text("🏠 Home", style: TextStyle(fontSize: 24))),
    Center(child: Text("💬 Message", style: TextStyle(fontSize: 24))),
    Center(child: Text("👥 Users", style: TextStyle(fontSize: 24))),
    Center(child: Text("👤 Profil", style: TextStyle(fontSize: 24))),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: AnimatedGradientBorder(
          width: double.infinity,
          height: 70,
          borderRadius: 15, // 🔹 cohérent avec le Container
          strokeWidth: 2,
          duration: const Duration(seconds: 10),
          colors: const [
            Color(0xffFFA91F),
            Colors.deepOrange,
            Colors.redAccent,
            Color.fromARGB(255, 242, 245, 26),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavIcon(
                  asset: "assets/component/home.svg",
                  index: 0,
                  selectedIndex: selectedIndex,
                  onTap: () => onItemTapped(0),
                ),
                NavIcon(
                  asset: "assets/component/msg.svg",
                  index: 1,
                  selectedIndex: selectedIndex,
                  onTap: () => onItemTapped(1),
                ),
                NavIcon(
                  asset: "assets/component/users.svg",
                  index: 2,
                  selectedIndex: selectedIndex,
                  onTap: () => onItemTapped(2),
                ),
                NavIcon(
                  asset: "assets/component/person.svg",
                  index: 3,
                  selectedIndex: selectedIndex,
                  onTap: () => onItemTapped(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 🔹 Widget réutilisable pour les icônes de nav
class NavIcon extends StatelessWidget {
  final String asset;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const NavIcon({
    super.key,
    required this.asset,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        asset,
        color: selectedIndex == index ? Colors.black : Colors.redAccent,
        width: 20,
        height: 20,
      ),
      onPressed: onTap,
    );
  }
}
