import 'package:flutter/material.dart';
import 'card_msg.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 1000, // nombre de messages
      itemBuilder: (context, index) {
        return const CardMsg();
      },
    );
  }
}
