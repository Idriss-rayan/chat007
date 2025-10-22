import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FriendCard extends StatefulWidget {
  const FriendCard({super.key});

  @override
  State<FriendCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  bool istype = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color.fromARGB(7, 236, 34, 31),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color.fromARGB(30, 255, 86, 34),
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/component/avatar.svg',
              width: 80,
              height: 80,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                  SizedBox(height: 4),
                  Row(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
