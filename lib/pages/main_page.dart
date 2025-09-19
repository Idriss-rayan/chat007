import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simplechat/pages/custom/animated_gradient_border.dart';
import 'package:simplechat/pages/otherspages/messages/message/msg_page.dart';
import 'package:simplechat/pages/otherspages/publication/pub_page.dart';
import 'package:flutter/services.dart';
import 'package:simplechat/pages/otherspages/users/main_user_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _PubPageState();
}

class _PubPageState extends State<MainPage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    PubPage(),
    MsgPage(),
    //PageUser(),
    MainUserPage(),
    Center(child: Text("👤 Profil", style: TextStyle(fontSize: 24))),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // transparent, joli pour mobile
        statusBarIconBrightness:
            Brightness.dark, // icônes noires (sur fond clair)
        statusBarBrightness: Brightness.light, // pour iOS
      ),
    );
    return Scaffold(
      //systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: Colors.white,
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
