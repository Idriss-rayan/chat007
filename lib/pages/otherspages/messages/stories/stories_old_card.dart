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
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38),
                  //color: Colors.amber,
                  shape: BoxShape.circle,
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
