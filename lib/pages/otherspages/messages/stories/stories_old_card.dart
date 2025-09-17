import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/pages/custom/animated_gradient_border.dart';

class StoriesOldCard extends StatefulWidget {
  const StoriesOldCard({super.key});

  @override
  State<StoriesOldCard> createState() => _StoriesOldCardState();
}

class _StoriesOldCardState extends State<StoriesOldCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        width: 180,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: AnimatedGradientBorder(
                width: 80,
                height: 80,
                strokeWidth: 1.5,
                borderRadius: 80,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    //color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  'idriss rayan',
                  style: TextStyle(
                      fontSize: 13,
                      //fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "il y'a 13 minutes",
                  style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
