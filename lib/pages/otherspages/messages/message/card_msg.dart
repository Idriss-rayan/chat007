import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/pages/otherspages/messages/chat_discussion.dart';

class CardMsg extends StatefulWidget {
  const CardMsg({super.key});

  @override
  State<CardMsg> createState() => _CardMsgState();
}

class _CardMsgState extends State<CardMsg> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ChatDiscussion(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.2),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          //color: Color.fromARGB(7, 236, 34, 31),
          color: Color.fromARGB(3, 236, 34, 31),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/component/avatar.svg',
              width: 64,
              height: 64,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "John Doe",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(195, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Dernier message...",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Text(
              "12:45",
              style: TextStyle(color: Colors.black45, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
