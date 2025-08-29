import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
                'assets/logo/tik2.svg',
                width: 150,
                height: 150,
                // colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn), // optionnel: recoloriser
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
                onTap: () {},
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
