import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/pages/main_page.dart';

class SuccesfullPage extends StatefulWidget {
  const SuccesfullPage({super.key});

  @override
  State<SuccesfullPage> createState() => _SuccesfullPageState();
}

class _SuccesfullPageState extends State<SuccesfullPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: SvgPicture.asset(
                'assets/component/tik2.svg',
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(height: 60),
            Text(
              "successfull",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Data has been store successfull",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const MainPage(),
                      transitionDuration: Duration.zero, // ⛔ pas d’animation
                      reverseTransitionDuration:
                          Duration.zero, // ⛔ pas d’animation au retour
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return child; // 👈 on affiche la page sans effet
                      },
                    ),
                    (Route<dynamic> route) =>
                        false, // 🔥 supprime toutes les pages précédentes
                  );
                },
                child: Container(
                  width: width * 0.7,
                  height: height * 0.08,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepOrangeAccent),
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.deepOrange,
                  ),
                  child: Center(
                    child: Text(
                      'Start',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
