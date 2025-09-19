import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardUser2 extends StatefulWidget {
  const CardUser2({super.key});

  @override
  State<CardUser2> createState() => _CardUser2State();
}

class _CardUser2State extends State<CardUser2> {
  bool istype = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: const Color.fromARGB(30, 233, 30, 98),
        //border: Border.all(color: Colors.deepOrange),
      ),
      width: width * 0.5,
      height: height * 0.2,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset(
              'assets/component/avatar.svg',
              width: 80,
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Idriss Rayan".toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(195, 0, 0, 0),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  color: Colors.orange,
                  'assets/component/loc.svg',
                  width: 20,
                  height: 20,
                ),
                Text(
                  "Cameroun",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4),
                SvgPicture.asset(
                  'assets/component/cmr.svg',
                  width: 10,
                  height: 10,
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  istype = !istype;
                });
              },
              child: istype
                  ? SvgPicture.asset(
                      'assets/component/pend.svg',
                      width: 33,
                      height: 33,
                    )
                  : SvgPicture.asset(
                      'assets/component/follow.svg',
                      width: 33,
                      height: 33,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
