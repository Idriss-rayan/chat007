import 'package:flutter/material.dart';
import 'package:simplechat/pages/otherspages/users/followers_pages/card_follow.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 50, // nombre de messages
      itemBuilder: (context, index) {
        return const CardFollow();
      },
    );
  }
}
